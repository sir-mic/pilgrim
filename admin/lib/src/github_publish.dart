import 'dart:convert';

import 'package:http/http.dart' as http;

/// Thrown when publishing a bundle to GitHub fails.
class PublishException implements Exception {
  PublishException(this.statusCode, this.message);
  final int statusCode;
  final String message;

  @override
  String toString() => 'GitHub API $statusCode: $message';
}

/// Publishes signed bundles to a GitHub Pages repository using the Contents
/// API. The token is a personal access token with `contents:write` scope; it is
/// used only for the HTTP request and never stored.
class GitHubPublisher {
  GitHubPublisher({
    required this.repo,
    required this.token,
    this.branch = 'gh-pages',
    this.path = 'content.json',
    http.Client? client,
  }) : _client = client ?? http.Client();

  static const _api = 'https://api.github.com';

  /// `owner/repo`, e.g. `sir-mic/pilgrim`.
  final String repo;

  /// Fine-grained or classic personal access token.
  final String token;

  /// Branch hosting the Pages site.
  final String branch;

  /// Path of the content bundle inside that branch.
  final String path;

  final http.Client _client;

  Map<String, String> get _headers => {
        'Authorization': 'token $token',
        'Accept': 'application/vnd.github+json',
        'Content-Type': 'application/json',
      };

  /// The public URL the app fetches the bundle from.
  String get manifestUrl {
    final owner = repo.split('/').first;
    final name = repo.split('/').last;
    return 'https://$owner.github.io/$name/$path';
  }

  /// Replaces (or creates) the content bundle on [branch] with [rawJson].
  Future<void> publish({
    required String rawJson,
    required String message,
  }) async {
    final url = '$_api/repos/$repo/contents/$path';

    String? existingSha;
    final getResponse = await _client
        .get(Uri.parse('$url?ref=$branch'), headers: _headers);
    if (getResponse.statusCode == 200) {
      final data = jsonDecode(getResponse.body) as Map<String, dynamic>;
      existingSha = data['sha'] as String?;
    } else if (getResponse.statusCode != 404) {
      throw PublishException(getResponse.statusCode, getResponse.body);
    }

    final body = jsonEncode({
      'message': message,
      'content': base64Encode(utf8.encode(rawJson)),
      'branch': branch,
      'sha': ?existingSha,
    });

    final putResponse = await _client.put(
      Uri.parse(url),
      headers: _headers,
      body: body,
    );
    if (putResponse.statusCode < 200 || putResponse.statusCode >= 300) {
      throw PublishException(putResponse.statusCode, putResponse.body);
    }
  }
}
