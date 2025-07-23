import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifaa/features/search/presentation/manager/specialty_search_cubit.dart';
import 'package:shifaa/features/search/presentation/views/widgets/search_field_widget.dart';
import 'package:shifaa/features/search/presentation/views/widgets/search_results_section.dart';
import 'package:shifaa/features/search/presentation/views/widgets/toggle_search_type.dart';

class SearchViewBody extends StatelessWidget {
  const SearchViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
   
          const Text('Search', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

  
          const ToggleSearchType(),
          const SizedBox(height: 20),

  
          SearchFieldWidget(
            hintText: 'Search for a Specialty',
            onSubmitted: (query) {
              context.read<SpecialtySearchCubit>().searchForSpecialty(query);
            },
          ),
          const SizedBox(height: 20),

          const Expanded(
            child: SearchResultsSection(),
          ),
        ],
      ),
    );
  }
}
