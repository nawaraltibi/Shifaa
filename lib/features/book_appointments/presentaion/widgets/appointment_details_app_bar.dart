import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';
import 'package:shifaa/features/home/presentation/views/home_view.dart';

class AppointmentDetailsAppBar extends StatelessWidget {
  const AppointmentDetailsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            size: 25.sp,
            Icons.arrow_back,
            color: const Color(0xFFCECECE),
          ),
          onPressed: () => context.goNamed(HomeView.routeName),
        ),
        SizedBox(width: 50.w),
        Text(
          'Appointment Details',
          style: AppTextStyles.semiBold22.copyWith(fontSize: 18.sp),
        ),
      ],
    );
  }
}
