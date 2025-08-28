import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shifaa/core/utils/app_colors.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';
import 'package:shifaa/features/treatmeant_plan/models/appointment_models.dart';

class MedicationsSection extends StatelessWidget {
  final List<MedicationInfo> medications;

  const MedicationsSection({Key? key, required this.medications})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < medications.length; i++)
          _buildMedicationCard(medications[i], i),
      ],
    );
  }

  Widget _buildMedicationCard(MedicationInfo medication, int index) {
    return Container(
      margin: EdgeInsets.only(
        bottom: index < medications.length - 1 ? 12.h : 0,
      ),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.red.withOpacity(0.2), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Medication Icon
          Container(
            width: 32.w,
            height: 32.w,
            decoration: const BoxDecoration(
              color: AppColors.red,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.medical_services,
              color: Colors.white,
              size: 16.sp,
            ),
          ),
          SizedBox(width: 12.w),
          // Medication Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Medication Name
                Text(
                  medication.name,
                  style: AppTextStyles.semiBold15.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                // Dosage
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Dosage:',
                      style: AppTextStyles.regular12.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      medication.dosage,
                      style: AppTextStyles.medium12.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                // Frequency
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Frequency:',
                      style: AppTextStyles.regular12.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      medication.frequency,
                      style: AppTextStyles.medium12.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                // Doctor's Notes
                Text(
                  'Doctor\'s Notes:',
                  style: AppTextStyles.medium12.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  medication.doctorNotes,
                  style: AppTextStyles.regular10.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
