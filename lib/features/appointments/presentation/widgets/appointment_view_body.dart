import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifaa/features/appointments/presentation/manager/appointments_cubit.dart';
import 'package:shifaa/features/appointments/presentation/widgets/appointment_card.dart';
import 'package:shifaa/features/appointments/presentation/widgets/toggel_appointment_type.dart';
// ... other imports

class AppointmentViewBody extends StatelessWidget {
  const AppointmentViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentsCubit, AppointmentsLoadSuccess>(
      builder: (context, state) {
        return Column(
          children: [
            ToggleAppointmentsType(
              selectedType: state.appointmentType,
              onTypeChanged: (type) {
                context.read<AppointmentsCubit>().changeAppointmentType(type);
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<AppointmentsCubit>().fetchAppointments(forceRefresh: true);
                },
                child: _buildContent(state),
              ),
            ) ,
          ],
        );
      },
    );
  }

  Widget _buildContent(AppointmentsLoadSuccess state) {
    if (state.isLoading && state.appointments.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.errorMessage != null && state.appointments.isEmpty) {
      return Center(child: Text(state.errorMessage!));
    }
    if (state.appointments.isEmpty) {
      return const Center(child: Text('No appointments found'));
    }
    return ListView.builder(
      itemCount: state.appointments.length,
      itemBuilder: (context, index) {
        final appointment = state.appointments[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: AppointmentCard(
            appointment: appointment,
            type: state.appointmentType,
          ),
        );
      },
    );
  }
}