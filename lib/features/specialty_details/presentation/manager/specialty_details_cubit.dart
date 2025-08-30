import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shifaa/features/search/domain/entities/dtoctor_entity.dart';
import 'package:shifaa/features/specialty_details/domain/usecases/get_specialty_doctors_usecase.dart';

part 'specialty_details_state.dart';

class SpecialtyDetailsCubit extends Cubit<SpecialtyDetailsState> {
  final GetSpecialtyDoctorsUsecase _getSpecialtyDoctorsUsecase;

  SpecialtyDetailsCubit(this._getSpecialtyDoctorsUsecase) : super(const SpecialtyDetailsState());

  Future<void> fetchDoctors(int specialtyId) async {
    emit(state.copyWith(status: SpecialtyDetailsStatus.loading));

    final result = await _getSpecialtyDoctorsUsecase(GetSpecialtyDoctorsParams(specialtyId: specialtyId));

    result.fold(
      (failure) => emit(state.copyWith(status: SpecialtyDetailsStatus.error, errorMessage: failure.message)),
      (doctors) => emit(state.copyWith(status: SpecialtyDetailsStatus.success, doctors: doctors)),
    );
  }
}