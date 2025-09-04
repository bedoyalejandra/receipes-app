import 'package:email_validator/email_validator.dart';
import 'package:receipes_app_02/domain/entities/auth_result.dart';
import 'package:receipes_app_02/domain/repositories/auth_repository.dart';
import 'package:receipes_app_02/domain/repositories/user_repository.dart';

class RegisterUsecase {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  RegisterUsecase(this._authRepository, this._userRepository);

  Future<AuthResult> execute({
    required String name,
    required String email,
    required String password,
    required String confirmPassworf,
  }) async {
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassworf.isEmpty) {
      return AuthResult.failure('All fields are required');
    }

    if (EmailValidator.validate(email)) {
      return AuthResult.failure('Please enter a valid email address');
    }

    if (password.length < 6) {
      return AuthResult.failure('Password must be at least 6 characters long');
    }

    if (password != confirmPassworf) {
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
