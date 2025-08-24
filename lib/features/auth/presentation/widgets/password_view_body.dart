import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';
import 'package:shifaa/core/widgets/custom_button.dart';
import 'package:shifaa/features/book_appointments/presentaion/views/doctor_details_view.dart';
import 'package:shifaa/features/auth/presentation/cubits/password_cubit/password_cubit.dart';
import 'package:shifaa/features/auth/presentation/widgets/auth_template.dart';
import 'package:shifaa/features/auth/presentation/widgets/auth_title.dart';
import 'package:shifaa/features/auth/presentation/widgets/custom_password_field.dart';
import 'package:shifaa/features/auth/presentation/widgets/on_tap_text.dart';
import 'package:shifaa/generated/l10n.dart';

class PasswordViewBody extends StatefulWidget {
  const PasswordViewBody({
    super.key,
    required this.phoneNumber,
    required this.otp,
  });
  final String phoneNumber;
  final int otp;

  @override
  State<PasswordViewBody> createState() => _PasswordViewBodyState();
}

class _PasswordViewBodyState extends State<PasswordViewBody> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PasswordCubit, PasswordState>(
      listener: (context, state) {
        if (state is PasswordSuccess) {
          context.goNamed(DoctorDetailsView.routeName);
        } else if (state is PasswordFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },

      builder: (context, state) {
        return AuthTemplate(
          containerHeight: 500.h,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                state is PasswordLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                        text: S.of(context).continueText,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final password = _passwordController.text;
                            context.read<PasswordCubit>().verifyPassword(
                              phone: widget.phoneNumber,
                              otp: widget.otp,
                              password: password,
                            );
                          }
                        },
                      ),
                SizedBox(height: 56.h),
                OnTapBlueText(text: S.of(context).forgotPassword, onTap: () {}),
              ],
            ),
          ),
        );
      },
    );
  }
}
