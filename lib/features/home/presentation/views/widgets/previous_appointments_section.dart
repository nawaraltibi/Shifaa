import 'package:flutter/material.dart';
import 'package:shifaa/features/home/presentation/views/widgets/previous_appointment_card.dart';
import 'package:shifaa/features/home/presentation/views/widgets/section_header.dart';

class PreviousAppointmentsSection extends StatelessWidget {
  const PreviousAppointmentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: 'Previous Appointments',
          count: 7,
          onSeeAllTap: () {},
        ),
        const SizedBox(height: 16),
        ListView.builder(
          itemCount: 1,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return const PreviousAppointmentCard();
          },
        ),
      ],
    );
  }
} 