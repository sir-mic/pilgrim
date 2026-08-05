import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:file_picker/file_picker.dart';
import 'package:pilgrim_content/pilgrim_content.dart';

import 'src/copy_tab.dart';
import 'src/plans_tab.dart';
import 'src/publish_tab.dart';

void main() => runApp(const PilgrimAdminApp());

/// Maintainer-facing editor and publisher for signed Pilgrim content bundles.
class PilgrimAdminApp extends StatelessWidget {
  const PilgrimAdminApp({super.key, this.state});

  /// Preloaded state, used by tests to avoid loading the source asset.
  final AdminState? state;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pilgrim Admin',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8A9A5B)),
        useMaterial3: true,
      ),
      home: AdminShell(state: state),
    );
  }
}

/// A single editable plan: the day schedule is immutable, but the marketing
/// copy (title and description) can change per bundle.
class PlanEdit {
  PlanEdit({
    required this.slug,
    required this.kind,
    required this.days,
    required this.title,
    required this.description,
  });

  final String slug;
  final String kind;
  final List<PlanDay> days;
  String title;
  String description;

  int get totalDays => days.length;

  PlanDefinition toDefinition() => PlanDefinition(
        slug: slug,
        title: title,
        description: description,
        kind: kind,
        days: days,
      );
}

class AdminState extends ChangeNotifier {
  AdminState();

  static const publicKeyBase64 = '9Par+fcD5gQ8dcs1htkkhXjbJTXdYgCL8DYzsQvVYQ=';

  String? mcheyneSource;
  String? loadError;
  List<PlanEdit> plans = [];
  List<String> prompts = [];
  List<String> messages = [];
  int version = 1;
  String? privateKeyPem;

  /// Loads the M'Cheyne source asset and populates the default bundle copy.
  Future<void> loadDefaults() async {
    try {
      mcheyneSource = await rootBundle.loadString('assets/mcheyne-plan.json');
      final content = buildDefaultBundleContent(
        version,
        mcheyneSourceJson: mcheyneSource!,
      );
      applyContent(content);
    } on Object catch (e) {
      loadError = e.toString();
      notifyListeners();
    }
  }

  void applyContent(BundleContent content) {
    plans = content.plans
        .map((p) => PlanEdit(
              slug: p.slug,
              kind: p.kind,
              days: p.days,
              title: p.title,
              description: p.description,
            ))
        .toList();
    prompts = List.of(content.reflectionPrompts);
    messages = List.of(content.notificationMessages);
    notifyListeners();
  }

  /// Rebuilds the default plans and copy from scratch, discarding edits.
  void resetDefaults() {
    if (mcheyneSource == null) return;
    applyContent(buildDefaultBundleContent(
      version,
      mcheyneSourceJson: mcheyneSource!,
    ));
  }

  /// Builds the bundle content for [version], validates it, signs it with the
  /// loaded private key and verifies the signature against the embedded public
  /// key. Returns the signed, verified bundle or throws.
  Future<SignedBundle> buildSigned(int version) async {
    final key = privateKeyPem;
    if (key == null || key.trim().isEmpty) {
      throw StateError('Load the private key first.');
    }
    final content = BundleContent(
      plans: plans.map((p) => p.toDefinition()).toList(),
      reflectionPrompts: prompts
          .map((p) => p.trim())
          .where((p) => p.isNotEmpty)
          .toList(),
      notificationMessages: messages
          .map((m) => m.trim())
          .where((m) => m.isNotEmpty)
          .toList(),
    );
    validateBundle(content);
    final signature = await signBundleFromPem(content, key);
    final bundle = SignedBundle(
      version: version,
      content: content,
      signature: signature,
    );
    final ok = await verifyBundle(bundle, decodePublicKey(publicKeyBase64));
    if (!ok) throw StateError('Signature verification failed.');
    return bundle;
  }
}

class AdminShell extends StatefulWidget {
  const AdminShell({super.key, this.state});

  /// Optional preloaded state; when omitted the shell loads defaults itself.
  final AdminState? state;

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  late final AdminState _state;
  int _index = 0;
  static const _icons = [Icons.menu_book, Icons.edit_note, Icons.rocket_launch];
  static const _titles = ['Content', 'Copy', 'Publish'];

  @override
  void initState() {
    super.initState();
    _state = widget.state ?? AdminState();
    if (widget.state == null) {
      _state.loadDefaults();
    }
  }

  @override
  void dispose() {
    if (widget.state == null) {
      _state.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilgrim Admin'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'Public key: ${AdminState.publicKeyBase64}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _state,
        builder: (context, _) {
          if (_state.loadError != null) {
            return Center(child: Text('Failed to load: ${_state.loadError}'));
          }
          if (_state.plans.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return Row(
            children: [
              NavigationRail(
                selectedIndex: _index,
                onDestinationSelected: (i) => setState(() => _index = i),
                labelType: NavigationRailLabelType.all,
                destinations: [
                  for (var i = 0; i < _titles.length; i++)
                    NavigationRailDestination(
                      icon: Icon(_icons[i]),
                      label: Text(_titles[i]),
                    ),
                ],
              ),
              const VerticalDivider(width: 1),
              Expanded(
                child: IndexedStack(
                  index: _index,
                  children: [
                    PlansTab(state: _state),
                    CopyTab(state: _state),
                    PublishTab(state: _state),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Picks a PEM private key file and returns its text, or null if cancelled.
Future<String?> pickPrivateKey() async {
  final result = await FilePicker.pickFiles(withData: true);
  if (result == null || result.files.isEmpty) return null;
  final bytes = result.files.single.bytes;
  if (bytes == null) return null;
  return String.fromCharCodes(bytes);
}

/// Saves [text] as a file download through the browser.
Future<bool> saveTextFile(String fileName, String text) async {
  final path = await FilePicker.saveFile(
    dialogTitle: 'Save content bundle',
    fileName: fileName,
    type: FileType.custom,
    allowedExtensions: ['json'],
    bytes: Uint8List.fromList(text.codeUnits),
  );
  return path != null && path.isNotEmpty;
}
