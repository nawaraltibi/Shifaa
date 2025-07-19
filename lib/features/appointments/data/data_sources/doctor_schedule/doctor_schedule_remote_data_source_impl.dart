import 'package:shifaa/core/api/api_consumer.dart';
import 'package:shifaa/core/api/end_ponits.dart';
import 'package:shifaa/features/appointments/data/data_sources/doctor_schedule/doctor_schedule_remote_data_source.dart';
import 'package:shifaa/features/appointments/data/models/doctor_schedule_model.dart';

class DoctorScheduleRemoteDataSourceImpl
    implements DoctorScheduleRemoteDataSource {
  final ApiConsumer api;

  DoctorScheduleRemoteDataSourceImpl(this.api);

  @override
  Future<List<DoctorScheduleModel>> getDoctorSchedules({
    required String doctorId,
    String? date,
    String type = 'regular',
  }) async {
    final response = await api.get(
      EndPoint.doctorSchedules(doctorId),
      queryParameters: {'type': type, if (date != null) 'date': date},
    );

    final data = response['data']['schedules'] as List;
    return data.map((json) => DoctorScheduleModel.fromJson(json)).toList();
  }
}
