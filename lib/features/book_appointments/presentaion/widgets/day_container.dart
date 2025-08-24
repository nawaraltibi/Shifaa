import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DayContainer extends StatelessWidget {
  final String day;
  final String date;
  final bool isSelected;
  final bool isAvailable;
  final VoidCallback onTap;

  const DayContainer({
    super.key,
    required this.day,
    required this.date,
    required this.isSelected,
    required this.isAvailable,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color baseColor = isAvailable
        ? (isSelected ? const Color(0xFF5C85D9) : const Color(0xFFD9D9D9))
        : Colors.grey.shade300;

    return GestureDetector(
      onTap: isAvailable ? onTap : null,
      child: Container(
        width: 54.w,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(color: baseColor, width: 1.4),
        ),
        child: Column(
          children: [
            Text(
              day,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: isAvailable
                    ? (isSelected ? baseColor : Colors.black)
                    : Colors.grey.shade400,
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              date,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: isAvailable
                    ? (isSelected ? baseColor : Colors.black)
                    : Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
