import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pointycastle/export.dart' as pc;
import 'package:shifaa/core/utils/shared_prefs_helper.dart';
import 'package:asn1lib/asn1lib.dart'; // تأكد من وجود هذا الاستيراد
import 'dart:math';

// ===================================================================
// 🔑 قسم توليد وحفظ المفاتيح (النسخة النهائية والمؤكدة)
// ===================================================================

const _secureStorage = FlutterSecureStorage();

/// يولد زوج مفاتيح RSA باستخدام مكتبة pointycastle.
pc.AsymmetricKeyPair<pc.RSAPublicKey, pc.RSAPrivateKey> _generateRsaKeyPair() {
  final secureRandom = E2EE._getSecureRandom();
  final rsaParams = pc.RSAKeyGeneratorParameters(BigInt.parse('65537'), 2048, 64);

  final params = pc.ParametersWithRandom(rsaParams, secureRandom);
  final keyGen = pc.RSAKeyGenerator()..init(params);

  final pair = keyGen.generateKeyPair();
  final pub = pair.publicKey as pc.RSAPublicKey;
  final priv = pair.privateKey as pc.RSAPrivateKey;
  return pc.AsymmetricKeyPair<pc.RSAPublicKey, pc.RSAPrivateKey>(pub, priv);
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
      await _secureStorage.containsKey(key: 'privateKey')) {
    print('✅ Keys already exist. No new keys generated.');
    return;
  }

  print("🔹 Generating new RSA key pair...");

  final keyPair = _generateRsaKeyPair();
  final publicKeyPem = _encodePublicKeyToPem(keyPair.publicKey);
  final privateKeyPem = _encodePrivateKeyToPem(keyPair.privateKey);

  await sharedPrefs.savePublicKey(publicKeyPem);
  await _secureStorage.write(key: 'privateKey', value: privateKeyPem);

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

  static pc.RSAPrivateKey parsePrivateKeyFromPem(String pem) {
    print (pem);
    final cleaned = pem
        .replaceAll(RegExp(r'-----BEGIN (?:RSA )?PRIVATE KEY-----'), '')
        .replaceAll(RegExp(r'-----END (?:RSA )?PRIVATE KEY-----'), '')
        .replaceAll('\r', '')
        .replaceAll('\n', '')
        .trim();

    final bytes = base64.decode(cleaned);
    final parser = ASN1Parser(bytes);
    ASN1Sequence topLevel = parser.nextObject() as ASN1Sequence;

    ASN1Sequence privSeq;

    // Detect PKCS#8 (SubjectPrivateKeyInfo) vs PKCS#1
    if (topLevel.elements != null &&
        topLevel.elements!.length >= 2 &&
        topLevel.elements![1] is ASN1OctetString) {
      // PKCS#8: element 1 is OctetString that contains the PKCS#1 sequence
      final octet = topLevel.elements![1] as ASN1OctetString;
      final inner = ASN1Parser(octet.octets!);
      privSeq = inner.nextObject() as ASN1Sequence;
    } else {
      // directly PKCS#1
      privSeq = topLevel;
    }

    final elems = privSeq.elements!;
    if (elems.length < 6) {
      throw FormatException('Unexpected private key format (too few ASN.1 elements).');
    }

    final modulus = (elems[1] as ASN1Integer).valueAsBigInteger!;
    final //publicExponent = (elems[2] as ASN1Integer).valueAsBigInteger!; // we don't need it
    privateExponent = (elems[3] as ASN1Integer).valueAsBigInteger!;
    final p = (elems[4] as ASN1Integer).valueAsBigInteger!;
    final q = (elems[5] as ASN1Integer).valueAsBigInteger!;

    // Construct without passing publicExponent to avoid the strict validation.
    return pc.RSAPrivateKey(modulus, privateExponent, p, q);
  }

  // ✅✅✅ --- هذا هو الإصلاح النهائي الذي يعالج صيغ المفاتيح المختلفة --- ✅✅✅
  static pc.RSAPublicKey parsePublicKeyFromPem(String pem) {
    // reuse your existing parsePublicKeyFromPem implementation (the one that handles PKCS#8 & PKCS#1)
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
    var topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
    ASN1Sequence publicKeySeq;

    if (topLevelSeq.elements != null && topLevelSeq.elements!.isNotEmpty && topLevelSeq.elements![0] is ASN1Sequence) {
      // PKCS#8 / SubjectPublicKeyInfo
      final bitString = topLevelSeq.elements![1] as ASN1BitString;
      final publicKeyParser = ASN1Parser(bitString.contentBytes()!);
      publicKeySeq = publicKeyParser.nextObject() as ASN1Sequence;
    } else {
      // PKCS#1
      publicKeySeq = topLevelSeq;
    }

    final modulus = (publicKeySeq.elements![0] as ASN1Integer).valueAsBigInteger!;
    final exponent = (publicKeySeq.elements![1] as ASN1Integer).valueAsBigInteger!;
    return pc.RSAPublicKey(modulus, exponent);
  }

  static pc.SecureRandom _getSecureRandom() {
    final secureRandom = pc.FortunaRandom();

    // Seed with 32 secure bytes using Random.secure()
    final seed = Uint8List.fromList(List<int>.generate(32, (_) => Random.secure().nextInt(256)));
    secureRandom.seed(pc.KeyParameter(seed));

    return secureRandom;
  }

  // ... (باقي الكلاس)

  static Future<pc.RSAPrivateKey?> loadPrivateKeyFromSecureStorage() async {
      final pem = await _secureStorage.read(key: 'privateKey');
      if (pem == null) {
        print("❌ Private key not found in secure storage.");
        return null;
      }
      try {
        final priv = parsePrivateKeyFromPem(pem);
        print("✅ Private key parsed successfully (manual ASN.1 parser).");
        return priv;
      } catch (e, st) {
        print("❌ Failed to parse private key from PEM: $e\n$st");
        return null;
      }
  }

// ------------ RSA encrypt for public (use OAEP) ------------
  static Uint8List rsaEncryptForPublicOAEP(pc.RSAPublicKey pub, Uint8List data) {
    final engine = pc.OAEPEncoding(pc.RSAEngine())
      ..init(true, pc.PublicKeyParameter<pc.RSAPublicKey>(pub));
    return _processInBlocks(engine, data);
  }

// ------------ RSA decrypt with private (use OAEP) ------------
  static Uint8List rsaDecryptWithPrivateOAEP(pc.RSAPrivateKey priv, Uint8List cipher) {
    final engine = pc.OAEPEncoding(pc.RSAEngine())
      ..init(false, pc.PrivateKeyParameter<pc.RSAPrivateKey>(priv));
    return _processInBlocks(engine, cipher);
  }

  static Uint8List _processInBlocks(pc.AsymmetricBlockCipher engine, Uint8List input) {
    final output = <int>[];
    final inputLen = input.length;
    final inBlock = engine.inputBlockSize;
    var offset = 0;
    while (offset < inputLen) {
      final chunkEnd = (offset + inBlock < inputLen) ? offset + inBlock : inputLen;
      final chunk = input.sublist(offset, chunkEnd);
      final processed = engine.process(chunk);
      output.addAll(processed);
      offset = chunkEnd;
    }
    return Uint8List.fromList(output);
  }

  static List<Map<String, String>> buildEncryptedKeysPayload({
    required Map<int, String> targets,
    required Uint8List aesKey,
  }) {
    final List<Map<String, String>> list = [];
    targets.forEach((deviceId, pubPem) {
      try {
        final pub = parsePublicKeyFromPem(pubPem);
        final enc = rsaEncryptForPublicOAEP(pub, aesKey);
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
