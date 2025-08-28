import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shifaa/core/errors/failure.dart';
import 'package:shifaa/core/platform/network_info.dart';
import 'package:shifaa/features/appointments/data/datasources/appointment_local_data_source.dart';
import 'package:shifaa/features/appointments/data/datasources/appointment_remote_data_source_ashour.dart';
import 'package:shifaa/features/appointments/domain/entities/appointment_entity.dart';
import 'package:shifaa/features/appointments/domain/repositories/appointment_repository.dart';

class AppointmentRepositoryImplAshour implements AppointmentRepositoryAshour {
  final AppointmentRemoteDataSourceAshour remoteDataSource;
  final AppointmentLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AppointmentRepositoryImplAshour({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<AppointmentEntity>>> getUpcomingAppointments({
    bool forceRefresh = false,
  }) async {
    return _getAppointments(
      getLocal: () => localDataSource.getLastUpcomingAppointments(),
      getRemote: () => remoteDataSource.getAppointments('upcoming'),
      cacheLocal: (appointments) =>
          localDataSource.cacheUpcomingAppointments(appointments),
      forceRefresh: forceRefresh,
    );
  }

  @override
  Future<Either<Failure, List<AppointmentEntity>>> getPreviousAppointments({
    bool forceRefresh = false,
  }) async {
    return _getAppointments(
      getLocal: () => localDataSource.getLastPreviousAppointments(),
      getRemote: () => remoteDataSource.getAppointments('past'),
      cacheLocal: (appointments) =>
          localDataSource.cachePreviousAppointments(appointments),
      forceRefresh: forceRefresh,
    );
  }

  Future<Either<Failure, List<AppointmentEntity>>> _getAppointments({
    required Future<List<AppointmentEntity>> Function() getLocal,
    required Future<List<AppointmentEntity>> Function() getRemote,
    required Future<void> Function(List<AppointmentEntity>) cacheLocal,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      try {
        final localAppointments = await getLocal();
        if (localAppointments.isNotEmpty) return Right(localAppointments);
      } catch (e) {}
    }
    if (await networkInfo.isConnected) {
      try {
        final remoteAppointments = await getRemote();
        await cacheLocal(remoteAppointments);
        return Right(remoteAppointments);
      } on DioException catch (e) {
        return Left(ServerFailure.fromDiorError(e));
      }
    } else {
      try {
        final localAppointments = await getLocal();
        if (localAppointments.isNotEmpty) return Right(localAppointments);
      } catch (e) {}
      return const Left(
        CacheFailure('No internet connection and cache is empty.'),
      );
    }
  }
}
