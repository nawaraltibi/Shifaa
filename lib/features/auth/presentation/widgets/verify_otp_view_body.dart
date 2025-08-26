import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:shifaa/core/utils/app_colors.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';
import 'package:shifaa/core/widgets/custom_button.dart';
import 'package:shifaa/features/book_appointments/presentaion/views/doctor_details_view.dart';
import 'package:shifaa/features/auth/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:shifaa/features/auth/presentation/cubits/verify_otp_cubit/verify_otp_cubit.dart';
import 'package:shifaa/features/auth/presentation/views/password_view.dart';
import 'package:shifaa/features/auth/presentation/views/profile_setup_view.dart';
import 'package:shifaa/features/auth/presentation/widgets/auth_title.dart';
import 'package:shifaa/features/auth/presentation/widgets/otp_field.dart';
import 'package:shifaa/features/auth/presentation/widgets/auth_template.dart';
import 'package:shifaa/features/home/presentation/views/home_view.dart';
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

  int _secondsRemaining = 30;
  Timer? _timer;
  String? _otpError;

  @override
  void initState() {
    super.initState();

    _startCountdown();
    _addOtpListeners();
  }

  void _startCountdown() {
    _timer?.cancel(); // ألغِ أي مؤقت سابق قبل البدء
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
      } else {
        setState(() => _secondsRemaining--);
      }
    });
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
    bool allFilled = _otpControllers.every((c) => c.text.isNotEmpty);
    if (allFilled && _otpError != null) {
      setState(() => _otpError = null);
    }
  }

  void _onContinuePressed(BuildContext context) {
    final otp = _otpControllers.map((c) => c.text).join();

    if (otp.length < 4) {
      setState(() => _otpError = S.of(context).pleaseEnterOtp);
    } else {
      setState(() => _otpError = null);
      context.read<VerifyOtpCubit>().verifyOtp(
        widget.phoneNumber,
        otp,
        context,
      );
    }
  }

  void _resendOtp() {
    setState(() {
      _secondsRemaining = 30;
    });
    _startCountdown();

    // استدعاء دالة إعادة إرسال OTP من SendOtpCubit
    context.read<LoginCubit>().sendOtp(widget.phoneNumber, context);
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<VerifyOtpCubit, VerifyOtpState>(
      listener: (context, state) {
        if (state is VerifyOtpSuccess) {
          final otp = _otpControllers.map((c) => c.text).join();
          final otpValue = int.parse(otp);

          if (state.goToProfileSetup) {
            context.goNamed(
              ProfileSetupView.routeName,
              queryParams: {
                'phone': widget.phoneNumber,
                'otp': otpValue.toString(),
              },
            );
          } else if (state.goToDoctorDetails) {
            context.goNamed(
              HomeView.routeName,
              queryParams: {'phone': widget.phoneNumber},
            );
          } else if (state.goToPassword) {
            context.goNamed(
              PasswordView.routeName,
              queryParams: {
                'phone': widget.phoneNumber,
                'otp': otpValue.toString(),
              },
            );
          }
        }
      },

      child: AuthTemplate(
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
            BlocBuilder<VerifyOtpCubit, VerifyOtpState>(
              builder: (context, state) {
                final isLoading = state is VerifyOtpLoading;
                return CustomButton(
                  text: S.of(context).continueText,
                  isLoading: isLoading,
                  onPressed: isLoading
                      ? null
                      : () {
                    _onContinuePressed(context);

                  },
                );
              },
            ),
            SizedBox(height: 20.h),

            // هنا إظهار المؤقت أو زر إعادة الإرسال
            _secondsRemaining > 0
                ? _buildCountdownTimer()
                : TextButton(
                    onPressed: _resendOtp,
                    child: Text(
                      S.of(context).resendOtp,
                      style: TextStyle(
                        color: AppColors.primaryAppColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),

            SizedBox(height: 35.h),
          ],
        ),
      ),
    );
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
}
