import 'package:flutter_test/flutter_test.dart';
import 'package:klondike_table/game/codec.dart';
import 'package:klondike_table/game/deal.dart';
import 'package:klondike_table/game/hint.dart';
import 'package:klondike_table/game/history.dart';
import 'package:klondike_table/game/loss.dart';
import 'package:klondike_table/game/reducer.dart';
import 'package:klondike_table/game/rules.dart';

import 'board.dart';

List<List<PlayingCard>> _emptyTableau() => [[], [], [], [], [], [], []];

void main() {
  test('opening deal is not a loss', () {
    expect(isLoss(dealGame(seed: 1)), isFalse);
  });

  test('full Foundations is a win, not a loss', () {
    final foundations = [
      for (final suit in suits) [for (var r = 1; r <= 13; r++) c(suit, r)],
    ];
    final state = board(foundations: foundations, won: true);
    expect(isWin(state.foundations), isTrue);
    expect(isLoss(state), isFalse);
  });

  test('empty Stock and Waste with no Tableau play is a loss', () {
    final state = board(
      tableau: [
        [c('hearts', 2)],
        ..._emptyTableau().skip(1),
      ],
    );
    expect(isLoss(state), isTrue);
  });

  test('a King covering a face-down card with an empty pile is not a loss', () {
    final state = board(
      tableau: [
        [c('clubs', 4, faceUp: false), c('spades', 13)],
        ..._emptyTableau().skip(1),
      ],
    );
    expect(isLoss(state), isFalse);
  });

  test('a face-down Stock Ace that can play blocks a loss', () {
    final state = board(
      stock: [c('clubs', 1, faceUp: false)],
      tableau: [
        [c('hearts', 2)],
        ..._emptyTableau().skip(1),
      ],
    );
    expect(hasActiveHint(state), isFalse);
    expect(isLoss(state), isFalse);
  });

  test(
    'Stock cards that cannot play on the current table do not block a loss',
    () {
      final state = board(
        stock: [c('clubs', 5, faceUp: false)],
        tableau: [
          [c('hearts', 2)],
          ..._emptyTableau().skip(1),
        ],
      );
      expect(isLoss(state), isTrue);
    },
  );

  test('a buried draw-three Waste Ace blocks a loss', () {
    final state = board(
      drawType: DrawType.drawThree,
      waste: [c('clubs', 1), c('hearts', 5)],
      tableau: [
        [c('hearts', 2)],
        ..._emptyTableau().skip(1),
      ],
    );
    expect(hasActiveHint(state), isFalse);
    expect(isLoss(state), isFalse);
  });

  test('repeats do not block a loss', () {
    final after = board(
      tableau: [
        [],
        [c('clubs', 8), c('hearts', 7)],
        [],
        [],
        [],
        [],
        [],
      ],
    );
    final state = board(
      tableau: [
        [c('hearts', 7)],
        [c('clubs', 8)],
        [],
        [],
        [],
        [],
        [],
      ],
      seenFaceUp: {faceUpTableKey(after)},
    );
    expect(hintCycle(state), isNotEmpty);
    expect(hasActiveHint(state), isFalse);
    expect(isLoss(state), isTrue);
  });

  test('Undo drops face-up tables that only existed after the undone play', () {
    var meta = GameMeta(present: dealGame(seed: 1), past: const []);
    final openingSeen = {...meta.present.seenFaceUp};
    meta = reduceMeta(meta, const GameMetaAction(DrawAction()));
    expect(meta.present.seenFaceUp.length, greaterThan(openingSeen.length));
    meta = reduceMeta(meta, const UndoMetaAction());
    expect(meta.present.seenFaceUp, openingSeen);
  });

  test('Resume codec round-trips seen face-up tables', () {
    final state = board(waste: [c('hearts', 1)], seenFaceUp: {'already-seen'});
    final restored = decodeMeta(
      encodeMeta(GameMeta(present: state, past: const [])),
    );
    expect(restored.present.seenFaceUp, {'already-seen'});
  });
}
