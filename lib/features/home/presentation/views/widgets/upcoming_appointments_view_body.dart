import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shifaa/features/home/presentation/views/widgets/upcoming_appointment_card.dart';
import '../../providers/home_provider .dart';

class UpcomingAppointmentsViewBody extends StatelessWidget {
  const UpcomingAppointmentsViewBody({super.key});

  static const String routeName = '/upcoming-appointments';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Appointments'),
        centerTitle: true,
      ),
      body: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.allUpcomingAppointments.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.failure != null) {
            return Center(
              child: Text('Error: ${provider.failure!.message}'),
            );
          }

          final appointments = provider.allUpcomingAppointments;

          if (appointments.isEmpty) {
            return const Center(child: Text('No upcoming appointments found.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: UpcomingAppointmentCard(
                  appointment: appointments[index],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
