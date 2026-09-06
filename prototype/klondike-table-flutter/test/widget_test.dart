import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:klondike_table/game/deal.dart';
import 'package:klondike_table/game/history.dart';
import 'package:klondike_table/game/resume_store.dart';
import 'package:klondike_table/game/rules.dart';
import 'package:klondike_table/game/settings_store.dart';
import 'package:klondike_table/game/winning_deal.dart';
import 'package:klondike_table/main.dart';
import 'package:klondike_table/ui/interactive_pile.dart';
import 'package:klondike_table/ui/klondike_table.dart';

import 'board.dart';

Future<void> _pumpApp(
  WidgetTester tester, {
  MemoryResumeStore? store,
  MemorySettingsStore? settings,
  Random? winningDealRandom,
}) async {
  await tester.pumpWidget(
    KlondikePrototypeApp(
      store: store ?? MemoryResumeStore(),
      settings: settings ?? MemorySettingsStore(),
      openUrl: (_) async {},
      winningDealRandom: winningDealRandom,
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
    expect(find.text('Winning deal'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Resume'), findsNothing);
    expect(find.text('Undo'), findsNothing);
    expect(find.text('A — Felt banner'), findsNothing);
  });

  testWidgets('New Game deals onto the table with chrome', (tester) async {
    await _pumpApp(tester);
    await tester.tap(find.text('New Game'));
    await tester.pump();
    expect(find.text('Undo'), findsOneWidget);
    expect(find.text('Hint'), findsOneWidget);
    expect(find.text('Start'), findsOneWidget);
    expect(find.text('Winning deal'), findsNothing);
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

  testWidgets('Settings Draw three deals a draw-three Game', (tester) async {
    await _pumpApp(tester);
    await tester.tap(find.text('Settings'));
    await tester.pump();
    expect(find.text('Draw three'), findsOneWidget);
    expect(find.text('Fast Finish'), findsOneWidget);
    expect(find.text('Left-handed'), findsOneWidget);
    expect(find.text('Waste on left'), findsOneWidget);
    expect(find.text('Off'), findsNWidgets(4));
    await tester.tap(find.text('Draw three'));
    await tester.pump();
    expect(find.text('On'), findsOneWidget);
    await tester.tap(find.text('Start'));
    await tester.pump();
    await tester.tap(find.text('New Game'));
    await tester.pump();
    expect(find.byKey(const ValueKey(DrawType.drawThree)), findsOneWidget);
  });

  testWidgets('Resume restores draw-three even if Settings is off', (
    tester,
  ) async {
    final store = MemoryResumeStore();
    await store.save(
      GameMeta(
        present: dealGame(seed: 3, drawType: DrawType.drawThree),
        past: const [],
      ),
    );
    await _pumpApp(tester, store: store);
    expect(find.text('Resume'), findsOneWidget);
    await tester.tap(find.text('Resume'));
    await tester.pump();
    expect(find.byKey(const ValueKey(DrawType.drawThree)), findsOneWidget);
  });

  GameMeta finishable() {
    List<PlayingCard> run(String suit, int through) => [
      for (var r = 1; r <= through; r++) c(suit, r),
    ];
    return GameMeta(
      present: board(
        waste: [c('spades', 13)],
        foundations: [
          run('spades', 12),
          run('hearts', 12),
          run('diamonds', 12),
          run('clubs', 12),
        ],
        tableau: [
          [c('hearts', 13)],
          [c('diamonds', 13)],
          [c('clubs', 13)],
          [],
          [],
          [],
          [],
        ],
      ),
      past: const [],
    );
  }

  testWidgets('Resume of a finishable Game shows Finish!', (tester) async {
    final store = MemoryResumeStore();
    await store.save(finishable());
    await _pumpApp(tester, store: store);
    await tester.tap(find.text('Resume'));
    await tester.pump();
    expect(find.text('Finish!'), findsOneWidget);
    expect(find.text('Finish'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
    expect(find.text('Winning deal'), findsNothing);
  });

  testWidgets('Continue hides Finish and lets play continue', (tester) async {
    final store = MemoryResumeStore();
    await store.save(finishable());
    await _pumpApp(tester, store: store);
    await tester.tap(find.text('Resume'));
    await tester.pump();
    await tester.tap(find.text('Continue'));
    await tester.pump();
    expect(find.text('Finish!'), findsNothing);
    expect(find.text('Hint'), findsOneWidget);
  });

  testWidgets('Finish runs through to You won', (tester) async {
    final store = MemoryResumeStore();
    await store.save(finishable());
    await _pumpApp(tester, store: store);
    await tester.tap(find.text('Resume'));
    await tester.pump();
    await tester.tap(find.text('Finish'));
    await tester.pump();
    expect(find.text('Finish!'), findsNothing);
    for (var i = 0; i < 12; i++) {
      await tester.pump(KlondikeTable.finishFlight);
    }
    expect(find.text('You won!'), findsOneWidget);
    expect(find.text('Winning deal'), findsOneWidget);
  });

  testWidgets('Settings Fast Finish is off by default and can turn on', (
    tester,
  ) async {
    await _pumpApp(tester);
    await tester.tap(find.text('Settings'));
    await tester.pump();
    expect(find.text('Fast Finish'), findsOneWidget);
    expect(find.text('Off'), findsNWidgets(4));
    await tester.tap(find.text('Fast Finish'));
    await tester.pump();
    expect(find.text('On'), findsOneWidget);
    expect(find.text('Off'), findsNWidgets(3));
  });

  testWidgets('Fast Finish persists independent of Draw three', (tester) async {
    final settings = MemorySettingsStore();
    await _pumpApp(tester, settings: settings);
    await tester.tap(find.text('Settings'));
    await tester.pump();
    await tester.tap(find.text('Fast Finish'));
    await tester.pump();
    expect(await settings.loadFastFinish(), isTrue);
    expect(await settings.loadDrawThree(), isFalse);
    expect(await settings.loadLeftHanded(), isFalse);
    expect(await settings.loadWasteOnLeft(), isFalse);
  });

  testWidgets('Fast Finish runs the Finish animation at double speed', (
    tester,
  ) async {
    final store = MemoryResumeStore();
    await store.save(finishable());
    await _pumpApp(
      tester,
      store: store,
      settings: MemorySettingsStore(fastFinish: true),
    );
    await tester.tap(find.text('Resume'));
    await tester.pump();
    await tester.tap(find.text('Finish'));
    await tester.pump();
    expect(find.text('Finish!'), findsNothing);
    for (var i = 0; i < 12; i++) {
      await tester.pump(KlondikeTable.fastFinishFlight);
    }
    expect(find.text('You won!'), findsOneWidget);
  });

  testWidgets('Winning deal deals a random seed from the Settings pool', (
    tester,
  ) async {
    const rngSeed = 42;
    final expected = pickWinningDealSeed(DrawType.drawOne, Random(rngSeed));
    await _pumpApp(tester, winningDealRandom: Random(rngSeed));
    await tester.tap(find.text('Winning deal'));
    await tester.pump();
    final table = tester.widget<KlondikeTable>(find.byType(KlondikeTable));
    expect(boardKey(table.meta.present), boardKey(dealGame(seed: expected)));
    expect(table.meta.past, isEmpty);
    expect(find.text('Winning deal'), findsNothing);
  });

  testWidgets('Winning deal uses the draw-three pool when Draw three is on', (
    tester,
  ) async {
    const rngSeed = 7;
    final expected = pickWinningDealSeed(DrawType.drawThree, Random(rngSeed));
    await _pumpApp(tester, winningDealRandom: Random(rngSeed));
    await tester.tap(find.text('Settings'));
    await tester.pump();
    await tester.tap(find.text('Draw three'));
    await tester.pump();
    await tester.tap(find.text('Start'));
    await tester.pump();
    await tester.tap(find.text('Winning deal'));
    await tester.pump();
    final table = tester.widget<KlondikeTable>(find.byType(KlondikeTable));
    expect(
      boardKey(table.meta.present),
      boardKey(dealGame(seed: expected, drawType: DrawType.drawThree)),
    );
    expect(find.byKey(const ValueKey(DrawType.drawThree)), findsOneWidget);
  });

  testWidgets('Winning deal from start with Resume asks to discard', (
    tester,
  ) async {
    await _pumpApp(tester);
    await tester.tap(find.text('New Game'));
    await tester.pump();
    await tester.tap(find.text('Start'));
    await tester.pump();
    await tester.tap(find.text('Winning deal'));
    await tester.pump();
    expect(
      find.text('This unfinished Game will be discarded.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Cancel'));
    await tester.pump();
    expect(find.text('Resume'), findsOneWidget);
  });

  testWidgets('loss overlay has Winning deal next to New Game', (tester) async {
    final store = MemoryResumeStore();
    await store.save(
      GameMeta(
        present: board(
          tableau: [
            [c('hearts', 2)],
            [],
            [],
            [],
            [],
            [],
            [],
          ],
        ),
        past: const [],
      ),
    );
    await _pumpApp(tester, store: store);
    await tester.tap(find.text('Resume'));
    await tester.pump();
    expect(find.text('You lost.'), findsOneWidget);
    expect(find.text('Winning deal'), findsOneWidget);
  });

  Finder foundation0() => find.byWidgetPredicate(
    (w) => w is InteractivePile && w.pile == const PileRef.foundation(0),
  );

  Finder wastePile() => find.byWidgetPredicate(
    (w) => w is InteractivePile && w.pile == const PileRef.waste(),
  );

  testWidgets('Stock then Waste sit on the right by default', (tester) async {
    await _pumpApp(tester);
    await tester.tap(find.text('New Game'));
    await tester.pump();
    final stock = tester.getTopLeft(find.byType(StockPile));
    final waste = tester.getTopLeft(wastePile());
    final foundation = tester.getTopLeft(foundation0());
    expect(stock.dx, greaterThan(foundation.dx));
    expect(waste.dx, greaterThan(stock.dx));
  });

  testWidgets('Left-handed Settings keeps Stock then Waste on the left', (
    tester,
  ) async {
    await _pumpApp(tester);
    await tester.tap(find.text('Settings'));
    await tester.pump();
    await tester.tap(find.text('Left-handed'));
    await tester.pump();
    await tester.tap(find.text('Start'));
    await tester.pump();
    await tester.tap(find.text('New Game'));
    await tester.pump();
    final stock = tester.getTopLeft(find.byType(StockPile));
    final waste = tester.getTopLeft(wastePile());
    final foundation = tester.getTopLeft(foundation0());
    expect(stock.dx, lessThan(foundation.dx));
    expect(waste.dx, greaterThan(stock.dx));
  });

  testWidgets('Left-handed persists independent of Draw three', (tester) async {
    final settings = MemorySettingsStore();
    await _pumpApp(tester, settings: settings);
    await tester.tap(find.text('Settings'));
    await tester.pump();
    await tester.tap(find.text('Left-handed'));
    await tester.pump();
    expect(await settings.loadLeftHanded(), isTrue);
    expect(await settings.loadDrawThree(), isFalse);
  });

  testWidgets('Waste on left Settings puts Waste to the left of Stock', (
    tester,
  ) async {
    await _pumpApp(tester);
    await tester.tap(find.text('Settings'));
    await tester.pump();
    await tester.tap(find.text('Waste on left'));
    await tester.pump();
    await tester.tap(find.text('Start'));
    await tester.pump();
    await tester.tap(find.text('New Game'));
    await tester.pump();
    final stock = tester.getTopLeft(find.byType(StockPile));
    final waste = tester.getTopLeft(wastePile());
    expect(waste.dx, lessThan(stock.dx));
  });

  testWidgets(
    'Waste on left still puts Waste left of Stock in Left-handed layout',
    (tester) async {
      await _pumpApp(tester);
      await tester.tap(find.text('Settings'));
      await tester.pump();
      await tester.tap(find.text('Left-handed'));
      await tester.pump();
      await tester.tap(find.text('Waste on left'));
      await tester.pump();
      await tester.tap(find.text('Start'));
      await tester.pump();
      await tester.tap(find.text('New Game'));
      await tester.pump();
      final stock = tester.getTopLeft(find.byType(StockPile));
      final waste = tester.getTopLeft(wastePile());
      final foundation = tester.getTopLeft(foundation0());
      expect(stock.dx, lessThan(foundation.dx));
      expect(waste.dx, lessThan(stock.dx));
    },
  );

  testWidgets('Waste on left persists independent of Left-handed', (
    tester,
  ) async {
    final settings = MemorySettingsStore();
    await _pumpApp(tester, settings: settings);
    await tester.tap(find.text('Settings'));
    await tester.pump();
    await tester.tap(find.text('Waste on left'));
    await tester.pump();
    expect(await settings.loadWasteOnLeft(), isTrue);
    expect(await settings.loadLeftHanded(), isFalse);
  });
}
