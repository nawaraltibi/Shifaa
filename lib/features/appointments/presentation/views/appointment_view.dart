import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifaa/dependency_injection.dart';
import 'package:shifaa/features/appointments/presentation/manager/appointments_cubit.dart';
import 'package:shifaa/features/appointments/presentation/widgets/appointment_view_body.dart';
// import 'package:shifaa/core/utils/app_text_styles.dart';
// import 'package:shifaa/dependency_injection.dart';
// import 'package:shifaa/features/appointments/presentation/manager/appointments_cubit.dart';
// import 'package:shifaa/features/appointments/presentation/widgets/appointment_view_body.dart';

class AppointmentView extends StatelessWidget {
  const AppointmentView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AppointmentsCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('My appointments')),
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
        ),
        body: const Padding(
          padding: EdgeInsets.all(20.0),
          child: AppointmentViewBody(),
        ),
      ),
    );
  }
}
