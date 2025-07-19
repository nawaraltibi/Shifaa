import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';
import 'package:shifaa/generated/l10n.dart';

class WelcomeText extends StatelessWidget {
  const WelcomeText({super.key});

  @override
  Widget build(BuildContext context) {
    String currentLocale = Intl.getCurrentLocale();
    String languageCode = currentLocale.split('_')[0];
    return Container(
      margin: EdgeInsets.only(left: languageCode == 'en' ? 30.w : 90.w),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).welcome,
            style: AppTextStyles.medium24.copyWith(color: Colors.white),
          ),
          Text(
            S.of(context).Shifaa,
            style: AppTextStyles.medium34.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
