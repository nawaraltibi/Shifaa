import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shifaa/features/appointments/presentaion/widgets/day_container.dart';

class SelectDateList extends StatefulWidget {
  final List<String> availableDays; // e.g. ['monday', 'wednesday']
  final DateTime selectedDate;
  final Function(DateTime date) onDateSelected;

  const SelectDateList({
    super.key,
    required this.availableDays,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<SelectDateList> createState() => _SelectDateListState();
}

class _SelectDateListState extends State<SelectDateList> {
  late List<DateTime> monthDates;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    monthDates =
        List.generate(daysInMonth, (i) {
              return DateTime(now.year, now.month, i + 1);
            })
            .where((date) => !date.isBefore(now))
            .toList(); // 👈 فلترة التواريخ قبل اليوم
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 15.w,
      runSpacing: 10.h,
      children: monthDates.map((date) {
        final dayOfWeek = date.weekday; // 1 (Mon) - 7 (Sun)
        final formattedDay = _weekdayToString(dayOfWeek);
        final isAvailable = widget.availableDays.contains(
          formattedDay.toLowerCase(),
        );

        return DayContainer(
          day: Intl.getCurrentLocale().startsWith('ar')
              ? formattedDay
              : formattedDay.substring(0, 3),
          date: date.day.toString(),
          isSelected: _isSameDay(date, widget.selectedDate),
          isAvailable: isAvailable,
          onTap: () {
            if (isAvailable) {
              widget.onDateSelected(date);
            }
          },
        );
      }).toList(),
    );
  }

  String _weekdayToString(int weekday) {
    // نستخدم أي تاريخ مع weekday محدد لنحصل على اسمه بصيغة locale
    final now = DateTime.now();
    final date = now.subtract(Duration(days: now.weekday - weekday));
    return DateFormat.EEEE(Intl.getCurrentLocale()).format(date);
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
