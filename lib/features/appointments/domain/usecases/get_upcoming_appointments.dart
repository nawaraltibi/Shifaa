import 'package:dartz/dartz.dart';
import 'package:shifaa/core/errors/failure.dart';
import 'package:shifaa/core/usecase/usecase.dart';
import 'package:shifaa/features/appointments/domain/entities/appointment_entity.dart';
import 'package:shifaa/features/appointments/domain/repositories/appointment_repository.dart';
import 'package:shifaa/features/appointments/domain/usecases/get_previous_appointments.dart';

class GetUpcomingAppointmentsUseCase
    implements UseCase<List<AppointmentEntity>, GetAppointmentsParams> {
  final AppointmentRepositoryAshour repository;
  GetUpcomingAppointmentsUseCase(this.repository);
  @override
  Future<Either<Failure, List<AppointmentEntity>>> call(
    GetAppointmentsParams params,
  ) async {
    return await repository.getUpcomingAppointments(
      forceRefresh: params.forceRefresh,
    );
  }
}
