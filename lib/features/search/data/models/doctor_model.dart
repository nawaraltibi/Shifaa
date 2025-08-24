import 'package:shifaa/features/search/domain/entities/dtoctor_entity.dart';

class DoctorModelAshour extends DoctorEntity {
  const DoctorModelAshour({
    required super.id,
    required super.fullName,
    required super.specialtyName,
    required super.imageUrl,
    required super.rating,
  });

  factory DoctorModelAshour.fromJson(Map<String, dynamic> json) {
    final String firstName = json['first_name'] ?? '';
    final String lastName = json['last_name'] ?? '';
    final String fullName = '$firstName $lastName'.trim();
    final String specialtyName = json['specialty']?['name'] ?? 'N/A';
    final String? avatarUrl = json['avatar'];

    return DoctorModelAshour(
      id: json['id'] ?? 0,
      fullName: fullName,
      specialtyName: specialtyName,
      imageUrl: avatarUrl,
      rating: 4.5,
    );
  }
}
