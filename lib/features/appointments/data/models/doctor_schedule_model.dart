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

  factory DoctorScheduleModel.fromJson(Map<String, dynamic> json) {
    return DoctorScheduleModel(
      id: json['id'],
      dayOfWeek: json['day_of_week'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      sessionDuration: json['session_duration'],
      type: json['type'],
      slots: List<String>.from(json['slots']),
      availableSlots: json['available_slots'] != null
          ? List<String>.from(json['available_slots'])
          : null,
    );
  }
}
