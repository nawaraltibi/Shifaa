import 'package:flutter/material.dart';
import 'package:shifaa/features/auth/presentation/widgets/signup_view_body.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});
  static const routeName = '/signup';
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SignupViewBody());
  }
}
