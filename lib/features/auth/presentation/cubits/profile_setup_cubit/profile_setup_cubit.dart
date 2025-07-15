import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:shifaa/core/utils/shared_prefs_helper.dart';
import 'package:shifaa/features/auth/domain/usecases/register_patient_usecase.dart';
import 'package:shifaa/generated/l10n.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

part 'profile_setup_state.dart';

class ProfileSetupCubit extends Cubit<ProfileSetupState> {
  final RegisterUseCase registerUseCase;

  ProfileSetupCubit(this.registerUseCase) : super(ProfileSetupInitial());

  Future<void> register({
    required BuildContext context,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String gender,
    required int otp,
    required String dateOfBirth,
  }) async {
    emit(ProfileSetupLoading());

    final result = await registerUseCase(
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      gender: gender.toLowerCase(),
      otp: otp,
      dateOfBirth: DateFormat(
        'yyyy-MM-dd',
      ).format(DateFormat('dd/MM/yyyy').parse(dateOfBirth)),
    );

    if (!context.mounted) return;

    result.fold(
      (failure) {
        String message = failure.message;
        ContentType contentType = ContentType.failure;
        String title = S.of(context).errorTitle;

        if (message.contains('phone_number')) {
          message = S.of(context).invalidPhoneFormat;
          contentType = ContentType.warning;
          title = S.of(context).warningTitle;
        } else if (message.contains('No internet') ||
            message.contains('connection')) {
          message = S.of(context).noInternet;
        } else if (message.contains('timeout')) {
          message = S.of(context).timeout;
        }

        _showSnackbar(
          context: context,
          title: title,
          message: message,
          contentType: contentType,
        );

        emit(ProfileSetupFailure(message));
      },
      (authData) async {
        // ✅ حفظ التوكين
        if (authData.token != null) {
          await SharedPrefsHelper.instance.saveToken(authData.token!);
        }

        // ✅ حفظ معلومات المستخدم
        if (authData.user != null) {
          await SharedPrefsHelper.instance.saveUserData(authData.user!);
        }

        emit(ProfileSetupSuccess());
      },
    );
  }

  void _showSnackbar({
    required BuildContext context,
    required String title,
    required String message,
    required ContentType contentType,
  }) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: contentType,
      ),
    );

    Future.delayed(Duration.zero, () {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }
}
