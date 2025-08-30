import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifaa/dependency_injection.dart';
import 'package:shifaa/features/user_info/presentation/manager/user_info_cubit.dart';
import 'package:shifaa/features/user_info/presentation/views/widgets/user_info_view_body.dart';

class UserInfoScreen extends StatelessWidget {
  const UserInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<UserInfoCubit>()..fetchUserInfo(),
      child: const UserInfoViewBody(),
    );
  }
}