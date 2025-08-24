import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shifaa/core/errors/failure.dart';
import 'package:shifaa/features/book_appointments/data/data_sources/doctor_details/doctor_remote_data_soucre.dart';
import 'package:shifaa/features/book_appointments/data/models/doctor_model.dart';
import 'package:shifaa/features/book_appointments/domain/repos/doctor_details_repo/doctor_repo.dart';

class DoctorRepositoryImpl implements DoctorRepository {
  final DoctorRemoteDataSource remoteDataSource;

  DoctorRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, DoctorModel>> getDoctorDetails(String doctorId) async {
    try {
      final doctor = await remoteDataSource.getDoctorDetails(doctorId);
      return Right(doctor);
    } on DioException catch (dioError) {
      return Left(ServerFailure.fromDiorError(dioError));
    } catch (e) {
      return Left(ServerFailure('حدث خطأ غير معروف: $e'));
    }
  }
}
