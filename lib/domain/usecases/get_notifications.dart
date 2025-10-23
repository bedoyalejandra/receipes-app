import 'package:receipes_app_02/domain/entities/notification.dart';
import 'package:receipes_app_02/domain/repositories/notifications_repository.dart';

class GetNotificationsUseCase {
  final NotificationsRepository _notificationsRepository;

  GetNotificationsUseCase(this._notificationsRepository);

  Future<List<Notification>> execute({
    required String userId,
    int limit = 20,
    DateTime? startAfter,
  }) async {
    if (userId.isEmpty) {
      throw ArgumentError('User ID is empty');
    }
    return await _notificationsRepository.getNotification(
      userId,
      limit: limit,
      startAfter: startAfter,
    );
  }
}
