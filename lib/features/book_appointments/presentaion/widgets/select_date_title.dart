import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';
import 'package:shifaa/features/book_appointments/presentaion/widgets/doctor_details_title.dart';
import 'package:shifaa/generated/l10n.dart';

class SelectDateTitle extends StatelessWidget {
  final DateTime currentMonth;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const SelectDateTitle({
    super.key,
    required this.currentMonth,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DoctorDetailsTitle(text: S.of(context).select_date),
        const Spacer(),

        // زر يسار
        IconButton(
          icon: Icon(Icons.arrow_left, color: Colors.black54, size: 28.sp),
          onPressed: onPrevious,
        ),

        // اسم الشهر والسنة
        Text(
          DateFormat('MMMM yyyy').format(currentMonth),
          style: AppTextStyles.regular14.copyWith(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),

        // زر يمين
        IconButton(
          icon: Icon(Icons.arrow_right, color: Colors.black54, size: 28.sp),
          onPressed: onNext,
        ),
      ],
    );
  }
}
