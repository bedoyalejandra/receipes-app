import 'package:receipes_app_02/constants/validators.dart';
import 'package:receipes_app_02/domain/entities/auth_result.dart';
import 'package:receipes_app_02/domain/repositories/auth_repository.dart';

class SignInUsecase {
  final AuthRepository _authRepository;

  SignInUsecase(this._authRepository);

  Future<AuthResult> execute({
    required String email,
    required String password,
  }) async {
    if(email.isEmpty || password.isEmpty){
      return AuthResult.failure('All fields are required');
    }

    if(!isValidEmail(email)){
      return AuthResult.failure('Please enter a valid email address');
    }

    return _authRepository.signIn(email, password);
  }
}
