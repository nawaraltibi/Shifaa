import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shifaa/features/notifications/data/models/notification_model.dart';
import 'package:shifaa/features/notifications/presentation/view/widgets/notification_item_tile.dart';

class NotificationGroupCard extends StatelessWidget {
  final DateTime date;
  final List<NotificationModel> notifications;

  const NotificationGroupCard({
    super.key,
    required this.date,
    required this.notifications,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              DateFormat('dd / MM / yyyy').format(date),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: notifications.length,
            itemBuilder: (context, index) => NotificationItemTile(
              notification: notifications[index],
            ),
          ),
        ],
      ),
    );
  }
}
