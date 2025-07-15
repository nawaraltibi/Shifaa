import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifaa/core/functions/setup_service_locator.dart';
import 'package:shifaa/features/auth/domain/usecases/register_patient_usecase.dart';
import 'package:shifaa/features/auth/presentation/cubits/profile_setup_cubit/profile_setup_cubit.dart';
import 'package:shifaa/features/auth/presentation/widgets/profile_setup_view_body.dart';

class ProfileSetupView extends StatelessWidget {
  const ProfileSetupView({
    super.key,
    required this.phoneNumber,
    required this.otp,
  });

  final String phoneNumber;
  final int otp;

  static const routeName = '/profileSetup';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileSetupCubit(getIt<RegisterUseCase>()),
      child: ProfileSetupViewBody(phoneNumber: phoneNumber, otp: otp),
    );
  }
}
