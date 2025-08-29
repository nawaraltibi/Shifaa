import 'package:intl/intl.dart';
import 'package:shifaa/features/home/domain/entities/home_appointment_entity.dart';

class HomeAppointmentModel extends HomeAppointmentEntity {
  const HomeAppointmentModel({
    required super.id,
    required super.doctorName,
    required super.specialty,
    required super.imageUrl,
    required super.date,
    required super.time,
  });

  factory HomeAppointmentModel.fromJson(Map<String, dynamic> json) {
    final doctor = json['doctor'] ?? {};
    final specialty = doctor['specialty'] ?? {};
    final String firstName = doctor['first_name'] ?? '';
    final String lastName = doctor['last_name'] ?? '';
    final String fullName = '$firstName $lastName'.trim();
    final String startTimeString = json['start_time'] ?? '';
    final DateTime startTime = DateTime.tryParse(startTimeString) ?? DateTime.now();

    return HomeAppointmentModel(
      id: json['id'] ?? 0,
      doctorName: fullName,
      specialty: specialty['name'] ?? 'N/A',
      imageUrl: doctor['avatar'],
      date: DateFormat('d MMMM, EEEE').format(startTime),
      time: DateFormat('h:mm a').format(startTime),
    );
  }
}
