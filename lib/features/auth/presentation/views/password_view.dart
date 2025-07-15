import 'package:flutter/material.dart';
import 'package:shifaa/features/auth/presentation/widgets/password_view_body.dart';

class PasswordView extends StatelessWidget {
  const PasswordView({super.key, required this.phoneNumber, required this.otp});
  static const routeName = '/password';
  final String phoneNumber;
  final int otp;
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,

      body: PasswordViewBody(),
    );
  }
}
