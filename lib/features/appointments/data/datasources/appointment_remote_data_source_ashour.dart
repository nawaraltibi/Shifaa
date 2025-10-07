import 'package:dio/dio.dart';
import 'package:shifaa/features/appointments/data/models/appointment_model.dart';
// import 'package:shifaa/features/appointments/data/models/appointment_model.dart';

abstract class AppointmentRemoteDataSourceAshour {
  Future<List<AppointmentModel>> getAppointments(String timeType);
}

class AppointmentRemoteDataSourceImpl
    implements AppointmentRemoteDataSourceAshour {
  final Dio dio;
  AppointmentRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<AppointmentModel>> getAppointments(String timeType) async {
    final response = await dio.get(
      'appointments',
      queryParameters: {
        'time': timeType,
        'per_page': 100,
      },
    );

    if (response.statusCode == 200 && response.data['success'] == true) {
      final List<dynamic> appointmentsJson =
          response.data['data']['appointments'];
      return appointmentsJson
          .map((json) => AppointmentModel.fromJson(json))
          .toList();
    } else {
      throw DioException(requestOptions: response.requestOptions);
    }
  }
}
