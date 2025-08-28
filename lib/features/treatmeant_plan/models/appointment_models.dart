class DiagnosisInfo {
  final String status;
  final String diagnosedWith;
  final String doctorName;
  final String doctorSpecialty;

  DiagnosisInfo({
    required this.status,
    required this.diagnosedWith,
    required this.doctorName,
    required this.doctorSpecialty,
  });
}

class AppointmentInfo {
  // **** الخطوة 1: إضافة الحقل هنا ****
  final DateTime date;
  final String time;
  final String type;
  final String doctorNotes;

  AppointmentInfo({
    // **** الخطوة 2: إضافته إلى الـ constructor ****
    required this.date,
    required this.time,
    required this.type,
    required this.doctorNotes,
  });
}

class MedicationInfo {
  final String name;
  final String dosage;
  final String frequency;
  final String doctorNotes;

  MedicationInfo({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.doctorNotes,
  });
}

class AppointmentDetails {
  final DiagnosisInfo diagnosis;
  final List<AppointmentInfo> appointments;
  final List<MedicationInfo> medications;

  AppointmentDetails({
    required this.diagnosis,
    required this.appointments,
    required this.medications,
  });
}
