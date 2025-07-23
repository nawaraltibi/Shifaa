import 'package:flutter/material.dart';
import 'package:shifaa/features/home/presentation/views/widgets/section_header.dart';
import 'package:shifaa/features/home/presentation/views/widgets/upcoming_appointment_card.dart';

class UpcomingAppointmentsSection extends StatelessWidget {
  const UpcomingAppointmentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: 'Upcoming Appointments',
          count: 3,
          onSeeAllTap: () {},
        ),
        const SizedBox(height: 16),
        ListView.builder(
          itemCount: 1, 
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return const UpcomingAppointmentCard();
          },
        ),
      ],
    );
  }
} 