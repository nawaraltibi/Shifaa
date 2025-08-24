import 'package:equatable/equatable.dart';

class DoctorEntity extends Equatable {
  final int id;
  final String fullName;
  final String specialtyName;
  final String? imageUrl;
  final double rating;

  const DoctorEntity({
    required this.id,
    required this.fullName,
    required this.specialtyName,
    this.imageUrl,
    required this.rating,
  });

  @override
  List<Object?> get props => [id, fullName, specialtyName, imageUrl, rating];
}
