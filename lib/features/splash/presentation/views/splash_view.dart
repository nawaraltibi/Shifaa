import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shifaa/core/utils/app_colors.dart';
import 'package:shifaa/core/utils/shared_prefs_helper.dart';
import 'package:shifaa/features/book_appointments/presentaion/views/doctor_details_view.dart';
import 'package:shifaa/features/auth/presentation/views/login_view.dart';
import 'package:shifaa/features/chat/presentation/views/chat_view.dart';
import 'package:shifaa/features/home/presentation/views/home_view.dart';
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
    executeNavigation(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primaryAppColor,
      body: SafeArea(child: SplashViewBody()),
    );
  }

  Future<void> executeNavigation(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();
    final alreadyLaunched = prefs.getBool('alreadyLaunched') ?? false;
    final token = prefs.getString('token');

    // if (!alreadyLaunched) {
    //   // أول مرة → OnBoarding
    //   context.goNamed(OnBoardingView.routeName);
    // } else if (alreadyLaunched && (token == null || token.isEmpty)) {
    //   // عمل OnBoarding بس ما عندو token → Login
    //   context.goNamed(LoginView.routeName);
    // } else {
    //   // عندو token → DoctorDetails
    //   context.goNamed(DoctorDetailsView.routeName);
    // }
    goToLogin();
  }

  void goToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomeView()),
    );
    // context.goNamed(LoginView.routeName);
  }
}
