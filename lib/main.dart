import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shifaa/constants.dart';
import 'package:shifaa/core/utils/app_routes.dart';
import 'package:shifaa/core/utils/functions/setup_service_locator.dart';
import 'package:shifaa/core/utils/simple_bloc_observer.dart';
import 'package:shifaa/dependency_injection.dart';
import 'package:shifaa/features/book_appointments/domain/usecases/cancel_appointment_use_case.dart';
import 'package:shifaa/features/book_appointments/presentaion/cubits/cancel_appointment/cancel_appointment_cubit.dart';
import 'package:shifaa/features/home/domain/repositories/home_repository.dart';
import 'package:shifaa/firebase_options.dart';

import 'features/home/presentation/providers/home_provider .dart';
import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Bloc.observer = SimpleBlocObserver();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  setupServiceLocator();
  await setupServiceLocatorAshour();
  loadToken();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
          HomeProvider(homeRepository: GetIt.instance<HomeRepository>())
            ..fetchAllData(),
        ),
        BlocProvider(
          create: (context) => CancelCubit(getIt<CancelAppointmentUseCase>()),
        ),
      ],
      child: const Shifaa(),
    ),
  );
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
