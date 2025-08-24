import 'package:shifaa/core/services/database_service.dart';
import 'package:shifaa/features/appointments/domain/entities/appointment_entity.dart';

abstract class AppointmentLocalDataSource {
  Future<void> cacheUpcomingAppointments(List<AppointmentEntity> appointments);
  Future<List<AppointmentEntity>> getLastUpcomingAppointments();
  Future<void> cachePreviousAppointments(List<AppointmentEntity> appointments);
  Future<List<AppointmentEntity>> getLastPreviousAppointments();
}

class AppointmentLocalDataSourceImpl implements AppointmentLocalDataSource {
  final DatabaseService databaseService;
  AppointmentLocalDataSourceImpl({required this.databaseService});

  @override
  Future<void> cacheUpcomingAppointments(List<AppointmentEntity> appointments) async {
    await databaseService.cacheAppointments(appointments, 'upcoming');
  }

  @override
  Future<List<AppointmentEntity>> getLastUpcomingAppointments() async {
    return await databaseService.getCachedAppointments('upcoming');
  }

  @override
  Future<void> cachePreviousAppointments(List<AppointmentEntity> appointments) async {
    await databaseService.cacheAppointments(appointments, 'previous');
  }

  @override
  Future<List<AppointmentEntity>> getLastPreviousAppointments() async {
    return await databaseService.getCachedAppointments('previous');
  }
}
