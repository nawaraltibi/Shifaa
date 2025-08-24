import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifaa/dependency_injection.dart';
import 'package:shifaa/features/home/presentation/manager/home_cubit.dart';
import 'package:shifaa/features/home/presentation/views/widgets/home_view_body.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
static const routeName = '/home';
  @override
  Widget build(BuildContext context) {
  
    return BlocProvider(
      create: (context) => sl<HomeCubit>(),
      child: const HomeViewBody(),
    );
  }
}
