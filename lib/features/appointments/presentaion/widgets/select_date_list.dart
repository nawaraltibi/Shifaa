import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shifaa/features/appointments/presentaion/widgets/day_container.dart';

class SelectDateList extends StatefulWidget {
  const SelectDateList({super.key});

  @override
  State<SelectDateList> createState() => _SelectDateListState();
}

class _SelectDateListState extends State<SelectDateList> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 15.w,
      runSpacing: 15.h,
      children: List.generate(14, (index) {
        final day = [
          'Sun',
          'Mon',
          'Tue',
          'Wed',
          'Thu',
          'Fri',
          'Sat',
        ][index % 7];
        final date = (21 + index).toString();
        return DayContainer(
          day: day,
          date: date,
          isSelected: selectedIndex == index,
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
          },
        );
      }),
    );
  }
}
