import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifaa/features/search/presentation/manager/search_cubit.dart';
import 'package:shifaa/features/search/presentation/views/widgets/search_field_widget.dart';
import 'package:shifaa/features/search/presentation/views/widgets/search_results_section.dart';
import 'package:shifaa/features/search/presentation/views/widgets/toggle_search_type.dart';
// import 'package:shifaa/features/search/presentation/manager/search_cubit.dart';
// import 'package:shifaa/features/search/presentation/view/widgets/search_field_widget.dart';
// import 'package:shifaa/features/search/presentation/view/widgets/search_results_section.dart';
// import 'package:shifaa/features/search/presentation/view/widgets/toggle_search_type.dart';

class SearchViewBody extends StatelessWidget {
  const SearchViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    // نستخدم BlocBuilder هنا لنحصل على آخر قيمة للـ searchType
    return BlocBuilder<SearchCubit, SearchLoadSuccess>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Search', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              ToggleSearchType(
                selectedType: state.searchType,
                onTypeChanged: (type) {
                  context.read<SearchCubit>().changeSearchType(type);
                },
              ),
              const SizedBox(height: 20),
              SearchFieldWidget(
                // تغيير الـ Hint Text بناءً على الحالة
                hintText: state.searchType == SearchType.doctors
                    ? 'Search for a doctor'
                    : 'Search for a specialty',
                onSubmitted: (query) {
                  context.read<SearchCubit>().performSearch(query);
                },
              ),
              const SizedBox(height: 20),
              const Expanded(
                child: SearchResultsSection(),
              ),
            ],
          ),
        );
      },
    );
  }
}
