import 'package:flutter_test/flutter_test.dart';
import 'package:klondike_table/game/hint_bot.dart';
import 'package:klondike_table/game/history.dart';
import 'package:klondike_table/game/rules.dart';

import 'board.dart';

List<PlayingCard> _run(String suit, int through) => [
  for (var r = 1; r <= through; r++) c(suit, r),
];

void main() {
  test('hint bot finishes when only Foundation plays remain', () {
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
    expect(
      followHintsOn(GameMeta(present: state, past: const [])),
      HintBotResult.win,
    );
  });

  test('hint bot skips a last-resort loss', () {
    final state = board(
      tableau: [
        [c('hearts', 2)],
        [],
        [],
        [],
        [],
        [],
        [],
      ],
    );
    expect(
      followHintsOn(GameMeta(present: state, past: const [])),
      HintBotResult.skip,
    );
  });

  test(
    'hint bot skips when draw-three recycle never uncovers a buried play',
    () {
      final state = board(
        drawType: DrawType.drawThree,
        stock: [
          c('clubs', 5, faceUp: false),
          c('clubs', 1, faceUp: false),
          c('hearts', 9, faceUp: false),
        ],
        tableau: [
          [c('hearts', 2)],
          [],
          [],
          [],
          [],
          [],
          [],
        ],
      );
      expect(
        followHintsOn(GameMeta(present: state, past: const [])),
        HintBotResult.skip,
      );
    },
  );
}
