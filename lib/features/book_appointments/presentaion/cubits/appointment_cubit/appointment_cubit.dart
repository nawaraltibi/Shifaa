import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifaa/features/book_appointments/domain/usecases/book_appointment_use_case.dart';
import 'appointment_state.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  final BookAppointmentUseCase bookAppointmentUseCase;

  AppointmentCubit(this.bookAppointmentUseCase) : super(AppointmentInitial());

  Future<void> bookAppointment({
    required String startTime,
    required int doctorScheduleId,
  }) async {
    emit(AppointmentLoading());
    final result = await bookAppointmentUseCase(
      startTime: startTime,
      doctorScheduleId: doctorScheduleId,
    );
    if (isClosed) return;
    result.fold(
          (failure) => emit(AppointmentError(failure.message)),
          (_) => emit(AppointmentSuccess()),
    );
  }

  void reset() {
    if (isClosed) return;
    emit(AppointmentInitial());
  }
}
