import 'package:dartz/dartz.dart';
import 'package:shifaa/core/errors/failure.dart';
import 'package:shifaa/features/auth/data/models/user_auth_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> sendOtp(String phoneNumber);
  Future<Either<Failure, UserAuthModel>> verifyOtp(
    String phoneNumber,
    String otp,
  );
  Future<Either<Failure, UserAuthModel>> register({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String gender,
    required int otp,
    required String dateOfBirth,
  });
}
