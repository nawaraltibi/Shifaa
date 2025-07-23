import 'package:dio/dio.dart';
import 'package:shifaa/features/search/data/models/specialty_model.dart';


abstract class SpecialtyRemoteDataSource {
 
  Future<List<SpecialtyModel>> searchForSpecialties(String query);
}

class SpecialtyRemoteDataSourceImpl implements SpecialtyRemoteDataSource {
  final Dio dio;

  SpecialtyRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<SpecialtyModel>> searchForSpecialties(String query) async {
    
    final response = await dio.get(
      'specialties', 
      queryParameters: {'search': query}, 
    );
    // ================================================

    if (response.statusCode == 200 && response.data['success'] == true) {
      final List<dynamic> specialtiesJson = response.data['data']['specialties'];
      return specialtiesJson.map((json) => SpecialtyModel.fromJson(json)).toList();
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: response.data['message'] ?? 'Failed to fetch data',
      );
    }
  }}