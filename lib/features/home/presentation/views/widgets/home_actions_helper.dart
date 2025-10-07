import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifaa/core/utils/functions/setup_service_locator.dart';
import 'package:shifaa/features/book_appointments/domain/usecases/get_doctor_schedule_use_case.dart';
import 'package:shifaa/features/book_appointments/presentaion/cubits/cancel_appointment/cancel_appointment_cubit.dart';
import 'package:shifaa/features/book_appointments/presentaion/cubits/doctor_schedule_cubit/doctor_schedule_cubit.dart';
import 'package:shifaa/features/book_appointments/presentaion/cubits/reschedule_appointment/reschedule_appointment_cubit.dart';
import 'package:shifaa/features/book_appointments/presentaion/widgets/reschedule_sheet.dart';
import 'package:shifaa/core/widgets/custom_button.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';
import 'dart:ui' as ui;

import '../../../../book_appointments/domain/usecases/reschedule_appointment_use_case.dart';

void showRescheduleSheetForAppointment(BuildContext context, int appointmentId,int doctorId) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (_) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => DoctorScheduleCubit(getIt<GetDoctorScheduleUseCase>()),
          ),
          BlocProvider(
            create: (context) => RescheduleCubit(getIt<RescheduleAppointmentUseCase>()),
          ),
        ],
        child: RescheduleSheet(appointmentId: appointmentId, doctorId: doctorId),
      );
    },
  );
}

void showCancelConfirmationDialogForAppointment(BuildContext context, int appointmentId) {
  final cancelCubit = context.read<CancelCubit>();

  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Cancel Appointment"),
        content: const Text("Are you sure you want to cancel this appointment?"),
        actions: [
          TextButton(
            child: const Text("Keep"),
            onPressed: () => Navigator.pop(dialogContext),
          ),
          TextButton(
            child: const Text("Confirm"),
            onPressed: () {
              cancelCubit.confirmCancellation(appointmentId: appointmentId);
              Navigator.pop(dialogContext);
            },
          ),
        ],
      );
    },
  );
}
