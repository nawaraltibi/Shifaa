import 'package:dartz/dartz.dart';
import 'package:shifaa/core/errors/failure.dart';
import 'package:shifaa/core/usecase/usecase.dart';
import 'package:shifaa/features/appointments/domain/entities/appointment_entity.dart';

import 'package:shifaa/features/home/domain/entities/home_appointment_entity.dart';
import 'package:shifaa/features/home/domain/repositories/home_repository.dart';
import 'package:shifaa/features/home/domain/usecases/get_home_appointments_params.dart';


class GetHomePreviousAppointmentUsecase implements UseCase<List <AppointmentEntity>?, GetHomeAppointmentsParams> {
  final HomeRepository repository;
  GetHomePreviousAppointmentUsecase(this.repository);

  @override
  Future<Either<Failure, List <AppointmentEntity>?>> call(GetHomeAppointmentsParams params) async {
    return await repository.getPreviousAppointment(forceRefresh: params.forceRefresh);
  }
}

