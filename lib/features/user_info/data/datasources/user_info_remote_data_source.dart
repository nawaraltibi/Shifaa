import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shifaa/core/models/user_model_local.dart';
import 'package:shifaa/core/utils/shared_prefs_helper.dart'; // افترض وجود هذا الملف
import 'package:shifaa/features/user_info/data/models/user_info_model.dart';

abstract class UserInfoRemoteDataSource {
  Future<UserInfoModel> getUserInfo();
}

class UserInfoRemoteDataSourceImpl implements UserInfoRemoteDataSource {
  final Dio dio;
  final sharedPref = SharedPrefsHelper.instance;

  UserInfoRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserInfoModel> getUserInfo() async {
    UserLocalModel user = await sharedPref.getUserModel();
    //final patientId = user.patientId;
    final patientId = 1;

    if (patientId == 0) {
      throw Exception('Patient ID not found in local storage.');
    }

    final response = await dio.get('patient/$patientId');

    if (response.statusCode == 200 && response.data['success'] == true) {
      return UserInfoModel.fromJson(response.data['data']['patient']);
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: response.data['message'] ?? 'Failed to fetch user info',
      );
    }
  }
}