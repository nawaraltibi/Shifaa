import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';
import 'package:shifaa/core/widgets/custom_button.dart';
import 'package:shifaa/features/auth/presentation/views/password_view.dart';
import 'package:shifaa/features/auth/presentation/views/signup_view.dart';
import 'package:shifaa/features/auth/presentation/widgets/auth_template.dart';
import 'package:shifaa/features/auth/presentation/widgets/auth_title.dart';
import 'package:shifaa/features/auth/presentation/widgets/on_tap_text.dart';
import 'package:shifaa/features/auth/presentation/widgets/phone_number_text_field.dart';
import 'package:shifaa/generated/l10n.dart';

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key});

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AuthTemplate(
      margin: 300,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 90.h),
              AuthTitle(text: S.of(context).login),
              SizedBox(height: 60.h),
              Text(S.of(context).phoneNumber, style: AppTextStyles.medium16),
              const SizedBox(height: 5),
              PhoneNumberTextField(
                controller: _phoneController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return S.of(context).pleaseEnterPhone;
                  }
                  return null;
                },
              ),
              SizedBox(height: 60.h),
              CustomButton(
                text: S.of(context).login,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.goNamed(PasswordView.routeName);
                  }
                },
              ),
              SizedBox(height: 20.h),
              OnTapBlueText(text: S.of(context).forgotPassword, onTap: () {}),
              SizedBox(height: 37.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(S.of(context).dontHaveAccount),
                  OnTapBlueText(
                    text: S.of(context).singUpNow,
                    onTap: () {
                      context.goNamed(SignupView.routeName);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
