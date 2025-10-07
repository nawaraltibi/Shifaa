import 'package:equatable/equatable.dart';

class PreviousAppointment extends Equatable {
  final int id;
  final String date;
  final String time;
  final String doctorName;
  final String doctorSpecialty;
  final String doctorAvatar;
  final int doctorId;
  final String status;

  const PreviousAppointment({
    required this.id,
    required this.date,
    required this.time,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.doctorAvatar,
    required this.doctorId,
    required this.status,
  });

  @override
  List<Object?> get props => [
    id,
    date,
    time,
    doctorName,
    doctorSpecialty,
    doctorAvatar,
    doctorId,
    status,
  ];
}
