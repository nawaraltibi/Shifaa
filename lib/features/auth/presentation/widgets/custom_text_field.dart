import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shifaa/core/utils/app_colors.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextDirection? textDirection;
  final bool? readOnly;
  final void Function()? onTap;
  final String? errorText;

  const CustomTextField({
    Key? key,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
    this.inputFormatters,
    this.textDirection,
    this.readOnly,
    this.onTap,
    this.errorText,
  }) : super(key: key);

  OutlineInputBorder _buildOutlineInputBorder(Color color, [double width = 2]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      readOnly: readOnly ?? false,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      inputFormatters: inputFormatters,
      textDirection: textDirection,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        errorText: errorText,
        contentPadding: const EdgeInsets.all(14),
        hintText: hintText,
        hintStyle: AppTextStyles.regular15.copyWith(
          color: const Color(0xFF989898),
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: _buildOutlineInputBorder(const Color(0xFFC8C8C8)),
        enabledBorder: _buildOutlineInputBorder(const Color(0xFFC8C8C8)),
        focusedBorder: _buildOutlineInputBorder(AppColors.primaryAppColor),
        errorBorder: _buildOutlineInputBorder(Colors.red),
        focusedErrorBorder: _buildOutlineInputBorder(Colors.red),
      ),
    );
  }
}
