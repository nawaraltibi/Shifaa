import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shifaa/core/errors/failure.dart';
import 'package:shifaa/features/auth/data/models/user_auth_model.dart';
import 'package:shifaa/features/auth/domain/repos/auth_repo.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, void>> sendOtp(String phoneNumber) async {
    try {
      await remote.sendOtp(phoneNumber);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDiorError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserAuthModel>> verifyOtp(
    String phoneNumber,
    String otp,
  ) async {
    try {
      final result = await remote.verifyOtp(phoneNumber, otp);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDiorError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserAuthModel>> register({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String gender,
    required int otp,
    required String dateOfBirth,
  }) async {
    try {
      final result = await remote.register(
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        gender: gender,
        otp: otp,
        dateOfBirth: dateOfBirth,
      );
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDiorError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserAuthModel>> verifyPassword({
    required String phone,
    required int otp,
    required String password,
  }) async {
    try {
      final result = await remote.verifyPassword(
        phone: phone,
        otp: otp,
        password: password,
      );
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDiorError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
