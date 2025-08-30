import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shifaa/core/errors/failure.dart';
import 'package:shifaa/core/platform/network_info.dart';
import 'package:shifaa/features/appointments/domain/entities/appointment_entity.dart';
import 'package:shifaa/features/home/data/datasources/home_local_data_source.dart';
import 'package:shifaa/features/home/data/datasources/home_remote_data_source.dart';
import 'package:shifaa/features/home/domain/entities/home_appointment_entity.dart';
import 'package:shifaa/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  final HomeLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  HomeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List <AppointmentEntity>?>> getUpcomingAppointment({bool forceRefresh = false}) async {
    return _getAppointment(
      forceRefresh: forceRefresh,
      getLocal: localDataSource.getUpcomingAppointment,
      getRemote: remoteDataSource.getUpcomingAppointment,
      cacheRemote: localDataSource.cacheUpcomingAppointment,
    );
  }

  @override
  Future<Either<Failure,List <AppointmentEntity>?>> getPreviousAppointment({bool forceRefresh = false}) async {
    return _getAppointment(
      forceRefresh: forceRefresh,
      getLocal: localDataSource.getPreviousAppointment,
      getRemote: remoteDataSource.getPreviousAppointment,
      cacheRemote: localDataSource.cachePreviousAppointment,
    );
  }

  // دالة مساعدة لتجنب تكرار الكود
  Future<Either<Failure, List <AppointmentEntity>?>> _getAppointment({
    required bool forceRefresh,
    required Future<List <AppointmentEntity>?> Function() getLocal,
    required Future<List <AppointmentEntity>?> Function() getRemote,
    required Future<void> Function(List <AppointmentEntity>) cacheRemote,
  }) async {
    if (!forceRefresh) {
      final List<AppointmentEntity>? localData = await getLocal();
      if (localData != null) return Right(localData);
    }
    if (await networkInfo.isConnected) {
      try {
        final List<AppointmentEntity>? remoteData = await getRemote();
        if (remoteData != null) {
          await cacheRemote(remoteData );
        }
        return Right(remoteData);
      } on DioException catch (e) {
        return Left(ServerFailure.fromDiorError(e));
      }
    } else {
      final List<AppointmentEntity>? localData = await getLocal();
      if (localData != null) return Right(localData);
      return Left(ServerFailure('No Internet Connection and no cached data.'));
    }
  }
}
