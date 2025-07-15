part of 'verify_otp_cubit.dart';

@immutable
abstract class VerifyOtpState {}

class VerifyOtpInitial extends VerifyOtpState {}

class VerifyOtpLoading extends VerifyOtpState {}

class VerifyOtpSuccess extends VerifyOtpState {
  final bool goToProfileSetup;
  final bool goToPassword;
  final bool goToDoctorDetails;

  VerifyOtpSuccess({
    this.goToProfileSetup = false,
    this.goToPassword = false,
    this.goToDoctorDetails = false,
  });
}

class VerifyOtpError extends VerifyOtpState {
  final String message;

  VerifyOtpError(this.message);
}
