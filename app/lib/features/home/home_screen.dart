import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/data/models.dart';
import '../../core/providers.dart';
import '../../core/widgets/fade_route.dart';
import '../../core/widgets/quiet_buttons.dart';
import '../journal/journal_detail_screen.dart';
import '../reading/reading_flow_screen.dart';

/// Today's reading — the heart of the app.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reading = ref.watch(currentReadingProvider);
    return SafeArea(
      child: reading.when(
        data: (value) => _TodayBody(reading: value),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => const _NoPlanView(),
      ),
    );
  }
}

class _TodayBody extends ConsumerWidget {
  const _TodayBody({required this.reading});

  final CurrentReading reading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final weekday = DateFormat('EEEE').format(now);
    final monthDay = DateFormat('MMMM d').format(now);

    final showWelcome = reading.hasHistory &&
        reading.todaysSession == null &&
        !reading.planFinished;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 32, 28, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showWelcome) ...[
            Text(
              'Welcome back.',
              style: theme.textTheme.titleMedium
                  ?.copyWith(color: theme.colorScheme.primary),
            ),
            Text(
              'Let\'s continue where we left off.',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
          ],
          Text(weekday,
              style: theme.textTheme.labelSmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: 4),
          Text(monthDay, style: theme.textTheme.displaySmall),
          const SizedBox(height: 8),
          Text(
            '${reading.plan.title} · Day ${reading.currentDay} of ${reading.plan.totalDays}',
            style: theme.textTheme.labelMedium
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),

          const SizedBox(height: 28),

          if (reading.planFinished)
            _PlanFinished(planTitle: reading.plan.title)
          else if (reading.todaysSession != null)
            _CompletedToday(reading: reading)
          else if (reading.hasInProgress)
            _ResumeReading(reading: reading)
          else
            _ReadingPrompt(reading: reading),
        ],
      ),
    );
  }
}

/// A quiet card used to group each Today state into one cohesive block.
class _TodayCard extends StatelessWidget {
  const _TodayCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest
            .withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(label, style: Theme.of(context).textTheme.labelSmall);
  }
}

class _CardDivider extends StatelessWidget {
  const _CardDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(color: Theme.of(context).colorScheme.outline);
  }
}

class _ReadingPrompt extends StatelessWidget {
  const _ReadingPrompt({required this.reading});

  final CurrentReading reading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final day = reading.day!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TodayCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionLabel('Today\'s Reading'),
              const SizedBox(height: 14),
              for (final r in day.readings) ...[
                Text(r.display(), style: theme.textTheme.displayMedium),
                const SizedBox(height: 6),
              ],
              const SizedBox(height: 18),
              const _CardDivider(),
              const SizedBox(height: 14),
              Row(
                children: [
                  Icon(Icons.schedule,
                      size: 18, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 8),
                  Text(
                    'Estimated Time · ${day.estimatedMinutes} minutes',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        PrimaryButton(
          label: 'Begin Reading',
          onPressed: () => Navigator.of(context).push(
            fadeRoute(ReadingFlowScreen(reading: reading)),
          ),
        ),
      ],
    );
  }
}

class _ResumeReading extends ConsumerWidget {
  const _ResumeReading({required this.reading});

