import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shifaa/core/utils/app_colors.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';

class OtpFieldItem extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final FocusNode? previousFocusNode;

  const OtpFieldItem({
    super.key,
    required this.controller,
    required this.focusNode,
    this.nextFocusNode,
    this.previousFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64.w,
      height: 70.h,
      child: TextField(
        textDirection: TextDirection.ltr,
        controller: controller,
        focusNode: focusNode,
        onChanged: (value) {
          if (value.isEmpty && previousFocusNode != null) {
            FocusScope.of(context).requestFocus(previousFocusNode);
          } else if (value.length == 1 && nextFocusNode != null) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          }
        },
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        style: AppTextStyles.medium16,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 23.h),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFC8C8C8), width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: AppColors.primaryAppColor,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
