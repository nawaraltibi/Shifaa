import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifaa/features/appointments/domain/usecases/get_doctor_schedule_use_case.dart';
import 'doctor_schedule_state.dart';

class DoctorScheduleCubit extends Cubit<DoctorScheduleState> {
  final GetDoctorScheduleUseCase getDoctorScheduleUseCase;

  DoctorScheduleCubit(this.getDoctorScheduleUseCase)
    : super(DoctorScheduleInitial());

  Future<void> fetchDoctorSchedule(String doctorId) async {
    emit(DoctorScheduleLoading());

    final result = await getDoctorScheduleUseCase(doctorId: doctorId);
    result.fold((failure) => emit(DoctorScheduleError(failure.message)), (
      schedule,
    ) {
      emit(DoctorScheduleSuccess(schedule)); // ✅ رجّع الموديل كامل
    });
  }

  Future<void> fetchDoctorScheduleForDate(String doctorId, String date) async {
    emit(DoctorScheduleLoading());

    final result = await getDoctorScheduleUseCase(
      doctorId: doctorId,
      date: date, // مرر التاريخ
    );

    result.fold(
      (failure) => emit(DoctorScheduleError(failure.message)),
      (schedule) => emit(DoctorScheduleSuccess(schedule)),
    );
  }
}
