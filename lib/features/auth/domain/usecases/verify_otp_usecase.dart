import 'package:dartz/dartz.dart';
import 'package:shifaa/core/errors/failure.dart';
import 'package:shifaa/features/auth/data/models/user_auth_model.dart';
import '../repos/auth_repo.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<Either<Failure, UserAuthModel>> call(String phoneNumber, String otp) {
    return repository.verifyOtp(phoneNumber, otp);
  }
}
