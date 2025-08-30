import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';
import 'package:shifaa/dependency_injection.dart';
import 'package:shifaa/features/specialty_details/presentation/manager/specialty_details_cubit.dart';
import 'package:shifaa/features/search/presentation/views/widgets/doctor_card.dart';
import 'package:shifaa/features/book_appointments/presentaion/views/doctor_details_view.dart';

class SpecialtyDetailsScreen extends StatelessWidget {
  final int specialtyId;
  final String specialtyName;

  const SpecialtyDetailsScreen({
    super.key,
    required this.specialtyId,
    required this.specialtyName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SpecialtyDetailsCubit>()..fetchDoctors(specialtyId),
      child: Scaffold(
        appBar: AppBar(
          title: Text(specialtyName, style: AppTextStyles.semiBold22),
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          elevation: 0,
          centerTitle: true,
        ),
        body: BlocBuilder<SpecialtyDetailsCubit, SpecialtyDetailsState>(
          builder: (context, state) {
            if (state.status == SpecialtyDetailsStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == SpecialtyDetailsStatus.error) {
              return Center(child: Text(state.errorMessage ?? 'An error occurred'));
            }
            if (state.doctors.isEmpty) {
              return const Center(child: Text('No doctors found in this specialty.'));
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.doctors.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final doctor = state.doctors[index];
                return DoctorCard(
                  name: doctor.fullName,
                  specialty: doctor.specialtyName,
                  rating: doctor.rating,
                  imageUrl: doctor.imageUrl ?? 'https://placehold.co/400x600/cccccc/ffffff?text=No+Image',
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
          },
        ),
      ),
    );
  }
}