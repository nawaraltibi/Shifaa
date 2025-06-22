import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shifaa/core/utils/app_images.dart';
import 'package:shifaa/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:shifaa/generated/l10n.dart';

class SyrianPhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 9) {
      digits = digits.substring(0, 9);
    }

    String formatted = '';
    for (int i = 0; i < digits.length; i++) {
      formatted += digits[i];
      if ((i == 2 || i == 5) && i != digits.length - 1) {
        formatted += ' ';
      }
    }

    int baseOffset = newValue.selection.baseOffset;
    int offset = formatted.length;

    if (baseOffset < oldValue.text.length) {
      String sub = newValue.text.substring(0, baseOffset);
      int digitsBefore = sub.replaceAll(RegExp(r'\D'), '').length;

      if (digitsBefore <= 3) {
        offset = digitsBefore;
      } else if (digitsBefore <= 6) {
        offset = digitsBefore + 1;
      } else {
        offset = digitsBefore + 2;
      }
    }

    if (offset > formatted.length) offset = formatted.length;

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: offset),
    );
  }
}

String? syrianPhoneValidator(BuildContext context, String? value) {
  if (value == null || value.isEmpty) {
    return S.of(context).pleaseEnterPhone;
  }

  final digits = value.replaceAll(RegExp(r'\D'), '');

  if (digits.length != 9 || !digits.startsWith('9')) {
    return S.of(context).invalidPhoneFormat;
  }

  return null;
}

class PhoneNumberField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const PhoneNumberField({super.key, this.controller, this.validator});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr, // يجبر ترتيب العناصر LTR
      child: CustomTextField(
        controller: controller,
        validator: validator,
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 10.w, right: 5.w),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 80.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  Assets.imagesSyrianFlag,
                  height: 27,
                  width: 27,
                  fit: BoxFit.contain,
                ),
                SizedBox(width: 8.w),
                Container(height: 30, width: 1, color: const Color(0xFFC8C8C8)),
              ],
            ),
          ),
        ),
        textDirection: TextDirection.ltr, // اتجاه النص داخل الحقل مثلاً عربي
        hintText: S.of(context).syrianPhoneHint,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          SyrianPhoneNumberFormatter(),
        ],
      ),
    );
  }
}
