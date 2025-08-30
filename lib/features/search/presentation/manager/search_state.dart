part of 'search_cubit.dart';

enum SearchType { doctors, specialties }

class SearchState extends Equatable {
  final SearchType searchType;
  final List<dynamic> results;
  final bool isLoading;
  final String? errorMessage;
  final String query;

  const SearchState({
    this.searchType = SearchType.specialties,
    this.results = const [],
    this.isLoading = false,
    this.errorMessage,
    this.query = '',
  });

  SearchState copyWith({
    SearchType? searchType,
    List<dynamic>? results,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    String? query,
  }) {
    return SearchState(
      searchType: searchType ?? this.searchType,
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      query: query ?? this.query,
    );
  }

  @override
  List<Object?> get props =>
      [searchType, results, isLoading, query, errorMessage];
}