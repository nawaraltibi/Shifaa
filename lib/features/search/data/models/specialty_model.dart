
import 'package:shifaa/features/search/domain/entities/specialty_entity.dart';



class SpecialtyModel extends SpecialtyEntity {
  final String createdAt;

  const SpecialtyModel({
    required super.name,
    required this.createdAt,
  });

  factory SpecialtyModel.fromJson(Map<String, dynamic> json) {
    return SpecialtyModel(
      name: json['name'] ?? 'Unknown Specialty',
      createdAt: json['created_at'] ?? '',
    );
  }
}