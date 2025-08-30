import 'package:dio/dio.dart';
import 'package:shifaa/features/search/data/models/doctor_model.dart';

abstract class SpecialtyDetailsRemoteDataSource {
  Future<List<DoctorModelAshour>> getDoctorsBySpecialty(int specialtyId);
}

class SpecialtyDetailsRemoteDataSourceImpl implements SpecialtyDetailsRemoteDataSource {
  final Dio dio;

  SpecialtyDetailsRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<DoctorModelAshour>> getDoctorsBySpecialty(int specialtyId) async {
    final response = await dio.get(
      'specialties/$specialtyId/doctors',
      queryParameters: {'per_page': 100},
    );

    if (response.statusCode == 200 && response.data['success'] == true) {
      final List<dynamic> doctorsJson = response.data['data']['doctors'];
      return doctorsJson.map((json) => DoctorModelAshour.fromJson(json)).toList();
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: response.data['message'] ?? 'Failed to fetch doctors',
      );
    }
  }
}