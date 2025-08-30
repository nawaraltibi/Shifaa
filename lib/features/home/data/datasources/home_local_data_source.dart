import 'package:shifaa/core/services/database_service.dart';
import 'package:shifaa/features/appointments/data/models/appointment_model.dart';
import 'package:shifaa/features/appointments/domain/entities/appointment_entity.dart';

abstract class HomeLocalDataSource {
  // Reverted back to using AppointmentEntity as per your request.
  Future<List<AppointmentEntity>> getUpcomingAppointment();
  Future<List<AppointmentEntity>> getPreviousAppointment();
  Future<void> cacheUpcomingAppointment(List<AppointmentEntity> appointments);
  Future<void> cachePreviousAppointment(List<AppointmentEntity> appointments);
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  final DatabaseService databaseService;
  HomeLocalDataSourceImpl({required this.databaseService});

  @override
  Future<void> cacheUpcomingAppointment(List<AppointmentEntity> appointments) async {
    // The type is now AppointmentEntity.
    await databaseService.cacheAppointments(appointments, 'upcoming');
  }

  @override
  Future<void> cachePreviousAppointment(List<AppointmentEntity> appointments) async {
    // The type is now AppointmentEntity.
    await databaseService.cacheAppointments(appointments, 'previous');
  }

  @override
  Future<List<AppointmentEntity>> getUpcomingAppointment() async {
    // The return type is now List<AppointmentEntity>.
    return await databaseService.getCachedAppointments('upcoming');
  }

  @override
  Future<List<AppointmentEntity>> getPreviousAppointment() async {
    // The return type is now List<AppointmentEntity>.
    return await databaseService.getCachedAppointments('previous');
  }
}

