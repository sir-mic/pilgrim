import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pilgrim_content/pilgrim_content.dart';

import '../../core/data/app_repository.dart';
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
            child: const ListTile(
              title: Text('mic'),
              subtitle: Text(
                'A quiet companion for reading the Bible.\n'
                'Version 1.0',
              ),
            ),
          ),
        ],
      ),
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
            ListTile(
              leading: const Icon(Icons.notifications_active_outlined, size: 20),
              title: const Text('Send test reminder'),
              subtitle: const Text('A notification in about ten seconds'),
              onTap: () async {
                await NotificationService.instance.ensureExactAlarms();
                await NotificationService.instance.scheduleTest();
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Test reminder coming in a few seconds.'),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  static String _two(int n) => n.toString().padLeft(2, '0');
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
