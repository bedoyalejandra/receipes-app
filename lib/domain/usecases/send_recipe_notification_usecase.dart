import 'package:receipes_app_02/domain/repositories/notifications_repository.dart';
import 'package:receipes_app_02/domain/repositories/user_repository.dart';

class SendRecipeNotificationUseCase {
  final NotificationsRepository _notificationsRepository;
  final UserRepository _userRepository;

  SendRecipeNotificationUseCase(
    this._notificationsRepository,
    this._userRepository,
  );

  Future<void> execute({
    required String recipeTitle,
    required String recipeId,
    required String creatorId,
    required String creatorName,
  }) async {
    if (recipeTitle.isEmpty) {
      throw ArgumentError('Recipe title is empty');
    }
    if (recipeId.isEmpty) {
      throw ArgumentError('Recipe ID is empty');
    }
    if (creatorId.isEmpty) {
      throw ArgumentError('Creator ID is empty');
    }

    final allUsers = await _userRepository.getAllUsers();
    final recipientsIds =
        allUsers
            .where((user) => user.id != creatorId)
            .map((user) => user.id)
            .toList();

    if (recipientsIds.isEmpty) {
      return;
    }

    final notificationTitle = '$creatorName shared a new recipe: $recipeTitle';

    await _notificationsRepository.createNotificationForMultipleUsers(
      userIds: recipientsIds,
      title: notificationTitle,
      recipeId: recipeId,
      senderId: creatorId,
    );
  }
}
