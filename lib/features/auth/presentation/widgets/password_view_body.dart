import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';
import 'package:shifaa/core/widgets/custom_button.dart';
import 'package:shifaa/features/auth/presentation/views/password_view.dart';
import 'package:shifaa/features/auth/presentation/widgets/auth_template.dart';
import 'package:shifaa/features/auth/presentation/widgets/auth_title.dart';
import 'package:shifaa/features/auth/presentation/widgets/custom_password_field.dart';
import 'package:shifaa/features/auth/presentation/widgets/on_tap_text.dart';
import 'package:shifaa/generated/l10n.dart';
import 'package:shifaa/features/home/presentation/views/home_view.dart';

class PasswordViewBody extends StatefulWidget {
  const PasswordViewBody({super.key});

  @override
  State<PasswordViewBody> createState() => _PasswordViewBodyState();
}

class _PasswordViewBodyState extends State<PasswordViewBody> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AuthTemplate(
      margin: 320,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 90.h),
              AuthTitle(text: S.of(context).password),
              SizedBox(height: 50.h),
              Text(S.of(context).password, style: AppTextStyles.medium16),
              const SizedBox(height: 5),
              CustomPasswordField(
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return S.of(context).enterPassword;
                  }
                  return null;
                },
              ),
              SizedBox(height: 40.h),
              CustomButton(
                text: S.of(context).continueText,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.goNamed(PasswordView.routeName);
                  }
                },
              ),
              SizedBox(height: 56.h),
              OnTapBlueText(
                text: S.of(context).forgotPassword,
                onTap: () => context.goNamed(HomeView.routeName),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
