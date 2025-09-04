import 'package:receipes_app_02/domain/entities/auth_result.dart';
import 'package:receipes_app_02/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<AuthResult> signUp(String name, String email, String password);
  Future<AuthResult> signIn(String email, String password);
  Future<void> signOut();
  Future<UserEntity?> getCurrentUser();
  Stream<UserEntity?> get authStateChanges;
}