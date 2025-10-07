import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shifaa/features/home/presentation/views/widgets/previous_appointment_card.dart';
import 'package:shifaa/features/home/presentation/views/widgets/previous_appointments_view.dart';
import 'package:shifaa/features/home/presentation/views/widgets/section_header.dart';

import '../../providers/home_provider .dart';

class PreviousAppointmentsSection extends StatelessWidget {
  const PreviousAppointmentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.previousSummary.totalCount == 0) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 40.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (provider.failure != null) {
          return Center(
            child: Text('Error: ${provider.failure!.message}'),
          );
        }

        final summary = provider.previousSummary;
        final latestAppointment = summary.latestAppointment;

        return Column(
          children: [
            SectionHeader(
              title: 'Previous Appointments',
              count: summary.totalCount,
              onSeeAllTap: () {
                context.pushNamed(PreviousAppointmentsView.routeName);
              },
            ),
            const SizedBox(height: 16),
            if (latestAppointment != null)
              PreviousAppointmentCard(appointment: latestAppointment)
            else if (summary.totalCount == 0 && !provider.isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: Text("You have no previous appointments."),
              )
            else
              const SizedBox.shrink(),
          ],
        );
      },
    );
  }
}
