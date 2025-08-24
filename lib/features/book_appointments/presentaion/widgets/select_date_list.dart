import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shifaa/features/book_appointments/presentaion/widgets/day_container.dart';

class SelectDateList extends StatefulWidget {
  final List<String> availableDays;
  final DateTime selectedDate;
  final DateTime currentMonth; // الشهر من الكيوبت
  final Function(DateTime date) onDateSelected;

  const SelectDateList({
    super.key,
    required this.availableDays,
    required this.selectedDate,
    required this.currentMonth,
    required this.onDateSelected,
  });

  @override
  State<SelectDateList> createState() => _SelectDateListState();
}

class _SelectDateListState extends State<SelectDateList> {
  late List<DateTime> monthDates;
  late DateTime _localSelectedDate; // تاريخ محلي يتلون فورًا

  @override
  void initState() {
    super.initState();
    _generateMonthDates();
    _localSelectedDate = widget.selectedDate;
  }

  @override
  void didUpdateWidget(covariant SelectDateList oldWidget) {
    super.didUpdateWidget(oldWidget);

    // إذا تغيّر الشهر أو التاريخ من الكيوبت → نزامن
    if (oldWidget.currentMonth != widget.currentMonth ||
        oldWidget.selectedDate != widget.selectedDate) {
      _generateMonthDates();
      _localSelectedDate = widget.selectedDate;
    }
  }

  void _generateMonthDates() {
    final today = DateTime.now();
    final year = widget.currentMonth.year;
    final month = widget.currentMonth.month;
    final daysInMonth = DateTime(year, month + 1, 0).day;

    monthDates = List.generate(daysInMonth, (i) {
      return DateTime(year, month, i + 1);
    });

    // إذا الشهر الحالي فقط → نحذف الأيام الماضية
    if (year == today.year && month == today.month) {
      monthDates = monthDates.where((date) {
        return !date.isBefore(DateTime(today.year, today.month, today.day));
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 15.w,
      runSpacing: 10.h,
      children: monthDates.map((date) {
        final formattedDay = _weekdayToString(date.weekday);
        final isAvailable = widget.availableDays.contains(
          formattedDay.toLowerCase(),
        );

        return DayContainer(
          day: Intl.getCurrentLocale().startsWith('ar')
              ? formattedDay
              : formattedDay.substring(0, 3),
          date: date.day.toString(),
          isSelected: _isSameDay(date, _localSelectedDate), // محلي
          isAvailable: isAvailable,
          onTap: () {
            if (isAvailable) {
              setState(() {
                _localSelectedDate = date; // يلون فورًا
              });
              widget.onDateSelected(date); // يبعث للكيوبت
            }
          },
        );
      }).toList(),
    );
  }

  String _weekdayToString(int weekday) {
    return DateFormat.EEEE(
      Intl.getCurrentLocale(),
    ).format(DateTime(2024, 1, weekday));
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
