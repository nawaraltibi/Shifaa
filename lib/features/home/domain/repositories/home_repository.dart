import 'package:dartz/dartz.dart';

import 'package:shifaa/core/errors/failure.dart';
import 'package:shifaa/features/appointments/domain/entities/appointment_entity.dart';
import 'package:shifaa/features/home/domain/entities/home_appointment_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure,List <AppointmentEntity>?>> getUpcomingAppointment({bool forceRefresh = false});
  Future<Either<Failure, List<AppointmentEntity>?>> getPreviousAppointment({bool forceRefresh = false});
}

