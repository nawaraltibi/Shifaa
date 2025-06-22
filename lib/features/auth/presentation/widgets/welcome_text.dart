import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';
import 'package:shifaa/generated/l10n.dart';

class WelcomeText extends StatelessWidget {
  const WelcomeText({Key? key, this.isVisible = false}) : super(key: key);
  final bool isVisible;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 30.w,
      top: 208.h,
      child: SizedBox(
        height: 200,
        width: 200,
        child: Visibility(
          visible: isVisible,
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
        ),
      ),
    );
  }
}
