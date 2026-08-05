import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/app_repository.dart';
import '../../core/notifications/notification_service.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/fade_route.dart';
import '../../core/widgets/plan_card.dart';
import '../../core/widgets/quiet_buttons.dart';
import '../home/home_shell.dart';

/// First-run welcome: choose a plan, set a gentle reminder, begin.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  String? _selectedSlug;
  bool _reminderEnabled = true;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 7, minute: 0);

  Future<void> _begin() async {
    final repo = ref.read(appRepositoryProvider);
    final plans = await ref.read(allPlansProvider.future);
    final slug = _selectedSlug ?? plans.first.slug;

    await repo.setCurrentPlan(slug);
    await repo.setSetting(
        AppRepository.keyReminderEnabled, _reminderEnabled ? '1' : '0');
    await repo.setSetting(AppRepository.keyReminderHour, '${_reminderTime.hour}');
    await repo.setSetting(
        AppRepository.keyReminderMinute, '${_reminderTime.minute}');

    if (_reminderEnabled) {
      final messages = await ref.read(notificationMessagesProvider.future);
      await NotificationService.instance.scheduleDaily(
        hour: _reminderTime.hour,
        minute: _reminderTime.minute,
        messages: messages,
      );
    }

    await repo.setOnboarded();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(fadeRoute(const HomeShell()));
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
      builder: (context, child) => Theme(
        data: pilgrimTheme(Theme.of(context).brightness),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _reminderTime = picked);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final plans = ref.watch(allPlansProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pilgrim', style: theme.textTheme.displaySmall),
              const SizedBox(height: 8),
              Text(
                'A quiet companion for reading your Bible.\n'
                'It only answers four questions.',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 44),

              Text(
                'Choose a plan',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 14),

              plans.when(
                data: (list) => Column(
                  children: [
                    for (final plan in list) ...[
                      PlanCard(
                        plan: plan,
                        selected: _selectedSlug == plan.slug,
                        onTap: () =>
                            setState(() => _selectedSlug = plan.slug),
                      ),
                      const SizedBox(height: 14),
                    ],
                  ],
                ),
                loading: () => const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => Text('Could not load plans.',
                    style: theme.textTheme.bodySmall),
              ),

              const SizedBox(height: 36),
              Text(
                'Daily reminder',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'A gentle nudge, never a demand.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  Switch(
                    value: _reminderEnabled,
                    onChanged: (v) => setState(() => _reminderEnabled = v),
                    activeTrackColor: theme.colorScheme.primary,
                  ),
                ],
              ),
              if (_reminderEnabled) ...[
                const SizedBox(height: 4),
                InkWell(
                  onTap: _pickTime,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                    child: Row(
                      children: [
                        Icon(Icons.schedule,
                            size: 18, color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(width: 10),
                        Text(
                          _formatTime(_reminderTime),
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 48),
              PrimaryButton(label: 'Begin', onPressed: _begin),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour12 = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final period = time.hour >= 12 ? 'pm' : 'am';
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour12:$minute $period';
  }
}
