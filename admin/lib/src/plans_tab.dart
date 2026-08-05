import 'package:flutter/material.dart';

import '../main.dart';

/// Edits the plans' titles and descriptions. Day schedules are fixed and shown
/// read-only.
class PlansTab extends StatefulWidget {
  const PlansTab({super.key, required this.state});

  final AdminState state;

  @override
  State<PlansTab> createState() => _PlansTabState();
}

class _PlansTabState extends State<PlansTab> {
  late final Map<String, TextEditingController> _titles;
  late final Map<String, TextEditingController> _descriptions;

  @override
  void initState() {
    super.initState();
    _titles = {};
    _descriptions = {};
    for (final plan in widget.state.plans) {
      _titles[plan.slug] =
          TextEditingController(text: plan.title);
      _descriptions[plan.slug] =
          TextEditingController(text: plan.description);
    }
  }

  @override
  void dispose() {
    for (final c in _titles.values) {
      c.dispose();
    }
    for (final c in _descriptions.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final plans = widget.state.plans;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Reading plans', style: Theme.of(context).textTheme.headlineSmall),
              TextButton.icon(
                onPressed: () => setState(widget.state.resetDefaults),
                icon: const Icon(Icons.restore),
                label: const Text('Reset to defaults'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Plans are rebuilt from source. Only titles and descriptions are '
            'editable here; day schedules are fixed by the build.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          for (final plan in plans)
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Chip(label: Text(plan.slug)),
                        const SizedBox(width: 8),
                        Chip(label: Text('${plan.totalDays} days')),
                        const SizedBox(width: 8),
                        Chip(label: Text(plan.kind)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _titles[plan.slug],
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) =>
                          plan.title = value.trim(),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _descriptions[plan.slug],
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      onChanged: (value) =>
                          plan.description = value.trim(),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
