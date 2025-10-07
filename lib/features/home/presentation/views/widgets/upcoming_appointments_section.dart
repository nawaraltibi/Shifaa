import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shifaa/features/home/presentation/views/upcoming_appointments_view.dart';
import 'package:shifaa/features/home/presentation/views/widgets/section_header.dart';
import 'package:shifaa/features/home/presentation/views/widgets/upcoming_appointment_card.dart';
import '../../providers/home_provider .dart';

class UpcomingAppointmentsSection extends StatelessWidget {
  const UpcomingAppointmentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.upcomingSummary.totalCount == 0) {
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

        final summary = provider.upcomingSummary;
        final latestAppointment = summary.latestAppointment;

        return Column(
          children: [
            SectionHeader(
              title: 'Upcoming Appointments',
              count: summary.totalCount,
              onSeeAllTap: () {
                context.pushNamed(UpcomingAppointmentsView.routeName);
              },
            ),
            const SizedBox(height: 16),
            if (latestAppointment != null)
              UpcomingAppointmentCard(appointment: latestAppointment)
            else if (summary.totalCount == 0 && !provider.isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: Text("You have no upcoming appointments."),
              )
            else
              const SizedBox.shrink(),
          ],
        );
      },
    );
  }
}
