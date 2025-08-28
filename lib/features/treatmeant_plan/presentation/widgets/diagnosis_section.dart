import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shifaa/core/utils/app_colors.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';
import 'package:shifaa/features/treatmeant_plan/models/appointment_models.dart';

class DiagnosisSection extends StatelessWidget {
  final DiagnosisInfo diagnosis;

  const DiagnosisSection({Key? key, required this.diagnosis}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildInfoRow('Status:', diagnosis.status, AppColors.blue),
        SizedBox(height: 12.h),
        _buildInfoRow(
          'Diagnosed With:',
          diagnosis.diagnosedWith,
          AppColors.textPrimary,
        ),
        SizedBox(height: 12.h),
        _buildInfoRow(
          'Doctor\'s Name:',
          diagnosis.doctorName,
          AppColors.textPrimary,
        ),
        SizedBox(height: 12.h),
        _buildInfoRow(
          'Doctor\'s Specialty:',
          diagnosis.doctorSpecialty,
          AppColors.textPrimary,
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, Color valueColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: AppTextStyles.regular13.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            value,
            style: AppTextStyles.regular14.copyWith(
              fontSize: 13.sp,
              color: AppColors.primaryAppColor,
            ),
          ),
        ),
      ],
    );
  }
}
