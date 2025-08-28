import 'package:shifaa/core/utils/app_images.dart';
import 'package:shifaa/features/search/domain/entities/dtoctor_entity.dart';

// في ملف: doctor_model_ashour.dart

// ... (import)

class DoctorModelAshour extends DoctorEntity {
  // ✅ الآن هذا الـ constructor صحيح
  const DoctorModelAshour({
    required super.id,
    required super.fullName,
    required super.specialtyName,
    super.imageUrl,
    required super.rating,
    super.consultationFee, // <-- تمرير المعامل المسمى إلى super
  });

  factory DoctorModelAshour.fromJson(Map<String, dynamic> json) {
    final String firstName = json['first_name'] ?? '';
    final String lastName = json['last_name'] ?? '';
    final String fullName = '$firstName $lastName'.trim();
    final String specialtyName = json['specialty']?['name'] ?? 'N/A';
    final String? avatarUrl = json['avatar'] ?? AppImages.imagesDoctor1;
    final int? consultationFee = json['consultation_fee'] ?? 0;

    // ✅ وهذا الاستدعاء أصبح صحيحاً أيضاً
    return DoctorModelAshour(
      id: json['id'] ?? 0,
      fullName: fullName,
      specialtyName: specialtyName,
      imageUrl: avatarUrl,
      rating: 4.5, // قيمة ثابتة كما في الكود
      consultationFee: consultationFee, // <-- الآن هذا يعمل
    );
  }
}
