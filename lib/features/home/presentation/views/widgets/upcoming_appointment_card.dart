import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shifaa/core/utils/app_colors.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';
import 'package:shifaa/features/appointments/domain/entities/appointment_entity.dart';

class UpcomingAppointmentCard extends StatelessWidget {
  // Reverted: The widget now accepts a list of AppointmentEntity as requested.
  final List<AppointmentEntity> appointment;
  const UpcomingAppointmentCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    // A check to prevent crashes if an empty list is accidentally passed.
    if (appointment.isEmpty) {
      return const SizedBox.shrink(); // Or a placeholder widget
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryAppColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
                // Accessing the first element of the list.
                backgroundImage: appointment.first.imageUrl != null
                    ? CachedNetworkImageProvider(appointment.first.imageUrl!)
                    : null,
                child: appointment.first.imageUrl == null
                    ? const Icon(Icons.person, size: 40, color: AppColors.primaryAppColor)
                    : null,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appointment.first.doctorName, // Reverted: Using .first
                    style: AppTextStyles.semiBold16.copyWith(color: Colors.white),
                  ),
                  Text(
                    appointment.first.specialty, // Reverted: Using .first
                    style: AppTextStyles.regular12.copyWith(color: Colors.white.withOpacity(0.8)),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.chat_bubble_outline, color: AppColors.primaryAppColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white, thickness: 0.5),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoColumn(Icons.calendar_today_outlined, 'Date', appointment.first.date), // Reverted
              _buildInfoColumn(Icons.access_time_outlined, 'Time', appointment.first.time), // Reverted
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Text(
                    'Re-Schedule',
                    style: AppTextStyles.medium12.copyWith(color: AppColors.primaryAppColor),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryAppColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Text(
                    'Cancel',
                    style: AppTextStyles.medium12.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: AppColors.secondaryAppColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.regular10.copyWith(color: Colors.white.withOpacity(0.8))),
            Text(subtitle, style: AppTextStyles.medium12.copyWith(color: Colors.white)),
          ],
        ),
      ],
    );
  }
}

