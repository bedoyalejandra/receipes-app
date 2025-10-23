import 'package:cloud_firestore/cloud_firestore.dart';

class Notification {
  final String id;
  final String title;
  final String recipeId;
  final String senderId;
  final String receiverId;
  final bool isRead;
  final DateTime createdAt;

  Notification({
    required this.id,
    required this.title,
    required this.recipeId,
    required this.senderId,
    required this.receiverId,
    required this.isRead,
    required this.createdAt,
  });

  Notification copyWith({
    String? id,
    String? title,
    String? recipeId,
    String? senderId,
    String? receiverId,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return Notification(
      id: id ?? this.id,
      title: title ?? this.title,
      recipeId: recipeId ?? this.recipeId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      title: json['title'],
      recipeId: json['recipeId'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      isRead: json['isRead'] ?? false,
      createdAt: _parseDateTime(json['createdAt']),
    );
  }

  toJson() {
    return {
      'id': id,
      'title': title,
      'recipeId': recipeId,
      'senderId': senderId,
      'receiverId': receiverId,
      'isRead': isRead,
      'createdAt': createdAt,
    };
  }

  static _parseDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    } else if (value is String) {
      return DateTime.parse(value);
    } else if (value is DateTime) {
      return value;
    }
    throw ArgumentError('Invalid value for createdAt');
  }

  @override
  String toString() {
    return 'Notification(id: $id, title: $title, recipeId: $recipeId, senderId: $senderId, receiverId: $receiverId, isRead: $isRead, createdAt: $createdAt)';
  }
}
