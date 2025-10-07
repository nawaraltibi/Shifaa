import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:asn1lib/asn1lib.dart';
import 'package:pointycastle/export.dart' as pointycastle;

const secureStorage = FlutterSecureStorage();

Future<pointycastle.RSAPrivateKey?> getPrivateKey() async {
  final privateKeyPem = await secureStorage.read(key: 'private_key');
  if (privateKeyPem == null) return null;

  return _parsePrivateKeyFromPem(privateKeyPem);
}

pointycastle.RSAPrivateKey _parsePrivateKeyFromPem(String pem) {
  final base64Str = pem
      .replaceAll('-----BEGIN RSA PRIVATE KEY-----', '')
      .replaceAll('-----END RSA PRIVATE KEY-----', '')
      .replaceAll('\n', '')
      .trim();

  final bytes = base64.decode(base64Str);
  final asn1Parser = ASN1Parser(bytes);
  final topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;

  final version = (topLevelSeq.elements[0] as ASN1Integer).valueAsBigInteger;
  final n = (topLevelSeq.elements[1] as ASN1Integer).valueAsBigInteger;
  final e = (topLevelSeq.elements[2] as ASN1Integer).valueAsBigInteger;
  final d = (topLevelSeq.elements[3] as ASN1Integer).valueAsBigInteger;
  final p = (topLevelSeq.elements[4] as ASN1Integer).valueAsBigInteger;
  final q = (topLevelSeq.elements[5] as ASN1Integer).valueAsBigInteger;

  final modulus = p * q;

  return pointycastle.RSAPrivateKey(modulus, d, p, q);
}
