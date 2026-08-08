import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';

/// Gentle progress: completion as a pilgrimage, never a streak.
class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final reading = ref.watch(currentReadingProvider);
    final completedPlans = ref.watch(_completedPlansProvider);
    final perPlan = ref.watch(_sessionsPerPlanProvider);
    final plans = ref.watch(allPlansProvider);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(28, 32, 28, 32),
        children: [
          Text('Progress', style: theme.textTheme.displaySmall),
          const SizedBox(height: 28),

          reading.when(
            data: (value) {
              final r = value;
              final fraction =
                  r.completedCount.clamp(0, r.plan.totalDays) / r.plan.totalDays;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(r.plan.title, style: theme.textTheme.titleLarge),
                  const SizedBox(height: 6),
                  Text(
                    '${dayLabel(r.completedCount)} · '
                    '${r.completedCount} of ${r.plan.totalDays} days',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: fraction,
                      minHeight: 8,
                      backgroundColor: theme.colorScheme.outline,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(fraction * 100).round()}%',
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(color: theme.colorScheme.primary),
                  ),
                ],
              );
            },
            loading: () => const LinearProgressIndicator(),
            error: (_, _) => const SizedBox(),
          ),

          const SizedBox(height: 40),

          Text('Readings completed', style: theme.textTheme.labelSmall),
          const SizedBox(height: 12),
          plans.when(
            data: (list) => perPlan.when(
              data: (counts) => Column(
                children: [
                  for (final plan in list) ...[
                    _StatCard(
                      label: plan.title,
                      value: '${counts[plan.slug] ?? 0}',
                      highlighted: reading.value?.plan.slug == plan.slug,
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
              ),
              loading: () => const SizedBox(),
              error: (_, _) => const SizedBox(),
            ),
            loading: () => const SizedBox(),
            error: (_, _) => const SizedBox(),
          ),

          const SizedBox(height: 40),

          Text('Completed', style: theme.textTheme.labelSmall),
          const SizedBox(height: 12),
          completedPlans.when(
            data: (plans) {
              if (plans.isEmpty) {
                return Text(
                  'No completed plans yet. The journey is its own reward.',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final plan in plans)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle,
                              size: 20, color: theme.colorScheme.secondary),
                          const SizedBox(width: 10),
                          Text(plan.title, style: theme.textTheme.bodyLarge),
                        ],
                      ),
                    ),
                ],
              );
            },
            loading: () => const SizedBox(),
            error: (_, _) => const SizedBox(),
          ),
        ],
      ),
    );
  }
}

String dayLabel(int count) =>
    count == 0 ? 'Beginning the walk' : 'Day $count';

final _completedPlansProvider =
    FutureProvider((ref) => ref.watch(appRepositoryProvider).completedPlans());

final _sessionsPerPlanProvider =
    FutureProvider<Map<String, int>>((ref) =>
        ref.watch(appRepositoryProvider).sessionsPerPlan());

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    this.highlighted = false,
  });

  final String label;
  final String value;

  /// Whether this plan is the one currently selected.
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: highlighted
            ? theme.colorScheme.primary.withValues(alpha: 0.10)
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: highlighted
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
                fontWeight:
                    highlighted ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
          Text(value, style: theme.textTheme.headlineSmall),
        ],
      ),
    );
  }
}
