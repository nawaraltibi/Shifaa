import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shifaa/core/utils/app_colors.dart';
import 'package:shifaa/features/auth/presentation/views/login_view.dart';
import 'package:shifaa/features/onboarding/presentation/views/on_boarding_view.dart';
import 'package:shifaa/features/splash/presentation/views/widgets/splash_view_body.dart';
import 'package:shifaa/features/auth/presentation/widgets/auth_template.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    executeNavigation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primaryAppColor,
      body: SafeArea(child: SplashViewBody()),
    );
  }

  void executeNavigation() async {
    await Future.delayed(const Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();
    final alreadyLaunched = prefs.getBool('alreadyLaunched') ?? false;

    if (alreadyLaunched) {
      context.goNamed(LoginView.routeName);
    } else {
      context.goNamed(OnBoardingView.routeName);
    }
  }
}
