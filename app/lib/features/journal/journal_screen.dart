import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/data/models.dart';
import '../../core/providers.dart';
import '../../core/widgets/fade_route.dart';
import 'journal_detail_screen.dart';

/// The journal: a searchable timeline of the user's walk.
class JournalScreen extends ConsumerStatefulWidget {
  const JournalScreen({super.key});

  @override
  ConsumerState<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends ConsumerState<JournalScreen> {
  final TextEditingController _search = TextEditingController();
  String _query = '';
  List<SessionEntry>? _results;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sessions = ref.watch(journalProvider);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 32, 28, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Journal', style: theme.textTheme.displaySmall),
                const SizedBox(height: 18),
                TextField(
                  controller: _search,
                  onChanged: (value) async {
                    setState(() => _query = value);
                    if (value.trim().isEmpty) {
                      setState(() => _results = null);
                      return;
                    }
                    final found =
                        await ref.read(appRepositoryProvider).searchSessions(value);
                    if (mounted && _search.text == value) {
                      setState(() => _results = found);
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search your reflections…',
                    prefixIcon: Icon(Icons.search, size: 20),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: sessions.when(
              data: (list) {
                final display = _query.trim().isEmpty ? list : _results;
                if (display == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (display.isEmpty) {
                  return _EmptyJournal(
                    searching: _query.trim().isNotEmpty,
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(28, 4, 28, 24),
                  itemCount: display.length,
                  itemBuilder: (context, index) => _JournalTile(
                    session: display[index],
                    onTap: () => Navigator.of(context).push(
                      fadeRoute(JournalDetailScreen(session: display[index])),
                    ),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}

class _JournalTile extends StatelessWidget {
  const _JournalTile({required this.session, required this.onTap});

  final SessionEntry session;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final date = DateFormat('MMMM d, yyyy').format(session.date);
    final readings = session.readings.map((r) => r.display()).join(' · ');

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        readings,
                        style: theme.textTheme.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (session.mood != null)
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          session.mood!,
                          style: theme.textTheme.labelSmall
                              ?.copyWith(color: theme.colorScheme.primary),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(date, style: theme.textTheme.labelMedium),
                if (session.reflection.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    session.reflection,
                    style: theme.textTheme.bodyMedium,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyJournal extends StatelessWidget {
  const _EmptyJournal({required this.searching});

  final bool searching;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book_outlined,
                size: 40, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(
              searching
                  ? 'Nothing found for that search.'
                  : 'Your journal is empty.\n'
                      'Every completed reading will appear here.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
