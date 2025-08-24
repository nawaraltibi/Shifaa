abstract class AppointmentRemoteDataSource {
  Future<void> bookAppointment({
    required String startTime,
    required int doctorScheduleId,
  });
}
