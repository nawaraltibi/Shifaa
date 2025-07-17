import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';
import 'package:shifaa/features/appointments/presentaion/widgets/doctor_details_title.dart';

class SelectTimeTitle extends StatelessWidget {
  const SelectTimeTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const DoctorDetailsTitle(text: 'Select Time'),
        const Spacer(),
        Icon(Icons.arrow_left, color: const Color(0xFFD9D9D9), size: 35.sp),
        Text(
          '8 Slots',
          style: AppTextStyles.regular14.copyWith(
            color: const Color(0xFFD9D9D9),
          ),
        ),
        Icon(Icons.arrow_right, color: const Color(0xFFD9D9D9), size: 35.sp),
      ],
    );
  }
}
