import 'package:flutter/material.dart';
import 'package:receipes_app_02/domain/entities/user_entity.dart';
import 'package:receipes_app_02/domain/repositories/user_repository.dart';
import 'package:receipes_app_02/domain/usecases/update_profile_usecase.dart';

enum UserState { initial, loading, success, error }

class UserProvider extends ChangeNotifier {
  final UpdateProfileUseCase _updateProfileUseCase;
  final UserRepository _userRepository;

  UserState _userState = UserState.initial;
  UserEntity? _user;
  String? _errorMessage;

  UserState get userState => _userState;
  UserEntity? get user => _user;
  String? get errorMessage => _errorMessage;

  UserProvider(this._updateProfileUseCase, this._userRepository);

  Future<void> loadUserProfile(String userId) async {
    _setState(UserState.loading);

    try {
      _user = await _userRepository.getUserProfile(userId);
      _setState(UserState.success);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _setState(UserState.error);
    }
  }

  Future<void> updateProfile({
    required UserEntity user,
    required String newName,
    required String newEmail,
  }) async {
    _setState(UserState.loading);
    try {
      final error = await _updateProfileUseCase.execute(
        user: user,
        name: newName,
        email: newEmail,
      );

      if (error != null) {
        _user = user.copyWith(name: newName, email: newEmail);
        _errorMessage = null;
        _setState(UserState.success);
      } else {
        _errorMessage = error;
        _setState(UserState.error);
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setState(UserState.error);
    }
  }

  void clearError() {
    _errorMessage = null;
    if (_userState == UserState.error) {
      _userState =
          _user != null ? UserState.success : UserState.initial;
    }
    notifyListeners();
  }

  void _setState(UserState status) {
    _userState = status;
    notifyListeners();
  }
}
