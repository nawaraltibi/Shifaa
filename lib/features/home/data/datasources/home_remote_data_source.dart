import 'package:shifaa/features/home/data/models/upcoming_appointment_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<UpcomingAppointmentModel>> getUpcomingAppointments({int? perPage});
  Future<Map<String, dynamic>> fetchAppointmentsResponse({
    int? perPage,
    String? time, // ✅ 1. أضف البارامتر الاختياري هنا
  });  Future<Map<String, dynamic>> fetchPreviousAppointmentsResponse({int? perPage});
}
