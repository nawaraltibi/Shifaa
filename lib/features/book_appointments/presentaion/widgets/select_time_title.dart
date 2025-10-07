import 'package:flutter/material.dart';
import 'package:shifaa/features/book_appointments/presentaion/widgets/doctor_details_title.dart';
import 'package:shifaa/generated/l10n.dart';

class SelectTimeTitle extends StatelessWidget {
  final int slotsCount;

  const SelectTimeTitle({super.key, required this.slotsCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DoctorDetailsTitle(text: S.of(context).select_time),
        const Spacer(),
      ],
    );
  }
}
