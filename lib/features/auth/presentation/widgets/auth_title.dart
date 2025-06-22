import 'package:flutter/material.dart';
import 'package:shifaa/core/utils/app_colors.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';

class AuthTitle extends StatelessWidget {
  const AuthTitle({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Text(
        text,
        style: AppTextStyles.bold24.copyWith(color: AppColors.primaryAppColor),
      ),
    );
  }
}
