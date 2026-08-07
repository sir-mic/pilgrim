import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pilgrim_content/pilgrim_content.dart';

import '../../core/notifications/notification_service.dart';
import '../../core/providers.dart';
import '../../core/widgets/quiet_nav_bar.dart';
import '../../core/widgets/verse_card_dialog.dart';
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
  AppLifecycleListener? _lifecycle;

  @override
  void initState() {
    super.initState();
    _refreshRemote();
    _rescheduleReminder();
    _rescheduleMicDrop();
    _listenForMicDrop();
    _checkLaunchMicDrop();
    _lifecycle = AppLifecycleListener(onResume: _rescheduleAll);
  }

  @override
  void dispose() {
    _lifecycle?.dispose();
    NotificationService.instance.nudgeTapped.removeListener(_showTappedVerse);
    super.dispose();
  }

  void _refreshRemote() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(remoteRefreshProvider.future).catchError((_) {});
    });
  }

  void _rescheduleAll() {
    _rescheduleReminder();
    _rescheduleMicDrop();
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

  /// Keeps the mic drop window topped up from launch settings. Rescheduling is
  /// cheap (a cancel + reschedule of the next ~48 hours) and guarantees a fresh
  /// shuffle so verses don't repeat across launches.
  Future<void> _rescheduleMicDrop() async {
    try {
      final service = NotificationService.instance;
      final repo = ref.read(appRepositoryProvider);
      if (!await repo.micDropEnabled()) {
        await service.cancelNudges();
        return;
      }
      final interval = await repo.micDropIntervalHours();
      if (interval == null) return;
      final verses = await ref.read(micDropVersesProvider.future);
      final categories = await repo.micDropCategories();
      await service.scheduleNudges(
        intervalHours: interval,
        categories: categories ??
            verses.map((v) => v.category).toSet().toList(),
        verses: verses,
      );
    } catch (_) {
      // Non-mobile platforms or plugin failures are silently ignored.
    }
  }

  void _listenForMicDrop() {
    NotificationService.instance.nudgeTapped.addListener(_showTappedVerse);
  }

  void _showTappedVerse() {
    final verse = NotificationService.instance.nudgeTapped.value;
    if (verse == null || !mounted) return;
    NotificationService.instance.nudgeTapped.value = null;
    _showVerseCard(verse);
  }

  /// If the app was launched from a mic drop notification, pop the verse card
  /// once the tree is ready.
  void _checkLaunchMicDrop() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final verse = await NotificationService.instance.takeLaunchNudge();
      if (verse == null || !mounted) return;
      _showVerseCard(verse);
    });
  }

  void _showVerseCard(VerseNudge verse) {
    showVerseCard(context, verse: verse);
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
