import 'package:receipes_app_02/domain/entities/notification.dart';

abstract class NotificationsRepository {
  Stream<List<Notification>> getNotificationStream(String userId);

  Future<List<Notification>> getNotification(
    String userId, {
    int limit = 20,
    DateTime? startAfter,
  });

  Future<void> markNotificationAsRead(String notificationId);

  Future<void> createNotification(Notification notification);

  Future<void> createNotificationForMultipleUsers({
    required List<String> userIds,
    required String title,
    required String recipeId,
    required String senderId,
  });

  Future<int> getUnreadNotificationCount(String userId);

  Stream<int> getUnreadNotificationCountStream(String userId);
}
