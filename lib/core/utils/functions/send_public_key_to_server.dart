import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:shifaa/core/api/dio_consumer.dart';
import 'package:shifaa/core/api/end_ponits.dart';
import 'package:shifaa/core/utils/shared_prefs_helper.dart';
import 'generate_keys.dart';

Future<int?> sendPublicKeyIfNeeded() async {
  final sharedPrefs = SharedPrefsHelper.instance;

  // ✅ إذا سبق وانبعت وتخزّن deviceId، خلّص ارجع
  final isPublicKeySent = await sharedPrefs.getPublicKeySentToServer();
  final existingDeviceId = await sharedPrefs.getMyDeviceId();
  if (isPublicKeySent && existingDeviceId != null) {
    print('✅ Public key already sent. Device ID = $existingDeviceId');
    return existingDeviceId;
  }

  final PublicKey = await sharedPrefs.getPublicKey();
  if (PublicKey == null) {
    print('⚠️ No public key found. Cannot send.');
    return null;
  }

  // ✅ اسم الجهاز
  final deviceInfo = DeviceInfoPlugin();
  String deviceName = 'Unknown';
  try {
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      deviceName = androidInfo.model ?? 'Android';
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      deviceName = iosInfo.utsname.machine ?? 'iPhone';
    } else {
      deviceName = 'Unknown';
    }
  } catch (e) {
    print('Error getting device info: $e');
  }

  // ✅ الإرسال
  final dioConsumer = DioConsumer(dio: Dio());
  final body = {"public_key": PublicKey, "device_name": deviceName};

  try {
    print('🔹 Sending public key to: ${EndPoint.baseUrl}${EndPoint.publicKey}');
    final response = await dioConsumer.post(EndPoint.publicKey, data: body);

    print('✅ Response from server: $response');

    // شكل الريسبونس حسب ما بعتي:
    // { success, message, data: { device: { id, public_key, fingerprint, device_name } } }
    final data = (response is Map<String, dynamic>) ? response['data'] : null;
    final device = (data is Map<String, dynamic>) ? data['device'] : null;

    if (device is Map<String, dynamic>) {
      final int deviceId = device['id'] is int
          ? device['id']
          : int.tryParse('${device['id']}') ?? 0;

      final String fingerprint = '${device['fingerprint'] ?? ''}';
      final String serverDeviceName = '${device['device_name'] ?? deviceName}';

      if (deviceId > 0) {
        await sharedPrefs.saveMyDeviceInfo(
          id: deviceId,
          fingerprint: fingerprint,
          name: serverDeviceName,
        );
        await sharedPrefs.setPublicKeySentToServer(true);
        print('💾 Saved deviceId=$deviceId, fingerprint=$fingerprint');
        return deviceId;
      }
    }

    // لو وصلنا لهون، معناها ما قدرنا نقرأ الـ device من الريسبونس
    print('⚠️ Could not parse device info from response.');
    return null;
  } on DioException catch (e) {
    print('❌ Dio error: ${e.response?.statusCode} | ${e.response?.data}');
    return null;
  } catch (e) {
    print('❌ Unexpected error: $e');
    return null;
  }
}
