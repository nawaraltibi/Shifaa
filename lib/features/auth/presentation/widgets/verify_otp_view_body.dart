import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shifaa/core/utils/app_colors.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';
import 'package:shifaa/core/widgets/custom_button.dart';
import 'package:shifaa/features/auth/presentation/views/profile_setup_view.dart';
import 'package:shifaa/features/auth/presentation/widgets/auth_title.dart';
import 'package:shifaa/features/auth/presentation/widgets/otp_field.dart';
import 'package:shifaa/generated/l10n.dart';
import 'package:shifaa/features/auth/presentation/widgets/auth_template.dart';

class VerifyOtpViewBody extends StatefulWidget {
  const VerifyOtpViewBody({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  State<VerifyOtpViewBody> createState() => _VerifyOtpViewBodyState();
}

class _VerifyOtpViewBodyState extends State<VerifyOtpViewBody> {
  @override
  Widget build(BuildContext context) {
    return AuthTemplate(
      containerHeight: 500.h,
      child: Column(
        children: [
          AuthTitle(text: S.of(context).verifyOtp),
          SizedBox(height: 50.h),
          _buildPhoneInfo(),
          SizedBox(height: 40.h),
          OtpField(controllers: _otpControllers),
          _buildOtpError(),
          SizedBox(height: 40.h),
          CustomButton(
            text: S.of(context).continueText,
            onPressed: () => _onContinuePressed(context),
          ),
          SizedBox(height: 35.h),
          _buildCountdownTimer(),
        ],
      ),
    );
  }

  final List<TextEditingController> _otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  int _secondsRemaining = 45;
  Timer? _timer;
  String? _otpError;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    _addOtpListeners();
  }

  void _addOtpListeners() {
    for (var controller in _otpControllers) {
      controller.addListener(_onOtpChanged);
    }
  }

  void _removeOtpListeners() {
    for (var controller in _otpControllers) {
      controller.removeListener(_onOtpChanged);
    }
  }

  void _onOtpChanged() {
    bool allFilled = _otpControllers.every(
      (controller) => controller.text.isNotEmpty,
    );
    if (allFilled && _otpError != null) {
      setState(() => _otpError = null);
    }
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  void _onContinuePressed(BuildContext context) {
    bool allFilled = _otpControllers.every(
      (controller) => controller.text.isNotEmpty,
    );
    if (!allFilled) {
      setState(() => _otpError = S.of(context).pleaseEnterOtp);
    } else {
      setState(() => _otpError = null);
      context.goNamed(ProfileSetupView.routeName);
    }
  }

  Widget _buildPhoneInfo() {
    return Column(
      children: [
        Text(S.of(context).weSentCodeTo, style: AppTextStyles.regular12),
        Text(
          widget.phoneNumber,
          style: AppTextStyles.regular14.copyWith(
            color: AppColors.primaryAppColor,
          ),
        ),
      ],
    );
  }

  Widget _buildOtpError() {
    if (_otpError == null) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Text(
        _otpError!,
        style: AppTextStyles.regular12.copyWith(color: Colors.red),
      ),
    );
  }

  Widget _buildCountdownTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(S.of(context).resendCodeIn, style: AppTextStyles.regular14),
        Text(
          '00:${_secondsRemaining.toString().padLeft(2, '0')}',
          style: AppTextStyles.regular14.copyWith(
            color: AppColors.primaryAppColor,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _removeOtpListeners();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
