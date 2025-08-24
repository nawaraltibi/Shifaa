import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifaa/features/book_appointments/domain/usecases/get_doctor_details_use_case.dart';
import 'package:shifaa/features/book_appointments/domain/usecases/get_doctor_schedule_use_case.dart';
import 'package:shifaa/features/book_appointments/domain/usecases/book_appointment_use_case.dart'; // إذا عندك use case للحجز
import 'package:shifaa/features/book_appointments/presentaion/cubits/doctor_details_cubit/doctor_details_cubit.dart';
import 'package:shifaa/features/book_appointments/presentaion/cubits/doctor_schedule_cubit/doctor_schedule_cubit.dart';
import 'package:shifaa/features/book_appointments/presentaion/cubits/appointment_cubit/appointment_cubit.dart'; // Cubit الحجز
import 'package:shifaa/features/book_appointments/presentaion/widgets/doctor_details_view_body.dart';
import 'package:shifaa/core/utils/functions/setup_service_locator.dart';
import 'package:shifaa/features/chat/domain/usecases/create_chat_use_case.dart';
import 'package:shifaa/features/chat/presentation/cubits/create_chat_cubit/create_chat_cubit.dart';

class DoctorDetailsView extends StatelessWidget {
  const DoctorDetailsView({super.key, required this.doctorId});
  static const String routeName = '/doctor_details';

  final int doctorId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                DoctorDetailsCubit(getIt<GetDoctorDetailsUseCase>())
                  ..fetchDoctorDetails(doctorId.toString()),
          ),
          BlocProvider(
            create: (context) =>
                DoctorScheduleCubit(getIt<GetDoctorScheduleUseCase>())
                  ..fetchDoctorSchedule(doctorId.toString()),
          ),
          BlocProvider(
            create: (context) =>
                AppointmentCubit(getIt<BookAppointmentUseCase>()),
          ),
          BlocProvider(
            create: (context) => CreateChatCubit(getIt<CreateChat>()),
          ),
        ],
        child: DoctorDetailsViewBody(doctorId: doctorId.toString()),
      ),
    );
  }
}
