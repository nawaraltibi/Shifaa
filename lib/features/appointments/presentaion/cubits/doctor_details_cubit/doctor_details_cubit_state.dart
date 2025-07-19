import 'package:shifaa/features/appointments/data/models/doctor_model.dart';

abstract class DoctorDetailsState {}

class DoctorDetailsInitial extends DoctorDetailsState {}

class DoctorDetailsLoading extends DoctorDetailsState {}

class DoctorDetailsSuccess extends DoctorDetailsState {
  final DoctorModel doctor;

  DoctorDetailsSuccess(this.doctor);
}

class DoctorDetailsError extends DoctorDetailsState {
  final String message;

  DoctorDetailsError(this.message);
}
