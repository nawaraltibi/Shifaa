import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shifaa/core/utils/functions/setup_service_locator.dart';
import 'package:shifaa/core/widgets/custom_button.dart';
import 'package:shifaa/features/book_appointments/domain/usecases/reschedule_appointment_use_case.dart';
import 'package:shifaa/features/book_appointments/presentaion/cubits/doctor_schedule_cubit/doctor_schedule_cubit.dart';
import 'package:shifaa/features/book_appointments/domain/usecases/get_doctor_schedule_use_case.dart';
import 'package:shifaa/features/book_appointments/presentaion/cubits/reschedule_appointment/reschedule_appointment_cubit.dart';
import 'package:shifaa/features/treatmeant_plan/presentation/views/treatment_view.dart';

// ✅ الخطوة 1: قم باستيراد ملف الـ Service Locator

import 'reschedule_sheet.dart';
import 'package:shifaa/features/book_appointments/presentaion/widgets/appointment_details_app_bar.dart';
import 'package:shifaa/features/book_appointments/presentaion/widgets/appointment_status_details.dart';
import 'package:shifaa/features/book_appointments/presentaion/widgets/doctor_info_card.dart';
import 'package:shifaa/features/book_appointments/presentaion/widgets/doctor_notes.dart';

class ReSchedAppointmentViewBody extends StatelessWidget {
  const ReSchedAppointmentViewBody({super.key});

  void _showRescheduleSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  DoctorScheduleCubit(getIt<GetDoctorScheduleUseCase>()),
            ),
            BlocProvider(
              create: (context) =>
                  RescheduleCubit(getIt<RescheduleAppointmentUseCase>()),
            ),
          ],
          child: const RescheduleSheet(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 35.h, horizontal: 25.w),
      child: Column(
        children: [
          const AppointmentDetailsAppBar(),
          SizedBox(height: 50.h),
          const DoctorInfoCard(
            doctorName: 'Dr. George Doe',
            specialty: 'Neurologist',
            imageUrl: '',
          ),
          SizedBox(height: 30.h),
          const AppointmentStatusDetails(),
          SizedBox(height: 30.h),
          const Divider(color: Color(0xFFF0F0F0), thickness: 1.5),
          SizedBox(height: 30.h),
          const DoctorNotes(),
          SizedBox(height: 30.h),
          const Divider(color: Color(0xFFF0F0F0), thickness: 1.5),
          const Spacer(),
          CustomButton(
            text: 'View Treatment Plan',
            onPressed: () {
              context.goNamed(TreatmentView.routeName);
            },
            borderRadius: 35.r,
          ),
          SizedBox(height: 12.h),
          CustomButton(
            text: 'Re-Schedule',
            onPressed: () {
              _showRescheduleSheet(context);
            },
            borderRadius: 35.r,
          ),
          SizedBox(height: 12.h),
          CustomButton(
            text: 'Cancel',
            onPressed: () {},
            color: const Color(0xFFD95C5C),
            borderRadius: 35.r,
          ),
        ],
      ),
    );
  }
}
