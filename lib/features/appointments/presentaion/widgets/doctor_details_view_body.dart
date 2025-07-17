import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shifaa/core/utils/app_images.dart';
import 'package:shifaa/core/widgets/custom_button.dart';
import 'package:shifaa/features/appointments/presentaion/widgets/about_doctor.dart';
import 'package:shifaa/features/appointments/presentaion/widgets/custom_doctor_details_app_bar.dart';
import 'package:shifaa/features/appointments/presentaion/widgets/doctor_details_title.dart';
import 'package:shifaa/features/appointments/presentaion/widgets/doctor_important_info.dart';
import 'package:shifaa/features/appointments/presentaion/widgets/doctor_stats.dart';
import 'package:shifaa/features/appointments/presentaion/widgets/select_date_list.dart';
import 'package:shifaa/features/appointments/presentaion/widgets/select_date_title.dart';
import 'package:shifaa/features/appointments/presentaion/widgets/select_time_title.dart';
import 'package:shifaa/features/appointments/presentaion/widgets/time_slots_list.dart';

class DoctorDetailsViewBody extends StatelessWidget {
  const DoctorDetailsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.0,
          colors: [Color(0xFFFFFFFF), Color(0xFFF1F4FF)],
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.w),
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
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        padding: EdgeInsets.only(
                          left: 22.w,
                          right: 22.w,
                          top: 35.h,
                          bottom: 54.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const DoctorStats(),
                            SizedBox(height: 25.h),
                            const DoctorDetailsTitle(text: 'About Doctor'),
                            const SizedBox(height: 10),
                            const AboutDoctor(
                              text:
                                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor Lorem ipsum dolor sit amet, consectetur',
                            ),
                            SizedBox(height: 30.h),
                            const SelectDateTitle(),
                            SizedBox(height: 15.h),
                            const SelectDateList(),
                            SizedBox(height: 25.h),
                            const SelectTimeTitle(),
                            const SizedBox(height: 14),
                            const TimeSlotsList(),
                            SizedBox(height: 25.h),
                            CustomButton(
                              text: "Book",
                              onPressed: () {},
                              borderRadius: 35.r,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
