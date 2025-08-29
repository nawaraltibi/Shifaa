import 'package:dartz/dartz.dart';
import 'package:shifaa/core/errors/failure.dart';
import 'package:shifaa/core/usecase/usecase.dart';
import 'package:shifaa/features/home/domain/entities/home_appointment_entity.dart';
import 'package:shifaa/features/home/domain/repositories/home_repository.dart';

// import 'package:shifaa/features/home/domain/entities/home_appointment_entity.dart';
// import 'package:shifaa/features/home/domain/repositories/home_repository.dart';

class GetHomeUpcomingAppointmentUsecase implements UseCase<HomeAppointmentEntity?, NoParams> {
  final HomeRepository repository;

  GetHomeUpcomingAppointmentUsecase(this.repository);

  @override
  Future<Either<Failure, HomeAppointmentEntity?>> call(NoParams params) async {
    return await repository.getUpcomingAppointment();
  }
}

