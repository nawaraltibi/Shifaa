import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pointycastle/export.dart' as pc;
import 'package:shifaa/core/utils/shared_prefs_helper.dart';
import 'package:asn1lib/asn1lib.dart';
import 'dart:math';

const _secureStorage = FlutterSecureStorage();

pc.AsymmetricKeyPair<pc.RSAPublicKey, pc.RSAPrivateKey> _generateRsaKeyPair() {
  final secureRandom = E2EE._getSecureRandom();
  final rsaParams = pc.RSAKeyGeneratorParameters(
    BigInt.parse('65537'),
    2048,
    64,
  );
  final params = pc.ParametersWithRandom(rsaParams, secureRandom);
  final keyGen = pc.RSAKeyGenerator()..init(params);
  final pair = keyGen.generateKeyPair();
  return pc.AsymmetricKeyPair<pc.RSAPublicKey, pc.RSAPrivateKey>(
    pair.publicKey as pc.RSAPublicKey,
    pair.privateKey as pc.RSAPrivateKey,
  );
}

String _encodePublicKeyToPem(pc.RSAPublicKey key) {
  final topLevelSeq = ASN1Sequence();
  topLevelSeq.add(ASN1Integer(key.modulus!));
  topLevelSeq.add(ASN1Integer(key.exponent!));
  final dataBase64 = base64.encode(topLevelSeq.encodedBytes);
  return "-----BEGIN RSA PUBLIC KEY-----\n${_chunk64(dataBase64)}\n-----END RSA PUBLIC KEY-----";
}

String _encodePrivateKeyToPem(pc.RSAPrivateKey key) {
  final topLevelSeq = ASN1Sequence();
  final version = ASN1Integer(BigInt.from(0));
  topLevelSeq.add(version);
  topLevelSeq.add(ASN1Integer(key.n!));
  topLevelSeq.add(ASN1Integer(key.exponent!));
  topLevelSeq.add(ASN1Integer(key.d!));
  topLevelSeq.add(ASN1Integer(key.p!));
  topLevelSeq.add(ASN1Integer(key.q!));
  topLevelSeq.add(ASN1Integer(key.d! % (key.p! - BigInt.one)));
  topLevelSeq.add(ASN1Integer(key.d! % (key.q! - BigInt.one)));
  topLevelSeq.add(ASN1Integer(key.q!.modInverse(key.p!)));
  final dataBase64 = base64.encode(topLevelSeq.encodedBytes);
  return "-----BEGIN RSA PRIVATE KEY-----\n${_chunk64(dataBase64)}\n-----END RSA PRIVATE KEY-----";
}

String _chunk64(String str) {
  return RegExp(r'.{1,64}').allMatches(str).map((m) => m.group(0)!).join('\n');
}

Future<void> generateAndSaveKeys() async {
  final sharedPrefs = SharedPrefsHelper.instance;
  if (await sharedPrefs.hasKeys() &&
      await _secureStorage.containsKey(key: 'privateKey'))
    return;
  final keyPair = _generateRsaKeyPair();
  final publicKeyPem = _encodePublicKeyToPem(keyPair.publicKey);
  final privateKeyPem = _encodePrivateKeyToPem(keyPair.privateKey);
  await sharedPrefs.savePublicKey(publicKeyPem);
  await _secureStorage.write(key: 'privateKey', value: privateKeyPem);
}

class E2EE {
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
      return null;
    }
  }

  static pc.RSAPrivateKey parsePrivateKeyFromPem(String pem) {
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
    if (topLevel.elements != null &&
        topLevel.elements!.length >= 2 &&
        topLevel.elements![1] is ASN1OctetString) {
      final octet = topLevel.elements![1] as ASN1OctetString;
      final inner = ASN1Parser(octet.octets!);
      privSeq = inner.nextObject() as ASN1Sequence;
    } else {
      privSeq = topLevel;
    }
    final elems = privSeq.elements!;
    final modulus = (elems[1] as ASN1Integer).valueAsBigInteger!;
    final privateExponent = (elems[3] as ASN1Integer).valueAsBigInteger!;
    final p = (elems[4] as ASN1Integer).valueAsBigInteger!;
    final q = (elems[5] as ASN1Integer).valueAsBigInteger!;
    return pc.RSAPrivateKey(modulus, privateExponent, p, q);
  }

  static pc.RSAPublicKey parsePublicKeyFromPem(String pem) {
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
    if (topLevelSeq.elements != null &&
        topLevelSeq.elements!.isNotEmpty &&
        topLevelSeq.elements![0] is ASN1Sequence) {
      final bitString = topLevelSeq.elements![1] as ASN1BitString;
      final publicKeyParser = ASN1Parser(bitString.contentBytes()!);
      publicKeySeq = publicKeyParser.nextObject() as ASN1Sequence;
    } else {
      publicKeySeq = topLevelSeq;
    }
    final modulus =
        (publicKeySeq.elements![0] as ASN1Integer).valueAsBigInteger!;
    final exponent =
        (publicKeySeq.elements![1] as ASN1Integer).valueAsBigInteger!;
    return pc.RSAPublicKey(modulus, exponent);
  }

  static pc.SecureRandom _getSecureRandom() {
    final secureRandom = pc.FortunaRandom();
    final seed = Uint8List.fromList(
      List<int>.generate(32, (_) => Random.secure().nextInt(256)),
    );
    secureRandom.seed(pc.KeyParameter(seed));
    return secureRandom;
  }

  static Future<pc.RSAPrivateKey?> loadPrivateKeyFromSecureStorage() async {
    final pem = await _secureStorage.read(key: 'privateKey');
    if (pem == null) return null;
    try {
      return parsePrivateKeyFromPem(pem);
    } catch (e) {
      return null;
    }
  }

  static Uint8List rsaEncryptForPublicOAEP(
    pc.RSAPublicKey pub,
    Uint8List data,
  ) {
    final engine = pc.OAEPEncoding(pc.RSAEngine())
      ..init(true, pc.PublicKeyParameter<pc.RSAPublicKey>(pub));
    return _processInBlocks(engine, data);
  }

  static Uint8List rsaDecryptWithPrivateOAEP(
    pc.RSAPrivateKey priv,
    Uint8List cipher,
  ) {
    final engine = pc.OAEPEncoding(pc.RSAEngine())
      ..init(false, pc.PrivateKeyParameter<pc.RSAPrivateKey>(priv));
    return _processInBlocks(engine, cipher);
  }

  static Uint8List _processInBlocks(
    pc.AsymmetricBlockCipher engine,
    Uint8List input,
  ) {
    final output = <int>[];
    final inputLen = input.length;
    final inBlock = engine.inputBlockSize;
    var offset = 0;
    while (offset < inputLen) {
      final chunkEnd = (offset + inBlock < inputLen)
          ? offset + inBlock
          : inputLen;
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
      } catch (e) {}
    });
    return list;
  }
}
