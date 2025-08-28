import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shifaa/core/utils/app_colors.dart';
import 'package:shifaa/core/utils/app_text_styles.dart';
import 'package:shifaa/core/widgets/custom_button.dart';
import 'package:shifaa/features/book_appointments/data/models/doctor_schedule_model.dart';
import 'package:shifaa/features/book_appointments/presentaion/cubits/doctor_schedule_cubit/doctor_schedule_cubit.dart';
import 'package:shifaa/features/book_appointments/presentaion/cubits/doctor_schedule_cubit/doctor_schedule_state.dart';
import 'package:shifaa/features/book_appointments/presentaion/cubits/reschedule_appointment/reschedule_appointment_cubit.dart';
import 'package:shifaa/features/book_appointments/presentaion/cubits/reschedule_appointment/reschedule_appointment_state.dart';
import 'package:shifaa/features/book_appointments/presentaion/widgets/select_date_list.dart';
import 'package:shifaa/features/book_appointments/presentaion/widgets/select_date_title.dart';
import 'package:shifaa/features/book_appointments/presentaion/widgets/select_time_title.dart';
import 'package:shifaa/features/book_appointments/presentaion/widgets/time_slots_list.dart';

const String DOCTOR_ID_FOR_RESCHEDULE = "1";

class RescheduleSheet extends StatefulWidget {
  const RescheduleSheet({super.key});

  @override
  State<RescheduleSheet> createState() => _RescheduleSheetState();
}

