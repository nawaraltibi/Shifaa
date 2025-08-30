part of 'specialty_details_cubit.dart';

enum SpecialtyDetailsStatus { initial, loading, success, error }

class SpecialtyDetailsState extends Equatable {
  final SpecialtyDetailsStatus status;
  final List<DoctorEntity> doctors;
  final String? errorMessage;

  const SpecialtyDetailsState({
    this.status = SpecialtyDetailsStatus.initial,
    this.doctors = const [],
    this.errorMessage,
  });

  SpecialtyDetailsState copyWith({
    SpecialtyDetailsStatus? status,
    List<DoctorEntity>? doctors,
    String? errorMessage,
  }) {
    return SpecialtyDetailsState(
      status: status ?? this.status,
      doctors: doctors ?? this.doctors,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, doctors, errorMessage];
}