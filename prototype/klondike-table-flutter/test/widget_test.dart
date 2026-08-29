import 'package:flutter_test/flutter_test.dart';

import 'package:klondike_table/game/resume_store.dart';
import 'package:klondike_table/main.dart';

Future<void> _pumpApp(WidgetTester tester, {MemoryResumeStore? store}) async {
  await tester.pumpWidget(
    KlondikePrototypeApp(
      store: store ?? MemoryResumeStore(),
      openUrl: (_) async {},
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('Start screen shows New Game and About, not Resume', (
    tester,
  ) async {
    await _pumpApp(tester);
    expect(find.text('Klondike Solitaire'), findsOneWidget);
    expect(find.text('New Game'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);
    expect(find.text('Resume'), findsNothing);
    expect(find.text('Undo'), findsNothing);
    expect(find.text('A — Felt banner'), findsNothing);
  });

  testWidgets('New Game deals onto the table with chrome', (tester) async {
    await _pumpApp(tester);
    await tester.tap(find.text('New Game'));
    await tester.pump();
    expect(find.text('Undo'), findsOneWidget);
    expect(find.text('Start'), findsOneWidget);
  });

  testWidgets('Start keeps the Game; Resume returns', (tester) async {
    await _pumpApp(tester);
    await tester.tap(find.text('New Game'));
    await tester.pump();
    await tester.tap(find.text('Start'));
    await tester.pump();
    expect(find.text('Resume'), findsOneWidget);
    await tester.tap(find.text('Resume'));
    await tester.pump();
    expect(find.text('Undo'), findsOneWidget);
  });

  testWidgets('New Game from start with Resume asks to discard', (
    tester,
  ) async {
    await _pumpApp(tester);
    await tester.tap(find.text('New Game'));
    await tester.pump();
    await tester.tap(find.text('Start'));
    await tester.pump();
    await tester.tap(find.text('New Game'));
    await tester.pump();
    expect(
      find.text('This unfinished Game will be discarded.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Cancel'));
    await tester.pump();
    expect(find.text('Resume'), findsOneWidget);
  });
}
