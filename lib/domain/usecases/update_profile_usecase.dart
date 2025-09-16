import 'package:receipes_app_02/constants/validators.dart';
import 'package:receipes_app_02/domain/entities/user_entity.dart';
import 'package:receipes_app_02/domain/repositories/user_repository.dart';

class UpdateProfileUseCase {
  final UserRepository _userRepository;

  UpdateProfileUseCase(this._userRepository);

  Future<String?> execute({
    required UserEntity user,
    required String name,
    required String email,
  }) async {
    try {
      if (name.isEmpty) {
        return 'Name is required';
      }

      if (email.isEmpty) {
        return 'Email is required';
      }

      if (!isValidEmail(email)) {
        return 'Please enter a valid email address';
      }

      final updatedUser = user.copyWith(name: name, email: email);
      await _userRepository.updateUserProfile(updatedUser);
      return null;
    } catch (e) {
      return 'Failed to update profile: ${e.toString()}';
    }
  }
}
