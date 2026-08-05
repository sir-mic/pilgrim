import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pilgrim_content/pilgrim_content.dart';

import '../main.dart';
import 'github_publish.dart';

/// Builds, signs, downloads and publishes content bundles.
class PublishTab extends StatefulWidget {
  const PublishTab({super.key, required this.state});

  final AdminState state;

  @override
  State<PublishTab> createState() => _PublishTabState();
}

class _PublishTabState extends State<PublishTab> {
  final _version = TextEditingController(text: '1');
  final _keyField = TextEditingController();
  final _repo = TextEditingController(text: 'sir-mic/pilgrim');
  final _branch = TextEditingController(text: 'gh-pages');
  final _token = TextEditingController();

  bool _busy = false;
  String? _status;
  bool _statusIsError = false;
  SignedBundle? _bundle;
  String? _publishedInfo;

  @override
  void dispose() {
    for (final c in [_version, _keyField, _repo, _branch, _token]) {
      c.dispose();
    }
    super.dispose();
  }

  int get _versionNumber => int.tryParse(_version.text.trim()) ?? 1;

  Future<void> _run(Future<void> Function() action) async {
    setState(() {
      _busy = true;
      _status = null;
      _statusIsError = false;
    });
    try {
      await action();
    } on Object catch (e) {
      if (mounted) {
        setState(() {
          _status = e.toString();
          _statusIsError = true;
        });
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _setStatus(String message, {bool isError = false}) {
    setState(() {
      _status = message;
      _statusIsError = isError;
    });
  }

  static const manifestUrl = 'https://sir-mic.github.io/pilgrim/content.json';

  Future<void> _fetchPublished() async {
    await _run(() async {
      final response = await http
          .get(Uri.parse(manifestUrl))
          .timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) {
        throw StateError('Published bundle not reachable '
            '(HTTP ${response.statusCode}).');
      }
      final bundle = SignedBundle.decode(response.body);
      final ok = await _verify(bundle);
      _publishedInfo = 'Published v${bundle.version} '
          '(${bundle.content.plans.length} plans, signature $ok).';
      _setStatus('Fetched published bundle v${bundle.version} — '
          'signature ${ok ? 'valid' : 'INVALID'}.');
    });
  }

  Future<bool> _verify(SignedBundle bundle) async {
    try {
      return await verifyBundle(
          bundle, decodePublicKey(AdminState.publicKeyBase64));
    } on Object {
      return false;
    }
  }

  Future<void> _buildAndSign() async {
    await _run(() async {
      final bundle = await widget.state.buildSigned(_versionNumber);
      final ok = await _verify(bundle);
      if (!ok) throw StateError('Verification failed after signing.');
      _bundle = bundle;
      _setStatus('Built and signed v${bundle.version}. '
          'Signature: ${bundle.signature.substring(0, 16)}…');
    });
  }

  Future<void> _download() async {
    final bundle = _bundle;
    if (bundle == null) return;
    await _run(() async {
      final saved = await saveTextFile('content.json', bundle.encode());
      _setStatus(saved ? 'Saved content.json.' : 'Download cancelled.');
    });
  }

  Future<void> _publish() async {
    final bundle = _bundle;
    if (bundle == null) {
      _setStatus('Build and sign the bundle first.', isError: true);
      return;
    }
    final token = _token.text.trim();
    if (token.isEmpty) {
      _setStatus('Enter a GitHub token with contents:write scope.',
          isError: true);
      return;
    }
    await _run(() async {
      final publisher = GitHubPublisher(
        repo: _repo.text.trim(),
        token: token,
        branch: _branch.text.trim(),
      );
      await publisher.publish(
        rawJson: bundle.encode(),
        message: 'content: publish v${bundle.version} bundle',
      );
      _setStatus('Published v${bundle.version} to ${publisher.manifestUrl}');
    });
  }

  Future<void> _pickKey() async {
    final pem = await pickPrivateKey();
    if (pem == null) return;
    setState(() {
      widget.state.privateKeyPem = pem.trim();
      _keyField.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasKey = (widget.state.privateKeyPem ?? '').trim().isNotEmpty;
    final bundle = _bundle;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Publish', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'The private key never leaves this machine and is never stored. '
            'Use the signed JSON for direct deployment or publish it to GitHub '
            'Pages, which the Pilgrim app checks on each launch.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _version,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Bundle version',
                    helperText: 'Must be higher than the current published one.',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: _busy ? null : _fetchPublished,
                icon: const Icon(Icons.cloud_download),
                label: const Text('Fetch published'),
              ),
            ],
          ),
          if (_publishedInfo != null) ...[
            const SizedBox(height: 8),
            Text(_publishedInfo!, style: Theme.of(context).textTheme.bodySmall),
          ],
          const SizedBox(height: 24),

          Text('Signing key', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _keyField,
                  obscureText: true,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    labelText: 'PEM private key (paste)',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) =>
                      widget.state.privateKeyPem = value.trim(),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: _busy ? null : _pickKey,
                icon: const Icon(Icons.key),
                label: const Text('Pick file'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            hasKey ? 'Key loaded (${widget.state.privateKeyPem!.length} chars).'
                   : 'No key loaded yet.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 24),

          FilledButton.icon(
            onPressed: _busy ? null : _buildAndSign,
            icon: const Icon(Icons.build),
            label: const Text('Build & sign'),
          ),
          if (bundle != null) ...[
            const SizedBox(height: 8),
            Text(
              '${bundle.content.plans.length} plans, '
              '${bundle.content.reflectionPrompts.length} prompts, '
              '${bundle.content.notificationMessages.length} messages, '
              '${bundle.encode().length} bytes.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _busy ? null : _download,
              icon: const Icon(Icons.download),
              label: const Text('Download content.json'),
            ),
          ],
          const SizedBox(height: 32),

          Text('GitHub Pages',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _repo,
                  decoration: const InputDecoration(
                    labelText: 'Repository (owner/repo)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _branch,
                  decoration: const InputDecoration(
                    labelText: 'Branch',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _token,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'GitHub token (contents:write)',
              helperText: 'Used only for this request; never stored.',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _busy ? null : _publish,
            icon: const Icon(Icons.rocket_launch),
            label: const Text('Publish to GitHub Pages'),
          ),
          if (_status != null) ...[
            const SizedBox(height: 16),
            Text(
              _status!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: _statusIsError
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.primary,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
