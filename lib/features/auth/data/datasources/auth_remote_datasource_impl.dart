import 'package:shifaa/core/api/api_consumer.dart';
import 'package:shifaa/core/api/end_ponits.dart';
import 'package:shifaa/features/auth/data/models/user_auth_model.dart';
import 'auth_remote_datasource.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiConsumer api;

  AuthRemoteDataSourceImpl(this.api);

  @override
  Future<void> sendOtp(String phoneNumber) async {
    await api.post(EndPoint.sendOtp, data: {"phone_number": phoneNumber});
  }

  @override
  Future<UserAuthModel> verifyOtp(String phoneNumber, String otp) async {
    final response = await api.post(
      EndPoint.verifyOtp,
      data: {"phone_number": phoneNumber, "otp": otp},
    );

    return UserAuthModel.fromJson(response);
  }

  @override
  Future<UserAuthModel> register({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String gender,
    required int otp,
    required String dateOfBirth,
  }) async {
    final response = await api.post(
      EndPoint.register,
      data: {
        "first_name": firstName,
        "last_name": lastName,
        "phone_number": phoneNumber,
        "gender": gender,
        "otp": otp,
        "date_of_birth": dateOfBirth,
      },
    );

    return UserAuthModel.fromJson(response); // ✅ رجع الريسبونس
  }
}
