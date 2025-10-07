import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';

class DoctorNotes extends StatelessWidget {
  const DoctorNotes({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Doctor\'s Notes',
          style: AppTextStyles.medium16.copyWith(fontSize: 20.sp),
        ),
        SizedBox(height: 8.h),
        Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
          style: AppTextStyles.regular12.copyWith(
            color: const Color(0xFF8D8D8D),
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
