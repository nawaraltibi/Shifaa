import 'package:equatable/equatable.dart';

class DoctorEntity extends Equatable {
  final int id;
  final String fullName;
  final String specialtyName;
  final String? imageUrl;
  final double rating;
  final int? consultationFee;
  const DoctorEntity({
    required this.id,
    required this.fullName,
    required this.specialtyName,
    this.imageUrl,
    required this.rating,
    this.consultationFee, // <-- اجعله معامل مسمى واختياري
  });
  @override
  List<Object?> get props => [id, fullName, specialtyName, imageUrl, rating];
}
