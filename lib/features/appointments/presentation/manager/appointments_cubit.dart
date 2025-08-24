import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shifaa/features/appointments/domain/entities/appointment_entity.dart';
import 'package:shifaa/features/appointments/domain/usecases/get_previous_appointments.dart';
import 'package:shifaa/features/appointments/domain/usecases/get_upcoming_appointments.dart';

part 'appointments_state.dart';

class AppointmentsCubit extends Cubit<AppointmentsLoadSuccess> {
  final GetUpcomingAppointmentsUseCase getUpcomingAppointmentsUseCase;
  final GetPreviousAppointmentsUseCase getPreviousAppointmentsUseCase;

  AppointmentsCubit({
    required this.getUpcomingAppointmentsUseCase,
    required this.getPreviousAppointmentsUseCase,
  }) : super(const AppointmentsLoadSuccess()) {
    fetchAppointments(isInitialLoad: true);
  }

  void changeAppointmentType(AppointmentType type) {
    emit(state.copyWith(appointmentType: type));
    fetchAppointments(isInitialLoad: true);
  }

  Future<void> fetchAppointments({bool forceRefresh = false, bool isInitialLoad = false}) async {
    if (forceRefresh || isInitialLoad) {
      emit(state.copyWith(isLoading: true, clearError: true));
    }
    
    final params = GetAppointmentsParams(forceRefresh: forceRefresh);
    final result = state.appointmentType == AppointmentType.upcoming
        ? await getUpcomingAppointmentsUseCase(params)
        : await getPreviousAppointmentsUseCase(params);

    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (appointments) => emit(state.copyWith(isLoading: false, appointments: appointments)),
    );
  }
}
