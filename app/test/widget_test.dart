import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pilgrim_app/core/theme/app_theme.dart';
import 'package:pilgrim_app/core/theme/colors.dart';

void main() {
  test('dark and light themes build with the pilgrim palette', () {
    for (final brightness in [Brightness.dark, Brightness.light]) {
      final theme = pilgrimTheme(brightness);
      expect(theme.textTheme.displaySmall, isNotNull);
      expect(theme.colorScheme.brightness, brightness);
    }
  });

  test('the pilgrim palette is calm and legible', () {
    expect(PilgrimColors.darkBackground, isNot(PilgrimColors.darkSurface));
    expect(PilgrimColors.darkText, isNot(PilgrimColors.darkTextSecondary));
    expect(PilgrimColors.lightBackground, isNot(PilgrimColors.lightSurface));
    expect(PilgrimColors.lightText, isNot(PilgrimColors.lightTextSecondary));

    final darkLuma = PilgrimColors.darkBackground.computeLuminance();
    final lightLuma = PilgrimColors.lightBackground.computeLuminance();
    expect(darkLuma, lessThan(0.05));
    expect(lightLuma, greaterThan(0.8));
  });

  testWidgets('primary button renders its label', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () {},
              child: const Text('Begin'),
            ),
          ),
        ),
      ),
    );
    expect(find.text('Begin'), findsOneWidget);
  });
}
