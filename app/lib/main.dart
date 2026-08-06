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

  return _BootstrapState(onboarded: onboarded);
});

class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'mic',
          style: Theme.of(context).textTheme.displaySmall,
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
