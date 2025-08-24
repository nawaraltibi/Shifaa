import 'package:flutter/material.dart';
import 'package:shifaa/core/utils/functions/e2ee_service.dart';
import 'package:shifaa/core/utils/functions/send_public_key_to_server.dart';
import 'package:shifaa/features/home/presentation/views/widgets/home_app_bar.dart';
import 'package:shifaa/features/home/presentation/views/widgets/previous_appointments_section.dart';
import 'package:shifaa/features/home/presentation/views/widgets/random_tips_section.dart';
import 'package:shifaa/features/home/presentation/views/widgets/specialties_section.dart';
import 'package:shifaa/features/home/presentation/views/widgets/upcoming_appointments_section.dart';

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
  }

  Future<void> _initializeKeysAndSendPublicKey() async {
    // توليد المفاتيح لو مش موجودة
    await generateAndSaveKeys();

    // طباعة الـ Private Key بالكامل
    // final privateKey = await getPrivateKey();
    // if (privateKey != null) {
    //   final pemString = privateKeyToPem(privateKey);
    //   print("Private Key PEM:\n$pemString");
    // }

    // إرسال الـ Public Key ونوع الجهاز إذا ما أرسل قبل
    await sendPublicKeyIfNeeded();

    // ✅ طباعة patient_id هنا
    // try {
    //   final userModel = await SharedPrefsHelper.instance.getUserModel();
    //   print('Patient ID: ${userModel.patientId}');
    // } catch (e) {
    //   print('Error getting Patient ID: $e');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                SizedBox(height: 16),
                HomeAppBar(),
                SizedBox(height: 24),
                RandomTipsSection(),
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
    );
  }
}
