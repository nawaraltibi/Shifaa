import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shifaa/core/utils/app_colors.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';

class DoctorStatsItem extends StatelessWidget {
  const DoctorStatsItem({
    super.key,
    required this.icon,
    required this.statNum,
    required this.statName,
    this.showPlus = true, // هذا هو الباراميتر الجديد
  });
  final IconData icon;
  final double statNum;
  final String statName;
  final bool showPlus;

  @override
  Widget build(BuildContext context) {
    final statNumText = statNum % 1 == 0
        ? statNum.toInt().toString()
        : statNum.toString();

    return Column(
      children: [
        Container(
          height: 67.h,
          width: 67.w,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFF1F4FF),
          ),
          child: Icon(icon, color: AppColors.primaryAppColor, size: 23.sp),
        ),
        const SizedBox(height: 6),
        Text(
          showPlus ? '$statNumText+' : statNumText,
          style: AppTextStyles.medium15.copyWith(
            color: AppColors.primaryAppColor,
          ),
        ),
        Text(
          statName,
          style: AppTextStyles.medium10.copyWith(
            color: const Color(0xFF8D8D8D),
            fontSize: 11.sp,
          ),
        ),
      ],
    );
  }
}
