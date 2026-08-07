import 'package:flutter/material.dart';

/// Static display metadata for the mic drop categories. The actual verse text
/// ships in the signed content bundle; this file only knows how to *label* a
/// category. Categories present in the content but unknown here fall back to a
/// generic label and icon.
class MicDropCategory {
  const MicDropCategory({
    required this.id,
    required this.label,
    required this.icon,
    required this.blurb,
  });

  final String id;
  final String label;
  final IconData icon;
  final String blurb;
}

/// The "usual stuff": a small set of everyday struggles and graces.
const List<MicDropCategory> micDropCategories = [
  MicDropCategory(
    id: 'hope',
    label: 'Hope',
    icon: Icons.wb_sunny_outlined,
    blurb: 'When hope runs thin',
  ),
  MicDropCategory(
    id: 'temptation',
    label: 'Temptation',
    icon: Icons.shield_outlined,
    blurb: 'Standing strong under pressure',
  ),
  MicDropCategory(
    id: 'peace',
    label: 'Peace',
    icon: Icons.self_improvement_outlined,
    blurb: 'For anxious, restless hearts',
  ),
  MicDropCategory(
    id: 'courage',
    label: 'Courage',
    icon: Icons.local_fire_department_outlined,
    blurb: 'Facing fear head-on',
  ),
  MicDropCategory(
    id: 'gratitude',
    label: 'Gratitude',
    icon: Icons.volunteer_activism_outlined,
    blurb: 'A thankful heart',
  ),
  MicDropCategory(
    id: 'patience',
    label: 'Patience',
    icon: Icons.hourglass_bottom_outlined,
    blurb: 'Enduring the wait',
  ),
  MicDropCategory(
    id: 'strength',
    label: 'Strength',
    icon: Icons.fitness_center_outlined,
    blurb: 'When you feel spent',
  ),
  MicDropCategory(
    id: 'guidance',
    label: 'Guidance',
    icon: Icons.explore_outlined,
    blurb: 'For decisions and direction',
  ),
  MicDropCategory(
    id: 'comfort',
    label: 'Comfort',
    icon: Icons.water_drop_outlined,
    blurb: 'For grief and hurt',
  ),
  MicDropCategory(
    id: 'faith',
    label: 'Faith',
    icon: Icons.brightness_medium_outlined,
    blurb: 'Trusting when it\'s hard',
  ),
  MicDropCategory(
    id: 'forgiveness',
    label: 'Forgiveness',
    icon: Icons.replay_outlined,
    blurb: 'Mercy given and received',
  ),
  MicDropCategory(
    id: 'wisdom',
    label: 'Wisdom',
    icon: Icons.lightbulb_outline,
    blurb: 'Choosing the wise path',
  ),
  MicDropCategory(
    id: 'joy',
    label: 'Joy',
    icon: Icons.celebration_outlined,
    blurb: 'Gladness that endures',
  ),
  MicDropCategory(
    id: 'love',
    label: 'Love',
    icon: Icons.favorite_outline,
    blurb: 'Loved, and learning to love',
  ),
];

/// Looks up display metadata by category id; falls back to a readable label.
MicDropCategory micDropCategoryFor(String id) {
  for (final category in micDropCategories) {
    if (category.id == id) return category;
  }
  return MicDropCategory(
    id: id,
    label: _titleCase(id),
    icon: Icons.format_quote_outlined,
    blurb: 'A word for today',
  );
}

String _titleCase(String input) {
  if (input.isEmpty) return input;
  return input.split(' ').map((word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1);
  }).join(' ');
}
