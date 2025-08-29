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
    // القسم الآن يعرض دائماً العنوان
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
            // إذا كانت البيانات قيد التحميل، نعرض كارد رمادي بنفس الحجم
            if (state.status == HomeStatus.loading) {
              return const EmptyStateCard(message: 'Loading...');
            }
            // إذا كان هناك موعد، نعرضه
            if (state.previousAppointment != null) {
              return PreviousAppointmentCard(appointment: state.previousAppointment!);
            } else {
              // إذا لم يكن هناك موعد، نعرض رسالة مناسبة في كارد بنفس الحجم
              return const EmptyStateCard(message: 'لا يوجد مواعيد سابقة حالياً');
            }
          },
        ),
      ],
    );
  }
}
