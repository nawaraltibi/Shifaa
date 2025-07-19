import 'package:shifaa/features/appointments/data/models/doctor_schedule_model.dart';

abstract class DoctorScheduleRemoteDataSource {
  Future<List<DoctorScheduleModel>> getDoctorSchedules({
    required String doctorId,
    String? date,
    String type = 'regular',
  });
}
