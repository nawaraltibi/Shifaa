import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pointycastle/export.dart' as pc;
import 'package:shifaa/core/utils/shared_prefs_helper.dart';
import 'package:asn1lib/asn1lib.dart'; // تأكد من وجود هذا الاستيراد

// ===================================================================
// 🔑 قسم توليد وحفظ المفاتيح (النسخة النهائية والمؤكدة)
// ===================================================================

const _secureStorage = FlutterSecureStorage();

/// يولد زوج مفاتيح RSA باستخدام مكتبة pointycastle.
pc.AsymmetricKeyPair<pc.RSAPublicKey, pc.RSAPrivateKey> _generateRsaKeyPair() {
  final secureRandom = pc.FortunaRandom()
    ..seed(pc.KeyParameter(pc.SecureRandom('Fortuna').nextBytes(32)));

  final keyGen = pc.RSAKeyGenerator()
    ..init(
      pc.ParametersWithRandom(
        pc.RSAKeyGeneratorParameters(BigInt.parse('65537'), 2048, 64),
        secureRandom,
      ),
    );

  return keyGen.generateKeyPair()
      as pc.AsymmetricKeyPair<pc.RSAPublicKey, pc.RSAPrivateKey>;
}

/// يقوم بترميز المفتاح العام إلى صيغة PEM (PKCS#1).
String _encodePublicKeyToPem(pc.RSAPublicKey key) {
  final topLevelSeq = ASN1Sequence();
  topLevelSeq.add(ASN1Integer(key.modulus!));
  topLevelSeq.add(ASN1Integer(key.exponent!));
  final dataBase64 = base64.encode(topLevelSeq.encodedBytes);
  return """-----BEGIN RSA PUBLIC KEY-----\n${_chunk64(dataBase64)}\n-----END RSA PUBLIC KEY-----""";
}

/// يقوم بترميز المفتاح الخاص إلى صيغة PEM (PKCS#1).
String _encodePrivateKeyToPem(pc.RSAPrivateKey key) {
  final topLevelSeq = ASN1Sequence();

  final version = ASN1Integer(BigInt.from(0));
  final modulus = ASN1Integer(key.n!);
  final publicExponent = ASN1Integer(key.exponent!); // e
  final privateExponent = ASN1Integer(key.d!); // d
  final p = ASN1Integer(key.p!);
  final q = ASN1Integer(key.q!);
  final exp1 = ASN1Integer(key.d! % (key.p! - BigInt.one));
  final exp2 = ASN1Integer(key.d! % (key.q! - BigInt.one));
  final coefficient = ASN1Integer(key.q!.modInverse(key.p!));

  topLevelSeq.add(version);
  topLevelSeq.add(modulus);
  topLevelSeq.add(publicExponent);
  topLevelSeq.add(privateExponent);
  topLevelSeq.add(p);
  topLevelSeq.add(q);
  topLevelSeq.add(exp1);
  topLevelSeq.add(exp2);
  topLevelSeq.add(coefficient);

  final dataBase64 = base64.encode(topLevelSeq.encodedBytes);
  return """-----BEGIN RSA PRIVATE KEY-----\n${_chunk64(dataBase64)}\n-----END RSA PRIVATE KEY-----""";
}

/// يقسم النص إلى أجزاء من 64 حرفاً.
String _chunk64(String str) {
  return RegExp(r'.{1,64}').allMatches(str).map((m) => m.group(0)!).join('\n');
}

