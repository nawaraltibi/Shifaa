import 'package:dio/dio.dart';
import 'package:shifaa/features/appointments/data/models/appointment_model.dart';

// Abstract class defining the contract for the home feature's remote data source.
abstract class HomeRemoteDataSource {
  /// Fetches the single next upcoming appointment.
  /// Returns a list containing zero or one appointment.
  Future<List<AppointmentModel>> getUpcomingAppointment();

  /// Fetches the single most recent previous appointment.
  /// Returns a list containing zero or one appointment.
  Future<List<AppointmentModel>> getPreviousAppointment();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;
  HomeRemoteDataSourceImpl({required this.dio});

  /// Generic private method to fetch appointments based on a time type.
  /// The API is configured to return only one appointment per request ('per_page': 1).
  Future<List<AppointmentModel>> _getAppointments(String timeType) async {
    final response = await dio.get(
      'appointments',
      queryParameters: {'per_page': 1, 'time': timeType},
    );

    if (response.statusCode == 200 && response.data['success'] == true) {
      final List appointmentsJson = response.data['data']['appointments'];
      
      // The API returns a list (even with one item), so we correctly map it 
      // from a list of JSON objects to a list of AppointmentModel objects.
      return (appointmentsJson as List)
          .map((appointment) => AppointmentModel.fromJson(appointment))
          .toList();
    } else {
      // Throw a DioException if the request was not successful.
      throw DioException(requestOptions: response.requestOptions);
    }
  }

  @override
  Future<List<AppointmentModel>> getUpcomingAppointment() => _getAppointments('upcoming');

  @override
  Future<List<AppointmentModel>> getPreviousAppointment() => _getAppointments('past');
}
