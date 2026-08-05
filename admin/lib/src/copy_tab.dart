import 'package:flutter/material.dart';

import '../main.dart';

/// Edits the editorial copy: reflection prompts and notification messages.
class CopyTab extends StatefulWidget {
  const CopyTab({super.key, required this.state});

  final AdminState state;

  @override
  State<CopyTab> createState() => _CopyTabState();
}

class _CopyTabState extends State<CopyTab> {
  late List<TextEditingController> _prompts;
  late List<TextEditingController> _messages;

  @override
  void initState() {
    super.initState();
    _prompts = widget.state.prompts
        .map((p) => TextEditingController(text: p))
        .toList();
    _messages = widget.state.messages
        .map((m) => TextEditingController(text: m))
        .toList();
  }

  @override
  void dispose() {
    for (final c in _prompts) {
      c.dispose();
    }
    for (final c in _messages) {
      c.dispose();
    }
    super.dispose();
  }

  void _sync() {
    widget.state.prompts = _prompts.map((c) => c.text).toList();
    widget.state.messages = _messages.map((c) => c.text).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Reflection prompts',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'Shown after each reading. One appears at random.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          _listBuilder(
            context,
            controllers: _prompts,
            onAdd: () => setState(() => _prompts.add(TextEditingController())),
          ),
          const SizedBox(height: 32),
          Text('Notification messages',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'Calm daily reminders. One appears at random.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          _listBuilder(
            context,
            controllers: _messages,
            onAdd: () => setState(() => _messages.add(TextEditingController())),
          ),
        ],
      ),
    );
  }

  Widget _listBuilder(
    BuildContext context, {
    required List<TextEditingController> controllers,
    required VoidCallback onAdd,
  }) {
    return Column(
      children: [
        for (var i = 0; i < controllers.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controllers[i],
                    onChanged: (_) => _sync(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Remove',
                  onPressed: () => setState(() {
                    controllers.removeAt(i).dispose();
                    _sync();
                  }),
                ),
              ],
            ),
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => setState(onAdd),
            icon: const Icon(Icons.add),
            label: const Text('Add'),
          ),
        ),
      ],
    );
  }
}
