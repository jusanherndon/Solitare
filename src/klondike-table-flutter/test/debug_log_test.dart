import 'package:flutter_test/flutter_test.dart';
import 'package:klondike_table/game/debug_log.dart';
import 'package:klondike_table/game/history.dart';
import 'package:klondike_table/game/reducer.dart';
import 'package:klondike_table/game/rules.dart';

import 'board.dart';

GameMeta _played(GameState before, GameState after) =>
    GameMeta(present: after, past: [before]);

void main() {
  test('a fresh deal has no moves yet', () {
    final meta = initMeta(seed: 8);
    expect(debugMoveLog(meta), 'Seed 8 · Draw-one · Undo 0\n(no moves yet)');
  });

  test('records a Draw of the cards that landed on Waste', () {
    final before = board(stock: [c('hearts', 7, faceUp: false)]);
    final meta = _played(before, draw(before));
    expect(debugMoveLog(meta), contains('1. Draw 7♥'));
  });

  test('records a draw-three Draw in Waste order', () {
    final before = board(
      stock: [
        c('spades', 5, faceUp: false),
        c('hearts', 6, faceUp: false),
        c('clubs', 7, faceUp: false),
      ],
      drawType: DrawType.drawThree,
    );
    final meta = _played(before, draw(before));
    expect(debugMoveLog(meta), contains('1. Draw 7♣ 6♥ 5♠'));
  });

  test('records Recycle when Waste returns to Stock', () {
    final before = board(waste: [c('hearts', 5), c('clubs', 6)]);
    final meta = _played(before, draw(before));
    expect(debugMoveLog(meta), contains('1. Recycle'));
  });

  test('tags a Hint play', () {
    final before = board(
      tableau: [
        [c('clubs', 4, faceUp: false), c('spades', 13)],
        [],
        [],
        [],
        [],
        [],
        [],
      ],
    );
    final after = applyDrop(
      before,
      const PileRef.tableau(1),
      const PileRef.tableau(0),
      1,
    );
    expect(
      debugMoveLog(_played(before, after)),
      contains('1. K♠ Tableau 1 → Tableau 2 empty (Hint)'),
    );
  });

  test('tags a King-empty hop as not Hint', () {
    final before = board(
      tableau: [
        [c('spades', 13)],
        [],
        [],
        [],
        [],
        [],
        [],
      ],
    );
    final after = applyDrop(
      before,
      const PileRef.tableau(1),
      const PileRef.tableau(0),
      0,
    );
    expect(
      debugMoveLog(_played(before, after)),
      contains('1. K♠ Tableau 1 → Tableau 2 empty (not Hint)'),
    );
  });

  test('tags a built Tableau rehome as last-resort', () {
    final before = board(
      tableau: [
        [c('spades', 8), c('hearts', 7)],
        [c('clubs', 8)],
        [],
        [],
        [],
        [],
        [],
      ],
    );
    final after = applyDrop(
      before,
      const PileRef.tableau(1),
      const PileRef.tableau(0),
      1,
    );
    expect(
      debugMoveLog(_played(before, after)),
      contains('1. 7♥ Tableau 1 → Tableau 2 (last-resort)'),
    );
  });

  test('Undo drops the last recorded move', () {
    var meta = initMeta(seed: 8);
    meta = reduceMeta(meta, const GameMetaAction(DrawAction()));
    expect(debugMoveLog(meta), contains('1. Draw'));
    meta = reduceMeta(meta, const UndoMetaAction());
    expect(debugMoveLog(meta), 'Seed 8 · Draw-one · Undo 0\n(no moves yet)');
  });

  test('debugLastMove is the current last line, or null', () {
    final before = board(stock: [c('hearts', 7, faceUp: false)]);
    expect(debugLastMove(initMeta(seed: 8)), isNull);
    expect(debugLastMove(_played(before, draw(before))), '1. Draw 7♥');
  });

  test('Finish keeps every Foundation play on the move log', () {
    List<PlayingCard> run(String suit, int through) => [
      for (var r = 1; r <= through; r++) c(suit, r),
    ];
    final before = board(
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
    );
    var meta = GameMeta(present: before, past: const []);
    meta = reduceMeta(meta, const FinishMetaAction());
    final log = debugMoveLog(meta);
    expect(log, contains('1. K♠ Waste → Foundation 1'));
    expect(log, contains('2. K♥ Tableau 1 → Foundation 2'));
    expect(log, contains('3. K♦ Tableau 2 → Foundation 3'));
    expect(log, contains('4. K♣ Tableau 3 → Foundation 4'));
  });
}
