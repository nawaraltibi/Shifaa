part of 'search_cubit.dart';


enum SearchType { doctors, specialties }

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}


class SearchLoadSuccess extends SearchState {
  final SearchType searchType;
  final List<dynamic> results; 
  final bool isLoading;
  final String? errorMessage;
  final String query;

  const SearchLoadSuccess({
    this.searchType = SearchType.specialties,
    this.results = const [],
    this.isLoading = false,
    this.errorMessage,
    this.query = '',
  });

 
  SearchLoadSuccess copyWith({
    SearchType? searchType,
    List<dynamic>? results,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    String? query,
  }) {
    return SearchLoadSuccess(
      searchType: searchType ?? this.searchType,
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      query: query ?? this.query,
    );
  }

  @override
  List<Object> get props => [searchType, results, isLoading, query, errorMessage ?? ''];
}