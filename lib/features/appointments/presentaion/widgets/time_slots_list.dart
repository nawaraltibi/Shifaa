import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shifaa/features/appointments/data/models/doctor_schedule_model.dart';
import 'package:shifaa/features/appointments/presentaion/widgets/time_slot.dart';
import 'package:shifaa/generated/l10n.dart';

class TimeSlotsList extends StatefulWidget {
  final DateTime selectedDate;
  final List<DoctorScheduleModel> schedule;

  const TimeSlotsList({
    super.key,
    required this.selectedDate,
    required this.schedule,
  });

  @override
  State<TimeSlotsList> createState() => _TimeSlotsListState();
}

class _TimeSlotsListState extends State<TimeSlotsList> {
  String? selectedSlot;

  @override
  Widget build(BuildContext context) {
    final String selectedDay = DateFormat(
      'EEEE',
    ).format(widget.selectedDate).toLowerCase();

    final filteredSchedules = widget.schedule
        .where((s) => s.dayOfWeek.toLowerCase() == selectedDay)
        .toList();

    final slots = filteredSchedules.expand((s) => s.slots ?? []).toList();

    if (slots.isEmpty) {
      return Text(S.of(context).no_slots);
    }

    return Container(
      width: double.infinity,
      color: const Color(0xFFF5F7FF),
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
      child: Wrap(
        spacing: 15.w,
        runSpacing: 10.h,
        children: slots.map((slot) {
          return TimeSlot(
            time: slot,
            isSelected: selectedSlot == slot,
            onTap: () {
              setState(() {
                selectedSlot = slot;
              });
            },
          );
        }).toList(),
      ),
    );
  }
}
