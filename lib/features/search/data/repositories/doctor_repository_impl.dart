import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shifaa/core/errors/failure.dart';
import 'package:shifaa/features/search/data/datasources/doctor_remote_data_source.dart';
import 'package:shifaa/features/search/domain/entities/dtoctor_entity.dart';
import 'package:shifaa/features/search/domain/repositories/doctor_repository.dart';

class DoctorRepositoryImplAshour implements DoctorRepositoryAshour {
  final DoctorRemoteDataSourceAshour remoteDataSource;

  DoctorRepositoryImplAshour({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<DoctorEntity>>> searchForDoctors(
    String query,
  ) async {
    try {
      final remoteDoctors = await remoteDataSource.searchForDoctors(query);
      return Right(remoteDoctors);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDiorError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}