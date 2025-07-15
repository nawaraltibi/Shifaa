import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shifaa/core/utils/app_images.dart';
import 'package:shifaa/features/appointments/presentaion/widgets/custom_doctor_details_app_bar.dart';
import 'package:shifaa/features/appointments/presentaion/widgets/doctor_important_info.dart';

class DoctorDetailsViewBody extends StatelessWidget {
  const DoctorDetailsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.0,
          colors: [
            Color(0xFFFFFFFF), // White at the center
            Color(0xFFF1F4FF), // Light purple at the edges
          ],
          stops: [0.0, 1.0],
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 30.w),
              child: Column(
                children: [
                  SizedBox(height: 40.h),
                  const CustomDoctorDetailsAppBar(),
                  SizedBox(height: 22.h),
                  const DoctorImportantInfo(
                    image: Assets.imagesDoctor1,
                    name: 'Dr. John Doe',
                    sessionPrice: 55,
                    specialization: 'Neurologist',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
