import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifaa/features/book_appointments/presentaion/views/doctor_details_view.dart';
import 'package:shifaa/features/search/domain/entities/dtoctor_entity.dart';
import 'package:shifaa/features/specialty_details/presentation/views/specialty_details_screen.dart'; 
import 'package:shifaa/features/search/domain/entities/specialty_entity.dart';
import 'package:shifaa/features/search/presentation/manager/search_cubit.dart';
import 'package:shifaa/features/search/presentation/views/widgets/doctor_card.dart'
    hide SpecialtyItem;
import 'package:shifaa/features/search/presentation/views/widgets/specialty_item.dart';

class SearchResultsSection extends StatelessWidget {
  const SearchResultsSection({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.errorMessage != null && state.results.isEmpty) {
          return Center(child: Text(state.errorMessage!));
        }
        if (state.results.isEmpty && state.query.isNotEmpty) {
          return Center(
            child: Text(
              'No results found for "${state.query}".',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          );
        }

        if (state.searchType == SearchType.doctors) {
          return GridView.builder(
            itemCount: state.results.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              final doctor = state.results[index] as DoctorEntity;
              return DoctorCard(
                name: doctor.fullName,
                specialty: doctor.specialtyName,
                rating: doctor.rating,
                imageUrl: doctor.imageUrl ??
                    'https://placehold.co/400x600/cccccc/ffffff?text=No+Image',
                doctorId: doctor.id,
                onTap: (id) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DoctorDetailsView(doctorId: id),
                    ),
                  );
                },
              );
            },
          );
        } else {
          return GridView.builder(
            itemCount: state.results.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 15,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              final specialty = state.results[index] as SpecialtyEntity;
              return SpecialtyItem(
                imageUrl: specialty.icon,
                name: specialty.name,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SpecialtyDetailsScreen(
                        specialtyId: specialty.id,
                        specialtyName: specialty.name,
                      ),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}