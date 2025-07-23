import 'package:flutter/material.dart';
import 'package:shifaa/core/utils/app_colors.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';

class PreviousAppointmentCard extends StatelessWidget {
  const PreviousAppointmentCard({super.key});

  @override
  Widget build(BuildContext context) {
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
              const CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: AppColors.primaryAppColor,),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dr. George Doe',
                      style: AppTextStyles.semiBold16
                          .copyWith(color: Colors.white)),
                  Text('Cardiologist',
                      style: AppTextStyles.regular12
                          .copyWith(color: Colors.white.withOpacity(0.8))),
                ],
              ),
              const Spacer(),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.chat_bubble_outline,
                      color: Colors.white),
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white, thickness: 0.5),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoColumn(Icons.calendar_today_outlined, 'Date', '11 May, Wednesday'),
              _buildInfoColumn(Icons.access_time_outlined, 'Time', '8 am - 8:30 am'),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Completed',
                    style: AppTextStyles.medium12.copyWith(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryAppColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Details',
                    style: AppTextStyles.medium12.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildInfoColumn(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: AppTextStyles.regular10
                    .copyWith(color: Colors.white.withOpacity(0.8))),
            Text(subtitle,
                style: AppTextStyles.medium12.copyWith(color: Colors.white)),
          ],
        ),
      ],
    );
  }
} 