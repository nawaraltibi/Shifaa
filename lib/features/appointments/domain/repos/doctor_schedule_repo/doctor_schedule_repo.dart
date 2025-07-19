import 'package:dartz/dartz.dart';
import 'package:shifaa/core/errors/failure.dart';
import 'package:shifaa/features/appointments/data/models/doctor_schedule_model.dart';

abstract class DoctorScheduleRepository {
  Future<Either<Failure, List<DoctorScheduleModel>>> getDoctorSchedules({
    required String doctorId,
    String? date,
  });
}
