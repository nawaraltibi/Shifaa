import 'package:flutter/material.dart';
import 'package:shifaa/features/auth/presentation/widgets/password_view_body.dart';

class PasswordView extends StatelessWidget {
  const PasswordView({super.key});
  static const routeName = '/password';
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: PasswordViewBody());
  }
}
