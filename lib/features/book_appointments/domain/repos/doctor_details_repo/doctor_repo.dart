import 'package:dartz/dartz.dart';
import 'package:shifaa/core/errors/failure.dart';
import 'package:shifaa/features/book_appointments/data/models/doctor_model.dart';

abstract class DoctorRepository {
  Future<Either<Failure, DoctorModel>> getDoctorDetails(String doctorId);
}
