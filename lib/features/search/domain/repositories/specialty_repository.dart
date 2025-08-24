import 'package:dartz/dartz.dart';
import 'package:shifaa/core/errors/failure.dart';
import 'package:shifaa/features/search/domain/entities/specialty_entity.dart';

abstract class SpecialtyRepository {
  Future<Either<Failure, List<SpecialtyEntity>>> searchForSpecialties(String query);
}

