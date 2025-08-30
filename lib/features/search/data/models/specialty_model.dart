import 'package:shifaa/features/search/domain/entities/specialty_entity.dart';

// Corrected: Model now perfectly matches the API response.
class SpecialtyModel extends SpecialtyEntity {
  const SpecialtyModel({
    required super.id,
    required super.name,
    required super.icon,
  });

  factory SpecialtyModel.fromJson(Map<String, dynamic> json) {
    return SpecialtyModel(
      id: json['id'] as int,
      name: json['name'] ?? 'Unknown Specialty',
      icon: json['icon'] ?? '',
    );
  }
}
