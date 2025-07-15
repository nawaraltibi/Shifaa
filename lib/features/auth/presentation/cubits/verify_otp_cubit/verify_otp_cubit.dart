import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import 'package:shifaa/core/utils/shared_prefs_helper.dart';
import 'package:shifaa/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:shifaa/generated/l10n.dart';

part 'verify_otp_state.dart';

class VerifyOtpCubit extends Cubit<VerifyOtpState> {
  final VerifyOtpUseCase verifyOtpUseCase;

  VerifyOtpCubit(this.verifyOtpUseCase) : super(VerifyOtpInitial());

  Future<void> verifyOtp(
    String phoneNumber,
    String otp,
    BuildContext context,
  ) async {
    emit(VerifyOtpLoading());

    final result = await verifyOtpUseCase(phoneNumber, otp);

    result.fold(
      (failure) {
        final (title, message, type) = _mapErrorToSnackbar(
          failure.message,
          context,
        );
        _showAwesomeSnackbar(context, title, message, type);
        emit(VerifyOtpError(message));
      },
      (verifyResult) async {
        if (verifyResult.token != null) {
          await SharedPrefsHelper.instance.saveToken(verifyResult.token!);
        }

        if (verifyResult.user != null) {
          await SharedPrefsHelper.instance.saveUserData(verifyResult.user!);
        }

        if (!verifyResult.hasAccount) {
          emit(VerifyOtpSuccess(goToProfileSetup: true));
        } else if (verifyResult.twoFactorEnabled) {
          emit(VerifyOtpSuccess(goToPassword: true));
        } else {
          emit(VerifyOtpSuccess(goToDoctorDetails: true));
        }
      },
    );
  }

  (String, String, ContentType) _mapErrorToSnackbar(
    String msg,
    BuildContext context,
  ) {
    if (msg.contains('expired') || msg.contains('Invalid')) {
      return (
        S.of(context).warningTitle,
        S.of(context).invalidOtp,
        ContentType.warning,
      );
    } else if (msg.contains('phone_number')) {
      return (
        S.of(context).warningTitle,
        S.of(context).invalidPhoneFormat,
        ContentType.warning,
      );
    } else if (msg.contains('No internet') || msg.contains('connection')) {
      return (
        S.of(context).errorTitle,
        S.of(context).noInternet,
        ContentType.failure,
      );
    } else if (msg.contains('timeout')) {
      return (
        S.of(context).errorTitle,
        S.of(context).timeout,
        ContentType.failure,
      );
    } else {
      return (S.of(context).errorTitle, msg, ContentType.failure);
    }
  }

  void _showAwesomeSnackbar(
    BuildContext context,
    String title,
    String msg,
    ContentType type,
  ) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: msg,
        contentType: type,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
