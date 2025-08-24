import 'package:dartz/dartz.dart';
import 'package:shifaa/core/errors/failure.dart';
import 'package:shifaa/features/appointments/domain/entities/appointment_entity.dart';

abstract class AppointmentRepositoryAshour {
  Future<Either<Failure, List<AppointmentEntity>>> getUpcomingAppointments({
    bool forceRefresh = false,
  });
  Future<Either<Failure, List<AppointmentEntity>>> getPreviousAppointments({
    bool forceRefresh = false,
  });
}
