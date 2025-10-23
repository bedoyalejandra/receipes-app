import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:receipes_app_02/domain/entities/notification.dart';
import 'package:receipes_app_02/domain/repositories/notifications_repository.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final FirebaseFirestore _firestore;

  NotificationsRepositoryImpl({required FirebaseFirestore firestore})
    : _firestore = firestore;

  static const String collectionName = 'notifications';

  @override
  Stream<List<Notification>> getNotificationStream(String userId) {
    return _firestore
        .collection(collectionName)
        .where('receiverId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(20)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return Notification.fromJson(data);
          }).toList();
        });
  }

  @override
  Future<List<Notification>> getNotification(
    String userId, {
    int limit = 20,
    DateTime? startAfter,
  }) async {
    try {
      Query query = _firestore
          .collection(collectionName)
          .where('receiverId', isEqualTo: userId)
          .orderBy('createdAt', descending: true);

      if (startAfter != null) {
        query = query.startAfter([Timestamp.fromDate(startAfter)]);
      }

      query = query.limit(limit);

      final snapshot = await query.get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Notification.fromJson(data);
      }).toList();
    } catch (e) {
      print('Failed to get notifications: $e');
      throw Exception('Failed to get notifications: $e');
    }
  }

  @override
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _firestore.collection(collectionName).doc(notificationId).update({
        'isRead': true,
      });
    } catch (e) {
      print('Failed to mark notification as read: $e');
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  @override
  Future<void> createNotification(Notification notification) async {
    try {
      final docRef = _firestore.collection(collectionName).doc();
      final notificationData = notification.copyWith(id: docRef.id);
      await docRef.set(notificationData.toJson());
    } catch (e) {
      print('Failed to create notification: $e');
      throw Exception('Failed to create notification: $e');
    }
  }

  @override
  Future<void> createNotificationForMultipleUsers({
    required List<String> userIds,
    required String title,
    required String recipeId,
    required String senderId,
  }) async {
    try {
      final batch = _firestore.batch();
      final createdAt = DateTime.now();

      for (final userId in userIds) {
        final docRef = _firestore.collection(collectionName).doc();
        final notificationData = Notification(
          id: docRef.id,
          title: title,
          recipeId: recipeId,
          senderId: senderId,
          receiverId: userId,
          isRead: false,
          createdAt: createdAt,
        );
        batch.set(docRef, notificationData.toJson());
      }
      await batch.commit();
    } catch (e) {
      print('Failed to create notification for multiple users: $e');
      throw Exception('Failed to create notification for multiple users: $e');
    }
  }

  @override
  Future<int> getUnreadNotificationCount(String userId) async {
    try {
      final snapshots =
          await _firestore
              .collection(collectionName)
              .where('receiverId', isEqualTo: userId)
              .where('isRead', isEqualTo: false)
              .get();

      return snapshots.docs.length;
    } catch (e) {
      print('Failed to get unread notification count: $e');
      throw Exception('Failed to get unread notification count: $e');
    }
  }

  @override
  Stream<int> getUnreadNotificationCountStream(String userId) {
    return _firestore
        .collection(collectionName)
        .where('receiverId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}
