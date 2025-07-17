import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shifaa/features/appointments/presentaion/widgets/time_slot.dart';

class TimeSlotsList extends StatefulWidget {
  const TimeSlotsList({super.key});

  @override
  State<TimeSlotsList> createState() => _TimeSlotsListState();
}

class _TimeSlotsListState extends State<TimeSlotsList> {
  int selectedIndex = -1;

  final List<String> timeSlots = [
    '10:00 AM',
    '10:30 AM',
    '11:00 AM',
    '11:30 AM',
    '12:00 PM',
    '12:30 PM',
    '1:00 PM',
    '1:30 PM',
  ];

  @override
  Widget build(BuildContext context) {
    // You can adjust the number of items per row here
    final double slotWidth = (MediaQuery.of(context).size.width - 110.w) / 3;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFFF5F7FF),
      ),
      child: Wrap(
        spacing: 15.w,
        runSpacing: 15.h,
        children: List.generate(timeSlots.length, (index) {
          return SizedBox(
            width: slotWidth,
            child: TimeSlot(
              time: timeSlots[index],
              isSelected: selectedIndex == index,
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
          );
        }),
      ),
    );
  }
}
