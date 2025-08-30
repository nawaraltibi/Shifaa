import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifaa/features/home/presentation/manager/home_cubit.dart';
import 'package:shifaa/features/home/presentation/views/widgets/empty_state_card.dart';
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

            // الحالة الثانية: يوجد موعد سابق (القائمة ليست فارغة)
            if (state.previousAppointment != null && state.previousAppointment!.isNotEmpty) {
              return PreviousAppointmentCard(appointment: state.previousAppointment!);
            } 
            // الحالة الثالثة: لا يوجد أي مواعيد سابقة
            else {
              return const EmptyStateCard(message: 'You have no previous appointments.');
            }
          },
        ),
      ],
    );
  }
}
