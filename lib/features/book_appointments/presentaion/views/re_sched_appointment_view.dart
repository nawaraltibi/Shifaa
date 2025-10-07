import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifaa/core/utils/functions/setup_service_locator.dart';
import 'package:shifaa/features/book_appointments/domain/usecases/cancel_appointment_use_case.dart';
import 'package:shifaa/features/book_appointments/presentaion/cubits/cancel_appointment/cancel_appointment_cubit.dart';

class ReSchedAppointmentView extends StatelessWidget {
  const ReSchedAppointmentView({super.key});

  static const routeName = '/re-sched-appointment';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CancelCubit(getIt<CancelAppointmentUseCase>()),
        ),
      ],
      child: Scaffold(backgroundColor: Colors.white, body: Container()),
    );
  }
}
