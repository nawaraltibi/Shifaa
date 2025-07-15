import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shifaa/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:shifaa/generated/l10n.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final SendOtpUseCase sendOtpUseCase;

  LoginCubit(this.sendOtpUseCase) : super(LoginInitial());

  Future<void> sendOtp(String? phoneNumber, BuildContext context) async {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      _showSnackbar(
        context: context,
        title: S.of(context).warningTitle,
        message: S.of(context).pleaseEnterPhone,
        contentType: ContentType.warning,
      );
      return;
    }

    emit(LoginLoading());

    final result = await sendOtpUseCase(phoneNumber);

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

        emit(LoginError(message));
      },
      (_) {
        emit(LoginSuccess(phoneNumber));
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

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
