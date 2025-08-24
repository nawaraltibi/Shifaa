import 'package:dartz/dartz.dart';
import 'package:shifaa/core/errors/failure.dart';
import 'package:shifaa/features/book_appointments/data/models/doctor_schedule_model.dart';
import 'package:shifaa/features/book_appointments/domain/repos/doctor_schedule_repo/doctor_schedule_repo.dart';

class GetDoctorScheduleUseCase {
  final DoctorScheduleRepository repository;

  GetDoctorScheduleUseCase(this.repository);

  Future<Either<Failure, List<DoctorScheduleModel>>> call({
    required String doctorId,
    String? date,
  }) {
    return repository.getDoctorSchedules(doctorId: doctorId, date: date);
  }
}
