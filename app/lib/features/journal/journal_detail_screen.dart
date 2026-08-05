import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/data/models.dart';

/// A single journal entry, in full.
class JournalDetailScreen extends StatelessWidget {
  const JournalDetailScreen({super.key, required this.session});

  final SessionEntry session;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final date = DateFormat('EEEE, MMMM d, yyyy').format(session.date);

    return Scaffold(
      appBar: AppBar(title: Text(date)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 16, 28, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final r in session.readings) ...[
                Text(r.display(), style: theme.textTheme.headlineMedium),
                const SizedBox(height: 6),
              ],
              const SizedBox(height: 20),
              if (session.mood != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    session.mood!,
                    style: theme.textTheme.labelMedium
                        ?.copyWith(color: theme.colorScheme.primary),
                  ),
                ),
              const SizedBox(height: 32),
              Text(session.prompt, style: theme.textTheme.titleMedium),
              const SizedBox(height: 10),
              Text(
                session.reflection.isEmpty
                    ? '—'
                    : session.reflection,
                style: theme.textTheme.bodyLarge,
              ),
              if (session.prayer != null) ...[
                const SizedBox(height: 28),
                Text('Prayer', style: theme.textTheme.labelSmall),
                const SizedBox(height: 8),
                Text(
                  session.prayer!,
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(fontStyle: FontStyle.italic),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
