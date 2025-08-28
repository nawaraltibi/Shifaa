import 'package:dartz/dartz.dart';
import 'package:shifaa/core/errors/failure.dart';
import 'package:shifaa/features/book_appointments/domain/repos/doctor_appointment_repo/doctor_appointment_repo.dart';

class RescheduleAppointmentUseCase {
  final AppointmentRepository _repository;

  RescheduleAppointmentUseCase(this._repository);

  Future<Either<Failure, Unit>> call({
    required int appointmentId,
    required String startTime,
    required int doctorScheduleId,
  }) async {
    return await _repository.rescheduleAppointment(
      appointmentId: appointmentId,
      startTime: startTime,
      doctorScheduleId: doctorScheduleId,
    );
  }
}
