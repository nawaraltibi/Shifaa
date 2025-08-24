import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shifaa/core/errors/failure.dart';
import 'package:shifaa/features/book_appointments/data/data_sources/doctor_appointment/doctor_details/doctor_appointment_remote_data_source.dart';
import 'package:shifaa/features/book_appointments/domain/repos/doctor_appointment_repo/doctor_appointment_repo.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentRemoteDataSource remoteDataSource;

  AppointmentRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, Unit>> bookAppointment({
    required String startTime,
    required int doctorScheduleId,
  }) async {
    try {
      await remoteDataSource.bookAppointment(
        startTime: startTime,
        doctorScheduleId: doctorScheduleId,
      );
      return const Right(unit); // نجح الحجز
    } on DioException catch (dioError) {
      return Left(ServerFailure.fromDiorError(dioError));
    } catch (e) {
      return Left(ServerFailure('حدث خطأ غير متوقع: $e'));
    }
  }
}
