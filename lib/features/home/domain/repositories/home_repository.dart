import 'package:dartz/dartz.dart';
import 'package:shifaa/core/errors/failure.dart';

import '../entities/previous_appointment_entity.dart';
import '../entities/upcoming_appointment_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<UpcomingAppointment>>> getUpcomingAppointments({
    int? perPage,
  });

  Future<Either<Failure, List<PreviousAppointment>>> getPreviousAppointments({
    int? perPage,
  });
}
