import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shifaa/core/errors/failure.dart';
import 'package:shifaa/features/home/data/datasources/home_remote_data_source.dart';
import 'package:shifaa/features/home/data/models/previous_appointment_model.dart';
import 'package:shifaa/features/home/data/models/upcoming_appointment_model.dart';
import 'package:shifaa/features/home/domain/repositories/home_repository.dart';

import '../../domain/entities/previous_appointment_entity.dart';
import '../../domain/entities/upcoming_appointment_entity.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<UpcomingAppointment>>> getUpcomingAppointments({
    int? perPage,
  }) async {
    try {
      final response =
      await remoteDataSource.fetchAppointmentsResponse(perPage: perPage);
      final appointmentsJson = response['data']['appointments'] as List;

      final appointments = appointmentsJson
          .map((json) => UpcomingAppointmentModel.fromJson(json))
          .toList();

      return Right(appointments);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDiorError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PreviousAppointment>>> getPreviousAppointments({
    int? perPage,
  }) async {
    try {
      final response = await remoteDataSource.fetchAppointmentsResponse(
        time: 'past',
        perPage: perPage,
      );
      final appointmentsJson = response['data']['appointments'] as List;

      final appointments = appointmentsJson
          .map((json) => PreviousAppointmentModel.fromJson(json))
          .toList();

      return Right(appointments);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDiorError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