class _RescheduleSheetState extends State<RescheduleSheet> {
  DateTime? _selectedDate;
  String? _selectedTimeSlot;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _timeSlotsKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    context.read<DoctorScheduleCubit>().fetchDoctorSchedule(
      DOCTOR_ID_FOR_RESCHEDULE,
    );
  }

  @override
  void dispose() {
    // ✅ لا تنسَ التخلص من الـ Controller لتجنب تسريب الذاكرة
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTimeSlots() {
    // ننتظر لحظة قصيرة للتأكد من أن الواجهة قد تم بناؤها بالكامل بعد تحديث الحالة
    Future.delayed(const Duration(milliseconds: 300), () {
      final context = _timeSlotsKey.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 500), // مدة الأنيميشن
          curve: Curves.easeInOut, // شكل منحنى الحركة
          alignment: 0.1, // محاذاة العنصر ليكون قريباً من الأعلى
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✅ الخطوة 1: تحديد الارتفاع الثابت باستخدام Container
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      height: 550.h, // يمكنك تعديل هذا الرقم بدقة
      padding: EdgeInsets.fromLTRB(15.w, 20.h, 24.w, 15.h),
      child: BlocBuilder<DoctorScheduleCubit, DoctorScheduleState>(
        builder: (context, state) {
          if (state is DoctorScheduleLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryAppColor,
              ),
            );
          }
          if (state is DoctorScheduleError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          if (state is DoctorScheduleSuccess ||
              state is DoctorScheduleDateLoading) {
            return _buildContent(context, state);
          }
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryAppColor),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, DoctorScheduleState state) {
    final scheduleCubit = context.read<DoctorScheduleCubit>();

    final DoctorScheduleSuccess? successState = state is DoctorScheduleSuccess
        ? state
        : null;
    final DateTime currentMonth =
        successState?.currentMonth ?? scheduleCubit.currentMonth;
    final DateTime selectedDate =
        successState?.selectedDate ?? scheduleCubit.selectedDate;
    final List<DoctorScheduleModel> schedule =
        successState?.schedule ?? scheduleCubit.schedules;
    final availableDays = schedule
        .map((e) => e.dayOfWeek.toLowerCase())
        .toList();

    // ✅ الخطوة 2: استخدام Column لتوزيع الأجزاء الثلاثة
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- الجزء العلوي (ثابت وغير قابل للتمرير) ---
        SelectDateTitle(
          currentMonth: currentMonth,
          onNext: () => scheduleCubit.nextMonth(),
          onPrevious: () => scheduleCubit.previousMonth(),
        ),
        SizedBox(height: 15.h),

        // ✅ الخطوة 3: استخدام Expanded مع ListView للمحتوى القابل للتمرير
        Expanded(
          child: ListView(
            controller: _scrollController, // الربط هنا
            padding: EdgeInsets.zero, // لإزالة أي padding افتراضي
            children: [
              // نضع قائمة الأيام هنا لتكون جزءاً من المحتوى القابل للتمرير
              SelectDateList(
                currentMonth: currentMonth,
                availableDays: availableDays,
                selectedDate: selectedDate,
                onDateSelected: (date) {
                  setState(() {
                    _selectedDate = date;
                    _selectedTimeSlot = null;
                  });
                  scheduleCubit.selectDateAndFetchSchedule(
                    DOCTOR_ID_FOR_RESCHEDULE,
                    date,
                  );
                  _scrollToTimeSlots();
                },
              ),
              SizedBox(height: 25.h),

              // قسم الوقت
              if (state is DoctorScheduleDateLoading)
                const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryAppColor,
                  ),
                )
              else if (successState != null) ...[
                SelectTimeTitle(
                  key: _timeSlotsKey, // ✅ Add the GlobalKey here
                  slotsCount: successState.schedule
                      .where(
                        (s) =>
                            s.dayOfWeek.toLowerCase() ==
                            DateFormat(
                              'EEEE',
                            ).format(successState.selectedDate!).toLowerCase(),
                      )
                      .expand((s) => s.availableSlots ?? [])
                      .length,
                ),
                SizedBox(height: 14.h),
                TimeSlotsList(
                  selectedDate: successState.selectedDate!,
                  schedule: successState.schedule,
                  onSlotSelected: (fullDateTime) {
                    setState(() {
                      _selectedTimeSlot = fullDateTime;
                    });
                  },
                ),
              ],
            ],
          ),
        ),

        // --- الجزء السفلي (ثابت وغير قابل للتمرير) ---
        SizedBox(height: 20.h),
        BlocListener<RescheduleCubit, RescheduleState>(
          listener: (context, state) {
            // إغلاق أي Dialog مفتوح (مثل مؤشر التحميل)
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }

            if (state is RescheduleLoading) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) =>
                    const Center(child: CircularProgressIndicator()),
              );
            } else if (state is RescheduleSuccess) {
              Navigator.pop(context); // لإغلاق الـ BottomSheet
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Appointment rescheduled successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is RescheduleError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: CustomButton(
            text: 'Confirm',
            onPressed: () {
              if (_selectedDate != null && _selectedTimeSlot != null) {
                // ✅ استدعاء دالة إظهار الـ Dialog
                _showConfirmationDialog(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please select a date and time.'),
                  ),
                );
              }
            },
            borderRadius: 35.r,
          ),
        ),
      ],
    );
  }
  // داخل _RescheduleSheetState

  // ... (أعلى الملف داخل _RescheduleSheetState)

  // لا تنسي إضافة هذا الـ import إذا لم يكن موجوداً

  void _showConfirmationDialog(BuildContext context) {
    // التأكد من أن البيانات موجودة
    if (_selectedDate == null || _selectedTimeSlot == null) return;

    // استدعاء الـ Cubit من الـ context الحالي للـ Dialog
    final rescheduleCubit = context.read<RescheduleCubit>();

    // --- تجهيز النصوص للعرض في الـ Dialog ---
    final locale = Localizations.localeOf(context).toString();
    final formattedDate = DateFormat(
      'EEEE, dd/MM/yyyy',
      locale,
    ).format(_selectedDate!);
    final fullDateTimeString = _selectedTimeSlot!;
    final time = fullDateTimeString.contains('-')
        ? fullDateTimeString.split('-').last.trim()
        : fullDateTimeString;
    final formattedDateTime = '$formattedDate - $time';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          title: Row(
            children: [
              const Icon(
                Icons.event_repeat, // أيقونة مناسبة لإعادة الجدولة
                color: AppColors.primaryAppColor,
              ),
              const SizedBox(width: 8),
              // ✅ تغيير النص ليعكس إعادة الجدولة
              Text(
                "Confirm Reschedule", // يمكنك استبدالها بمفتاح ترجمة مثل S.of(context).confirmReschedule
                style: AppTextStyles.semiBold18.copyWith(fontSize: 20.sp),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ✅ تغيير النص ليعكس إعادة الجدولة
              Text(
                "Reschedule your appointment to the following date and time?", // يمكنك استبدالها بمفتاح ترجمة
                style: AppTextStyles.regular15,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Text(
                formattedDateTime,
                style: AppTextStyles.semiBold18.copyWith(
                  fontSize: 16.sp,
                  color: AppColors.primaryAppColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // محاذاة الأزرار في المنتصف
                textDirection:
                    ui.TextDirection.ltr, // لضمان الترتيب الصحيح (Cancel ثم OK)
                children: [
                  SizedBox(
                    height: 40.h,
                    width: 110.w,
                    child: CustomButton(
                      text: "Cancel", // S.of(context).cancel
                      onPressed: () => Navigator.pop(dialogContext),
                      borderRadius: 35.r,
                      color: const Color(0xFFFF6F61),
                    ),
                  ),
                  SizedBox(width: 20.w), // تقليل المسافة قليلاً
                  SizedBox(
                    height: 40.h,
                    width: 110.w,
                    child: CustomButton(
                      text: "OK", // S.of(context).ok
                      onPressed: () {
                        // --- تجهيز البيانات للـ API ---
                        final datePart = DateFormat(
                          'yyyy-MM-dd',
                          'en_US',
                        ).format(_selectedDate!);
                        final rawTime = _selectedTimeSlot!
                            .split('-')
                            .last
                            .trim();
                        final parsedTime = DateFormat(
                          'h:mm a',
                          'en_US',
                        ).parse(rawTime);
                        final timePart = DateFormat(
                          'HH:mm',
                          'en_US',
                        ).format(parsedTime);
                        final startTimeForApi = "$datePart $timePart";

                        // البحث عن doctor_schedule_id
                        final scheduleState = context
                            .read<DoctorScheduleCubit>()
                            .state;
                        int? doctorScheduleId;
                        if (scheduleState is DoctorScheduleSuccess) {
                          for (final schedule in scheduleState.schedule) {
                            if ((schedule.availableSlots ?? []).contains(
                              timePart,
                            )) {
                              doctorScheduleId = schedule.id;
                              break;
                            }
                          }
                        }

                        if (doctorScheduleId == null) {
                          Navigator.pop(dialogContext);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Could not find schedule ID.'),
                            ),
                          );
                          return;
                        }

                        // ✅ **** التعديل الجوهري هنا ****
                        // استدعاء دالة الـ Cubit الصحيحة
                        rescheduleCubit.confirmReschedule(
                          appointmentId: 30, // قيمة ثابتة حسب الطلب
                          startTime: startTimeForApi,
                          doctorScheduleId: doctorScheduleId,
                        );

                        // لا نغلق الـ Dialog هنا، الـ BlocListener سيتولى الأمر
                        // سيتم إغلاقه تلقائياً عند بدء التحميل
                      },
                      borderRadius: 35.r,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
