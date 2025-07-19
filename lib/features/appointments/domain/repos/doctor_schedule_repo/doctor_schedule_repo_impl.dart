import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shifaa/core/errors/failure.dart';
import 'package:shifaa/features/appointments/data/data_sources/doctor_schedule/doctor_schedule_remote_data_source.dart';
import 'package:shifaa/features/appointments/data/models/doctor_schedule_model.dart';
import 'package:shifaa/features/appointments/domain/repos/doctor_schedule_repo/doctor_schedule_repo.dart';

class DoctorScheduleRepositoryImpl implements DoctorScheduleRepository {
  final DoctorScheduleRemoteDataSource remoteDataSource;

  DoctorScheduleRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<DoctorScheduleModel>>> getDoctorSchedules({
    required String doctorId,
    String? date,
  }) async {
    try {
      final schedules = await remoteDataSource.getDoctorSchedules(
        doctorId: doctorId,
        date: date,
      );
      return Right(schedules);
    } on DioException catch (dioError) {
      return Left(ServerFailure.fromDiorError(dioError));
    } catch (e) {
      return Left(ServerFailure('حدث خطأ غير متوقع: $e'));
    }
  }
}
