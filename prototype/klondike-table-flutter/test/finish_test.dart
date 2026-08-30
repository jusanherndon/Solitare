import 'package:flutter_test/flutter_test.dart';
import 'package:klondike_table/game/codec.dart';
import 'package:klondike_table/game/finish.dart';
import 'package:klondike_table/game/history.dart';
import 'package:klondike_table/game/rules.dart';

import 'board.dart';

List<PlayingCard> _run(String suit, int through) => [
  for (var r = 1; r <= through; r++) c(suit, r),
];

void main() {
  test('Finish gate holds when only Foundation plays remain', () {
    final state = board(
      waste: [c('spades', 13)],
      foundations: [
        _run('spades', 12),
        _run('hearts', 12),
        _run('diamonds', 12),
        _run('clubs', 12),
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
    expect(canFinish(state), isTrue);
    final won = applyFinish(state);
    expect(won.won, isTrue);
    expect(isWin(won.foundations), isTrue);
  });

  test('Finish gate is false when a Tableau play is still needed', () {
    final state = board(
      foundations: [_run('hearts', 4), [], [], []],
      tableau: [
        [c('hearts', 5), c('clubs', 4)],
        [],
        [],
        [],
        [],
        [],
        [],
      ],
    );
    expect(canFinish(state), isFalse);
  });

  test('Finish gate is false while any card is face-down', () {
    final state = board(
      waste: [c('spades', 13)],
      foundations: [
        _run('spades', 12),
        _run('hearts', 13),
        _run('diamonds', 13),
        _run('clubs', 13),
      ],
      tableau: [
        [c('hearts', 12, faceUp: false)],
        [],
        [],
        [],
        [],
        [],
        [],
      ],
    );
    expect(canFinish(state), isFalse);
  });

  test('Continue hides Finish for the rest of the Game, including Undo', () {
    final state = board(
      waste: [c('spades', 13)],
      foundations: [
        _run('spades', 12),
        _run('hearts', 12),
        _run('diamonds', 12),
        _run('clubs', 12),
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
    var meta = GameMeta(present: state, past: const []);
    expect(canFinish(meta.present) && !meta.finishContinued, isTrue);
    meta = reduceMeta(meta, const ContinueFinishMetaAction());
    expect(meta.finishContinued, isTrue);
    meta = reduceMeta(meta, const UndoMetaAction());
    expect(meta.finishContinued, isTrue);
  });

  test('Finish cannot be undone', () {
    final state = board(
      waste: [c('spades', 13)],
      foundations: [
        _run('spades', 12),
        _run('hearts', 12),
        _run('diamonds', 12),
        _run('clubs', 12),
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
    var meta = GameMeta(present: state, past: [state]);
    meta = reduceMeta(meta, const FinishMetaAction());
    expect(meta.present.won, isTrue);
    expect(meta.past, isEmpty);
  });

  test('each Finish step moves one card onto a Foundation', () {
    final state = board(
      waste: [c('spades', 13)],
      foundations: [
        _run('spades', 12),
        _run('hearts', 12),
        _run('diamonds', 12),
        _run('clubs', 12),
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
    expect(nextFinishPlay(state)!.from, const PileRef.waste());
    var meta = GameMeta(present: state, past: const []);
    meta = reduceMeta(meta, const FinishStepMetaAction());
    expect(meta.present.won, isFalse);
    expect(meta.present.waste, isEmpty);
    expect(meta.present.foundations[0].last.rank, 13);
  });

  test('Resume restores the Continue opted-out flag', () {
    final restored = decodeMeta(
      encodeMeta(
        GameMeta(
          present: board(waste: [c('hearts', 1)]),
          past: const [],
          finishContinued: true,
        ),
      ),
    );
    expect(restored.finishContinued, isTrue);
  });
}
