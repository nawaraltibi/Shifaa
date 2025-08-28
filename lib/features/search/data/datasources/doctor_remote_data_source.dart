import 'package:dio/dio.dart';
import 'package:shifaa/features/search/data/models/doctor_model_ashour.dart';

abstract class DoctorRemoteDataSourceAshour {
  Future<List<DoctorModelAshour>> searchForDoctors(String query);
}

class DoctorRemoteDataSourceImplAshour implements DoctorRemoteDataSourceAshour {
  final Dio dio;

  DoctorRemoteDataSourceImplAshour({required this.dio});

  @override
  Future<List<DoctorModelAshour>> searchForDoctors(String query) async {
    final response = await dio.get(
      'doctor',
      queryParameters: {'search': query},
    );

    if (response.statusCode == 200 && response.data['success'] == true) {
      final List<dynamic> doctorsJson = response.data['data']['doctors'];
      return doctorsJson
          .map((json) => DoctorModelAshour.fromJson(json))
          .toList();
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: response.data['message'] ?? 'Failed to fetch doctors',
      );
    }
  }
}
