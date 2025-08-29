import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shifaa/core/errors/failure.dart';
import 'package:shifaa/features/home/data/datasources/home_remote_data_source.dart';
import 'package:shifaa/features/home/domain/entities/home_appointment_entity.dart';
import 'package:shifaa/features/home/domain/repositories/home_repository.dart';
// import 'package:shifaa/features/home/data/datasources/home_remote_data_source.dart';
// import 'package:shifaa/features/home/domain/entities/home_appointment_entity.dart';
// import 'package:shifaa/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, HomeAppointmentEntity?>> getUpcomingAppointment() async {
    try {
      final result = await remoteDataSource.getUpcomingAppointment();
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDiorError(e));
    }
  }

  @override
  Future<Either<Failure, HomeAppointmentEntity?>> getPreviousAppointment() async {
    try {
      final result = await remoteDataSource.getPreviousAppointment();
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDiorError(e));
    }
  }
}
