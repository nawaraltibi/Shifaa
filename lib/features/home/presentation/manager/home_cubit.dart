import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shifaa/features/appointments/domain/entities/appointment_entity.dart';
import 'package:shifaa/features/home/domain/entities/home_appointment_entity.dart';
import 'package:shifaa/features/home/domain/usecases/get_home_appointments_params.dart';
import 'package:shifaa/features/home/domain/usecases/get_home_previous_appointment_usecase.dart';
import 'package:shifaa/features/home/domain/usecases/get_home_upcoming_appointment_usecase.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetHomeUpcomingAppointmentUsecase getUpcomingAppointmentUsecase;
  final GetHomePreviousAppointmentUsecase getPreviousAppointmentUsecase;

  HomeCubit({
    required this.getUpcomingAppointmentUsecase,
    required this.getPreviousAppointmentUsecase,
  }) : super(const HomeState()) {
    fetchAppointments();
  }

  Future<void> fetchAppointments({bool forceRefresh = false}) async {
    if (forceRefresh) {
      emit(state.copyWith(status: HomeStatus.loading));
    }

    final params = GetHomeAppointmentsParams(forceRefresh: forceRefresh);
    final upcomingResult = await getUpcomingAppointmentUsecase(params);
    final previousResult = await getPreviousAppointmentUsecase(params);

    HomeState newState = state;

    upcomingResult.fold(
      (failure) => newState = newState.copyWith(status: HomeStatus.error, errorMessage: failure.message),
      (appointment) => newState = newState.copyWith(upcomingAppointment: appointment, clearUpcoming: appointment == null),
    );

    previousResult.fold(
      (failure) => newState = newState.copyWith(status: HomeStatus.error, errorMessage: failure.message),
      (appointment) => newState = newState.copyWith(previousAppointment: appointment, clearPrevious: appointment == null),
    );

    emit(newState.copyWith(status: HomeStatus.success));
  }
}
