import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:shifaa/core/errors/failure.dart';
import 'package:shifaa/core/usecase/usecase.dart';
import 'package:shifaa/features/search/domain/entities/specialty_entity.dart';
import 'package:shifaa/features/search/domain/repositories/specialty_repository.dart';

class SearchForSpecialtiesUseCase implements UseCase<List<SpecialtyEntity>, SearchParams> {
  final SpecialtyRepository repository;

  SearchForSpecialtiesUseCase(this.repository);

  @override
  Future<Either<Failure, List<SpecialtyEntity>>> call(SearchParams params) async {
    if (params.query.trim().isEmpty) {
     
      return const Right([]); 
    }
    return await repository.searchForSpecialties(params.query);
  }
}

class SearchParams extends Equatable {
  final String query;

  const SearchParams({required this.query});

  @override
  List<Object?> get props => [query];
}
