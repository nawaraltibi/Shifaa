abstract class AppointmentRemoteDataSource {
  Future<void> bookAppointment({
    required String startTime,
    required int doctorScheduleId,
  });
  Future<void> rescheduleAppointment({
    required int appointmentId,
    required String startTime,
    required int doctorScheduleId,
  });
}
