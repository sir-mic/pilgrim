import 'package:flutter/material.dart';
import 'package:pilgrim_content/pilgrim_content.dart';

import '../data/verse_categories.dart';

/// Shows the quiet verse card for a mic drop notification.
Future<void> showVerseCard(
  BuildContext context, {
  required VerseNudge verse,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) => VerseCardDialog(verse: verse),
  );
}

/// A pop-up card with a mic drop verse: category chip, verse text in an italic
/// serif, and its reference.
class VerseCardDialog extends StatelessWidget {
  const VerseCardDialog({super.key, required this.verse});

  final VerseNudge verse;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final category = micDropCategoryFor(verse.category);

    return Dialog(
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(category.icon, size: 15, color: theme.colorScheme.primary),
                      const SizedBox(width: 6),
                      Text(
                        category.label,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  'mic drop',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              verse.text,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontStyle: FontStyle.italic,
                height: 1.7,
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                verse.reference,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
