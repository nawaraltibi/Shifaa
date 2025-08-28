import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifaa/core/utils/functions/setup_service_locator.dart';
import 'package:shifaa/features/book_appointments/domain/usecases/cancel_appointment_use_case.dart';
import 'package:shifaa/features/book_appointments/presentaion/cubits/cancel_appointment/cancel_appointment_cubit.dart';
import 'package:shifaa/features/book_appointments/presentaion/widgets/re_sched_appointment_view_body.dart';

class ReSchedAppointmentView extends StatelessWidget {
  const ReSchedAppointmentView({super.key});
  static const routeName = '/re-sched-appointment';

  @override
  Widget build(BuildContext context) {
    // ✅ الحل: استخدم MultiBlocProvider هنا ليكون المصدر الوحيد للـ Cubits
    // التي تحتاجها الشاشة بأكملها.
    return MultiBlocProvider(
      providers: [
        // توفير الـ Cubit الخاص بالإلغاء على مستوى الشاشة
        BlocProvider(
          create: (context) => CancelCubit(getIt<CancelAppointmentUseCase>()),
        ),
        // يمكنك إضافة أي Cubits أخرى تحتاجها الشاشة هنا في المستقبل
        // على سبيل المثال، إذا احتجت cubit لجلب تفاصيل الموعد
      ],
      child: const Scaffold(
        backgroundColor: Colors.white, // لون خلفية مناسب
        body: ReSchedAppointmentViewBody(),
      ),
    );
  }
}
