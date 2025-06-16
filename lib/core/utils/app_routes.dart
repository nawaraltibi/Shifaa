import 'package:go_router/go_router.dart';
import 'package:shifaa/features/splash/presentation/views/splash_view.dart';

abstract class AppRouter {
  static final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashView()),
    ],
  );
}
