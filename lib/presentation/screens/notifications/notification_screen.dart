import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:receipes_app_02/components/custom_chip.dart';
import 'package:receipes_app_02/components/primary_button.dart';
import 'package:receipes_app_02/constants/spacing.dart';
import 'package:receipes_app_02/presentation/screens/notifications/widgets/notification_card.dart';
import 'package:receipes_app_02/providers/auth_provider.dart';
import 'package:receipes_app_02/providers/notifications_provider.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      final notificationsProvider = context.read<NotificationsProvider>();

      if (authProvider.currentUser != null) {
        notificationsProvider.initializeNotifications(
          authProvider.currentUser!.id,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.padding),
        child: Consumer<NotificationsProvider>(
          builder: (context, provider, child) {
            final notifications = provider.notifications;

            return Column(
              children: [
                Text(
                  'Notifications',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: CustomChip(
                        label: 'All',
                        isSelected: provider.filter == NotificationFilter.all,
                        onTap: () => provider.setFilter(NotificationFilter.all),
                      ),
                    ),
                    Expanded(
                      child: CustomChip(
                        label: 'Read',
                        isSelected: provider.filter == NotificationFilter.read,
                        onTap:
                            () => provider.setFilter(NotificationFilter.read),
                      ),
                    ),
                    Expanded(
                      child: CustomChip(
                        label: 'Unread',
                        isSelected:
                            provider.filter == NotificationFilter.unread,
                        onTap:
                            () => provider.setFilter(NotificationFilter.unread),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                if (provider.state == NotificationStatus.loading)
                  const Center(child: CircularProgressIndicator())
                else if (provider.state == NotificationStatus.error)
                  Center(
                    child: Column(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red),
                        SizedBox(height: 8),
                        Text(
                          provider.errorMessage ?? 'Something went wrong',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(color: Colors.red),
                        ),
                        SizedBox(height: 8),
                        PrimaryButton(
                          title: 'Retry',
                          onPressed: () {
                            final authProvider = context.read<AuthProvider>();
                            if (authProvider.currentUser != null) {
                              provider.initializeNotifications(
                                authProvider.currentUser!.id,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  )
                else if (provider.state == NotificationStatus.success)
                  if (notifications.isEmpty)
                    Expanded(
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.notifications_none, color: Colors.grey),
                            SizedBox(height: 8),
                            Text(
                              'No notifications',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount:
                            notifications.length +
                            (provider.state == NotificationStatus.loadingMore
                                ? 1
                                : 0),
                        itemBuilder: (context, index) {
                          if (index >= notifications.length) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final notification = notifications[index];
                          return NotificationCard(
                            notification: notification,
                            onTap: () async {
                              await provider.markNotificationsAsRead(notification.id);
                              //TODO: navigate to recipe screen
                            },
                          );
                        },
                      ),
                    ),
              ],
            );
          },
        ),
      ),
    );
  }
}
