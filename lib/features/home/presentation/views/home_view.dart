import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifaa/dependency_injection.dart';
import 'package:shifaa/features/home/presentation/manager/home_cubit.dart';
import 'package:shifaa/features/home/presentation/views/widgets/home_view_body.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifaa/features/home/presentation/manager/home_cubit.dart';
import 'package:shifaa/features/home/presentation/views/widgets/home_app_bar.dart';
import 'package:shifaa/features/home/presentation/views/widgets/previous_appointments_section.dart';
import 'package:shifaa/features/home/presentation/views/widgets/random_tips_section.dart';
import 'package:shifaa/features/home/presentation/views/widgets/specialties_section.dart';
import 'package:shifaa/features/home/presentation/views/widgets/upcoming_appointments_section.dart';

class HomeView extends StatelessWidget {
  static String routeName= "/home";

  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
      create: (context) => sl<HomeCubit>(),
      // The actual UI that will consume the cubit is now in a separate widget.
      child: const HomeViewBody(),
    );
  }
}

