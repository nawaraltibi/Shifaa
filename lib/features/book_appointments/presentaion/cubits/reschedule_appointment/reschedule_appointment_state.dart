abstract class RescheduleState {}

class RescheduleInitial extends RescheduleState {}

class RescheduleLoading extends RescheduleState {}

class RescheduleSuccess extends RescheduleState {}

class RescheduleError extends RescheduleState {
  final String message;
  RescheduleError(this.message);
}
