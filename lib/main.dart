import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shifaa/core/utils/app_routes.dart';
import 'package:shifaa/dependency_injection.dart';
import 'generated/l10n.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();

  await setupServiceLocator();
  runApp(const Shifaa());
}

class Shifaa extends StatelessWidget {
  const Shifaa({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Shifaa App',
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.router,
          theme: ThemeData(
            fontFamily: 'Inter',
            scaffoldBackgroundColor: Colors.white,
            textTheme: ThemeData.light().textTheme.apply(
              bodyColor: const Color(0xFF2F2F2F),
              displayColor: const Color(0xFF2F2F2F),
            ),
            useMaterial3: true,
          ),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          locale: const Locale('en'),
        );
      },
    );
  }
}
