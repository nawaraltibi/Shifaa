import 'package:flutter/material.dart';
import 'package:shifaa/core/utils/app_colors.dart';
import 'package:shifaa/features/appointments/domain/entities/appointment_entity.dart';
import 'package:shifaa/features/appointments/presentation/manager/appointments_cubit.dart';
// import 'package:shifaa/core/utils/app_colors.dart';
// import 'package:shifaa/core/utils/app_text_styles.dart';
// import 'package:shifaa/features/appointments/domain/entities/appointment_entity.dart';
// import 'package:shifaa/features/appointments/presentation/manager/appointments_cubit.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentEntity appointment;
  final AppointmentType type;

  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF5c85d9), // AppColors.primaryAppColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(appointment.imageUrl!),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(appointment.doctorName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(appointment.specialty, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
                ],
              ),
              const Spacer(),
              if (type == AppointmentType.upcoming)
                Container(
                  width: 40, height: 40,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: IconButton(onPressed: () {}, icon: const Icon(Icons.chat_bubble_outline, color: AppColors.primaryAppColor)),
                )
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white, thickness: 0.5),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoColumn(Icons.calendar_today_outlined, 'Date', appointment.date),
              _buildInfoColumn(Icons.access_time_outlined, 'Time', appointment.time),
            ],
          ),
          const SizedBox(height: 20),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    if (type == AppointmentType.upcoming) {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('Re-Schedule', style: TextStyle(color: AppColors.primaryAppColor)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryAppColor, // AppColors.secondaryAppColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      );
    } else { // Previous appointments
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Chat', style: TextStyle(color: AppColors.primaryAppColor)),
                  SizedBox(width: 4),
                  Icon(Icons.chat_bubble_outline, color: AppColors.primaryAppColor, size: 16),
                ],
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
              child: const Text('Details', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildInfoColumn(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppColors.secondaryAppColor, shape: BoxShape.circle), // AppColors.secondaryAppColor,
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 10)),
            Text(subtitle, style: const TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
      ],
    );
  }
}
