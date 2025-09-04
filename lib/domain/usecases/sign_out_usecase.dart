import 'package:receipes_app_02/domain/repositories/auth_repository.dart';

class SignOutUsecase {
  final AuthRepository _authRepository;

  SignOutUsecase(this._authRepository);

  Future<void> execute() async {
    return _authRepository.signOut();
  }
}
