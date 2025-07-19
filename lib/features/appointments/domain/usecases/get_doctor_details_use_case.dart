import 'package:dartz/dartz.dart';
import 'package:shifaa/core/errors/failure.dart';
import 'package:shifaa/features/appointments/data/models/doctor_model.dart';
import 'package:shifaa/features/appointments/domain/repos/doctor_details_repo/doctor_repo.dart';

class GetDoctorDetailsUseCase {
  final DoctorRepository repository;

  GetDoctorDetailsUseCase(this.repository);

  Future<Either<Failure, DoctorModel>> call(String doctorId) {
    return repository.getDoctorDetails(doctorId);
  }
}
