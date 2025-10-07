class UpcomingDoctorModel {
  final int id;
  final String firstName;
  final String lastName;
  final String avatar;
  final SpecialtyModel specialty;

  String get fullName => '$firstName $lastName';

  const UpcomingDoctorModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.avatar,
    required this.specialty,
  });

  factory UpcomingDoctorModel.fromJson(Map<String, dynamic> json) {
    return UpcomingDoctorModel(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      avatar: json['avatar'],
      specialty: SpecialtyModel.fromJson(json['specialty']),
    );
  }
}

class SpecialtyModel {
  final int id;
  final String name;

  const SpecialtyModel({required this.id, required this.name});

  factory SpecialtyModel.fromJson(Map<String, dynamic> json) {
    return SpecialtyModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
