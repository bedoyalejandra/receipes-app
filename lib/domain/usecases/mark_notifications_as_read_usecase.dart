import 'package:receipes_app_02/domain/repositories/notifications_repository.dart';

class MarkNotificationsAsReadUseCase {
  final NotificationsRepository _notificationsRepository;

  MarkNotificationsAsReadUseCase(this._notificationsRepository);

  Future<void> execute(String notificationId) async {
    if(notificationId.isEmpty){
      throw ArgumentError('Notification ID is empty');
    }
    await _notificationsRepository.markNotificationAsRead(notificationId);
  }
}