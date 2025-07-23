part of 'specialty_search_cubit.dart';

abstract class SpecialtySearchState extends Equatable {
  const SpecialtySearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SpecialtySearchState {}

class SearchLoading extends SpecialtySearchState {}

class SearchSuccess extends SpecialtySearchState {
  final List<SpecialtyEntity> specialties;

  const SearchSuccess(this.specialties);

  @override
  List<Object> get props => [specialties];
}

class SearchFailure extends SpecialtySearchState {
  final String errorMessage;

  const SearchFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}