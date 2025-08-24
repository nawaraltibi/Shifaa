part of 'appointments_cubit.dart';


enum AppointmentType { upcoming, previous }

sealed class AppointmentsState extends Equatable {
  const AppointmentsState();

  @override
  List<Object> get props => [];
}

class AppointmentsLoadSuccess extends AppointmentsState {
  final AppointmentType appointmentType;
  final List<AppointmentEntity> appointments;
  final bool isLoading;
  final String? errorMessage;

  const AppointmentsLoadSuccess({
    this.appointmentType = AppointmentType.upcoming,
    this.appointments = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  AppointmentsLoadSuccess copyWith({
    AppointmentType? appointmentType,
    List<AppointmentEntity>? appointments,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AppointmentsLoadSuccess(
      appointmentType: appointmentType ?? this.appointmentType,
      appointments: appointments ?? this.appointments,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [appointmentType, appointments, isLoading, errorMessage ?? ''];
}
