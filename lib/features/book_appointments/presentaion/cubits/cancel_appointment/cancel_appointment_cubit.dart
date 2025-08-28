import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifaa/features/book_appointments/domain/usecases/cancel_appointment_use_case.dart';
import 'package:shifaa/features/book_appointments/presentaion/cubits/cancel_appointment/cancel_appointment_state.dart';

class CancelCubit extends Cubit<CancelState> {
  final CancelAppointmentUseCase _cancelUseCase;

  CancelCubit(this._cancelUseCase) : super(CancelInitial());

  Future<void> confirmCancellation({required int appointmentId}) async {
    emit(CancelLoading());
    final result = await _cancelUseCase(appointmentId: appointmentId);

    result.fold(
      (failure) => emit(CancelError(failure.message)),
      (_) => emit(CancelSuccess()),
    );
  }
}
