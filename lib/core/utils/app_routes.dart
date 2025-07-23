import 'package:go_router/go_router.dart';
import 'package:shifaa/core/layout/main_layout_screen.dart';
import 'package:shifaa/features/auth/presentation/views/login_view.dart';
import 'package:shifaa/features/auth/presentation/views/password_view.dart';
import 'package:shifaa/features/auth/presentation/views/signup_view.dart';
import 'package:shifaa/features/auth/presentation/views/verify_otp_view.dart';
import 'package:shifaa/features/home/presentation/views/home_view.dart';
import 'package:shifaa/features/onboarding/presentation/views/on_boarding_view.dart';
import 'package:shifaa/features/splash/presentation/views/splash_view.dart';


abstract class AppRouter {
  static final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashView()),
      GoRoute(
        path: OnBoardingView.routeName,
        name: OnBoardingView.routeName,
        builder: (context, state) => const MainLayoutScreen(),
      ),
      GoRoute(
        path: SignupView.routeName,
        name: SignupView.routeName,
        builder: (context, state) => const SignupView(),
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
        path: '/home',
        name: HomeView.routeName,
        builder: (context, state) => const HomeView(),
      ),
    ],
  );
}
