import 'package:dartz/dartz_streaming.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shifaa/features/auth/presentation/views/login_view.dart';
import 'package:shifaa/features/auth/presentation/views/password_view.dart';
import 'package:shifaa/features/auth/presentation/views/profile_setup_view.dart';
import 'package:shifaa/features/auth/presentation/views/verify_otp_view.dart';
import 'package:shifaa/features/onboarding/presentation/views/on_boarding_view.dart';
import 'package:shifaa/features/splash/presentation/views/splash_view.dart';
import 'package:shifaa/features/auth/presentation/widgets/auth_template.dart';

abstract class AppRouter {
  static final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashView()),
      GoRoute(
        path: OnBoardingView.routeName,
        name: OnBoardingView.routeName,
        builder: (context, state) => const OnBoardingView(),
      ),

      GoRoute(
        path: LoginView.routeName,
        name: LoginView.routeName,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: PasswordView.routeName,
        name: PasswordView.routeName,
        builder: (context, state) => const PasswordView(),
      ),
      GoRoute(
        path: '/verify-otp-view',
        name: VerifyOtpView.routeName,
        builder: (context, state) {
          final phone = state.queryParams['phone'] ?? '';
          return VerifyOtpView(phoneNumber: phone);
        },
      ),
      GoRoute(
        path: ProfileSetupView.routeName,
        name: ProfileSetupView.routeName,
        builder: (context, state) => const ProfileSetupView(),
      ),
    ],
  );
}
