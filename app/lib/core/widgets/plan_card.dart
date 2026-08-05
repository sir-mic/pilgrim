import 'package:flutter/material.dart';
import 'package:pilgrim_content/pilgrim_content.dart';

/// A quiet selectable card describing a reading plan.
class PlanCard extends StatelessWidget {
  const PlanCard({
    super.key,
    required this.plan,
    required this.selected,
    required this.onTap,
  });

  final PlanDefinition plan;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final averageMinutes =
        plan.days.fold<int>(0, (s, d) => s + d.estimatedMinutes) ~/
            plan.days.length;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: selected
                ? scheme.primary.withValues(alpha: 0.10)
                : scheme.surfaceContainerHighest.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? scheme.primary : scheme.outline,
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(plan.title, style: theme.textTheme.titleLarge),
                    const SizedBox(height: 6),
                    Text(
                      plan.description,
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${plan.totalDays} days · about $averageMinutes min/day',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: scheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedScale(
                scale: selected ? 1 : 0.9,
                duration: const Duration(milliseconds: 220),
                child: Icon(
                  selected ? Icons.check_circle : Icons.circle_outlined,
                  color: selected ? scheme.primary : scheme.outline,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
