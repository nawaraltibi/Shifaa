// import 'package:intl/intl.dart';
// import 'package:shifaa/features/home/domain/entities/home_appointment_entity.dart';

// class HomeAppointmentModel extends HomeAppointmentEntity {
//   const HomeAppointmentModel({
//     required super.id,
//     required super.doctorName,
//     required super.specialty,
//     required super.imageUrl,
//     required super.date,
//     required super.time,
//     required super.startTime,
//   });

//   factory HomeAppointmentModel.fromJson(Map<String, dynamic> json) {
//     final doctor = json['doctor'] ?? {};
//     final specialty = doctor['specialty'] ?? {};
//     final startTimeString = json['start_time'] ?? '';
//     final startTime = DateTime.tryParse(startTimeString) ?? DateTime.now();

//     return HomeAppointmentModel(
//       id: json['id'] ?? 0,
//       doctorName: "${doctor['first_name'] ?? ''} ${doctor['last_name'] ?? ''}".trim(),
//       specialty: specialty['name'] ?? 'N/A',
//       imageUrl: doctor['avatar'],
//       date: DateFormat('d MMMM, EEEE').format(startTime),
//       time: DateFormat('h:mm a').format(startTime),
//       startTime: startTimeString,
//     );
//   }
// }
