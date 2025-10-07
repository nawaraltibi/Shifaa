import 'package:dio/dio.dart';
import 'package:shifaa/core/api/api_consumer.dart';
import 'package:shifaa/features/home/data/datasources/home_remote_data_source.dart';
import 'package:shifaa/features/home/data/models/upcoming_appointment_model.dart';

import '../../../../core/api/end_ponits.dart';

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiConsumer apiConsumer;

  HomeRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<List<UpcomingAppointmentModel>> getUpcomingAppointments({
    int? perPage,
  }) async {
    final response = await apiConsumer.get(
      EndPoint.appointment,
      queryParameters: {
        'time': 'upcoming',
        'type': 'regular',
        if (perPage != null) 'per_page': perPage,
      },
    );

    final List<dynamic> appointmentsJson = response['data']['appointments'];

    final appointments = appointmentsJson
        .map((json) => UpcomingAppointmentModel.fromJson(json))
        .toList();

    return appointments;
  }

  @override
  Future<Map<String, dynamic>> fetchAppointmentsResponse({
    int? perPage,
    String? time,
  }) async {
    final response = await apiConsumer.get(
      EndPoint.appointment,
      queryParameters: {
        if (time != null) 'time': time,
        'type': 'regular',
        if (perPage != null) 'per_page': perPage,
      },
    );
    return response;
  }

  @override
  Future<Map<String, dynamic>> fetchPreviousAppointmentsResponse({
    int? perPage,
  }) async {
    final response = await apiConsumer.get(
      EndPoint.appointment,
      queryParameters: {
        'time': 'past',
        'type': 'regular',
        if (perPage != null) 'per_page': perPage,
      },
    );
    return response;
  }
}
