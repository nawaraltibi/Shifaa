import 'package:shifaa/features/auth/data/models/user_auth_model.dart';

abstract class AuthRemoteDataSource {
  Future<void> sendOtp(String phoneNumber);
  Future<UserAuthModel> verifyOtp(String phoneNumber, String otp);
  Future<UserAuthModel> register({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String gender,
    required int otp,
    required String dateOfBirth,
  });

  Future<UserAuthModel> verifyPassword({
    required String phone,
    required int otp,
    required String password,
  });
}
