// lib/features/treatmeant_plan/presentation/views/treatment_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shifaa/core/utils/app_colors.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';
import 'package:shifaa/features/home/presentation/views/home_view.dart';
import 'package:shifaa/features/treatmeant_plan/models/appointment_models.dart';
import '../widgets/expandable_section.dart';
import '../widgets/diagnosis_section.dart';
import '../widgets/appointments_section.dart';
import '../widgets/medications_section.dart';

class TreatmentView extends StatelessWidget {
  const TreatmentView({Key? key}) : super(key: key);
  static const routeName = '/treatment-view';

  @override
  Widget build(BuildContext context) {
    // Sample data updated with dates
    final appointmentDetails = AppointmentDetails(
      diagnosis: DiagnosisInfo(
        status: 'Completed',
        diagnosedWith: 'Common Cold',
        doctorName: 'Mouaz Zakaria',
        doctorSpecialty: 'General Surgery',
      ),
      appointments: [
        AppointmentInfo(
          date: DateTime(2024, 4, 19), // <-- تم إضافة التاريخ هنا
          time: '08:00 - 08:30',
          type: 'Follow Up',
          doctorNotes:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor Lorem ipsum dolor sit amet, consectetur.',
        ),
        AppointmentInfo(
          date: DateTime(2024, 4, 12), // <-- تم إضافة التاريخ هنا
          time: '08:00 - 08:30',
          type: 'Normal',
          doctorNotes:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        ),
      ],
      medications: [
        MedicationInfo(
          name: 'Panadol Extra',
          dosage: '500 mg',
          frequency: 'Twice Daily',
          doctorNotes:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        ),
        MedicationInfo(
          name: 'Panadol Extra',
          dosage: '500 mg',
          frequency: 'Twice Daily',
          doctorNotes:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        ),
      ],
    );

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.textPrimary,
            size: 20.sp,
          ),
          onPressed: () => context.goNamed(HomeView.routeName),
        ),
        title: Text(
          'Appointment Details',
          style: AppTextStyles.semiBold18.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        children: [
          SizedBox(height: 16.h),
          ExpandableSection(
            title: 'Diagnoses',
            headerColor: AppColors.primaryAppColor,
            backgroundColor: AppColors.diagnosesBackground,
            leadingIcon: Icons.assignment,
            initiallyExpanded: true,
            child: DiagnosisSection(diagnosis: appointmentDetails.diagnosis),
          ),
          SizedBox(height: 16.h),
          ExpandableSection(
            title: 'Appointments',
            headerColor: AppColors.purple,
            backgroundColor: AppColors.appointmentsBackground,
            leadingIcon: Icons.calendar_today,
            initiallyExpanded: true,
            child: AppointmentsSection(
              appointments: appointmentDetails.appointments,
            ),
          ),
          SizedBox(height: 16.h),
          ExpandableSection(
            title: 'Medications',
            headerColor: AppColors.red,
            backgroundColor: AppColors.medicationsBackground,
            leadingIcon: Icons.medical_services,
            initiallyExpanded: true,
            child: MedicationsSection(
              medications: appointmentDetails.medications,
            ),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
