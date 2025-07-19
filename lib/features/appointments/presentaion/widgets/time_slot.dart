import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shifaa/core/utils/app_colors.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';

class TimeSlot extends StatelessWidget {
  final String time;
  final bool isSelected;
  final VoidCallback onTap;

  const TimeSlot({
    super.key,
    required this.time,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        borderRadius: BorderRadius.circular(30.r),
        color: Colors.white,
        child: Container(
          width: 90.w,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 5.h),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryAppColor
                  : Colors.transparent,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Text(
            time,
            style: AppTextStyles.regular12.copyWith(
              color: isSelected ? AppColors.primaryAppColor : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