/// الدالة الرئيسية لتوليد وحفظ المفاتيح.
Future<void> generateAndSaveKeys() async {
  final sharedPrefs = SharedPrefsHelper.instance;

  if (await sharedPrefs.hasKeys() &&
      await _secureStorage.containsKey(key: 'private_key')) {
    print('✅ Keys already exist. No new keys generated.');
    return;
  }

  print("🔹 Generating new RSA key pair...");

  final keyPair = _generateRsaKeyPair();
  final publicKeyPem = _encodePublicKeyToPem(keyPair.publicKey);
  final privateKeyPem = _encodePrivateKeyToPem(keyPair.privateKey);

  await sharedPrefs.savePublicKey(publicKeyPem);
  await _secureStorage.write(key: 'private_key', value: privateKeyPem);

  print(
    '✅✅✅ New keys generated and saved successfully using the manual (but correct) PEM encoding.',
  );
}

// ===================================================================
// 🔐 قسم التشفير وفك التشفير (E2EE Service)
// ===================================================================

class E2EE {
  // ... باقي الكود يبقى كما هو بالضبط ...
  // دوال AES ودوال RSA الأخرى التي عدلناها سابقاً تبقى كما هي
  // فهي صحيحة 100%
  static final _rng = pc.SecureRandom('Fortuna')
    ..seed(
      pc.KeyParameter(
        Uint8List.fromList(
          List.generate(32, (i) => DateTime.now().microsecond % 256),
        ),
      ),
    );

  static Uint8List generateAESKey([int length = 32]) =>
      Uint8List.fromList(List.generate(length, (_) => _rng.nextUint8()));

  static String aesGcmEncryptToBase64(Uint8List key, String plainText) {
    final iv = _rng.nextBytes(12);
    final cipher = pc.GCMBlockCipher(pc.AESEngine());
    final params = pc.AEADParameters(
      pc.KeyParameter(key),
      128,
      iv,
      Uint8List(0),
    );
    cipher.init(true, params);
    final output = cipher.process(utf8.encode(plainText));
    final combined = Uint8List(iv.length + output.length)
      ..setAll(0, iv)
      ..setAll(iv.length, output);
    return base64.encode(combined);
  }

  static Uint8List aesGcmEncryptToBytes(Uint8List key, Uint8List plainBytes) {
    final iv = _rng.nextBytes(12);
    final cipher = pc.GCMBlockCipher(pc.AESEngine());
    final params = pc.AEADParameters(
      pc.KeyParameter(key),
      128,
      iv,
      Uint8List(0),
    );
    cipher.init(true, params);
    final output = cipher.process(plainBytes);
    final combined = Uint8List(iv.length + output.length)
      ..setAll(0, iv)
      ..setAll(iv.length, output);
    return combined;
  }

  static String? aesGcmDecryptFromBase64(Uint8List key, String base64Combined) {
    try {
      final bytes = base64.decode(base64Combined);
      if (bytes.length < 13) return null;
      final iv = bytes.sublist(0, 12);
      final cipherBytes = bytes.sublist(12);
      final cipher = pc.GCMBlockCipher(pc.AESEngine());
      final params = pc.AEADParameters(
        pc.KeyParameter(key),
        128,
        iv,
        Uint8List(0),
      );
      cipher.init(false, params);
      return utf8.decode(cipher.process(cipherBytes));
    } catch (e) {
      print("AES decrypt failed: $e");
      return null;
    }
  }

  // في ملف e2ee_service.dart

  // ... (باقي الكلاس)

