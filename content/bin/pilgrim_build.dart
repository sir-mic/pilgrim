/// Build tool for Pilgrim content bundles.
///
/// Usage:
///   dart run pilgrim_build keygen
///       Generate a new Ed25519 key pair (private key PEM + prints the
///       base64 public key to embed in the app and admin tool).
///
///   dart run pilgrim_build build [--version N] [--out FILE]
///       Build the signed content bundle from source data, validate it and
///       write content.json (default: build/content.json and the app asset).
library;

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:pilgrim_content/pilgrim_content.dart';

const _defaultPrivateKeyPath = 'keys/private_key.pem';
const _sourcePath = 'source/mcheyne-plan.json';
const _defaultOut = 'build/content.json';
const _appAssetOut = '../app/assets/content/content.json';

Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    _printUsage();
    return;
  }

  switch (args.first) {
    case 'keygen':
      await _keygen();
    case 'build':
      await _build(args.skip(1).toList());
    case 'help':
    case '--help':
      _printUsage();
    default:
      _printUsage();
  }
}

void _printUsage() {
  stdout.writeln('''
Pilgrim content build tool

Usage:
  dart run pilgrim_build keygen
      Generate a new Ed25519 key pair. Writes keys/private_key.pem and
      prints the base64 public key.

  dart run pilgrim_build build [--version N] [--out FILE]
      Build and sign the content bundle from source/mcheyne-plan.json.
      Validates the result and writes content.json.
''');
}

Future<void> _keygen() async {
  final publicKey = await generateKeyPair(_defaultPrivateKeyPath);
  stdout.writeln('Private key written to $_defaultPrivateKeyPath');
  stdout.writeln('Public key (base64):');
  stdout.writeln(base64Encode(publicKey));
}

Future<void> _build(List<String> args) async {
  var version = 1;
  var out = _defaultOut;
  for (var i = 0; i < args.length; i++) {
    switch (args[i]) {
      case '--version':
        version = int.parse(args[++i]);
      case '--out':
        out = args[++i];
    }
  }

  final source = File(_sourcePath);
  if (!source.existsSync()) {
    stderr.writeln('Source file not found: $_sourcePath');
    exitCode = 1;
    return;
  }

  final content = await _buildContent(version);
  validateBundle(content);

  final signature = await signBundle(content, _defaultPrivateKeyPath);
  final bundle = SignedBundle(
    version: version,
    content: content,
    signature: signature,
  );

  final raw = bundle.encode();
  final outFile = File(out);
  await outFile.parent.create(recursive: true);
  await outFile.writeAsString(raw, flush: true);

  // Also ship a copy as the app's bundled asset for offline first-run.
  final assetFile = File(_appAssetOut);
  await assetFile.parent.create(recursive: true);
  await assetFile.writeAsString(raw, flush: true);

  // Verify the written bundle against the public key before declaring success.
  final check = await verifyBundle(bundle, await _publicKey());
  if (!check) {
    stderr.writeln('Bundle verification failed.');
    exitCode = 1;
    return;
  }

  stdout.writeln('Built content bundle v$version:');
  for (final plan in content.plans) {
    stdout.writeln('  ${plan.slug} — ${plan.totalDays} days');
  }
  stdout.writeln('Wrote $out and $_appAssetOut (signed, verified).');
}

Future<BundleContent> _buildContent(int version) async {
  final source = File(_sourcePath).readAsStringSync();
  return buildDefaultBundleContent(
    version,
    mcheyneSourceJson: source,
  );
}

Future<Uint8List> _publicKey() async {
  final privatePem = File(_defaultPrivateKeyPath).readAsStringSync();
  final der = base64Decode(privatePem
      .split('\n')
      .map((l) => l.trim())
      .where((l) => l.isNotEmpty && !l.startsWith('-----'))
      .join());
  final seed = der.sublist(der.length - 32);
  final algorithm = Ed25519();
  final pair = await algorithm.newKeyPairFromSeed(seed);
  final public = await pair.extractPublicKey();
  return Uint8List.fromList(public.bytes);
}
