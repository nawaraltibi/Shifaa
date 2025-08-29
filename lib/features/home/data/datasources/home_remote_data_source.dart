import 'package:dio/dio.dart';
import 'package:shifaa/features/home/data/models/home_appointment_model.dart';
// import 'package:shifaa/features/home/data/models/home_appointment_model.dart';

abstract class HomeRemoteDataSource {
  Future<HomeAppointmentModel?> getUpcomingAppointment();
  Future<HomeAppointmentModel?> getPreviousAppointment();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;
  HomeRemoteDataSourceImpl({required this.dio});

  Future<HomeAppointmentModel?> _getAppointment(String timeType) async {
    final response = await dio.get(
      'appointments',
      queryParameters: {
        'time': timeType,
        'per_page': 1, // لجلب موعد واحد فقط
      },
    );

    if (response.statusCode == 200 && response.data['success'] == true) {
      final List<dynamic> appointmentsJson = response.data['data']['appointments'];
      if (appointmentsJson.isNotEmpty) {
        return HomeAppointmentModel.fromJson(appointmentsJson.first);
      }
      return null; // لا يوجد مواعيد من هذا النوع
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
      );
    }
  }

  @override
  Future<HomeAppointmentModel?> getUpcomingAppointment() async {
    return _getAppointment('upcoming');
  }

  @override
  Future<HomeAppointmentModel?> getPreviousAppointment() async {
    return _getAppointment('past');
  }
}

