import 'package:flutter/material.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';

class AboutDoctor extends StatelessWidget {
  const AboutDoctor({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.regular10.copyWith(color: const Color(0xFF8D8D8D)),
      textAlign: TextAlign.justify,
      softWrap: true,
    );
  }
}
