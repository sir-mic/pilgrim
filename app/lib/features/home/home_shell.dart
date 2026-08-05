import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/notifications/notification_service.dart';
import '../../core/providers.dart';
import '../../core/widgets/quiet_nav_bar.dart';
import '../journal/journal_screen.dart';
import '../progress/progress_screen.dart';
import '../settings/settings_screen.dart';
import 'home_screen.dart';

/// The main scaffold: Today, Journal, Progress, Settings.
class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _refreshRemote();
    _rescheduleReminder();
  }

  void _refreshRemote() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(remoteRefreshProvider.future).catchError((_) {});
    });
  }

  Future<void> _rescheduleReminder() async {
    try {
      final repo = ref.read(appRepositoryProvider);
      if (!await repo.reminderEnabled()) return;
      final hour = await repo.reminderHour();
      final minute = await repo.reminderMinute();
      if (hour == null || minute == null) return;
      final messages = await ref.read(notificationMessagesProvider.future);
      await NotificationService.instance.scheduleDaily(
        hour: hour,
        minute: minute,
        messages: messages,
      );
    } catch (_) {
      // Non-mobile platforms or plugin failures are silently ignored.
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = const [
      HomeScreen(),
      JournalScreen(),
      ProgressScreen(),
      SettingsScreen(),
    ];
    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: QuietNavBar(
        currentIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
      ),
    );
  }
}
