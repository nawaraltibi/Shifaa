import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shifaa/features/home/presentation/views/widgets/previous_appointment_card.dart';

import '../../providers/home_provider .dart';

class PreviousAppointmentsView extends StatelessWidget {
  const PreviousAppointmentsView({super.key});

  static const String routeName = '/previous-appointments';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Previous Appointments'),
        centerTitle: true,
      ),
      body: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.allPreviousAppointments.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.failure != null) {
            return Center(
              child: Text('Error: ${provider.failure!.message}'),
            );
          }

          final appointments = provider.allPreviousAppointments;

          if (appointments.isEmpty) {
            return const Center(child: Text('No previous appointments found.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: PreviousAppointmentCard(
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
