import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shifaa/core/utils/app_colors.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';
import 'package:shifaa/core/widgets/custom_button.dart';
import 'package:shifaa/features/auth/presentation/cubits/profile_setup_cubit/profile_setup_cubit.dart';
import 'package:shifaa/features/auth/presentation/views/password_view.dart';
import 'package:shifaa/features/auth/presentation/widgets/auth_title.dart';
import 'package:shifaa/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:shifaa/features/auth/presentation/widgets/text_field_title.dart';
import 'package:shifaa/generated/l10n.dart';
import 'dart:ui' as ui;

import 'package:shifaa/features/auth/presentation/widgets/auth_template.dart';

class ProfileSetupViewBody extends StatefulWidget {
  const ProfileSetupViewBody({
    super.key,
    required this.phoneNumber,
    required this.otp,
  });

  final String phoneNumber;
  final int otp;

  @override
  State<ProfileSetupViewBody> createState() => _ProfileSetupViewBodyState();
}

class _ProfileSetupViewBodyState extends State<ProfileSetupViewBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  String _gender = 'Male';
  bool _showAgeError = false;

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryAppColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child ?? const Text(''),
        );
      },
    );

    if (picked != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(picked);
      setState(() {
        _ageController.text = formattedDate;
        _showAgeError = false;
      });
    }
  }

  void _validateAndSubmit() {
    final isValid = _formKey.currentState?.validate() ?? false;

    setState(() {
      _showAgeError = _ageController.text.isEmpty;
    });

    if (isValid && !_showAgeError) {
      context.read<ProfileSetupCubit>().register(
        context: context,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phoneNumber: widget.phoneNumber,
        gender: _gender,
        otp: widget.otp,
        dateOfBirth: _ageController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;

    return BlocListener<ProfileSetupCubit, ProfileSetupState>(
      listener: (context, state) {
        if (state is ProfileSetupSuccess) {
          context.goNamed(
            PasswordView.routeName,
            queryParams: {
              'phone': widget.phoneNumber,
              'otp': widget.otp.toString(),
            },
          );
        }
      },
      child: AuthTemplate(
        containerHeight: 650.h,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthTitle(text: S.of(context).profileSetup),
              SizedBox(height: 30.h),

              TextFieldTitle(text: S.of(context).firstName),
              CustomTextField(
                controller: _firstNameController,
                hintText: S.of(context).firstName,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return S.of(context).pleaseEnterFirstName;
                  }
                  return null;
                },
              ),

              SizedBox(height: 30.h),

              TextFieldTitle(text: S.of(context).lastName),
              CustomTextField(
                controller: _lastNameController,
                hintText: S.of(context).lastName,
              ),

              SizedBox(height: 30.h),

              TextFieldTitle(text: S.of(context).age),
              buildDatePicker(context),

              SizedBox(height: 34.h),
              TextFieldTitle(text: S.of(context).gender, bottomPadding: 4),
              buildGenderRadio(context, lang),

              SizedBox(height: 25.h),

              BlocBuilder<ProfileSetupCubit, ProfileSetupState>(
                builder: (context, state) {
                  final isLoading = state is ProfileSetupLoading;

                  return CustomButton(
                    text: S.of(context).done,
                    isLoading: isLoading,
                    onPressed: _validateAndSubmit,
                  );
                },
              ),

              SizedBox(height: 50.h),
            ],
          ),
        ),
      ),
    );
  }

  Directionality buildDatePicker(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: CustomTextField(
        controller: _ageController,
        onTap: () => _pickDate(context),
        readOnly: true,
        hintText: 'dd/mm/yyyy',
        validator: (_) => null,
        errorText: _showAgeError ? S.of(context).pleaseEnterAge : null,
        suffixIcon: const Padding(
          padding: EdgeInsets.only(right: 10),
          child: Icon(Icons.calendar_today, color: AppColors.primaryAppColor),
        ),
      ),
    );
  }

  Transform buildGenderRadio(BuildContext context, String lang) {
    return Transform.translate(
      offset: lang == 'en' ? const Offset(-13, 0) : const Offset(13, 0),
      child: Row(
        children: [
          Radio<String>(
            value: 'Male',
            groupValue: _gender,
            onChanged: (value) {
              setState(() {
                _gender = value!;
              });
            },
            activeColor: AppColors.primaryAppColor,
            fillColor: WidgetStateProperty.resolveWith<Color>((states) {
              return states.contains(WidgetState.selected)
                  ? AppColors.primaryAppColor
                  : const Color(0xFF989898);
            }),
          ),
          Text(
            S.of(context).male,
            style: AppTextStyles.regular15.copyWith(
              color: const Color(0xFF989898),
            ),
          ),
          const Spacer(),
          Radio<String>(
            value: 'Female',
            groupValue: _gender,
            onChanged: (value) {
              setState(() {
                _gender = value!;
              });
            },
            activeColor: AppColors.primaryAppColor,
            fillColor: WidgetStateProperty.resolveWith<Color>((states) {
              return states.contains(WidgetState.selected)
                  ? AppColors.primaryAppColor
                  : const Color(0xFF989898);
            }),
          ),
          Text(
            S.of(context).female,
            style: AppTextStyles.regular15.copyWith(
              color: const Color(0xFF989898),
            ),
          ),
        ],
      ),
    );
  }
}
