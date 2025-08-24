import 'package:flutter/material.dart';
import 'package:shifaa/features/notifications/data/models/notification_model.dart';
import 'package:shifaa/features/notifications/presentation/view/widgets/notification_group_card.dart';

class NotificationsViewBody extends StatelessWidget {
  const NotificationsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
   
    final notifications = NotificationModel.getMockNotifications();

  
    final groupedNotifications = _groupNotificationsByDate(notifications);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: groupedNotifications.length,
        itemBuilder: (context, index) {
          final date = groupedNotifications.keys.elementAt(index);
          final notificationsForDate = groupedNotifications[date]!;

          return NotificationGroupCard(
            date: date,
            notifications: notificationsForDate,
          );
        },
      ),
    );
  }

  Map<DateTime, List<NotificationModel>> _groupNotificationsByDate(
      List<NotificationModel> notifications) {
    final grouped = <DateTime, List<NotificationModel>>{};

    for (final notification in notifications) {
      final date = DateTime(
        notification.timestamp.year,
        notification.timestamp.month,
        notification.timestamp.day,
      );

      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(notification);
    }

   
    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    
    return Map.fromEntries(
      sortedKeys.map((key) => MapEntry(key, grouped[key]!)),
    );
  }
}
