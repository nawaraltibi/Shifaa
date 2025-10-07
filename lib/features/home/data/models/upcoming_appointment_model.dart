import 'package:shifaa/features/home/data/models/upcoming_doctor_model.dart';

import '../../domain/entities/upcoming_appointment_entity.dart';

class UpcomingAppointmentModel extends UpcomingAppointment {
  const UpcomingAppointmentModel({
    required super.id,
    required super.date,
    required super.time,
    required super.doctorName,
    required super.doctorSpecialty,
    required super.doctorAvatar,
    required super.doctorId,
    required super.status,
  });

  factory UpcomingAppointmentModel.fromJson(Map<String, dynamic> json) {
    final dateTime = DateTime.parse(json['start_time']);
    final doctor = UpcomingDoctorModel.fromJson(json['doctor']);

    return UpcomingAppointmentModel(
      id: json['id'],
      doctorId: doctor.id,
      date: _formatDate(dateTime),
      time: _formatTimeRange(dateTime),
      doctorName: doctor.fullName,
      doctorSpecialty: doctor.specialty.name,
      doctorAvatar: doctor.avatar,
      status: json['status'],
    );
  }

  static String _formatDate(DateTime date) {
    const monthNames = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    const dayNames = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ];
    return '${date.day} ${monthNames[date.month - 1]}, ${dayNames[date.weekday - 1]}';
  }

  static String _formatTimeRange(
      DateTime startTime, {
        int durationMinutes = 30,
      }) {
    final endTime = startTime.add(Duration(minutes: durationMinutes));

    String formatHour(DateTime time) {
      final hour12 = time.hour % 12 == 0 ? 12 : time.hour % 12;
      final minute = time.minute.toString().padLeft(2, '0');
      final period = time.hour >= 12 ? 'pm' : 'am';
      return '$hour12:$minute $period';
    }

    String formatStartTime = formatHour(startTime).split(' ')[0];
    String formatEndTime = formatHour(endTime);

    return '$formatStartTime - $formatEndTime';
  }
}
