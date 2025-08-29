import 'package:equatable/equatable.dart';

// كيان يمثل الموعد في الشاشة الرئيسية
class HomeAppointmentEntity extends Equatable {
  final int id;
  final String doctorName;
  final String specialty;
  final String? imageUrl;
  final String date;
  final String time;

  const HomeAppointmentEntity({
    required this.id,
    required this.doctorName,
    required this.specialty,
    this.imageUrl,
    required this.date,
    required this.time,
  });

  @override
  List<Object?> get props => [id, doctorName, specialty, imageUrl, date, time];
}
