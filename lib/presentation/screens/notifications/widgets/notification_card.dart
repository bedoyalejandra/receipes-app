import 'package:flutter/material.dart';
import 'package:receipes_app_02/domain/entities/notification.dart' as domain;

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    Key? key,
    required this.notification,
    required this.onTap,
  }) : super(key: key);

  final domain.Notification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'New Recipe Alert!',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    notification.title,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.blueGrey),
                  ),
                  SizedBox(height: 4),
                  Text(
                    _formatDate(notification.createdAt),
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.blueGrey),
                  ),
                ],
              ),
            ),

            Stack(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFB74D).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    Icons.restaurant_menu,
                    color: const Color(0xFFFFB74D),
                  ),
                ),

                if (!notification.isRead)
                   Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFB74D),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 0) {
      return '${diff.inDays} days ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} hours ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes} minutes ago';
    } else {
      return 'just now';
    }
  }
}
