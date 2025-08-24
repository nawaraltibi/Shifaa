class DoctorScheduleModel {
  final int id;
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final int sessionDuration;
  final String type;
  final List<String> slots;
  final List<String>? availableSlots;

  DoctorScheduleModel({
    required this.id,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.sessionDuration,
    required this.type,
    required this.slots,
    this.availableSlots,
  });

  factory DoctorScheduleModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return DoctorScheduleModel(
        id: -1,
        dayOfWeek: '',
        startTime: '',
        endTime: '',
        sessionDuration: 0,
        type: '',
        slots: [],
        availableSlots: [],
      );
    }

    return DoctorScheduleModel(
      id: json['id'] ?? -1,
      dayOfWeek: json['day_of_week'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      sessionDuration: json['session_duration'] ?? 0,
      type: json['type'] ?? '',
      slots: List<String>.from(json['slots'] ?? []),
      availableSlots: json['available_slots'] != null
          ? List<String>.from(json['available_slots'])
          : [],
    );
  }
}
