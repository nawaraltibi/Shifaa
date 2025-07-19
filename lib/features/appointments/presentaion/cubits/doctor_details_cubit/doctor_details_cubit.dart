import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifaa/features/appointments/domain/usecases/get_doctor_details_use_case.dart';
import 'package:shifaa/features/appointments/presentaion/cubits/doctor_details_cubit/doctor_details_cubit_state.dart';

class DoctorDetailsCubit extends Cubit<DoctorDetailsState> {
  final GetDoctorDetailsUseCase getDoctorDetailsUseCase;
  late String _doctorId;

  DoctorDetailsCubit(this.getDoctorDetailsUseCase)
    : super(DoctorDetailsInitial());

  Future<void> fetchDoctorDetails(String doctorId) async {
    _doctorId = doctorId;
    emit(DoctorDetailsLoading());
    final result = await getDoctorDetailsUseCase(doctorId);
    result.fold(
      (failure) => emit(DoctorDetailsError(failure.message)),
      (doctor) => emit(DoctorDetailsSuccess(doctor)),
    );
  }

  void retry() {
    fetchDoctorDetails(_doctorId);
  }
}
