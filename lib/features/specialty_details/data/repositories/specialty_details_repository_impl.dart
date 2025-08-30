import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shifaa/core/errors/failure.dart';
import 'package:shifaa/features/search/domain/entities/dtoctor_entity.dart';
import 'package:shifaa/features/specialty_details/data/datasources/specialty_details_remote_data_source.dart';
import 'package:shifaa/features/specialty_details/domain/repositories/specialty_details_repository.dart';

class SpecialtyDetailsRepositoryImpl implements SpecialtyDetailsRepository {
  final SpecialtyDetailsRemoteDataSource remoteDataSource;

  SpecialtyDetailsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<DoctorEntity>>> getDoctorsBySpecialty(int specialtyId) async {
    try {
      final remoteDoctors = await remoteDataSource.getDoctorsBySpecialty(specialtyId);
      return Right(remoteDoctors);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDiorError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}