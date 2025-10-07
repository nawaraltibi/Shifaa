import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pointycastle/export.dart' as pc;
import 'package:shifaa/core/utils/shared_prefs_helper.dart';
import 'package:asn1lib/asn1lib.dart';

const secureStorage = FlutterSecureStorage();

Future<void> generateKeys() async {
  final sharedPrefs = SharedPrefsHelper.instance;

  if (await sharedPrefs.hasKeys() &&
      await secureStorage.containsKey(key: 'private_key')) {
    print('Keys already exist. No new keys generated.');
    return;
  }

  final rsaKeyGenerator = pc.RSAKeyGenerator();
  final secureRandom = pc.FortunaRandom();
  final seed = Uint8List.fromList(
    List<int>.generate(32, (i) => (DateTime.now().microsecond + i) % 256),
  );
  secureRandom.seed(pc.KeyParameter(seed));

  final rsaParams = pc.RSAKeyGeneratorParameters(
    BigInt.parse('65537'),
    2048,
    64,
  );

  rsaKeyGenerator.init(pc.ParametersWithRandom(rsaParams, secureRandom));
  final keyPair = rsaKeyGenerator.generateKeyPair();

  final pc.RSAPublicKey publicKey = keyPair.publicKey as pc.RSAPublicKey;
  final pc.RSAPrivateKey privateKey = keyPair.privateKey as pc.RSAPrivateKey;

  final String publicKeyPem = encodePublicKeyToPemSpki(publicKey);
  final String privateKeyPem = encodePrivateKeyToPemPKCS1(privateKey);

  await sharedPrefs.savePublicKey(publicKeyPem);
  await secureStorage.write(key: 'private_key', value: privateKeyPem);

  print('✅ New keys generated and saved securely.');
  print('Public Key PEM:\n$publicKeyPem');
  print('Private Key PEM saved securely (not printed)');
}

String encodePublicKeyToPemSpki(pc.RSAPublicKey publicKey) {
  final algorithmSeq = ASN1Sequence();
  final rsaOidBytes = Uint8List.fromList([
    0x2a,
    0x86,
    0x48,
    0x86,
    0xf7,
    0x0d,
    0x01,
    0x01,
    0x01,
  ]);
  algorithmSeq.add(ASN1ObjectIdentifier(rsaOidBytes));
  algorithmSeq.add(ASN1Null());

  final publicKeySeq = ASN1Sequence();
  publicKeySeq.add(ASN1Integer(publicKey.modulus!));
  publicKeySeq.add(ASN1Integer(publicKey.exponent!));

  final publicKeyBitString = ASN1BitString(
    Uint8List.fromList(publicKeySeq.encodedBytes),
  );

  final topLevelSeq = ASN1Sequence();
  topLevelSeq.add(algorithmSeq);
  topLevelSeq.add(publicKeyBitString);

  final dataBase64 = base64.encode(topLevelSeq.encodedBytes);
  return '-----BEGIN PUBLIC KEY-----\n${_chunk64(dataBase64)}\n-----END PUBLIC KEY-----';
}

String encodePrivateKeyToPemPKCS1(pc.RSAPrivateKey privateKey) {
  final topLevel = ASN1Sequence();
  topLevel.add(ASN1Integer(BigInt.from(0)));
  topLevel.add(ASN1Integer(privateKey.n!));
  topLevel.add(ASN1Integer(privateKey.exponent!));
  topLevel.add(ASN1Integer(privateKey.p!));
  topLevel.add(ASN1Integer(privateKey.q!));
  topLevel.add(ASN1Integer(privateKey.d! % (privateKey.p! - BigInt.one)));
  topLevel.add(ASN1Integer(privateKey.d! % (privateKey.q! - BigInt.one)));
  topLevel.add(ASN1Integer(privateKey.q!.modInverse(privateKey.p!)));
  final dataBase64 = base64.encode(topLevel.encodedBytes);
  return '-----BEGIN RSA PRIVATE KEY-----\n${_chunk64(dataBase64)}\n-----END RSA PRIVATE KEY-----';
}

String _chunk64(String str) =>
    RegExp('.{1,64}').allMatches(str).map((m) => m.group(0)).join('\n');
