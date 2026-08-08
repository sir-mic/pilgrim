import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/data/app_repository.dart';
import 'core/notifications/notification_service.dart';
import 'core/providers.dart';
import 'core/theme/app_theme.dart';
import 'features/home/home_shell.dart';
import 'features/onboarding/onboarding_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.instance.init();
  runApp(const ProviderScope(child: MicApp()));
}

/// A quiet companion for reading the Bible.
class MicApp extends ConsumerWidget {
  const MicApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final bootstrap = ref.watch(_bootstrapProvider);

    return MaterialApp(
      title: 'mic',
      debugShowCheckedModeBanner: false,
      theme: pilgrimTheme(Brightness.light),
      darkTheme: pilgrimTheme(Brightness.dark),
      themeMode: themeMode,
      home: bootstrap.when(
        data: (state) => state.onboarded
            ? const HomeShell()
            : const OnboardingScreen(),
        loading: () => const _Splash(),
        error: (_, _) => const _FatalError(),
      ),
    );
  }
}

class _BootstrapState {
  const _BootstrapState({required this.onboarded});

  final bool onboarded;
}

/// Seeds the bundled content, then decides between onboarding and the home
/// shell. Also restores the persisted theme preference.
final _bootstrapProvider = FutureProvider<_BootstrapState>((ref) async {
  await ref.watch(contentSeededProvider.future);

  final repo = ref.watch(appRepositoryProvider);
  final onboarded = await repo.isOnboarded();

  final mode = await repo.getSetting(AppRepository.keyThemeMode);
  ref.read(themeModeProvider.notifier).state = switch (mode) {
    'light' => ThemeMode.light,
    'system' => ThemeMode.system,
    _ => ThemeMode.dark,
  };

  // Keep the splash up long enough for the rotating tagline to be seen.
  await Future<void>.delayed(const Duration(milliseconds: 2000));

  return _BootstrapState(onboarded: onboarded);
});

class _Splash extends StatefulWidget {
  const _Splash();

  @override
  State<_Splash> createState() => _SplashState();
}

class _SplashState extends State<_Splash> {
  static const _taglines = [
    'Not another Bible app.',
    'Your Bible\'s companion.',
    'The app that wants you to leave it.',
    'It keeps the pace, you keep the Book.',
    'Open your Bible. We\'ll keep the pace.',
    'You bring the Bible, we\'ll bring the plan.',
  ];

  late final String _tagline = _taglines[Random().nextInt(_taglines.length)];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('mic', style: Theme.of(context).textTheme.displaySmall),
              const SizedBox(height: 14),
              Text(
                _tagline,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FatalError extends StatelessWidget {
  const _FatalError();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Something went wrong', style: theme.textTheme.headlineMedium),
              const SizedBox(height: 12),
              Text(
                'Please restart mic.',
                style: theme.textTheme.bodyLarge
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
