class UserLocalModel {
  final int id;
  final String firstName;
  final String lastName;
  final String username;
  final String gender;
  final int patientId;
  final String? dateOfBirth;
  final int? age;
  final double? weight;
  final double? height;
  final String? beamsId;

  UserLocalModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.gender,
    required this.patientId,
    this.dateOfBirth,
    this.age,
    this.weight,
    this.height,
    this.beamsId
  });
}
