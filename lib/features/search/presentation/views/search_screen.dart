import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifaa/dependency_injection.dart';
import 'package:shifaa/features/search/presentation/manager/specialty_search_cubit.dart';

import 'package:shifaa/features/search/presentation/views/widgets/search_view_body.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SpecialtySearchCubit>(),
      child: SafeArea(child: const SearchViewBody()),
    );
  }
}
