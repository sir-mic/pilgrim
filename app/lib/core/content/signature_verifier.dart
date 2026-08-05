import 'dart:convert';
import 'dart:typed_data';

import 'package:pilgrim_content/pilgrim_content.dart';

/// Verifies signed content bundles using the embedded Ed25519 public key.
///
/// The private key lives only with the content maintainer; the public key is
/// safe to ship in the app.
class BundleVerifier {
  BundleVerifier({Uint8List? publicKey})
      : publicKey =
            publicKey ?? Uint8List.fromList(base64Decode(publicKeyBase64));

  static const publicKeyBase64 = '9ParZ+fcD5gQ8dcs1htkkhXjbJTXdYgCL8DYzsQvVYQ=';

  final Uint8List publicKey;

  Future<bool> verify(SignedBundle bundle) => verifyBundle(bundle, publicKey);
}

/// Helper for the admin tool and tests to construct a verifier from raw bytes.
BundleVerifier verifierFromBytes(Uint8List publicKeyBytes) =>
    BundleVerifier(publicKey: publicKeyBytes);
