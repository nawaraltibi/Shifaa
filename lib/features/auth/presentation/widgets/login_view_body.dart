import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:shifaa/core/widgets/custom_button.dart';
import 'package:shifaa/features/auth/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:shifaa/features/auth/presentation/views/verify_otp_view.dart';
import 'package:shifaa/features/auth/presentation/widgets/auth_title.dart';
import 'package:shifaa/features/auth/presentation/widgets/phone_number_field.dart';
import 'package:shifaa/features/auth/presentation/widgets/text_field_title.dart';
import 'package:shifaa/features/auth/presentation/widgets/auth_template.dart';
import 'package:shifaa/generated/l10n.dart';

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key});

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {
  String? _nationalNumber;
  final TextEditingController _phoneController = TextEditingController();
  bool _showError = false;

  @override
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          final currentRoute = GoRouter.of(context).location;
          if (!currentRoute.contains(VerifyOtpView.routeName)) {
            context.goNamed(
              VerifyOtpView.routeName,
              queryParams: {'phone': state.phoneNumber},
            );
          }
        } else if (state is LoginError) {
        }
      },
      child: AuthTemplate(
        containerHeight: 500.h,
        isWelcomeVisible: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AuthTitle(text: S.of(context).login),
            SizedBox(height: 50.h),
            _buildPhoneNumberInput(),
            if (_showError) _buildErrorText(),
            SizedBox(height: 60.h),
            _buildSendOtpButton(),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneNumberInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldTitle(text: S.of(context).phoneNumber),
        Directionality(
          textDirection: TextDirection.ltr,
          child: PhoneNumberField(
            borderColor: _showError ? Colors.red : const Color(0xFFC8C8C8),
            onChanged: (fullNumber) {
              setState(() {
                _nationalNumber = fullNumber;
                _showError = false;
              });
            },
            controller: _phoneController,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorText() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        S.of(context).pleaseEnterPhone,
        style: TextStyle(color: Colors.red, fontSize: 13.sp),
      ),
    );
  }

  Widget _buildSendOtpButton() {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        final isLoading = state is LoginLoading;

        return CustomButton(
          text: S.of(context).login,
          isLoading: isLoading,
          onPressed: isLoading
              ? null
              : () {
                  context.read<LoginCubit>().sendOtp(_nationalNumber, context);
                },
        );
      },
    );
  }
}
