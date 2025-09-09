import 'package:email_validator/email_validator.dart';
import 'package:receipes_app_02/domain/entities/auth_result.dart';
import 'package:receipes_app_02/domain/repositories/auth_repository.dart';
import 'package:receipes_app_02/domain/repositories/user_repository.dart';

class SignUpUsecase {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  SignUpUsecase(this._authRepository, this._userRepository);

  Future<AuthResult> execute({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      return AuthResult.failure('All fields are required');
    }

    if (EmailValidator.validate(email.trim())) {
      return AuthResult.failure('Please enter a valid email address');
    }

    if (password.length < 6) {
      return AuthResult.failure('Password must be at least 6 characters long');
    }

    if (password != confirmPassword) {
      return AuthResult.failure('Passwords do not match');
    }

    final authResult = await _authRepository.signUp(name, email, password);

    if (authResult.isSuccess && authResult.user != null) {
      try {
        await _userRepository.saveUserProfile(authResult.user!);
      } catch (e) {
        return AuthResult.failure('Something went wrong: ${e.toString()}');
      }
    }

    return authResult;
  }
}
