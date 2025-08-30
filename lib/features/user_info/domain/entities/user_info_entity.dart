import 'package:equatable/equatable.dart';

class UserInfoEntity extends Equatable {
  final int id;
  final String fullName;
  final String phoneNumber;
  final int age;
  final double? weight;
  final double? height;

  const UserInfoEntity({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.age,
    this.weight,
    this.height,
  });

  @override
  List<Object?> get props => [id, fullName, phoneNumber, age, weight, height];
}