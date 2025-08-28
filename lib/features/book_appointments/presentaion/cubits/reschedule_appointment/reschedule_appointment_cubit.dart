import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifaa/features/book_appointments/domain/usecases/reschedule_appointment_use_case.dart';
import 'package:shifaa/features/book_appointments/presentaion/cubits/reschedule_appointment/reschedule_appointment_state.dart';

class RescheduleCubit extends Cubit<RescheduleState> {
  final RescheduleAppointmentUseCase _rescheduleUseCase;

  RescheduleCubit(this._rescheduleUseCase) : super(RescheduleInitial());

  Future<void> confirmReschedule({
    required int appointmentId,
    required String startTime,
    required int doctorScheduleId,
  }) async {
    emit(RescheduleLoading());
    final result = await _rescheduleUseCase(
      appointmentId: appointmentId,
      startTime: startTime,
      doctorScheduleId: doctorScheduleId,
    );

    result.fold(
      (failure) => emit(RescheduleError(failure.message)),
      (_) => emit(RescheduleSuccess()),
    );
  }
}
