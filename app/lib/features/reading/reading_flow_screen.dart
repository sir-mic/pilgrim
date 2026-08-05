import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/models.dart';
import '../../core/providers.dart';
import '../../core/widgets/fade_route.dart';
import '../../core/widgets/quiet_buttons.dart';
import '../home/home_shell.dart';

enum _Step { pray, read, reflect }

/// The daily reading flow: pray, open the Bible, reflect.
///
/// A reading cannot be completed immediately — it passes through a quiet
/// pause, then a reflection prompt. Nothing is graded or analyzed.
class ReadingFlowScreen extends ConsumerStatefulWidget {
  const ReadingFlowScreen({super.key, required this.reading});

  final CurrentReading reading;

  @override
  ConsumerState<ReadingFlowScreen> createState() => _ReadingFlowScreenState();
}

class _ReadingFlowScreenState extends ConsumerState<ReadingFlowScreen> {
  static const _prayerSeconds = 30;

  _Step _step = _Step.pray;
  int _countdown = _prayerSeconds;
  Timer? _timer;
  late Future<String> _prompt;
  final TextEditingController _reflection = TextEditingController();
  final TextEditingController _prayer = TextEditingController();
  String? _mood;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _prompt = ref.read(randomPromptProvider.future);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _reflection.dispose();
    _prayer.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_countdown <= 1) {
        t.cancel();
        _advance();
      } else {
        setState(() => _countdown--);
      }
    });
  }

  void _skipPrayer() {
    _timer?.cancel();
    _advance();
  }

  void _advance() {
    setState(() {
      if (_step == _Step.pray) {
        _step = _Step.read;
      } else if (_step == _Step.read) {
        _step = _Step.reflect;
      }
    });
  }

  Future<void> _complete() async {
    final reading = widget.reading;
    final day = reading.day!;
    final prompt = await _prompt;
    await ref.read(appRepositoryProvider).insertSession(
          date: DateTime.now(),
          planSlug: reading.plan.slug,
          dayIndex: reading.currentDay,
          prompt: prompt,
          reflection: _reflection.text.trim(),
          prayer: _prayer.text.trim().isEmpty ? null : _prayer.text.trim(),
          mood: _mood,
          readings: day.readings,
        );

    if (!mounted) return;
    if (reading.currentDay >= reading.plan.totalDays) {
      // Last day of the plan: a reflective finish, not a celebration.
      Navigator.of(context).pushAndRemoveUntil(
        fadeRoute(const _FinishView()),
        (route) => route.isFirst,
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: switch (_step) {
            _Step.pray => _buildPray(),
            _Step.read => _buildRead(),
            _Step.reflect => _buildReflect(),
          },
        ),
      ),
    );
  }

  Widget _buildPray() {
    final theme = Theme.of(context);
    final progress = 1 - _countdown / _prayerSeconds;
    return Padding(
      key: const ValueKey('pray'),
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Take thirty seconds.', style: theme.textTheme.displaySmall),
          const SizedBox(height: 10),
          Text(
            'Pray before reading.',
            style: theme.textTheme.bodyLarge
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 56),
          SizedBox(
            width: 160,
            height: 160,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 3,
                  strokeCap: StrokeCap.round,
                  backgroundColor: theme.colorScheme.outline,
                  color: theme.colorScheme.primary,
                ),
                Center(
                  child: Text(
                    '$_countdown',
                    style: theme.textTheme.displayMedium
                        ?.copyWith(fontSize: 56),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 56),
          GhostButton(label: 'Skip', onPressed: _skipPrayer),
        ],
      ),
    );
  }

  Widget _buildRead() {
    final theme = Theme.of(context);
    final day = widget.reading.day!;
    return Padding(
      key: const ValueKey('read'),
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Open your Bible.', style: theme.textTheme.displaySmall),
          const SizedBox(height: 24),
          for (final r in day.readings) ...[
            Text(r.display(), style: theme.textTheme.headlineLarge),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 32),
          Text(
            'Read slowly. When you have finished, continue.',
            style: theme.textTheme.bodyLarge
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 48),
          PrimaryButton(label: 'I\'ve finished reading', onPressed: _advance),
        ],
      ),
    );
  }

  Widget _buildReflect() {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      key: const ValueKey('reflect'),
      padding: const EdgeInsets.fromLTRB(28, 40, 28, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Reflect', style: theme.textTheme.labelSmall),
          const SizedBox(height: 12),
          FutureBuilder<String>(
            future: _prompt,
            builder: (context, snapshot) => Text(
              snapshot.data ?? 'What did God show you today?',
              style: theme.textTheme.headlineMedium,
            ),
          ),
          const SizedBox(height: 28),
          TextField(
            controller: _reflection,
            minLines: 3,
            maxLines: 8,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              hintText: 'Write honestly. No one will grade this.',
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _prayer,
            minLines: 2,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'A one-sentence prayer (optional)',
            ),
          ),
          const SizedBox(height: 24),
          Text('How was your heart? (optional)',
              style: theme.textTheme.labelMedium),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final mood in _moods)
                _MoodChip(
                  label: mood,
                  selected: _mood == mood,
                  onTap: () => setState(() => _mood = _mood == mood ? null : mood),
                ),
            ],
          ),
          const SizedBox(height: 40),
          PrimaryButton(
            label: 'Complete',
            busy: false,
            onPressed: _reflection.text.trim().isEmpty ? null : _complete,
          ),
        ],
      ),
    );
  }

  static const _moods = [
    'Peaceful',
    'Thankful',
    'Hopeful',
    'Seeking',
    'Heavy',
    'Joyful',
  ];
}

class _MoodChip extends StatelessWidget {
  const _MoodChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: selected
              ? scheme.primary.withValues(alpha: 0.16)
              : scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? scheme.primary : scheme.outline,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: selected ? scheme.primary : scheme.onSurfaceVariant,
              ),
        ),
      ),
    );
  }
}

/// Shown after the final day of a plan: a reflective close, not confetti.
class _FinishView extends ConsumerWidget {
  const _FinishView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('The journey continues.', style: theme.textTheme.displaySmall),
              const SizedBox(height: 16),
              Text(
                'You\'ve completed your reading plan.\n'
                'Take a moment to look back at where God has met you.',
                style: theme.textTheme.bodyLarge
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 44),
              PrimaryButton(
                label: 'Start Again',
                onPressed: () async {
                  await ref.read(appRepositoryProvider).restartCurrentPlan();
                  ref.invalidate(currentReadingProvider);
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      fadeRoute(const HomeShell()),
                      (route) => route.isFirst,
                    );
                  }
                },
              ),
              const SizedBox(height: 12),
              GhostButton(
                label: 'Choose Another Plan',
                onPressed: () async {
                  final slug = await _pickPlan(context, ref);
                  if (slug == null) return;
                  await ref.read(appRepositoryProvider).setCurrentPlan(slug);
                  ref.invalidate(currentReadingProvider);
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      fadeRoute(const HomeShell()),
                      (route) => route.isFirst,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> _pickPlan(BuildContext context, WidgetRef ref) async {
    final plans = await ref.read(allPlansProvider.future);
    if (!context.mounted) return null;
    final slug = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          shrinkWrap: true,
          children: [
            for (final plan in plans)
              ListTile(
                title: Text(plan.title,
                    style: Theme.of(context).textTheme.titleMedium),
                subtitle: Text(plan.description,
                    style: Theme.of(context).textTheme.bodySmall),
                onTap: () => Navigator.of(context).pop(plan.slug),
              ),
          ],
        ),
      ),
    );
    return slug;
  }
}
