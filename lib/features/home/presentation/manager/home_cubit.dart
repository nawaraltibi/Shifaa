import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shifaa/core/usecase/usecase.dart';
import 'package:shifaa/features/home/domain/entities/home_appointment_entity.dart';
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
    fetchAllHomeData();
  }

  Future<void> fetchAllHomeData() async {
    emit(state.copyWith(status: HomeStatus.loading));

    await Future.wait([
      _fetchUpcomingAppointment(),
      _fetchPreviousAppointment(),
    ]);

    // إذا لم يكن هناك خطأ، نغير الحالة إلى success
    if (state.errorMessage == null) {
      emit(state.copyWith(status: HomeStatus.success));
    }
  }

  Future<void> _fetchUpcomingAppointment() async {
    final result = await getUpcomingAppointmentUsecase(NoParams());
    result.fold(
      (failure) {
        emit(state.copyWith(status: HomeStatus.failure, errorMessage: failure.message));
      },
      (appointment) {
        emit(state.copyWith(upcomingAppointment: appointment, clearUpcoming: appointment == null));
      },
    );
  }

  Future<void> _fetchPreviousAppointment() async {
    final result = await getPreviousAppointmentUsecase(NoParams());
    result.fold(
      (failure) {
        emit(state.copyWith(status: HomeStatus.failure, errorMessage: failure.message));
      },
      (appointment) {
        emit(state.copyWith(previousAppointment: appointment, clearPrevious: appointment == null));
      },
    );
  }
}