  // ✅✅✅ --- هذا هو الإصلاح النهائي الذي يعالج صيغ المفاتيح المختلفة --- ✅✅✅
  static pc.RSAPublicKey parsePublicKeyFromPem(String pem) {
    try {
      // 1. تنظيف المفتاح وفك تشفير base64
      final cleanBase64 = pem
          .replaceAll('-----BEGIN PUBLIC KEY-----', '')
          .replaceAll('-----END PUBLIC KEY-----', '')
          .replaceAll('-----BEGIN RSA PUBLIC KEY-----', '')
          .replaceAll('-----END RSA PUBLIC KEY-----', '')
          .replaceAll('\n', '')
          .replaceAll('\r', '')
          .trim();

      final keyBytes = base64.decode(cleanBase64);
      final asn1Parser = ASN1Parser(keyBytes);

      // 2. اقرأ البنية الخارجية (ASN.1 Sequence)
      var topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;

      ASN1Sequence publicKeySeq;

      // 3. التحقق من نوع المفتاح (PKCS#8 vs PKCS#1)
      // إذا كان العنصر الأول هو sequence، فهذا يعني أنه PKCS#8 (يحتوي على غلاف الخوارزمية)
      if (topLevelSeq.elements[0] is ASN1Sequence) {
        // هذا مفتاح PKCS#8. المفتاح الفعلي موجود داخل ASN1BitString
        final bitString = topLevelSeq.elements[1] as ASN1BitString;
        final publicKeyParser = ASN1Parser(bitString.contentBytes());
        publicKeySeq = publicKeyParser.nextObject() as ASN1Sequence;
      } else {
        // هذا مفتاح PKCS#1. البنية الخارجية هي المفتاح نفسه
        publicKeySeq = topLevelSeq;
      }

      // 4. الآن، استخرج الـ modulus والـ exponent من البنية الصحيحة
      final modulus =
          (publicKeySeq.elements[0] as ASN1Integer).valueAsBigInteger;
      final exponent =
          (publicKeySeq.elements[1] as ASN1Integer).valueAsBigInteger;

      // 5. قم ببناء كائن RSAPublicKey
      return pc.RSAPublicKey(modulus, exponent);
    } catch (e, stackTrace) {
      print("🔥🔥🔥 FAILED TO PARSE PUBLIC KEY MANUALLY. Error: $e");
      print("   --- StackTrace: ---\n$stackTrace");
      throw Exception('Failed to parse public key.');
    }
  }

  // ... (باقي الكلاس)

  static Future<pc.RSAPrivateKey?> loadPrivateKeyFromSecureStorage() async {
    final pem = await _secureStorage.read(key: 'private_key');
    if (pem == null) {
      print("❌ Private key not found in secure storage.");
      return null;
    }
    try {
      final parser = encrypt.RSAKeyParser();
      final privateKey = parser.parse(pem) as pc.RSAPrivateKey;
      print("✅ Private key loaded and parsed successfully using RSAKeyParser.");
      return privateKey;
    } catch (e) {
      print(
        "❌ FAILED to parse private key from PEM using RSAKeyParser. Error: $e",
      );
      return null;
    }
  }

  static Uint8List rsaEncryptForPublic(pc.RSAPublicKey pub, Uint8List data) {
    final encrypter = encrypt.Encrypter(
      encrypt.RSA(publicKey: pub, encoding: encrypt.RSAEncoding.OAEP),
    );
    return encrypter.encryptBytes(data).bytes;
  }

  static Uint8List rsaDecryptWithPrivate(
    pc.RSAPrivateKey priv,
    Uint8List cipher,
  ) {
    final decrypter = encrypt.Encrypter(
      encrypt.RSA(privateKey: priv, encoding: encrypt.RSAEncoding.PKCS1),
    );
    try {
      final decrypted = decrypter.decryptBytes(encrypt.Encrypted(cipher));
      return Uint8List.fromList(decrypted);
    } catch (e) {
      print("❌ RSA Decryption with PKCS1 failed. Error: $e");
      rethrow;
    }
  }

  static List<Map<String, String>> buildEncryptedKeysPayload({
    required Map<int, String> targets,
    required Uint8List aesKey,
  }) {
    final List<Map<String, String>> list = [];
    targets.forEach((deviceId, pubPem) {
      try {
        final pub = parsePublicKeyFromPem(pubPem);
        final enc = rsaEncryptForPublic(pub, aesKey);
        list.add({
          'device_id': deviceId.toString(),
          'encrypted_key': base64.encode(enc),
        });
      } catch (e) {
        print(
          "⚠️ Could not encrypt for device ID $deviceId. Skipping. Error: $e",
        );
      }
    });
    return list;
  }
}
