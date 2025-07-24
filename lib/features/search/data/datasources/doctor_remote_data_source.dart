import 'package:dio/dio.dart';
import 'package:shifaa/features/search/data/models/doctor_model.dart';
// import 'package:shifaa/features/search/data/models/doctor_model.dart';

abstract class DoctorRemoteDataSource {
  Future<List<DoctorModel>> searchForDoctors(String query);
}

class DoctorRemoteDataSourceImpl implements DoctorRemoteDataSource {
  final Dio dio;

  DoctorRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<DoctorModel>> searchForDoctors(String query) async {
    final response = await dio.get(
      'doctors',
      queryParameters: {'search': query},
    );

    if (response.statusCode == 200 && response.data['success'] == true) {
      final List<dynamic> doctorsJson = response.data['data']['doctors'];
      return doctorsJson.map((json) => DoctorModel.fromJson(json)).toList();
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: response.data['message'] ?? 'Failed to fetch doctors',
      );
    }
  }
}