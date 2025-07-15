import 'package:dartz/dartz.dart';
import 'package:shifaa/core/errors/failure.dart';
import 'package:shifaa/features/auth/data/models/user_auth_model.dart';
import 'package:shifaa/features/auth/domain/repos/auth_repo.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, UserAuthModel>> call({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String gender,
    required int otp,
    required String dateOfBirth,
  }) {
    return repository.register(
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      gender: gender,
      otp: otp,
      dateOfBirth: dateOfBirth,
    );
  }
}
