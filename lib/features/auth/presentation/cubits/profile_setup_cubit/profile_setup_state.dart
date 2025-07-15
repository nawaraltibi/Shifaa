part of 'profile_setup_cubit.dart';

@immutable
sealed class ProfileSetupState {}

final class ProfileSetupInitial extends ProfileSetupState {}

class ProfileSetupLoading extends ProfileSetupState {}

class ProfileSetupSuccess extends ProfileSetupState {}

class ProfileSetupFailure extends ProfileSetupState {
  final String message;

  ProfileSetupFailure(this.message);
}
