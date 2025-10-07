import 'dart:typed_data';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pointycastle/export.dart' as pc;
import 'package:shifaa/core/utils/functions/e2ee_service.dart';
import 'package:shifaa/core/utils/shared_prefs_helper.dart';
import 'package:shifaa/features/chat/data/models/message.dart';
import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class CryptoHelper {
  static final _random = Random.secure();

  static Uint8List generateAESKey([int length = 32]) {
    return Uint8List.fromList(
      List<int>.generate(length, (_) => _random.nextInt(256)),
    );
  }

  static Uint8List generateIV([int length = 12]) {
    return Uint8List.fromList(
      List<int>.generate(length, (_) => _random.nextInt(256)),
    );
  }

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
    final output = cipher.process(input);

    final combined = Uint8List(iv.length + output.length)
      ..setAll(0, iv)
      ..setAll(iv.length, output);

    return base64.encode(combined);
  }

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

Future<Uint8List> getAesKey(MessageModel msg) async {
  print(
    "\n🕵️‍♂️ --- DECRYPTION PROCESS STARTED for Message ID: ${msg.id} --- 🕵️‍♂️",
  );

  try {
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
      return Uint8List(0);
    }

    final priv = await E2EE.loadPrivateKeyFromSecureStorage();
    if (priv == null) {
      print(
        "❌ FAILED at STEP 4: Private key not found in secure storage. Cannot decrypt.",
      );
      return Uint8List(0);
    }
    print("✅ STEP 4: Private key loaded successfully from secure storage.");

    Uint8List? aesKey;
    try {
      aesKey = E2EE.rsaDecryptWithPrivateOAEP(
        priv,
        base64.decode(me.encryptedKey),
      );
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
    return Uint8List(0);
  }
}

Future<Message> decryptText(MessageModel msg, Uint8List aesKey) async {
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

  return msg.copyWith(text: plainText);
}

Future<File?> downloadDecryptAndOpenExternal(
  String url,
  Uint8List aesKey,
  void Function(int received, int? total)? onProgress,
) async {
  print("[file] start downloadDecryptAndOpenExternal for file=${url}");

  final cacheDir = await getTemporaryDirectory();
  final basename = p.basename(Uri.tryParse(url)?.path ?? 'file');
  final hashed = url.hashCode;
  final outName = 'decrypted_${hashed}_$basename';
  final outFile = File(p.join(cacheDir.path, outName));

  if (await outFile.exists()) {
    print('[file] cache hit -> using existing file: ${outFile.path}');
    try {
      final openResult = await OpenFile.open(outFile.path);
      print('[file] OpenFile result: ${openResult.type} ${openResult.message}');
    } catch (e) {
      print('[file] OpenFile failed (cache hit): $e');
    }
    return outFile;
  }

  print("[file] encrypted file not in cache -> downloading: $url");
  final token = await SharedPrefsHelper.instance.getToken();
  print("[file] auth token is: ${token}");
  final headers = {
    'Authorization': 'Bearer $token',
    'Accept': 'application/octet-stream',
  };

  final dio = new Dio();
  final resp = await dio.get(
    url,
    options: Options(responseType: ResponseType.bytes, headers: headers),
    onReceiveProgress: (received, total) {
      try {
        if (onProgress != null)
          onProgress(received, total == -1 ? null : total);
      } catch (_) {}
    },
  );

  print("[file] download complete");

  final Uint8List encryptedBytes = Uint8List.fromList((resp.data as List<int>));

  print('[file] downloaded encrypted bytes len=${encryptedBytes.length}');

  if (!(aesKey.length == 16 || aesKey.length == 24 || aesKey.length == 32)) {
    print('[file] invalid AES key length=${aesKey.length}');
    return null;
  }

  final decrypted = await compute<List<dynamic>, Uint8List?>(
    _decryptBytesIsolate,
    [encryptedBytes, aesKey],
  );

  if (decrypted == null) {
    print('[file] decryption failed (null)');
    return null;
  }
  print('[file] decryption succeeded, bytes=${decrypted.length}');

  await outFile.writeAsBytes(decrypted, flush: true);
  print(
    '[file] decrypted file written: ${outFile.path} (${await outFile.length()})',
  );

  try {
    final openResult = await OpenFile.open(outFile.path);
    print('[file] OpenFile result: ${openResult.type} ${openResult.message}');
  } catch (e) {
    print('[file] OpenFile failed: $e');
  }

  return outFile;
}

Future<Uint8List?> _decryptBytesIsolate(List<dynamic> args) async {
  final Uint8List encrypted = args[0] as Uint8List;
  final Uint8List key = args[1] as Uint8List;

  try {
    if (encrypted.length <= 12) {
      print('[isolate] encrypted payload too short: ${encrypted.length}');
      return null;
    }
    final iv = encrypted.sublist(0, 12);
    final cipherAndTag = encrypted.sublist(12);

    if (!(key.length == 16 || key.length == 24 || key.length == 32)) {
      print('[isolate] invalid AES key length: ${key.length}');
      return null;
    }

    final pc.GCMBlockCipher cipher = pc.GCMBlockCipher(pc.AESEngine());
    final params = pc.AEADParameters(
      pc.KeyParameter(key),
      128,
      iv,
      Uint8List(0),
    );
    cipher.init(false, params);

    final out = cipher.process(cipherAndTag);
    return Uint8List.fromList(out);
  } catch (e, st) {
    print('[isolate] decrypt error: $e\n$st');
    return null;
  }
}

Future<T?> showProgressDialog<T>(
  BuildContext context,
  ValueNotifier<int> progress,
) {
  return showDialog<T>(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return ValueListenableBuilder<int>(
        valueListenable: progress,
        builder: (_, value, __) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(value: value / 100),
                const SizedBox(height: 16),
                Text("Downloading... $value%"),
              ],
            ),
          );
        },
      );
    },
  );
}
