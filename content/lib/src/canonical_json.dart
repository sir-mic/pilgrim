/// Deterministic JSON encoding for signature purposes.
///
/// Map keys are sorted and no insignificant whitespace is emitted, so the
/// same logical content always produces identical bytes. Both the signer and
/// the verifier must use this encoding.
library;

import 'dart:convert';

String canonicalEncode(Object? value) {
  final buffer = StringBuffer();
  _write(value, buffer);
  return buffer.toString();
}

void _write(Object? value, StringBuffer out) {
  if (value == null) {
    out.write('null');
    return;
  }
  if (value is String) {
    out.write(jsonEncode(value));
    return;
  }
  if (value is num || value is bool) {
    out.write(value.toString());
    return;
  }
  if (value is List) {
    out.write('[');
    for (var i = 0; i < value.length; i++) {
      if (i > 0) out.write(',');
      _write(value[i], out);
    }
    out.write(']');
    return;
  }
  if (value is Map) {
    final entries = value.entries.toList()
      ..sort((a, b) => a.key.toString().compareTo(b.key.toString()));
    out.write('{');
    for (var i = 0; i < entries.length; i++) {
      if (i > 0) out.write(',');
      out.write(jsonEncode(entries[i].key.toString()));
      out.write(':');
      _write(entries[i].value, out);
    }
    out.write('}');
    return;
  }
  throw ArgumentError('Unsupported value: $value');
}
