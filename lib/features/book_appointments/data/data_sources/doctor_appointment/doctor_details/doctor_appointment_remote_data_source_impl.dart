import 'package:shifaa/core/api/api_consumer.dart';
import 'package:shifaa/core/api/end_ponits.dart';
import 'package:shifaa/features/book_appointments/data/data_sources/doctor_appointment/doctor_details/doctor_appointment_remote_data_source.dart';

class AppointmentRemoteDataSourceImpl implements AppointmentRemoteDataSource {
  final ApiConsumer apiConsumer;

  AppointmentRemoteDataSourceImpl(this.apiConsumer);
  @override
  Future<void> rescheduleAppointment({
    required int appointmentId,
    required String startTime,
    required int doctorScheduleId,
  }) async {
    // استخدمي .put بدلاً من .post
    await apiConsumer.put(
      EndPoint.rescheduleAppointment(appointmentId), // الرابط الديناميكي
      data: {"start_time": startTime, "doctor_schedule_id": doctorScheduleId},
    );
  }

  @override
  Future<void> bookAppointment({
    required String startTime,
    required int doctorScheduleId,
  }) async {
    await apiConsumer.post(
      EndPoint.appointment,
      data: {"start_time": startTime, "doctor_schedule_id": doctorScheduleId},
    );
    // ما عم نرجع شي من الـ response
  }

  @override
  Future<void> cancelAppointment({required int appointmentId}) async {
    // استخدمي .delete
    await apiConsumer.post(
      EndPoint.cancelAppointment(appointmentId), // الرابط الديناميكي
    );
  }
}
