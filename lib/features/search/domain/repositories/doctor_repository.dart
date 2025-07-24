import 'package:dartz/dartz.dart';
import 'package:shifaa/core/errors/failure.dart';
import 'package:shifaa/features/search/domain/entities/dtoctor_entity.dart';
// import 'package:shifaa/features/search/domain/entities/doctor_entity.dart';

abstract class DoctorRepository {
  Future<Either<Failure, List<DoctorEntity>>> searchForDoctors(String query);
}
