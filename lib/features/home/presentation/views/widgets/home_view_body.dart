import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shifaa/core/utils/functions/e2ee_service.dart';
import 'package:shifaa/core/utils/functions/send_public_key_to_server.dart';
import 'package:shifaa/features/book_appointments/presentaion/cubits/cancel_appointment/cancel_appointment_cubit.dart';
import 'package:shifaa/features/book_appointments/presentaion/cubits/cancel_appointment/cancel_appointment_state.dart';
import 'package:shifaa/features/home/presentation/views/widgets/home_app_bar.dart';
import 'package:shifaa/features/home/presentation/views/widgets/previous_appointments_section.dart';
import 'package:shifaa/features/home/presentation/views/widgets/specialties_section.dart';
import 'package:shifaa/features/home/presentation/views/widgets/upcoming_appointments_section.dart';

import '../../providers/home_provider .dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  @override
  void initState() {
    super.initState();
    _initializeKeysAndSendPublicKey();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<HomeProvider>().fetchAllData();
      }
    });
  }

  Future<void> _initializeKeysAndSendPublicKey() async {
    await generateAndSaveKeys();
    await sendPublicKeyIfNeeded();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<CancelCubit, CancelState>(
        listener: (context, state) {
          if (state is! CancelLoading &&
              Navigator.of(context, rootNavigator: true).canPop()) {
            Navigator.of(context, rootNavigator: true).pop();
          }

          if (state is CancelLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          } else if (state is CancelSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Appointment cancelled successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            context.read<HomeProvider>().refreshAllData();
          } else if (state is CancelError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              await context.read<HomeProvider>().refreshAllData();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: const [
                    SizedBox(height: 16),
                    HomeAppBar(),
                    SizedBox(height: 24),
                    UpcomingAppointmentsSection(),
                    SizedBox(height: 16),
                    PreviousAppointmentsSection(),
                    SizedBox(height: 24),
                    SpecialtiesSection(),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
