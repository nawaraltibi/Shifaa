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
      return const Right(unit);
    } on DioException catch (dioError) {
      return Left(ServerFailure.fromDiorError(dioError));
    } catch (e) {
      return Left(ServerFailure('حدث خطأ غير متوقع: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> rescheduleAppointment({
    required int appointmentId,
    required String startTime,
    required int doctorScheduleId,
  }) async {
    try {
      await remoteDataSource.rescheduleAppointment(
        appointmentId: appointmentId,
        startTime: startTime,
        doctorScheduleId: doctorScheduleId,
      );
      return const Right(unit);
    } on DioException catch (dioError) {
      return Left(ServerFailure.fromDiorError(dioError));
    } catch (e) {
      return Left(ServerFailure('حدث خطأ غير متوقع: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> cancelAppointment({
    required int appointmentId,
  }) async {
    try {
      await remoteDataSource.cancelAppointment(appointmentId: appointmentId);
      return const Right(unit);
    } on DioException catch (dioError) {
      return Left(ServerFailure.fromDiorError(dioError));
    } catch (e) {
      return Left(ServerFailure('حدث خطأ غير متوقع: $e'));
    }
  }
}