  final CurrentReading reading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final day = reading.day!;
    final finished = reading.inProgressDone.length;
    final total = day.readings.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TodayCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionLabel('You\'re partway through'),
              const SizedBox(height: 14),
              for (var i = 0; i < day.readings.length; i++) ...[
                Row(
                  children: [
                    Icon(
                      reading.inProgressDone.contains(i)
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      size: 18,
                      color: reading.inProgressDone.contains(i)
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        day.readings[i].display(),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: reading.inProgressDone.contains(i)
                              ? theme.colorScheme.onSurfaceVariant
                              : theme.colorScheme.onSurface,
                          decoration: reading.inProgressDone.contains(i)
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
              const SizedBox(height: 6),
              const _CardDivider(),
              const SizedBox(height: 12),
              Text(
                '$finished of $total finished. Rest is good.',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        PrimaryButton(
          label: 'Continue reading',
          onPressed: () => Navigator.of(context).push(
            fadeRoute(ReadingFlowScreen(reading: reading, resume: true)),
          ),
        ),
        const SizedBox(height: 12),
        GhostButton(
          label: 'Start today over',
          onPressed: () => _startTodayOver(context, ref),
        ),
      ],
    );
  }

  Future<void> _startTodayOver(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start today over?'),
        content: const Text(
            'This clears today\'s progress and returns you to the first '
            'reading. Your journal entries are kept.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Start over'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(appRepositoryProvider).clearReadingProgress(
          reading.plan.slug,
          DateTime.parse(reading.progressDate),
        );
    ref.invalidate(currentReadingProvider);
  }
}

class _CompletedToday extends ConsumerWidget {
  const _CompletedToday({required this.reading});

  final CurrentReading reading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final session = reading.todaysSession!;
    final canReadMore =
        reading.plan.kind == 'sequential' && !reading.planFinished;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TodayCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.check_circle,
                      color: theme.colorScheme.secondary, size: 22),
                  const SizedBox(width: 8),
                  Text('Today\'s reading is complete',
                      style: theme.textTheme.titleMedium),
                ],
              ),
              const SizedBox(height: 20),
              for (final r in session.readings) ...[
                Text(r.display(), style: theme.textTheme.headlineMedium),
                const SizedBox(height: 6),
              ],
              if (session.mood != null) ...[
                const SizedBox(height: 16),
                const _SectionLabel('Mood'),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
              if (session.reflection.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  '“${session.reflection}”',
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 18),
              const _CardDivider(),
              const SizedBox(height: 12),
              Text(
                canReadMore
                    ? 'The plan will wait here until tomorrow — or you can '
                        'keep going now.'
                    : 'The next reading will be here tomorrow.',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        if (canReadMore) ...[
          const SizedBox(height: 28),
          PrimaryButton(
            label: 'Read one more chapter',
            onPressed: () => Navigator.of(context).push(
              fadeRoute(ReadingFlowScreen(reading: reading, resume: true)),
            ),
          ),
        ],
        const SizedBox(height: 12),
        GhostButton(
          label: 'View in journal',
          onPressed: () => Navigator.of(context).push(
            fadeRoute(JournalDetailScreen(session: session)),
          ),
        ),
      ],
    );
  }
}

class _PlanFinished extends ConsumerWidget {
  const _PlanFinished({required this.planTitle});

  final String planTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('The journey continues.', style: theme.textTheme.displaySmall),
        const SizedBox(height: 16),
        Text(
          'You\'ve completed your reading plan. Take a moment to look back '
          'at where God has met you.',
          style: theme.textTheme.bodyLarge
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 44),
        PrimaryButton(
          label: 'Start Again',
          onPressed: () async {
            await ref.read(appRepositoryProvider).restartCurrentPlan();
            ref.invalidate(currentReadingProvider);
          },
        ),
        const SizedBox(height: 12),
        GhostButton(
          label: 'Choose Another Plan',
          onPressed: () => Navigator.of(context)
              .push(fadeRoute(const _PlanPick())),
        ),
      ],
    );
  }
}

class _PlanPick extends ConsumerWidget {
  const _PlanPick();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final plans = ref.watch(allPlansProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Choose a plan')),
      body: SafeArea(
        child: plans.when(
          data: (list) => ListView(
            padding: const EdgeInsets.all(28),
            children: [
              for (final plan in list)
                Card(
                  elevation: 0,
                  color: theme.colorScheme.surfaceContainerHighest,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(18),
                    title: Text(plan.title,
                        style: theme.textTheme.titleMedium),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(plan.description,
                          style: theme.textTheme.bodySmall),
                    ),
                    onTap: () async {
                      final repo = ref.read(appRepositoryProvider);
                      await repo.setCurrentPlan(plan.slug);
                      ref.invalidate(currentReadingProvider);
                      if (context.mounted) {
                        Navigator.of(context).popUntil((r) => r.isFirst);
                      }
                    },
                  ),
                ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => const SizedBox(),
        ),
      ),
    );
  }
}

class _NoPlanView extends StatelessWidget {
  const _NoPlanView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Text(
          'Choose a reading plan to begin.',
          style: theme.textTheme.bodyLarge,
        ),
      ),
    );
  }
}
