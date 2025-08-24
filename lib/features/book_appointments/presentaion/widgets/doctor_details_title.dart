import 'package:flutter/material.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';

class DoctorDetailsTitle extends StatelessWidget {
  const DoctorDetailsTitle({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.semiBold18);
  }
}
