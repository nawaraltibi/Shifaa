import 'package:dartz/dartz.dart';
import 'package:shifaa/core/errors/failure.dart';
import 'package:shifaa/features/home/domain/entities/home_appointment_entity.dart';
// import 'package:shifaa/features/home/domain/entities/home_appointment_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, HomeAppointmentEntity?>> getUpcomingAppointment();
  Future<Either<Failure, HomeAppointmentEntity?>> getPreviousAppointment();
}
