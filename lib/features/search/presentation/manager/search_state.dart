part of 'search_cubit.dart';


enum SearchType { doctors, specialties }

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

// الحالة الكاملة للشاشة، تحتوي على كل المعلومات
class SearchLoadSuccess extends SearchState {
  final SearchType searchType;
  final List<dynamic> results; // يمكن أن تكون قائمة أطباء أو تخصصات
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

  // دالة مساعدة لنسخ الحالة مع تعديلات بسيطة
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