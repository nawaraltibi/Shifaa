import 'package:flutter/material.dart';
import 'package:shifaa/features/auth/presentation/widgets/profile_setup_view_body.dart';

class ProfileSetupView extends StatelessWidget {
  const ProfileSetupView({super.key});
  static const routeName = '/profileSetup';
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,

      body: ProfileSetupViewBody(),
    );
  }
}
