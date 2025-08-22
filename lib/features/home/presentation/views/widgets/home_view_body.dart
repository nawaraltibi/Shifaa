import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shifaa/core/utils/functions/generate_keys.dart';
import 'package:shifaa/core/utils/functions/e2ee_service.dart';
import 'package:shifaa/core/utils/functions/get_private_key.dart';
import 'package:shifaa/core/utils/functions/privatekey_to_pem.dart';
import 'package:shifaa/core/utils/functions/send_public_key_to_server.dart';
import 'package:shifaa/features/appointments/presentaion/views/doctor_details_view.dart';
import 'package:shifaa/features/chat/presentation/views/chat_view.dart';
import 'package:shifaa/core/utils/shared_prefs_helper.dart'; // استورد SharedPrefsHelper

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
    return Center(
      child: ElevatedButton(
        onPressed: () => context.goNamed(DoctorDetailsView.routeName),
        child: const Text('Go To Chat'),
      ),
    );
  }
}
