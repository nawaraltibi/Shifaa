import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifaa/features/search/domain/entities/dtoctor_entity.dart';
import 'package:shifaa/features/search/domain/entities/specialty_entity.dart';
import 'package:shifaa/features/search/presentation/manager/search_cubit.dart';
import 'package:shifaa/features/home/presentation/views/widgets/specialty_item.dart';
import 'package:shifaa/features/search/presentation/views/widgets/doctor_card.dart' hide SpecialtyItem;

class SearchResultsSection extends StatelessWidget {
  const SearchResultsSection({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchLoadSuccess>(
      builder: (context, state) {
        if (state.isLoading) return const Center(child: CircularProgressIndicator());
        if (state.errorMessage != null && state.results.isEmpty) return Center(child: Text(state.errorMessage!));
        if (state.results.isEmpty) {
          return Center(
            child: Text(
              state.query.isEmpty ? 'Start by typing in the search bar above.' : 'No results found for "${state.query}".',
              textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey),
            ),
          );
        }
        if (state.searchType == SearchType.doctors) {
          return GridView.builder(
            itemCount: state.results.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15, childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              final doctor = state.results[index] as DoctorEntity; 
              return DoctorCard(
                name: doctor.fullName,
                specialty: doctor.specialtyName,
                rating: doctor.rating,
                imageUrl: doctor.imageUrl ?? 'https://placehold.co/400x600/cccccc/ffffff?text=No+Image',
                onTap: () {},
              );
            },
          );
        } else {
          return GridView.builder(
            itemCount: state.results.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 15, childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              final specialty = state.results[index] as SpecialtyEntity;
              return SpecialtyItem(icon: _mapSpecialtyNameToIcon(specialty.name), name: specialty.name);
            },
          );
        }
      },
    );
  }
  IconData _mapSpecialtyNameToIcon(String specialtyName) {

    return Icons.medical_services;
  }
}