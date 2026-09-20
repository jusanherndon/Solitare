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

  test(
    'a buried draw-three Waste Ace that recycle cannot turn up is a loss',
    () {
      final state = board(
        drawType: DrawType.drawThree,
        waste: [c('clubs', 1), c('hearts', 5)],
        tableau: [
          [c('hearts', 2)],
          ..._emptyTableau().skip(1),
        ],
      );
      expect(hasActiveHint(state), isFalse);
      expect(isLoss(state), isTrue);
    },
  );

  test(
    'a draw-three Stock Ace that the next draw turns up blocks a loss',
    () {
      final state = board(
        drawType: DrawType.drawThree,
        stock: [c('clubs', 1, faceUp: false)],
        waste: [c('hearts', 5)],
        tableau: [
          [c('hearts', 2)],
          ..._emptyTableau().skip(1),
        ],
      );
      expect(hasActiveHint(state), isFalse);
      expect(isLoss(state), isFalse);
    },
  );

  test(
    'a buried draw-three Waste Queen that never becomes the top is a loss',
    () {
      final state = board(
        drawType: DrawType.drawThree,
        waste: [c('clubs', 12), c('spades', 6), c('spades', 11)],
        tableau: [
          [c('hearts', 13)],
          ..._emptyTableau().skip(1),
        ],
      );
      expect(hasActiveHint(state), isFalse);
      expect(cardCanPlayOnTable(c('clubs', 12), state), isTrue);
      expect(isLoss(state), isTrue);
    },
  );

  test(
    'draw-three Waste 6-Q-J cannot play on a black King, so that is a loss',
    () {
      final state = board(
        drawType: DrawType.drawThree,
        waste: [c('spades', 6), c('clubs', 12), c('spades', 11)],
        foundations: [
          [c('spades', 1), c('spades', 2)],
          [c('hearts', 1), c('hearts', 2), c('hearts', 3)],
          [c('clubs', 1)],
          [c('diamonds', 1)],
        ],
        tableau: [
          [c('hearts', 13), c('spades', 12)],
          [c('diamonds', 13, faceUp: false), c('diamonds', 3)],
          [c('spades', 13)],
          ..._emptyTableau().skip(3),
        ],
      );
      expect(cardCanPlayOnTable(c('clubs', 12), state), isFalse);
      expect(hasActiveHint(state), isFalse);
      expect(isLoss(state), isTrue);
    },
  );

  test(
    'a draw-three Waste Ace that a later recycle turns up blocks a loss',
    () {
      final state = board(
        drawType: DrawType.drawThree,
        waste: [
          c('hearts', 5),
          c('spades', 6),
          c('clubs', 1),
          c('clubs', 7),
        ],
        tableau: [
          [c('hearts', 2)],
          ..._emptyTableau().skip(1),
        ],
      );
      expect(hasActiveHint(state), isFalse);
      expect(isLoss(state), isFalse);
    },
  );

  test('a new Tableau-run shift onto another pile is not a loss', () {
    final state = board(
      tableau: [
        [c('clubs', 6), c('hearts', 5), c('spades', 4)],
        [c('spades', 6)],
        [],
        [],
        [],
        [],
        [],
      ],
    );
    expect(hasActiveHint(state), isFalse);
    expect(hintCycle(state), isEmpty);
    expect(isLoss(state), isFalse);
  });

  test('a King hopping from one empty pile to another is still a loss', () {
    final state = board(
      tableau: [
        [c('hearts', 13)],
        [c('hearts', 2)],
        [],
        [],
        [],
        [],
        [],
      ],
    );
    expect(hintCycle(state), isEmpty);
    expect(isLoss(state), isTrue);
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

  test('Resume codec round-trips Hint loop-stops', () {
    final stop = HintLoopStop(
      cardId: 'clubs-3',
      from: const PileRef.foundation(0),
      onto: const PileRef.tableau(0),
    );
    final state = board(
      waste: [c('hearts', 1)],
    ).copyWith(hintLoopStops: [stop]);
    final restored = decodeMeta(
      encodeMeta(GameMeta(present: state, past: const [])),
    );
    expect(restored.present.hintLoopStops, [stop]);
  });
}
