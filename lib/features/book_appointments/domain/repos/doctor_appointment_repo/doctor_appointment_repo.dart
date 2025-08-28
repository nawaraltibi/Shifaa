import 'package:dartz/dartz.dart';
import 'package:shifaa/core/errors/failure.dart';

abstract class AppointmentRepository {
  Future<Either<Failure, Unit>> bookAppointment({
    required String startTime,
    required int doctorScheduleId,
  });
  Future<Either<Failure, Unit>> rescheduleAppointment({
    required int appointmentId,
    required String startTime,
    required int doctorScheduleId,
  });
}
