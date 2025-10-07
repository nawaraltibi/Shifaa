import 'package:equatable/equatable.dart';

class AppointmentsSummary<T> extends Equatable {
  final int totalCount;

  final T? latestAppointment;

  const AppointmentsSummary({
    required this.totalCount,
    this.latestAppointment,
  });

  @override
  List<Object?> get props => [totalCount, latestAppointment];
}
