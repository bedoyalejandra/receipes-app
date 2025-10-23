import 'package:receipes_app_02/domain/entities/notification.dart';
import 'package:receipes_app_02/domain/repositories/notifications_repository.dart';

class GetNotificationsStreamUseCase {
  final NotificationsRepository _notificationsRepository;

  GetNotificationsStreamUseCase(this._notificationsRepository);

  Stream<List<Notification>> execute(String userId) {
    if(userId.isEmpty){
      throw ArgumentError('User ID is empty');
    }
    return _notificationsRepository.getNotificationStream(userId);
  }
}