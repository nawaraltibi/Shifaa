import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shifaa/features/search/domain/usecases/search_for_doctors_usecase.dart';
import 'package:shifaa/features/search/domain/usecases/search_for_specialties_usecase.dart';

part 'search_state.dart'; // افترض أن search_state.dart موجود وصحيح

class SearchCubit extends Cubit<SearchLoadSuccess> {
  final SearchForSpecialtiesUseCase searchForSpecialtiesUseCase;
  final SearchForDoctorsUseCase searchForDoctorsUseCase; // إضافة الـ UseCase الجديد

  SearchCubit({
    required this.searchForSpecialtiesUseCase,
    required this.searchForDoctorsUseCase, // حقن الـ UseCase الجديد
  }) : super(const SearchLoadSuccess());

  void changeSearchType(SearchType type) {
    emit(state.copyWith(searchType: type, results: [], query: '', clearError: true));
  }

  Future<void> performSearch(String query) async {
    if (query.trim().isEmpty) {
      emit(state.copyWith(results: [], query: '', clearError: true));
      return;
    }
    emit(state.copyWith(isLoading: true, clearError: true, query: query));

    if (state.searchType == SearchType.doctors) {
      // --- البحث عن الأطباء عبر الـ API الحقيقي ---
      final result = await searchForDoctorsUseCase(SearchParams(query: query));
      result.fold(
        (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
        (doctors) {
          if (doctors.isEmpty) {
            emit(state.copyWith(isLoading: false, results: [], errorMessage: 'No doctors found.'));
          } else {
            emit(state.copyWith(isLoading: false, results: doctors));
          }
        },
      );
    } else {
      // --- البحث عن التخصصات عبر الـ API الحقيقي ---
      final result = await searchForSpecialtiesUseCase(SearchParams(query: query));
      result.fold(
        (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
        (specialties) {
          if (specialties.isEmpty) {
            emit(state.copyWith(isLoading: false, results: [], errorMessage: 'No specialties found.'));
          } else {
            emit(state.copyWith(isLoading: false, results: specialties));
          }
        },
      );
    }
  }
}