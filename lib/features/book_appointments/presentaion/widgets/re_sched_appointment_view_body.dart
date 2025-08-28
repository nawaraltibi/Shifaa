import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shifaa/core/utils/functions/setup_service_locator.dart';
import 'package:shifaa/core/widgets/custom_button.dart';
import 'package:shifaa/features/book_appointments/domain/usecases/get_doctor_schedule_use_case.dart';
import 'package:shifaa/features/book_appointments/domain/usecases/reschedule_appointment_use_case.dart';
import 'package:shifaa/features/book_appointments/presentaion/cubits/cancel_appointment/cancel_appointment_cubit.dart';
import 'package:shifaa/features/book_appointments/presentaion/cubits/cancel_appointment/cancel_appointment_state.dart';
import 'package:shifaa/features/book_appointments/presentaion/cubits/doctor_schedule_cubit/doctor_schedule_cubit.dart';
import 'package:shifaa/features/book_appointments/presentaion/cubits/reschedule_appointment/reschedule_appointment_cubit.dart';
import 'package:shifaa/features/book_appointments/presentaion/views/re_sched_appointment_view.dart';
import 'package:shifaa/features/treatmeant_plan/presentation/views/treatment_view.dart';
import 'package:shifaa/core/utils/app_colors.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';
import 'dart:ui' as ui;

import 'reschedule_sheet.dart';
import 'package:shifaa/features/book_appointments/presentaion/widgets/appointment_details_app_bar.dart';
import 'package:shifaa/features/book_appointments/presentaion/widgets/appointment_status_details.dart';
import 'package:shifaa/features/book_appointments/presentaion/widgets/doctor_info_card.dart';
import 'package:shifaa/features/book_appointments/presentaion/widgets/doctor_notes.dart';

class ReSchedAppointmentViewBody extends StatelessWidget {
  const ReSchedAppointmentViewBody({super.key});

  // --- دالة إظهار ورقة إعادة الجدولة ---
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
        // ✅ تم إزالة BlocProvider الخاص بـ CancelCubit من هنا
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

  // --- دالة إظهار Dialog تأكيد الإلغاء ---
  void _showCancelConfirmationDialog(BuildContext context) {
    final cancelCubit = context.read<CancelCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Color(0xFFD95C5C)),
              const SizedBox(width: 8),
              Text(
                "Cancel Appointment",
                style: AppTextStyles.semiBold18.copyWith(fontSize: 20.sp),
              ),
            ],
          ),
          content: Text(
            "Are you sure you want to cancel this appointment? This action cannot be undone.",
            style: AppTextStyles.regular15,
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              textDirection: ui.TextDirection.ltr,
              children: [
                SizedBox(
                  height: 40.h,
                  width: 110.w,
                  child: CustomButton(
                    text: "Keep",
                    onPressed: () => Navigator.pop(dialogContext),
                    borderRadius: 35.r,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(width: 20.w),
                SizedBox(
                  height: 40.h,
                  width: 110.w,
                  child: CustomButton(
                    text: "Confirm",
                    onPressed: () {
                      cancelCubit.confirmCancellation(
                        appointmentId: 30, // قيمة ثابتة حسب الطلب
                      );
                      context.goNamed(ReSchedAppointmentView.routeName);
                    },
                    borderRadius: 35.r,
                    color: const Color(0xFFD95C5C),
                  ),
                ),
              ],
            ),
          ],
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
          BlocListener<CancelCubit, CancelState>(
            listener: (context, state) {
              if (state is! CancelLoading && Navigator.canPop(context)) {
                Navigator.pop(context);
              }

              if (state is CancelLoading) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) =>
                      const Center(child: CircularProgressIndicator()),
                );
              } else if (state is CancelSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Appointment cancelled successfully!'),
                    backgroundColor: Colors.blue,
                  ),
                );
                // يمكنك إضافة .pop() هنا إذا أردت الخروج من الشاشة بعد الإلغاء
                // context.pop();
              } else if (state is CancelError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: CustomButton(
              text: 'Cancel',
              onPressed: () {
                _showCancelConfirmationDialog(context);
              },
              color: const Color(0xFFD95C5C),
              borderRadius: 35.r,
            ),
          ),
        ],
      ),
    );
  }
}
