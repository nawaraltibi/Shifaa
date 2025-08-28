import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shifaa/core/utils/app_colors.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';

class AppointmentStatusDetails extends StatelessWidget {
  const AppointmentStatusDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildDetailRow('Date', '3 August, Tuesday'),
        SizedBox(height: 16.h),
        _buildDetailRow('Time', '10 am - 10:30 am'),
        SizedBox(height: 16.h),
        _buildDetailRow('Status', 'Completed', valueColor: Colors.green),
      ],
    );
  }

  // ويدجت مساعد لتجنب تكرار الكود
  Widget _buildDetailRow(String title, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.regular14.copyWith(
            color: const Color(0xFF8D8D8D),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.regular15.copyWith(
            color: AppColors.primaryAppColor,
          ),
        ),
      ],
    );
  }
}
