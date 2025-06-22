import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';
import 'package:shifaa/core/widgets/custom_button.dart';
import 'package:shifaa/features/auth/presentation/views/login_view.dart';
import 'package:shifaa/features/auth/presentation/views/password_view.dart';
import 'package:shifaa/features/auth/presentation/widgets/auth_template.dart';
import 'package:shifaa/features/auth/presentation/widgets/auth_title.dart';
import 'package:shifaa/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:shifaa/features/auth/presentation/widgets/on_tap_text.dart';
import 'package:shifaa/generated/l10n.dart';

class SignupViewBody extends StatefulWidget {
  const SignupViewBody({super.key});

  @override
  State<SignupViewBody> createState() => _SignupViewBodyState();
}

class _SignupViewBodyState extends State<SignupViewBody> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AuthTemplate(
      margin: 200.h,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 75.h),
              AuthTitle(text: S.of(context).signup),
              SizedBox(height: 20.h),
              Text(S.of(context).firstName, style: AppTextStyles.medium16),
              const SizedBox(height: 5),
              CustomTextField(
                controller: _firstNameController,
                hintText: S.of(context).firstName,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return S.of(context).pleaseEnterFirstName;
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              Text(S.of(context).lastName, style: AppTextStyles.medium16),
              const SizedBox(height: 5),
              CustomTextField(
                controller: _lastNameController,
                hintText: S.of(context).lastName,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return S.of(context).pleaseEnterLastName;
                  }
                  return null;
                },
              ),
              SizedBox(height: 40.h),
              CustomButton(
                text: S.of(context).signup,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.goNamed(PasswordView.routeName);
                  }
                },
              ),
              SizedBox(height: 21.h),
              Align(
                alignment: Alignment.center,
                child: Text(
                  S.of(context).haveAnAccount,
                  style: AppTextStyles.regular12,
                ),
              ),
              OnTapBlueText(
                onTap: () => context.goNamed(LoginView.routeName),
                text: S.of(context).login,
              ),
              SizedBox(height: 35.h),
            ],
          ),
        ),
      ),
    );
  }
}
