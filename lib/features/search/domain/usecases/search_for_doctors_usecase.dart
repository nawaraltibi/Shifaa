import 'package:dartz/dartz.dart';
import 'package:shifaa/core/errors/failure.dart';
import 'package:shifaa/core/usecase/usecase.dart';
import 'package:shifaa/features/search/domain/entities/dtoctor_entity.dart';
import 'package:shifaa/features/search/domain/repositories/doctor_repository.dart';
import 'package:shifaa/features/search/domain/usecases/search_for_specialties_usecase.dart';

class SearchForDoctorsUseCase
    implements UseCase<List<DoctorEntity>, SearchParams> {
  final DoctorRepositoryAshour repository;

  SearchForDoctorsUseCase(this.repository);

  @override
  Future<Either<Failure, List<DoctorEntity>>> call(SearchParams params) async {
    return await repository.searchForDoctors(params.query);
  }
}
