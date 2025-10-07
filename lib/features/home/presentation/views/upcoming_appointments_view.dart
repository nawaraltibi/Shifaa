import 'package:flutter/material.dart';
import 'package:shifaa/features/home/presentation/views/widgets/upcoming_appointments_view_body.dart';

class UpcomingAppointmentsView extends StatelessWidget {
  const UpcomingAppointmentsView({super.key});
static const String routeName = '/upcoming-appointments';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Appointments'),
        centerTitle: true,
      ),
      body: UpcomingAppointmentsViewBody(),
    );
  }
}
