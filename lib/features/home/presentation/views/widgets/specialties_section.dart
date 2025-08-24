import 'package:flutter/material.dart';
import 'package:shifaa/features/home/presentation/views/widgets/section_header.dart';
import 'package:shifaa/features/home/presentation/views/widgets/specialty_item.dart';

class SpecialtiesSection extends StatelessWidget {
  const SpecialtiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Replace with actual data model
    final List<Map<String, dynamic>> specialties = [
      {'icon': Icons.favorite_border, 'name': 'Cardiology'},
      {'icon': Icons.healing, 'name': 'Gastroenterology'},
      {'icon': Icons.psychology, 'name': 'Neurology'},
      {'icon': Icons.child_care, 'name': 'Pediatrics'},
      {'icon': Icons.personal_injury_outlined, 'name': 'Orthopedics'},
      {'icon': Icons.visibility, 'name': 'Ophthalmology'},
      {'icon': Icons.medical_services, 'name': 'Dentistry'},
      {'icon': Icons.bloodtype, 'name': 'Radiology'},
    ];

    return Column(
      children: [
        SectionHeader(
          title: 'Specialties',
          onSeeAllTap: () {},
        ),
        const SizedBox(height: 16),
        GridView.builder(
          itemCount: specialties.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 15,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            return SpecialtyItem(
              icon: specialties[index]['icon'],
              name: specialties[index]['name'],
            );
          },
        ),
      ],
    );
  }
} 