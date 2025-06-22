import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shifaa/core/utils/app_colors.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';
import 'package:shifaa/core/widgets/custom_button.dart';
import 'package:shifaa/features/auth/presentation/views/signup_view.dart';
import 'package:shifaa/features/auth/presentation/widgets/auth_template.dart';
import 'package:shifaa/features/auth/presentation/widgets/auth_title.dart';
import 'package:shifaa/features/auth/presentation/widgets/otp_field.dart';
import 'package:shifaa/generated/l10n.dart';

class VerifyOtpViewBody extends StatefulWidget {
  const VerifyOtpViewBody({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  State<VerifyOtpViewBody> createState() => _VerifyOtpViewBodyState();
}

class _VerifyOtpViewBodyState extends State<VerifyOtpViewBody> {
  final List<TextEditingController> _otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  int _secondsRemaining = 45;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onContinuePressed(BuildContext context) {
    bool allFilled = _otpControllers.every(
      (controller) => controller.text.isNotEmpty,
    );
    if (!allFilled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).pleaseEnterOtp),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } else {
      context.goNamed(SignupView.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthTemplate(
      margin: 205.h,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 100.h),
            AuthTitle(text: S.of(context).verifyOtp),
            SizedBox(height: 50.h),
            Text(S.of(context).weSentCodeTo, style: AppTextStyles.regular12),
            Text(
              widget.phoneNumber,
              style: AppTextStyles.regular14.copyWith(
                color: AppColors.primaryAppColor,
              ),
            ),
            SizedBox(height: 40.h),
            OtpField(controllers: _otpControllers),
            SizedBox(height: 55.h),
            CustomButton(
              text: S.of(context).continueText,
              onPressed: () => _onContinuePressed(context),
            ),
            SizedBox(height: 35.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  S.of(context).resendCodeIn,
                  style: AppTextStyles.regular14,
                ),
                Text(
                  '00:${_secondsRemaining.toString().padLeft(2, '0')}',
                  style: AppTextStyles.regular14.copyWith(
                    color: AppColors.primaryAppColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
