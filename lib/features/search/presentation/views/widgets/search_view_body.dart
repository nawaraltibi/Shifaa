import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';
import 'package:shifaa/features/search/presentation/manager/search_cubit.dart';
import 'package:shifaa/features/search/presentation/views/widgets/search_field_widget.dart';
import 'package:shifaa/features/search/presentation/views/widgets/search_results_section.dart';
import 'package:shifaa/features/search/presentation/views/widgets/toggle_search_type.dart';


class SearchViewBody extends StatelessWidget {
  const SearchViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchLoadSuccess>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title:  Center(
              child: Text(
                'Search',
                style: AppTextStyles.semiBold22
              ),
            ),
            backgroundColor: Colors.white,
            scrolledUnderElevation: 0,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              ToggleSearchType(
                selectedType: state.searchType,
                onTypeChanged: (type) {
                  context.read<SearchCubit>().changeSearchType(type);
                },
              ),
              const SizedBox(height: 20),
              SearchFieldWidget(
      
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
        ),
      );
    },
  );
  }}
