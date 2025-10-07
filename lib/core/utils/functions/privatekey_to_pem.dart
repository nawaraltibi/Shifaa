import 'dart:convert';
import 'package:asn1lib/asn1lib.dart';
import 'package:pointycastle/export.dart' as pointycastle;

String privateKeyToPem(pointycastle.RSAPrivateKey privateKey) {
  final topLevel = ASN1Sequence();

  topLevel.add(ASN1Integer(BigInt.from(0))); // version
  topLevel.add(ASN1Integer(privateKey.n!));
  topLevel.add(ASN1Integer(privateKey.exponent!)); // d
  topLevel.add(ASN1Integer(privateKey.p!));
  topLevel.add(ASN1Integer(privateKey.q!));
  topLevel.add(ASN1Integer(privateKey.d! % (privateKey.p! - BigInt.one)));
  topLevel.add(ASN1Integer(privateKey.d! % (privateKey.q! - BigInt.one)));
  topLevel.add(ASN1Integer(privateKey.q!.modInverse(privateKey.p!)));

  final base64Str = base64.encode(topLevel.encodedBytes);

  final chunks = RegExp(
    '.{1,64}',
  ).allMatches(base64Str).map((m) => m.group(0)).join('\n');

  return '-----BEGIN RSA PRIVATE KEY-----\n$chunks\n-----END RSA PRIVATE KEY-----';
}
