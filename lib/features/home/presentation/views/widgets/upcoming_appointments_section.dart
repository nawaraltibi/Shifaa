import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifaa/features/home/presentation/manager/home_cubit.dart';
import 'package:shifaa/features/home/presentation/views/widgets/empty_state_card.dart';
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
          onSeeAllTap: () {
            // TODO: Implement navigation to all appointments screen
          },
        ),
        const SizedBox(height: 16),
        BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            // الحالة الأولى: جاري التحميل
            if (state.status == HomeStatus.loading) {
              return const EmptyStateCard(message: 'Loading...');
            }
            // الحالة الثانية: يوجد موعد قادم (القائمة ليست فارغة)
            if (state.upcomingAppointment != null && state.upcomingAppointment!.isNotEmpty) {
              return UpcomingAppointmentCard(appointment: state.upcomingAppointment!);
            } 
            // الحالة الثالثة: لا يوجد أي مواعيد قادمة
            else {
              return const EmptyStateCard(message: 'You have no upcoming appointments.');
            }
          },
        ),
      ],
    );
  }
}
