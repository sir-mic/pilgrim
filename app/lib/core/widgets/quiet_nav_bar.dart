import 'package:flutter/material.dart';

/// A minimal, quiet bottom navigation with four destinations.
class QuietNavBar extends StatelessWidget {
  const QuietNavBar({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  static const destinations = [
    (icon: Icons.auto_stories_outlined, selectedIcon: Icons.auto_stories, label: 'Today'),
    (icon: Icons.menu_book_outlined, selectedIcon: Icons.menu_book, label: 'Journal'),
    (icon: Icons.route_outlined, selectedIcon: Icons.route, label: 'Progress'),
    (icon: Icons.tune, selectedIcon: Icons.tune, label: 'Settings'),
  ];

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surface,
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: scheme.outline.withValues(alpha: 0.6)),
            ),
          ),
          child: Row(
            children: [
              for (var i = 0; i < destinations.length; i++)
                Expanded(
                  child: _NavItem(
                    icon: destinations[i].icon,
                    selectedIcon: destinations[i].selectedIcon,
                    label: destinations[i].label,
                    selected: i == currentIndex,
                    color: i == currentIndex ? scheme.primary : scheme.onSurfaceVariant,
                    onTap: () => onDestinationSelected(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                selected ? selectedIcon : icon,
                key: ValueKey(selected),
                size: 22,
                color: color,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
