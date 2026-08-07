import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pilgrim_content/pilgrim_content.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/data/app_repository.dart';
import '../../core/data/verse_categories.dart';
import '../../core/notifications/notification_service.dart';
import '../../core/providers.dart';

/// Quiet settings: reminder, appearance, plan, data.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeMode = ref.watch(themeModeProvider);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(28, 32, 28, 32),
        children: [
          Text('Settings', style: theme.textTheme.displaySmall),
          const SizedBox(height: 28),

          _SectionHeader('Reminder'),
          const _ReminderTile(),
          Padding(
            padding: const EdgeInsets.only(left: 6, top: 8),
            child: Text(
              'Reminders are scheduled on this phone, not the server. '
              'If one doesn\'t arrive, enable Autostart and set battery to '
              '"No restrictions" for mic in system settings.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),

          const SizedBox(height: 28),
          _SectionHeader('mic drop'),
          const _MicDropTile(),
          Padding(
            padding: const EdgeInsets.only(left: 6, top: 8),
            child: Text(
              'Verses ship with the app and update with new content. '
              'Nudges are scheduled on this phone, not the server — like the '
              'reminder, they need Autostart and unrestricted battery to be '
              'dependable.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),

          const SizedBox(height: 28),
          _SectionHeader('Appearance'),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(16),
            ),
            child: SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(
                  value: ThemeMode.dark,
                  label: Text('Dark'),
                  icon: Icon(Icons.dark_mode_outlined, size: 18),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  label: Text('Light'),
                  icon: Icon(Icons.light_mode_outlined, size: 18),
                ),
                ButtonSegment(
                  value: ThemeMode.system,
                  label: Text('System'),
                  icon: Icon(Icons.brightness_auto_outlined, size: 18),
                ),
              ],
              selected: {themeMode},
              showSelectedIcon: false,
              onSelectionChanged: (selection) async {
                final mode = selection.first;
                ref.read(themeModeProvider.notifier).state = mode;
                await ref
                    .read(appRepositoryProvider)
                    .setSetting(
                        AppRepository.keyThemeMode, mode.name);
              },
            ),
          ),

          const SizedBox(height: 28),
          _SectionHeader('Reading plan'),
          const _PlanTile(),

          const SizedBox(height: 28),
          _SectionHeader('About'),
          Card(
            elevation: 0,
            margin: EdgeInsets.zero,
            color: theme.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const ListTile(
                  title: Text('mic'),
                  subtitle: Text(
                    'A quiet companion for reading the Bible.\n'
                    'Version 1.0.5',
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.feedback_outlined, size: 20),
                  title: const Text('Send feedback'),
                  subtitle: const Text('Tell us what you think'),
                  onTap: () => _openFeedback(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> _openFeedback(BuildContext context) async {
    final uri = Uri.parse('https://sir-mic.github.io/path2mic/#feedback');
    if (await launchUrl(uri, mode: LaunchMode.externalApplication)) return;
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Could not open the browser.')),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(label, style: Theme.of(context).textTheme.labelSmall),
    );
  }
}

class _ReminderTile extends ConsumerStatefulWidget {
  const _ReminderTile();

  @override
  ConsumerState<_ReminderTile> createState() => _ReminderTileState();
}

class _ReminderTileState extends ConsumerState<_ReminderTile> {
  bool? _enabled;
  int _hour = 7;
  int _minute = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = ref.read(appRepositoryProvider);
    final enabled = await repo.reminderEnabled();
    final hour = await repo.reminderHour();
    final minute = await repo.reminderMinute();
    if (!mounted) return;
    setState(() {
      _enabled = enabled;
      if (hour != null) _hour = hour;
      if (minute != null) _minute = minute;
    });
  }

  Future<void> _apply(bool enabled, {int? hour, int? minute}) async {
    final repo = ref.read(appRepositoryProvider);
    await repo.setSetting(AppRepository.keyReminderEnabled, enabled ? '1' : '0');
    if (hour != null) {
      await repo.setSetting(AppRepository.keyReminderHour, '$hour');
      await repo.setSetting(AppRepository.keyReminderMinute, '$minute');
    }
    if (enabled) {
      await NotificationService.instance.ensureExactAlarms();
      final messages = await ref.read(notificationMessagesProvider.future);
      final h = hour ?? _hour;
      final m = minute ?? _minute;
      await NotificationService.instance.scheduleDaily(
        hour: h,
        minute: m,
        messages: messages,
      );
    } else {
      await NotificationService.instance.cancelAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (_enabled == null) return const SizedBox();

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          SwitchListTile(
            value: _enabled!,
            title: const Text('Daily reminder'),
            subtitle: const Text('A quiet nudge to read'),
            onChanged: (v) async {
              setState(() => _enabled = v);
              await _apply(v);
            },
          ),
          if (_enabled!)
            ListTile(
              leading: const Icon(Icons.schedule, size: 20),
              title: const Text('Time'),
              trailing: Text(
                '${_two(_hour)}:${_two(_minute)}',
                style: theme.textTheme.titleMedium,
              ),
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(hour: _hour, minute: _minute),
                );
                if (picked == null) return;
                setState(() {
                  _hour = picked.hour;
                  _minute = picked.minute;
                });
                await _apply(true, hour: picked.hour, minute: picked.minute);
              },
            ),
          if (_enabled!)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Next reminder: ${_formatNext(_hour, _minute)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  static String _two(int n) => n.toString().padLeft(2, '0');

  /// The next [hour]:[minute] from the device's local clock — today if still
  /// ahead, otherwise tomorrow.
  static String _formatNext(int hour, int minute) {
    final now = DateTime.now();
    var next = DateTime(now.year, now.month, now.day, hour, minute);
    if (!next.isAfter(now)) {
      next = next.add(const Duration(days: 1));
    }
    return DateFormat('EEEE, MMM d, h:mm a').format(next);
  }
}

class _MicDropTile extends ConsumerStatefulWidget {
  const _MicDropTile();

  @override
  ConsumerState<_MicDropTile> createState() => _MicDropTileState();
}

class _MicDropTileState extends ConsumerState<_MicDropTile> {
  static const _intervals = [1, 2, 3, 4, 6];

  bool? _enabled;
  int _intervalHours = 2;

  /// Enabled category ids; null means every category available is enabled.
  Set<String>? _enabledCategories;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = ref.read(appRepositoryProvider);
    final enabled = await repo.micDropEnabled();
    final interval = await repo.micDropIntervalHours();
    final categories = await repo.micDropCategories();
    if (!mounted) return;
    setState(() {
      _enabled = enabled;
      if (interval != null) _intervalHours = interval;
      _enabledCategories = categories?.toSet();
    });
  }

  /// Categories present in the current content, oldest first, so new bundles
  /// surface new mic drop categories automatically.
  List<String> _availableCategories(List<VerseNudge> verses) {
    final seen = <String>{};
    return verses
        .map((v) => v.category)
        .where(seen.add)
        .toList();
  }

  Set<String> _effectiveCategories(List<VerseNudge> verses) {
    final available = _availableCategories(verses);
    final chosen = _enabledCategories;
    if (chosen == null) return available.toSet();
    return chosen.intersection(available.toSet());
  }

  Future<void> _apply(bool enabled, {int? interval, Set<String>? categories}) async {
    final repo = ref.read(appRepositoryProvider);
    await repo.setMicDropEnabled(enabled);
    if (interval != null) {
      await repo.setMicDropIntervalHours(interval);
    }
    if (categories != null) {
      final list = categories.toList()..sort();
      if (list.isEmpty) {
        await repo.clearMicDropCategories();
      } else {
        await repo.setMicDropCategories(list);
      }
    }

    if (enabled) {
      final verses = await ref.read(micDropVersesProvider.future);
      final i = interval ?? _intervalHours;
      final cats = categories ?? _effectiveCategories(verses);
      await NotificationService.instance.scheduleNudges(
        intervalHours: i,
        categories: cats.toList(),
        verses: verses,
      );
    } else {
      await NotificationService.instance.cancelNudges();
    }
  }

  Future<void> _sendOneNow(List<VerseNudge> verses) async {
    final pool = verses
        .where((v) => _effectiveCategories(verses).contains(v.category))
        .toList();
    if (pool.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enable at least one category first.')),
      );
      return;
    }
    final verse = pool[DateTime.now().millisecond % pool.length];
    await NotificationService.instance.sendOneNow(verse);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('mic drop sent — check your notifications.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final verses = ref.watch(micDropVersesProvider);
    if (_enabled == null) return const SizedBox();

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: verses.when(
        data: (all) => _buildBody(theme, all),
        loading: () => const SizedBox(height: 120),
        error: (_, _) => const SizedBox(height: 120),
      ),
    );
  }

  Widget _buildBody(ThemeData theme, List<VerseNudge> verses) {
    final available = _availableCategories(verses);
    final chosen = _effectiveCategories(verses);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          value: _enabled!,
          title: const Text('mic drop'),
          subtitle: const Text('Bible verses through the day'),
          onChanged: (v) async {
            setState(() => _enabled = v);
            await _apply(v);
          },
        ),
        if (_enabled!)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Every', style: theme.textTheme.labelMedium),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<int>(
                    segments: [
                      for (final hours in _intervals)
                        ButtonSegment(
                          value: hours,
                          label: Text(hours == 1 ? '1 hour' : '$hours hours'),
                        ),
                    ],
                    selected: {_intervalHours},
                    showSelectedIcon: false,
                    onSelectionChanged: (selection) async {
                      final hours = selection.first;
                      setState(() => _intervalHours = hours);
                      await _apply(true, interval: hours);
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Text('Drop a verse from', style: theme.textTheme.labelMedium),
                const SizedBox(height: 4),
                Text(
                  'Tap to choose the ones you need today.',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final id in available)
                      FilterChip(
                        selected: chosen.contains(id),
                        showCheckmark: false,
                        avatar: Icon(
                          micDropCategoryFor(id).icon,
                          size: 17,
                          color: chosen.contains(id)
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                        label: Text(micDropCategoryFor(id).label),
                        onSelected: (selected) async {
                          final next = {...chosen};
                          if (selected) {
                            next.add(id);
                          } else {
                            next.remove(id);
                          }
                          setState(() => _enabledCategories = next);
                          await _apply(true, categories: next);
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _sendOneNow(verses),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.notifications_active_outlined, size: 18),
                    label: const Text('Send one now'),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _PlanTile extends ConsumerStatefulWidget {
  const _PlanTile();

  @override
  ConsumerState<_PlanTile> createState() => _PlanTileState();
}

class _PlanTileState extends ConsumerState<_PlanTile> {
  String? _slug;

  @override
  void initState() {
    super.initState();
    ref.read(appRepositoryProvider).currentPlanSlug().then((slug) {
      if (mounted) setState(() => _slug = slug);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final plans = ref.watch(allPlansProvider);
    return plans.when(
      data: (list) {
        PlanDefinition? current;
        for (final plan in list) {
          if (plan.slug == _slug) {
            current = plan;
            break;
          }
        }
        return Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          color: theme.colorScheme.surfaceContainerHighest
              .withValues(alpha: 0.55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              ListTile(
                title: Text(current?.title ?? 'Not chosen yet'),
                subtitle: const Text('Current plan'),
                onTap: () async {
                  final picked = await showModalBottomSheet<String>(
                    context: context,
                    backgroundColor: theme.colorScheme.surface,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    builder: (context) => SafeArea(
                      child: ListView(
                        padding: const EdgeInsets.all(20),
                        shrinkWrap: true,
                        children: [
                          for (final plan in list)
                            ListTile(
                              title: Text(plan.title),
                              subtitle: Text(plan.description,
                                  style: theme.textTheme.bodySmall),
                              onTap: () =>
                                  Navigator.of(context).pop(plan.slug),
                            ),
                        ],
                      ),
                    ),
                  );
                  if (picked == null) return;
                  await ref.read(appRepositoryProvider).setCurrentPlan(picked);
                  ref.invalidate(currentReadingProvider);
                  if (mounted) setState(() => _slug = picked);
                },
              ),
              ListTile(
                leading: const Icon(Icons.restart_alt, size: 20),
                title: const Text('Start current plan over'),
                subtitle: const Text('Journal entries are kept'),
                onTap: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Start over?'),
                      content: const Text(
                          'This resets your progress to day one. '
                          'Your journal entries are kept.'),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.of(context).pop(true),
                          child: const Text('Start over'),
                        ),
                      ],
                    ),
                  );
                  if (confirmed == true) {
                    await ref
                        .read(appRepositoryProvider)
                        .restartCurrentPlan();
                    ref.invalidate(currentReadingProvider);
                  }
                },
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox(),
      error: (_, _) => const SizedBox(),
    );
  }
}
