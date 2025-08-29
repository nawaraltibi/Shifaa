part of 'home_cubit.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final HomeAppointmentEntity? upcomingAppointment;
  final HomeAppointmentEntity? previousAppointment;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.upcomingAppointment,
    this.previousAppointment,
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? status,
    HomeAppointmentEntity? upcomingAppointment,
    HomeAppointmentEntity? previousAppointment,
    String? errorMessage,
    bool clearUpcoming = false,
    bool clearPrevious = false,
  }) {
    return HomeState(
      status: status ?? this.status,
      upcomingAppointment: clearUpcoming ? null : upcomingAppointment ?? this.upcomingAppointment,
      previousAppointment: clearPrevious ? null : previousAppointment ?? this.previousAppointment,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, upcomingAppointment, previousAppointment, errorMessage];
}
