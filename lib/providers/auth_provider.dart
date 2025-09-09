import 'package:flutter/material.dart';
import 'package:receipes_app_02/domain/entities/user_entity.dart';
import 'package:receipes_app_02/domain/repositories/auth_repository.dart';
import 'package:receipes_app_02/domain/repositories/user_repository.dart';
import 'package:receipes_app_02/domain/usecases/sign_in_usecase.dart';
import 'package:receipes_app_02/domain/usecases/sign_out_usecase.dart';
import 'package:receipes_app_02/domain/usecases/sign_up_usecase.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  SignInUsecase _signInUsecase;
  SignUpUsecase _signUpUsecase;
  SignOutUsecase _signOutUsecase;
  AuthRepository _authRepository;
  UserRepository _userRepository;

  AuthStatus _authStatus = AuthStatus.initial;
  UserEntity? _currentUser;
  String? _errorMessage;

  AuthStatus get authStatus => _authStatus;
  UserEntity? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;

  AuthProvider(
    this._signInUsecase,
    this._signUpUsecase,
    this._signOutUsecase,
    this._authRepository,
    this._userRepository,
  ) {
    _initializaAuthState();
  }

  void _initializaAuthState() {
    _authRepository.authStateChanges.listen((user) async {
      if (user != null) {
        _currentUser = user;
        _setState(AuthStatus.authenticated);

        try {
          final userProfile = await _userRepository.getUserProfile(user!.id);
          if (userProfile != null) {
            _currentUser = userProfile;
            _setState(AuthStatus.authenticated);
            notifyListeners();
          }
        } catch (e) {
          print('Error getting user profile: ${e.toString()}');
        }
      } else {
        _currentUser = null;
        _setState(AuthStatus.unauthenticated);
      }
    });
  }

  Future<void> signIn({required String email, required String password}) async {
    _setState(AuthStatus.loading);
    final result = await _signInUsecase.execute(
      email: email,
      password: password,
    );
    if (result.isSuccess) {
      _currentUser = result.user;
      _errorMessage = null;
    } else {
      print('Sign in failed: ${result.errorMessage}');
      _errorMessage = result.errorMessage;
      _setState(AuthStatus.error);
    }
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String confirmPassworf,
  }) async {
    _setState(AuthStatus.loading);

    final result = await _signUpUsecase.execute(
      name: name,
      email: email,
      password: password,
      confirmPassworf: confirmPassworf,
    );

    if (result.isSuccess) {
      _currentUser = result.user;
      _errorMessage = null;
      _setState(AuthStatus.authenticated);
    } else {
      print('Sign up failed: ${result.errorMessage}');
      _errorMessage = result.errorMessage;
      _setState(AuthStatus.error);
    }
  }

  Future<void> signOut() async {
    _setState(AuthStatus.loading);
    await _signOutUsecase.execute();
    _currentUser = null;
    _errorMessage = null;
    _setState(AuthStatus.unauthenticated);
  }

  void _setState(AuthStatus status) {
    _authStatus = status;
    notifyListeners();
  }

  void updateCurrentUser(UserEntity user) {
    _currentUser = user;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    if (_authStatus == AuthStatus.error) {
      _authStatus =
          _currentUser != null
              ? AuthStatus.authenticated
              : AuthStatus.unauthenticated;
    }
    notifyListeners();
  }
}
