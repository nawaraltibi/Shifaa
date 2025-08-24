import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:shifaa/core/errors/failure.dart';
import 'package:shifaa/core/usecase/usecase.dart';
import 'package:shifaa/features/appointments/domain/entities/appointment_entity.dart';
import 'package:shifaa/features/appointments/domain/repositories/appointment_repository.dart';

class GetPreviousAppointmentsUseCase implements UseCase<List<AppointmentEntity>, GetAppointmentsParams> {
  final AppointmentRepository repository;
  GetPreviousAppointmentsUseCase(this.repository);

  @override
  Future<Either<Failure, List<AppointmentEntity>>> call(GetAppointmentsParams params) async {
    return await repository.getPreviousAppointments(forceRefresh: params.forceRefresh);
  }
}


class GetAppointmentsParams extends Equatable {
  final bool forceRefresh;
  const GetAppointmentsParams({this.forceRefresh = false});
  @override
  List<Object> get props => [forceRefresh];
}
