import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifaa/core/functions/setup_service_locator.dart';
import 'package:shifaa/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:shifaa/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:shifaa/features/auth/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:shifaa/features/auth/presentation/cubits/verify_otp_cubit/verify_otp_cubit.dart';
import 'package:shifaa/features/auth/presentation/widgets/verify_otp_view_body.dart';

class VerifyOtpView extends StatelessWidget {
  const VerifyOtpView({super.key, required this.phoneNumber});

  final String phoneNumber;
  static const routeName = '/verify-otp-view';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoginCubit(getIt<SendOtpUseCase>())),
        BlocProvider(create: (_) => VerifyOtpCubit(getIt<VerifyOtpUseCase>())),
      ],

      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: VerifyOtpViewBody(phoneNumber: phoneNumber),
      ),
    );
  }
}
