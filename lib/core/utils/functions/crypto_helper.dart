import 'dart:typed_data';
import 'dart:convert';
import 'dart:math';
import 'package:pointycastle/export.dart' as pc;
import 'package:shifaa/core/utils/functions/e2ee_service.dart';
import 'package:shifaa/core/utils/shared_prefs_helper.dart';
import 'package:shifaa/features/chat/data/models/message.dart';

class CryptoHelper {
  static final _random = Random.secure();

  /// توليد مفتاح AES (256bit)
  static Uint8List generateAESKey([int length = 32]) {
    return Uint8List.fromList(
      List<int>.generate(length, (_) => _random.nextInt(256)),
    );
  }

  /// توليد IV عشوائي (12 bytes للـ GCM)
  static Uint8List generateIV([int length = 12]) {
    return Uint8List.fromList(
      List<int>.generate(length, (_) => _random.nextInt(256)),
    );
  }

  /// AES-GCM Encrypt: بيرجع base64(iv + cipher + tag)
  static String aesGcmEncryptToBase64(Uint8List key, String plainText) {
    final iv = generateIV(12);
    final cipher = pc.GCMBlockCipher(pc.AESEngine());
    final aeadParams = pc.AEADParameters(
      pc.KeyParameter(key),
      128,
      iv,
      Uint8List(0),
    );
    cipher.init(true, aeadParams);

    final input = Uint8List.fromList(utf8.encode(plainText));
    final output = cipher.process(input); // cipher + tag

    final combined = Uint8List(iv.length + output.length)
      ..setAll(0, iv)
      ..setAll(iv.length, output);

    return base64.encode(combined);
  }

  /// AES-GCM Decrypt: بياخد base64(iv + cipher + tag)
  static String? aesGcmDecryptFromBase64(Uint8List key, String base64Combined) {
    try {
      final bytes = base64.decode(base64Combined);
      if (bytes.length < 13) return null;

      final iv = bytes.sublist(0, 12);
      final cipherBytes = bytes.sublist(12);

      final cipher = pc.GCMBlockCipher(pc.AESEngine());
      final aeadParams = pc.AEADParameters(
        pc.KeyParameter(key),
        128,
        iv,
        Uint8List(0),
      );
      cipher.init(false, aeadParams);

      final plain = cipher.process(cipherBytes);
      return utf8.decode(plain);
    } catch (e) {
      print("AES decrypt failed: $e");
      return null;
    }
  }
}

// في ملف crypto_helper.dart

Future<Uint8List> getAesKey(MessageModel msg) async {
  // استخدمنا print() بدلاً من logger لضمان ظهورها دائماً
  print(
    "\n🕵️‍♂️ --- DECRYPTION PROCESS STARTED for Message ID: ${msg.id} --- 🕵️‍♂️",
  );

  try {
    // --- الخطوة 1: التحقق من الشروط الأساسية ---
    if ((msg.text ?? '').isEmpty) {
      print("➡️ SKIPPED: Message text is empty or null.");
      return Uint8List(0);
    }
    if (msg.encryptedKeys.isEmpty) {
      print(
        "➡️ SKIPPED: Message has no encrypted keys attached. (Check MessageModel.fromJson)",
      );
      return Uint8List(0);
    }
    print("✅ STEP 1: Basic conditions passed. Message has text and keys.");

    // --- الخطوة 2: جلب ID الجهاز الحالي ---
    final myDeviceId = await SharedPrefsHelper.instance.getMyDeviceId();
    if (myDeviceId == null) {
      print(
        "❌ FAILED at STEP 2: Could not get current device ID from SharedPreferences.",
      );
      return Uint8List(0);
    }
    print(
      "✅ STEP 2: My Device ID is: $myDeviceId (Type: ${myDeviceId.runtimeType})",
    );
    print(
      "   - Available Keys for Devices: ${msg.encryptedKeys.map((k) => 'ID: ${k.deviceId} (Type: ${k.deviceId.runtimeType})').toList()}",
    );

    // --- الخطوة 3: البحث عن المفتاح المشفر الخاص بجهازي ---
    EncryptedKeyTarget? me;
    try {
      for (int i = 0; i < msg.encryptedKeys.length; i++) {
        print(msg.id);
        print(msg.encryptedKeys[i].deviceId);
        print(msg.encryptedKeys[i].encryptedKey);
      }
      print(msg.encryptedKeys);
      me = msg.encryptedKeys.firstWhere(
        (keyTarget) => keyTarget.deviceId == myDeviceId,
      );
      print(
        "✅ STEP 3: Found encrypted key for my device: ${me.encryptedKey.substring(0, 10)}...",
      );
    } catch (e) {
      print(
        "❌ FAILED at STEP 3: No encrypted key found for my device ID ($myDeviceId). The message was not encrypted for this device.",
      );
      return Uint8List(0); // أعد الرسالة الأصلية لأنها غير موجهة لهذا الجهاز
    }

    // --- الخطوة 4: تحميل المفتاح الخاص من الـ Secure Storage ---
    final priv = await E2EE.loadPrivateKeyFromSecureStorage();
    if (priv == null) {
      print(
        "❌ FAILED at STEP 4: Private key not found in secure storage. Cannot decrypt.",
      );
      return Uint8List(0);
    }
    print("✅ STEP 4: Private key loaded successfully from secure storage.");

    // --- الخطوة 5: فك تشفير مفتاح AES باستخدام المفتاح الخاص (RSA) ---
    // في ملف crypto_helper.dart، داخل دالة decryptForMe

    // --- الخطوة 5: فك تشفير مفتاح AES باستخدام المفتاح الخاص (RSA) ---
    Uint8List? aesKey;
    try {
      // ✅✅✅ --- هذا هو الإصلاح --- ✅✅✅
      // تم حذف useOaep: true لأنه لم يعد ضرورياً
      aesKey = E2EE.rsaDecryptWithPrivateOAEP(priv, base64.decode(me.encryptedKey));
      print("✅ STEP 5: AES key decrypted successfully using RSA.");
    } catch (e) {
      print("❌ FAILED at STEP 5: RSA decryption failed. Error: $e");
      return Uint8List(0);
    }
    return aesKey;
  } catch (e, stackTrace) {
    print("\n🔥🔥🔥 AN UNEXPECTED ERROR OCCURRED IN DECRYPTION 🔥🔥🔥");
    print("Error for Message ID: ${msg.id}");
    print("THE ERROR: $e");
    print("STACK TRACE: $stackTrace");
    print("🔥🔥🔥 END OF ERROR 🔥🔥🔥\n");
    return Uint8List(0); // أعد الرسالة المشفرة عند حدوث خطأ فادح
  }
}

Future<Message> decryptText(MessageModel msg, Uint8List aesKey) async {
  // --- الخطوة 6: فك تشفير نص الرسالة باستخدام مفتاح AES (AES-GCM) ---
  String? plainText;
  try {
    plainText = E2EE.aesGcmDecryptFromBase64(aesKey, msg.text!);
    if (plainText == null) {
      print(
        "❌ FAILED at STEP 6: AES-GCM decryption returned null. (The AES key might be wrong or text is corrupted).",
      );
      return msg;
    }
    print("✅ STEP 6: SUCCESS! Message decrypted!");
    print("   ---> Decrypted Text: $plainText <---");
  } catch (e) {
    print(
      "❌ FAILED at STEP 6: AES-GCM decryption threw an exception. Error: $e",
    );
    return msg;
  }

  // --- الخطوة 7: إعادة بناء الموديل مع النص المفكوك ---
  // نستخدم copyWith لتحديث النص فقط
  return msg.copyWith(text: plainText);
}
