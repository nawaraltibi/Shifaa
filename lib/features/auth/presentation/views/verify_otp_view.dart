import 'package:flutter/material.dart';
import 'package:shifaa/features/auth/presentation/widgets/verify_otp_view_body.dart';

class VerifyOtpView extends StatelessWidget {
  const VerifyOtpView({super.key, required this.phoneNumber});
  final String phoneNumber;
  static const routeName = '/verify-otp-view';
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: VerifyOtpViewBody(phoneNumber: phoneNumber));
  }
}
