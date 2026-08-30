import 'package:flutter_test/flutter_test.dart';
import 'package:klondike_table/game/reducer.dart';
import 'package:klondike_table/game/rules.dart';

import 'board.dart';

GameState auto(GameState state, PileRef from, [int? cardIndex]) =>
    applyAutoMove(state, from, cardIndex);

void main() {
  test('Auto-move sends a Waste Ace to an empty Foundation', () {
    final next = auto(board(waste: [c('hearts', 1)]), const PileRef.waste());
    expect(next.waste, isEmpty);
    expect(next.foundations[0].last.rank, 1);
  });

  test('Auto-move prefers Foundation over Tableau', () {
    final next = auto(
      board(
        foundations: [
          [c('hearts', 1)],
          [],
          [],
          [],
        ],
        tableau: [
          [c('hearts', 2)],
          [c('spades', 3)],
          [],
          [],
          [],
          [],
          [],
        ],
      ),
      const PileRef.tableau(0),
    );
    expect(next.tableau[0], isEmpty);
    expect(next.foundations[0].last.rank, 2);
  });

  test('Auto-move does not hop a Foundation Ace to another Foundation', () {
    final state = board(
      foundations: [
        [c('clubs', 1)],
        [],
        [],
        [],
      ],
    );
    final next = auto(state, const PileRef.foundation(0));
    expect(next.foundations[0].single.suit, 'clubs');
    expect(next.foundations[1], isEmpty);
  });

  test('Auto-move does not pull a Foundation Ace onto Tableau', () {
    final state = board(
      foundations: [
        [c('clubs', 1)],
        [],
        [],
        [],
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
    final next = auto(state, const PileRef.foundation(0));
    expect(next.foundations[0].single.rank, 1);
    expect(next.tableau[0].single.rank, 2);
  });

  test('Auto-move pulls a Foundation 3 onto Tableau when a 2 is waiting', () {
    final next = auto(
      board(
        foundations: [
          [c('hearts', 1), c('hearts', 2), c('hearts', 3)],
          [],
          [],
          [],
        ],
        tableau: [
          [c('spades', 4)],
          [c('clubs', 2)],
          [],
          [],
          [],
          [],
          [],
        ],
      ),
      const PileRef.foundation(0),
    );
    expect(next.foundations[0].last.rank, 2);
    expect(next.tableau[0].last.rank, 3);
  });

  test('Auto-move does not shift a Tableau run that is already stacked', () {
    final state = board(
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
    final next = auto(state, const PileRef.tableau(0), 1);
    expect(next.tableau[0].last.rank, 7);
    expect(next.tableau[1].single.rank, 8);
  });

  test(
    'Auto-move does shift a stacked Tableau run when it frees a Foundation',
    () {
      final next = auto(
        board(
          foundations: [
            [
              c('spades', 1),
              c('spades', 2),
              c('spades', 3),
              c('spades', 4),
              c('spades', 5),
              c('spades', 6),
              c('spades', 7),
            ],
            [],
            [],
            [],
          ],
          tableau: [
            [c('spades', 8), c('hearts', 7)],
            [c('clubs', 8)],
            [],
            [],
            [],
            [],
            [],
          ],
        ),
        const PileRef.tableau(0),
        1,
      );
      expect(next.tableau[0].single.rank, 8);
      expect(next.tableau[1].last.rank, 7);
    },
  );

  test('Auto-move does not relocate a built King tower', () {
    final state = board(
      tableau: [
        [c('spades', 13), c('hearts', 12)],
        [],
        [],
        [],
        [],
        [],
        [],
      ],
    );
    final next = auto(state, const PileRef.tableau(0), 0);
    expect(next.tableau[0].length, 2);
    expect(next.tableau[1], isEmpty);
  });

  test('Auto-move does not hop a lone King already on an empty pile', () {
    final state = board(
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
    final next = auto(state, const PileRef.tableau(0));
    expect(next.tableau[0].single.rank, 13);
    expect(next.tableau[1], isEmpty);
  });
}
