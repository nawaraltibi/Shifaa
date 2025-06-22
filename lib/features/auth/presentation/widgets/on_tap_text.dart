import 'package:flutter/material.dart';
import 'package:shifaa/core/utils/app_colors.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';

class OnTapBlueText extends StatelessWidget {
  const OnTapBlueText({super.key, required this.text, required this.onTap});
  final String text;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          text,
          style: AppTextStyles.regular12.copyWith(
            color: AppColors.primaryAppColor,
          ),
        ),
      ),
    );
  }
}
