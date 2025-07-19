// doctor_schedule_state.dart

import 'package:shifaa/features/appointments/data/models/doctor_schedule_model.dart';

abstract class DoctorScheduleState {
  @override
  List<Object?> get props => [];
}

class DoctorScheduleInitial extends DoctorScheduleState {}

class DoctorScheduleLoading extends DoctorScheduleState {}

class DoctorScheduleSuccess extends DoctorScheduleState {
  final List<DoctorScheduleModel> schedule;

  DoctorScheduleSuccess(this.schedule);

  @override
  List<Object?> get props => [schedule];
}

class DoctorScheduleError extends DoctorScheduleState {
  final String message;

  DoctorScheduleError(this.message);

  @override
  List<Object?> get props => [message];
}
