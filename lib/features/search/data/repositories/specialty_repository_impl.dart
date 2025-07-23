import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shifaa/core/errors/failure.dart';
import 'package:shifaa/features/search/data/datasources/specialty_remote_data_source.dart';
import 'package:shifaa/features/search/domain/entities/specialty_entity.dart';
import 'package:shifaa/features/search/domain/repositories/specialty_repository.dart';

class SpecialtyRepositoryImpl implements SpecialtyRepository {
  final SpecialtyRemoteDataSource remoteDataSource;

  SpecialtyRepositoryImpl({
    required this.remoteDataSource,
    // required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<SpecialtyEntity>>> searchForSpecialties(String query) async {
  
      try {
        final remoteSpecialties = await remoteDataSource.searchForSpecialties(query);
      
        return Right(remoteSpecialties);
      } on DioException catch (e) {
 
        return Left(ServerFailure.fromDiorError(e));
      } catch (e) {
 
        return Left(ServerFailure(e.toString()));
      }
  
  }

}