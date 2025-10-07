import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'package:shifaa/core/utils/app_colors.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';

class PhoneNumberField extends StatelessWidget {
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final Color borderColor;

  const PhoneNumberField({
    Key? key,
    this.onChanged,
    this.controller,
    this.borderColor = Colors.grey,
  }) : super(key: key);

  OutlineInputBorder _buildOutlineInputBorder(Color color, [double width = 2]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      controller: controller,
      initialCountryCode: 'SY',
      dropdownIconPosition: IconPosition.trailing,
      cursorHeight: 18,
      dropdownTextStyle: AppTextStyles.regular15,
      disableLengthCheck: true,
      pickerDialogStyle: PickerDialogStyle(
        backgroundColor: Colors.white,
        countryCodeStyle: AppTextStyles.regular15,
        countryNameStyle: AppTextStyles.regular15,
        searchFieldInputDecoration: InputDecoration(
          hintText: 'Search for a country',
          suffixIcon: Icon(Icons.search, color: Colors.grey[600]),
          hintStyle: AppTextStyles.regular15.copyWith(
            color: const Color(0xFF989898),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 8,
          ),
        ),
      ),
      style: AppTextStyles.regular15,
      flagsButtonPadding: const EdgeInsets.only(left: 10),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 16.h),
        hintStyle: AppTextStyles.regular15.copyWith(
          color: const Color(0xFF989898),
        ),
        border: _buildOutlineInputBorder(const Color(0xFFC8C8C8)),
        enabledBorder: _buildOutlineInputBorder(borderColor),
        focusedBorder: _buildOutlineInputBorder(AppColors.primaryAppColor),
        errorBorder: _buildOutlineInputBorder(Colors.red),
        focusedErrorBorder: _buildOutlineInputBorder(Colors.red),
      ),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],

      onChanged: (phone) => onChanged?.call(phone.completeNumber),
    );
  }
}
