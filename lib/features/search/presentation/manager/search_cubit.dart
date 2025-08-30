import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shifaa/features/search/domain/entities/specialty_entity.dart';
import 'package:shifaa/features/search/domain/usecases/search_for_doctors_usecase.dart';
import 'package:shifaa/features/search/domain/usecases/search_for_specialties_usecase.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchForSpecialtiesUseCase searchForSpecialtiesUseCase;
  final SearchForDoctorsUseCase searchForDoctorsUseCase;

  SearchCubit({
    required this.searchForSpecialtiesUseCase,
    required this.searchForDoctorsUseCase,
  }) : super(const SearchState());

  void changeSearchType(SearchType type) {
    emit(state.copyWith(
        searchType: type, results: [], query: '', clearError: true));

    if (type == SearchType.specialties) {
      fetchInitialSpecialties();
    } else {
      fetchInitialDoctors();
    }
  }

  Future<void> fetchInitialSpecialties() async {
    await performSearch('');
  }

  Future<void> fetchInitialDoctors() async {
    await performSearch('');
  }

  Future<void> performSearch(String query) async {
    emit(state.copyWith(isLoading: true, clearError: true, query: query));

    if (state.searchType == SearchType.doctors) {
      final result = await searchForDoctorsUseCase(SearchParams(query: query));
      result.fold(
        (failure) => emit(
            state.copyWith(isLoading: false, errorMessage: failure.message)),
        (doctors) => emit(state.copyWith(isLoading: false, results: doctors)),
      );
    } else {
      final result =
          await searchForSpecialtiesUseCase(SearchParams(query: query));
      result.fold(
        (failure) => emit(
            state.copyWith(isLoading: false, errorMessage: failure.message)),
        (specialties) =>
            emit(state.copyWith(isLoading: false, results: specialties)),
      );
    }
  }
}