import 'package:shifaa/features/book_appointments/data/models/doctor_schedule_model.dart';

abstract class DoctorScheduleState {
  @override
  List<Object?> get props => [];
}

class DoctorScheduleInitial extends DoctorScheduleState {}

class DoctorScheduleLoading extends DoctorScheduleState {}

class DoctorScheduleSuccess extends DoctorScheduleState {
  final List<DoctorScheduleModel> schedule;
  final DateTime currentMonth;
  final DateTime? selectedDate;

  DoctorScheduleSuccess(this.schedule, this.currentMonth, this.selectedDate);

  @override
  List<Object?> get props => [schedule, currentMonth, selectedDate];
}

class DoctorScheduleError extends DoctorScheduleState {
  final String message;

  DoctorScheduleError(this.message);

  @override
  List<Object?> get props => [message];
}

class DoctorScheduleMonthChanged extends DoctorScheduleState {
  final List<DoctorScheduleModel> schedule;
  final DateTime currentMonth;
  final DateTime selectedDate;

  DoctorScheduleMonthChanged(
    this.schedule,
    this.currentMonth,
    this.selectedDate,
  );

  @override
  List<Object?> get props => [schedule, currentMonth, selectedDate];
}

class DoctorScheduleDateLoading extends DoctorScheduleState {
  final DateTime? selectedDate;
  DoctorScheduleDateLoading(this.selectedDate);

  @override
  List<Object?> get props => [selectedDate];
}
