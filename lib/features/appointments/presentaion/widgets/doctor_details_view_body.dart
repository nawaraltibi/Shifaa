import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shifaa/core/utils/app_images.dart';
import 'package:shifaa/core/widgets/custom_button.dart';
import 'package:shifaa/features/appointments/data/models/doctor_schedule_model.dart';
import 'package:shifaa/features/appointments/presentaion/cubits/doctor_details_cubit/doctor_details_cubit.dart';
import 'package:shifaa/features/appointments/presentaion/cubits/doctor_details_cubit/doctor_details_cubit_state.dart';
import 'package:shifaa/features/appointments/presentaion/cubits/doctor_schedule_cubit/doctor_schedule_cubit.dart';
import 'package:shifaa/features/appointments/presentaion/cubits/doctor_schedule_cubit/doctor_schedule_state.dart';
import 'package:shifaa/features/appointments/presentaion/widgets/about_doctor.dart';
import 'package:shifaa/features/appointments/presentaion/widgets/custom_doctor_details_app_bar.dart';
import 'package:shifaa/features/appointments/presentaion/widgets/doctor_details_title.dart';
import 'package:shifaa/features/appointments/presentaion/widgets/doctor_important_info.dart';
import 'package:shifaa/features/appointments/presentaion/widgets/doctor_stats.dart';
import 'package:shifaa/features/appointments/presentaion/widgets/select_date_list.dart';
import 'package:shifaa/features/appointments/presentaion/widgets/select_date_title.dart';
import 'package:shifaa/features/appointments/presentaion/widgets/select_time_title.dart';
import 'package:shifaa/features/appointments/presentaion/widgets/time_slots_list.dart';
import 'package:shifaa/generated/l10n.dart';

class DoctorDetailsViewBody extends StatefulWidget {
  final String doctorId;

  const DoctorDetailsViewBody({super.key, required this.doctorId});

  @override
  State<DoctorDetailsViewBody> createState() => _DoctorDetailsViewBodyState();
}

class _DoctorDetailsViewBodyState extends State<DoctorDetailsViewBody> {
  List<DoctorScheduleModel> currentSchedule = [];

  DateTime selectedDate = DateTime.now();

  bool detailsLoaded = false;
  bool scheduleLoaded = false;
  List<String> availableDays = [];
  bool isInitialScheduleLoaded = false;

  @override
  void initState() {
    super.initState();
    context.read<DoctorDetailsCubit>().fetchDoctorDetails(widget.doctorId);
    context.read<DoctorScheduleCubit>().fetchDoctorSchedule(widget.doctorId);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DoctorDetailsCubit, DoctorDetailsState>(
          listener: (context, state) {
            if (state is DoctorDetailsSuccess) {
              setState(() => detailsLoaded = true);
            } else if (state is DoctorDetailsError) {
              _showError(context, state.message);
            }
          },
        ),

        BlocListener<DoctorScheduleCubit, DoctorScheduleState>(
          listener: (context, state) {
            if (state is DoctorScheduleSuccess) {
              setState(() {
                if (!isInitialScheduleLoaded) {
                  availableDays = state.schedule
                      .map((e) => e.dayOfWeek.toLowerCase())
                      .toList();
                  isInitialScheduleLoaded = true;
                }
                currentSchedule = state.schedule;
                scheduleLoaded = true;
              });
            } else if (state is DoctorScheduleError) {
              _showError(context, state.message);
            }
          },
        ),
      ],
      child: detailsLoaded && scheduleLoaded
          ? _buildContent()
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildContent() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.0,
          colors: [Color(0xFFFFFFFF), Color(0xFFF1F4FF)],
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.w),
                      child:
                          BlocBuilder<DoctorDetailsCubit, DoctorDetailsState>(
                            builder: (context, state) {
                              if (state is DoctorDetailsSuccess) {
                                final doctor = state.doctor;
                                return Column(
                                  children: [
                                    SizedBox(height: 40.h),
                                    const CustomDoctorDetailsAppBar(),
                                    SizedBox(height: 22.h),
                                    DoctorImportantInfo(
                                      image:
                                          doctor.avatar ?? Assets.imagesDoctor1,
                                      name: doctor.fullName,
                                      sessionPrice: doctor.consultationFee,
                                      specialization: doctor.specialty,
                                    ),
                                  ],
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            },
                          ),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        padding: EdgeInsets.only(
                          left: 22.w,
                          right: 22.w,
                          top: 35.h,
                          bottom: 54.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const DoctorStats(),
                            SizedBox(height: 25.h),
                            DoctorDetailsTitle(
                              text: S.of(context).about_doctor,
                            ),
                            const SizedBox(height: 10),
                            BlocBuilder<DoctorDetailsCubit, DoctorDetailsState>(
                              builder: (context, state) {
                                if (state is DoctorDetailsSuccess) {
                                  return AboutDoctor(text: state.doctor.bio);
                                } else {
                                  return AboutDoctor(
                                    text: S.of(context).loading_bio,
                                  );
                                }
                              },
                            ),
                            SizedBox(height: 30.h),
                            const SelectDateTitle(),
                            SizedBox(height: 15.h),

                            SelectDateList(
                              availableDays:
                                  availableDays, // من DoctorScheduleSuccess
                              selectedDate: selectedDate,
                              onDateSelected: (date) {
                                setState(() {
                                  selectedDate = date;
                                });

                                final formattedDate = _formatDate(date);
                                print("📤 Sending request for: $formattedDate");

                                context
                                    .read<DoctorScheduleCubit>()
                                    .fetchDoctorScheduleForDate(
                                      widget.doctorId,
                                      formattedDate,
                                    );
                              },
                            ),

                            SizedBox(height: 25.h),
                            SelectTimeTitle(
                              slotsCount: currentSchedule
                                  .firstWhere(
                                    (s) =>
                                        s.dayOfWeek.toLowerCase() ==
                                        DateFormat(
                                          'EEEE',
                                        ).format(selectedDate).toLowerCase(),
                                    orElse: () => DoctorScheduleModel(
                                      id: -1,
                                      dayOfWeek: '',
                                      startTime: '',
                                      endTime: '',
                                      sessionDuration: 0,
                                      type: '',
                                      slots: [],
                                    ),
                                  )
                                  .slots
                                  .length,
                            ),

                            const SizedBox(height: 14),
                            BlocBuilder<
                              DoctorScheduleCubit,
                              DoctorScheduleState
                            >(
                              builder: (context, state) {
                                if (state is DoctorScheduleLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state is DoctorScheduleSuccess) {
                                  return TimeSlotsList(
                                    selectedDate: selectedDate,
                                    schedule: currentSchedule,
                                  );
                                } else if (state is DoctorScheduleError) {
                                  return const Center(
                                    child: Text('Failed to load time slots'),
                                  );
                                } else {
                                  return const SizedBox.shrink(); // أو placeholder فارغ
                                }
                              },
                            ),

                            SizedBox(height: 25.h),
                            CustomButton(
                              text: S.of(context).book,
                              onPressed: () {},
                              borderRadius: 35.r,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
