import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shifaa/features/search/domain/entities/specialty_entity.dart';
import 'package:shifaa/features/search/domain/usecases/search_for_specialties_usecase.dart';

part 'specialty_search_state.dart';

class SpecialtySearchCubit extends Cubit<SpecialtySearchState> {
  final SearchForSpecialtiesUseCase searchForSpecialtiesUseCase;

  SpecialtySearchCubit({required this.searchForSpecialtiesUseCase})
      : super(SearchInitial());

  Future<void> searchForSpecialty(String query) async {
    if (query.trim().isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());

    final result = await searchForSpecialtiesUseCase(SearchParams(query: query));

    result.fold(
      (failure) {
        emit(SearchFailure(failure.message));
      },
      (specialties) {
        if (specialties.isEmpty) {
          emit(const SearchFailure('No specialties found matching your search.'));
        } else {
          emit(SearchSuccess(specialties));
        }
      },
    );
  }
}
