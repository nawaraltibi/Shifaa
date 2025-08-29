import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifaa/core/utils/functions/setup_service_locator.dart';
import 'package:shifaa/features/auth/domain/usecases/verify_password_usecase.dart';
import 'package:shifaa/features/auth/presentation/cubits/password_cubit/password_cubit.dart';
import 'package:shifaa/features/auth/presentation/widgets/password_view_body.dart';

class PasswordView extends StatelessWidget {
  const PasswordView({super.key, required this.phoneNumber, required this.otp});
  static const routeName = '/password';
  final String phoneNumber;
  final  otp;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PasswordCubit(getIt<VerifyPasswordUseCase>()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: PasswordViewBody(otp: otp, phoneNumber: phoneNumber),
      ),
    );
  }
}
