import 'package:flutter_test/flutter_test.dart';
import 'package:pilgrim_content/pilgrim_content.dart';

import 'package:pilgrim_admin/main.dart';

AdminState _loadedState() {
  final state = AdminState();
  state.applyContent(BundleContent(
    plans: [
      PlanDefinition(
        slug: 'slow-walk',
        title: 'Slow Walk',
        description: 'A gentle pace for careful study.',
        kind: 'sequential',
        days: [
          PlanDay(
            day: 1,
            readings: [const ReadingRef(book: 'Genesis', start: 1)],
            estimatedMinutes: 2,
          ),
        ],
      ),
    ],
    reflectionPrompts: ['What stood out today?', 'What challenged you?'],
    notificationMessages: ['The Word is waiting.', 'Grace and peace.'],
  ));
  return state;
}

void main() {
  testWidgets('content tab renders plans', (WidgetTester tester) async {
    await tester.pumpWidget(PilgrimAdminApp(state: _loadedState()));
    await tester.pumpAndSettle();

    expect(find.text('Pilgrim Admin'), findsOneWidget);
    expect(find.text('Reading plans'), findsOneWidget);
    expect(find.text('slow-walk'), findsOneWidget);
    expect(find.text('1 days'), findsOneWidget);
  });

  testWidgets('copy tab lists prompts and messages',
      (WidgetTester tester) async {
    await tester.pumpWidget(PilgrimAdminApp(state: _loadedState()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Copy'));
    await tester.pumpAndSettle();

    expect(find.text('Reflection prompts'), findsOneWidget);
    expect(find.text('Notification messages'), findsOneWidget);
    expect(find.text('What stood out today?'), findsOneWidget);
    expect(find.text('The Word is waiting.'), findsOneWidget);
  });
}
