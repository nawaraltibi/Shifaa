import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shifaa/core/utils/app_colors.dart';
import 'package:shifaa/features/notifications/data/models/notification_model.dart';

class NotificationItemTile extends StatelessWidget {
  final NotificationModel notification;

  const NotificationItemTile({
    super.key,
    required this.notification,
  });

  Widget _buildIconWithDot() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: const Color(0xFFF5F5F5),
          child: Icon(
            notification.type == 'appointment'
                ? Icons.person_outline
                : Icons.notifications_outlined,
            color: AppColors.primaryAppColor,
            size: 20,
          ),
        ),
        if (!notification.isRead)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.primaryAppColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildIconWithDot(),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              notification.title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            DateFormat('HH:mm').format(notification.timestamp),
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
