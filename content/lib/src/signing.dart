/// Ed25519 signing and verification for content bundles.
///
/// The app embeds the public key (public, safe to ship). The private key is
/// held only by the content maintainer and never enters the app or the admin
/// tool's repository.
library;

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

import 'canonical_json.dart';
import 'models.dart';

const _pemPrivateHeader = '-----BEGIN PRIVATE KEY-----';
const _pemPrivateFooter = '-----END PRIVATE KEY-----';

final Ed25519 _ed25519 = Ed25519();

/// The bytes over which a bundle is signed: the canonical UTF-8 encoding of
/// the bundle content.
Uint8List bundleMessageBytes(BundleContent content) =>
    Uint8List.fromList(utf8.encode(canonicalEncode(content.toJson())));

/// Generates a new Ed25519 key pair and writes the private key as PKCS#8 PEM
/// to [privateKeyPath], returning the raw public key bytes.
Future<Uint8List> generateKeyPair(String privateKeyPath) async {
  final keyPair = await _ed25519.newKeyPair();
  final publicKey = await keyPair.extractPublicKey();
  final privateBytes = await keyPair.extractPrivateKeyBytes();

  final file = File(privateKeyPath);
  await file.parent.create(recursive: true);
  await file.writeAsString(_pkcs8Pem(Uint8List.fromList(privateBytes)),
      flush: true);

  return Uint8List.fromList(publicKey.bytes);
}

/// Signs [content], returning base64 signature text.
Future<String> signBundle(BundleContent content, String privateKeyPath) async {
  final pem = await _readPrivateKey(privateKeyPath);
  return signBundleFromPem(content, pem);
}

/// Signs [content] with a PEM-encoded private key passed as a string.
///
/// Web-safe: does not touch the file system, so the web admin tool can sign
/// from a key picked on the maintainer's machine.
Future<String> signBundleFromPem(BundleContent content, String pem) async {
  final keyPair = await _parsePkcs8(_decodePem(pem));
  final signature =
      await _ed25519.sign(bundleMessageBytes(content), keyPair: keyPair);
  return base64Encode(signature.bytes);
}

/// Verifies [bundle] against [publicKeyBytes], returning true if the signature
/// matches the canonical encoding of the content.
Future<bool> verifyBundle(SignedBundle bundle, Uint8List publicKeyBytes) async {
  final signature = Signature(
    base64Decode(bundle.signature),
    publicKey: SimplePublicKey(publicKeyBytes, type: KeyPairType.ed25519),
  );
  return _ed25519.verify(
    bundleMessageBytes(bundle.content),
    signature: signature,
  );
}

/// Decodes a raw public key from a base64 string.
Uint8List decodePublicKey(String base64) => base64Decode(base64);

String _readPrivateKey(String path) {
  final file = File(path);
  if (!file.existsSync()) {
    throw StateError('Private key not found at $path. '
        'Run: dart run pilgrim_build keygen');
  }
  return file.readAsStringSync();
}

Uint8List _decodePem(String pem) {
  final base64 = pem
      .split('\n')
      .map((l) => l.trim())
      .where((l) => l.isNotEmpty && !l.startsWith('-----'))
      .join();
  return base64Decode(base64);
}

/// Parses a PKCS#8 DER-encoded Ed25519 private key. For Ed25519 the key
/// material is a 32-byte seed, which is the last 32 bytes of the DER body.
Future<SimpleKeyPair> _parsePkcs8(Uint8List der) async {
  final seed = der.sublist(der.length - 32);
  return _ed25519.newKeyPairFromSeed(seed);
}

String _pkcs8Pem(Uint8List privateKeyBytes) {
  final der = _pkcs8Der(privateKeyBytes);
  final base64 = base64Encode(der);
  return '$_pemPrivateHeader\n$base64\n$_pemPrivateFooter\n';
}

Uint8List _pkcs8Der(Uint8List seed) {
  // PKCS#8: SEQUENCE { INTEGER 0, SEQUENCE { OID 1.3.101.112 }, OCTET
  // STRING { OCTET STRING seed } }
  final oidEd25519 = <int>[0x2B, 0x65, 0x70];
  final algId = <int>[0x30, 0x05, 0x06, 0x03, ...oidEd25519];
  final version = <int>[0x02, 0x01, 0x00];
  final inner = <int>[0x04, seed.length, ...seed];
  final wrapped = <int>[0x04, inner.length, ...inner];
  final body = [...version, ...algId, ...wrapped];
  return Uint8List.fromList([0x30, body.length, ...body]);
}
