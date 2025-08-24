import 'package:shifaa/features/book_appointments/data/models/doctor_schedule_model.dart';

abstract class DoctorScheduleRemoteDataSource {
  Future<List<DoctorScheduleModel>> getDoctorSchedules({
    required String doctorId,
    String? date,
    String type = 'regular',
  });
}
