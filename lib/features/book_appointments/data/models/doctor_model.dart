// ... (الأكواد الأخرى)

class DoctorModel {
  final int id;
  final String firstName;
  final String lastName;
  final String bio;
  final String? avatar;
  final int consultationFee;
  final String specialty;
  final String gender;

  String get fullName => '$firstName $lastName';

  DoctorModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.bio,
    this.avatar,
    required this.consultationFee,
    required this.specialty,
    required this.gender,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> doctor) {
    // 1. استخدام المعامل ?? {} للتعامل مع null أو الأنواع غير الصحيحة بأمان.
    final specialty = doctor['specialty'] is Map<String, dynamic>
        ? doctor['specialty']
        : {};
    final user = doctor['user'] is Map<String, dynamic> ? doctor['user'] : {};

    return DoctorModel(
      id: user['id'] ?? -1,
      firstName: doctor['first_name'] ?? '',
      lastName: doctor['last_name'] ?? '',
      bio: doctor['bio'] ?? '',
      avatar: doctor['avatar'],
      consultationFee: doctor['consultation_fee'] ?? 0,
      specialty: specialty['name'] ?? '',
      gender: user['gender'] ?? '',
    );
  }
}
