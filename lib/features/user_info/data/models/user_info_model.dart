import 'package:shifaa/features/user_info/domain/entities/user_info_entity.dart';

class UserInfoModel extends UserInfoEntity {
  const UserInfoModel({
    required super.id,
    required super.fullName,
    required super.phoneNumber,
    required super.age,
    required super.weight,
    required super.height,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] ?? {};
    final String firstName = userJson['first_name'] ?? '';
    final String lastName = userJson['last_name'] ?? '';
    final String fullName = '$firstName $lastName'.trim();

    return UserInfoModel(
      id: json['id'] ?? 0,
      fullName: fullName,
      phoneNumber: userJson['phone_number'] ?? 'N/A',
      age: json['age'] ?? 0,
      weight: (json['weight'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
    );
  }
}