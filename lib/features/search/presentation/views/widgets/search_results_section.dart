import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifaa/features/home/presentation/views/widgets/specialty_item.dart';
import 'package:shifaa/features/search/presentation/manager/specialty_search_cubit.dart';

class SearchResultsSection extends StatelessWidget {
  const SearchResultsSection({super.key});

  IconData _mapSpecialtyNameToIcon(String specialtyName) {
    final lowerCaseName = specialtyName.toLowerCase();
    if (lowerCaseName.contains('cardiology')) {
      return Icons.favorite_border;
    } else if (lowerCaseName.contains('dermatology')) {
      return Icons.healing;
    } else if (lowerCaseName.contains('neurology')) {
      return Icons.psychology;
    } else if (lowerCaseName.contains('pediatrics')) {
      return Icons.child_care;
    } else if (lowerCaseName.contains('ophthalmology')) {
      return Icons.visibility;
    } else {
      return Icons.medical_services; 
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpecialtySearchCubit, SpecialtySearchState>(
      builder: (context, state) {
        if (state is SearchLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is SearchSuccess) {
          return GridView.builder(
            itemCount: state.specialties.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 15,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              final specialty = state.specialties[index];
              return GestureDetector(
                onTap: () {
                  print('Tapped on ${specialty.name}');
                },
                child: SpecialtyItem( 
                  icon: _mapSpecialtyNameToIcon(specialty.name),
                  name: specialty.name,
                ),
              );
            },
          );
        }
        if (state is SearchFailure) {
          return Center(child: Text(state.errorMessage));
        }
        return const Center(
          child: Text('Find a specialty by typing its name above.'),
        );
      },
    );
  }
}