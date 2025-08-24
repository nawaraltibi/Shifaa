import 'package:dartz/dartz.dart';
import 'package:shifaa/core/errors/failure.dart';
import 'package:shifaa/features/book_appointments/domain/repos/doctor_appointment_repo/doctor_appointment_repo.dart';

class BookAppointmentUseCase {
  final AppointmentRepository repository;

  BookAppointmentUseCase(this.repository);

  Future<Either<Failure, Unit>> call({
    required String startTime,
    required int doctorScheduleId,
  }) {
    return repository.bookAppointment(
      startTime: startTime,
      doctorScheduleId: doctorScheduleId,
    );
  }
}
