import 'package:flutter_test/flutter_test.dart';
import 'package:klondike_table/game/hint.dart';
import 'package:klondike_table/game/history.dart';
import 'package:klondike_table/game/reducer.dart';
import 'package:klondike_table/game/rules.dart';

import 'board.dart';

void main() {
  test('Hint is empty when no legal face-up play remains', () {
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
    expect(hintCycle(state), isEmpty);
    expect(hasActiveHint(state), isFalse);
  });

  test('Hint does not move a King from one empty pile to another', () {
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
    expect(
      hintCycle(state).any(
        (p) =>
            p.from == const PileRef.tableau(0) &&
            p.onto.area == PileArea.tableau,
      ),
      isFalse,
    );
  });

  test(
    'Hint lists a King onto an empty Tableau pile when it uncovers a card',
    () {
      final state = board(
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
      final cycle = hintCycle(state);
      expect(cycle, isNotEmpty);
      expect(
        cycle.first,
        HintPlay(
          from: const PileRef.tableau(0),
          cardIndex: 1,
          onto: const PileRef.tableau(1),
        ),
      );
    },
  );

  test('new Hints come before repeats, and wrap returns to the first new', () {
    final repeatTable = board(
      waste: [c('hearts', 1)],
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
      waste: [c('hearts', 1)],
      tableau: [
        [c('hearts', 7)],
        [c('clubs', 8)],
        [],
        [],
        [],
        [],
        [],
      ],
      seenFaceUp: {faceUpTableKey(repeatTable)},
    );
    final cycle = hintCycle(state);
    expect(cycle, isNotEmpty);
    expect(cycle.first.from.area, PileArea.waste);
    expect(cycle.first.onto.area, PileArea.foundation);
    expect(
      cycle.any((p) => p.from.area == PileArea.tableau),
      isFalse,
      reason: 'repeat Tableau shift is hidden while a new play exists',
    );
    final cursor = HintCursor(cycle);
    for (var i = 0; i < cycle.length; i++) {
      cursor.advance();
    }
    expect(cursor.current, cycle.first);
  });

  test('draw-three Hint uses only the Waste top, not a buried card', () {
    final state = board(
      drawType: DrawType.drawThree,
      waste: [c('clubs', 1), c('hearts', 5)],
      foundations: const [[], [], [], []],
    );
    final fromWaste = hintCycle(
      state,
    ).where((p) => p.from.area == PileArea.waste);
    for (final play in fromWaste) {
      expect(play.cardIndex, 1);
    }
    expect(fromWaste.any((p) => p.onto.area == PileArea.foundation), isFalse);
  });

  test('Hint cycle rebuilds after a Tableau play', () {
    final opening = board(
      tableau: [
        [c('clubs', 4, faceUp: false), c('spades', 13)],
        [c('hearts', 12)],
        [],
        [],
        [],
        [],
        [],
      ],
    );
    final before = hintCycle(opening);
    expect(before, isNotEmpty);
    var meta = GameMeta(present: opening, past: const []);
    meta = reduceMeta(
      meta,
      GameMetaAction(
        DropAction(
          const PileRef.tableau(2),
          from: const PileRef.tableau(0),
          cardIndex: 1,
        ),
      ),
    );
    final after = hintCycle(meta.present);
    expect(after, isNot(equals(before)));
  });

  test('Hint does not move a Foundation card onto another Foundation', () {
    final state = board(
      foundations: [
        [c('clubs', 1)],
        [],
        [],
        [],
      ],
    );
    expect(
      hintCycle(state).any(
        (p) =>
            p.from.area == PileArea.foundation &&
            p.onto.area == PileArea.foundation,
      ),
      isFalse,
    );
  });

  test(
    'Hint last-resort prefers the leftmost Foundation pull that unlocks a draw',
    () {
      final state = board(
        stock: [c('clubs', 2, faceUp: false)],
        foundations: [
          [c('hearts', 1), c('hearts', 2), c('hearts', 3)],
          [],
          [],
          [],
        ],
        tableau: [
          [c('spades', 4)],
          [c('clubs', 4)],
          [],
          [],
          [],
          [],
          [],
        ],
      );
      expect(
        hintCycle(state).first,
        HintPlay(
          from: const PileRef.foundation(0),
          cardIndex: 2,
          onto: const PileRef.tableau(0),
        ),
      );
    },
  );

  test(
    'Hint does not last-resort a Tableau rehome that cannot uncover a play',
    () {
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
      expect(hintCycle(state), isEmpty);
      expect(hasActiveHint(state), isFalse);
    },
  );

  test(
    'Hint does shift a stacked Tableau run when it frees a Foundation play',
    () {
      final state = board(
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
      );
      expect(
        hintCycle(state).any(
          (p) =>
              p.from == const PileRef.tableau(0) &&
              p.onto == const PileRef.tableau(1),
        ),
        isTrue,
      );
    },
  );

  test('Hint does not relocate a built King tower to another empty pile', () {
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
    expect(
      hintCycle(state).any(
        (p) =>
            p.from == const PileRef.tableau(0) &&
            p.onto.area == PileArea.tableau,
      ),
      isFalse,
    );
  });

  test('Hint still moves a Tableau run off a face-down card', () {
    final state = board(
      tableau: [
        [c('spades', 10, faceUp: false), c('hearts', 7)],
        [c('clubs', 8)],
        [],
        [],
        [],
        [],
        [],
      ],
    );
    expect(
      hintCycle(state).any(
        (p) =>
            p.from == const PileRef.tableau(0) &&
            p.onto == const PileRef.tableau(1),
      ),
      isTrue,
    );
  });

  test('Hint does not pull a Foundation Ace onto Tableau', () {
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
    expect(
      hintCycle(state).any((p) => p.from.area == PileArea.foundation),
      isFalse,
    );
  });

  test('Hint still does not pull a Foundation Ace when Waste is showing', () {
    final state = board(
      waste: [c('diamonds', 5)],
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
    expect(
      hintCycle(state).any((p) => p.from.area == PileArea.foundation),
      isFalse,
    );
  });

  test('Hint pulls a Foundation 3 onto Tableau when a 2 is waiting', () {
    final state = board(
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
    );
    expect(
      hintCycle(state).any(
        (p) =>
            p.from == const PileRef.foundation(0) &&
            p.onto == const PileRef.tableau(0),
      ),
      isTrue,
    );
  });

  test('Hint pulls a Foundation 3 onto Tableau when Waste shows a 2', () {
    final state = board(
      waste: [c('clubs', 2)],
      foundations: [
        [c('hearts', 1), c('hearts', 2), c('hearts', 3)],
        [],
        [],
        [],
      ],
      tableau: [
        [c('spades', 4)],
        [],
        [],
        [],
        [],
        [],
        [],
      ],
    );
    expect(
      hintCycle(state).any(
        (p) =>
            p.from == const PileRef.foundation(0) &&
            p.onto == const PileRef.tableau(0),
      ),
      isTrue,
    );
  });

  test('Hint pulls a Foundation card when it frees a stacked waiting card', () {
    final state = board(
      foundations: [
        [
          c('hearts', 1),
          c('hearts', 2),
          c('hearts', 3),
          c('hearts', 4),
          c('hearts', 5),
          c('hearts', 6),
        ],
        [],
        [
          c('diamonds', 1),
          c('diamonds', 2),
          c('diamonds', 3),
          c('diamonds', 4),
          c('diamonds', 5),
        ],
        [],
      ],
      tableau: [
        [c('spades', 7)],
        [c('diamonds', 6), c('clubs', 5)],
        [],
        [],
        [],
        [],
        [],
      ],
    );
    expect(
      hintCycle(state).any(
        (p) =>
            p.from == const PileRef.foundation(0) &&
            p.onto == const PileRef.tableau(0),
      ),
      isTrue,
    );
  });

  test(
    'Hint does not pull a Foundation card back down after it just went up',
    () {
      final opening = board(
        foundations: [
          [c('spades', 1), c('spades', 2), c('spades', 3), c('spades', 4)],
          [c('clubs', 1), c('clubs', 2), c('clubs', 3)],
          [],
          [],
        ],
        tableau: [
          [c('hearts', 5)],
          [c('diamonds', 5), c('clubs', 4), c('hearts', 3)],
          [],
          [],
          [],
          [],
          [],
        ],
      );
      var meta = GameMeta(
        present: opening.copyWith(seenFaceUp: {faceUpTableKey(opening)}),
        past: const [],
      );
      final keys = <String>{boardKey(meta.present)};
      for (var i = 0; i < 8; i++) {
        final cycle = hintCycle(meta.present);
        if (cycle.isEmpty) break;
        final play = cycle.first;
        if (!legalHintPlays(meta.present).contains(play)) break;
        meta = reduceMeta(
          meta,
          GameMetaAction(
            DropAction(play.onto, from: play.from, cardIndex: play.cardIndex),
          ),
        );
        expect(
          keys.add(boardKey(meta.present)),
          isTrue,
          reason: 'Hint followed a loop at step $i',
        );
      }
      expect(meta.present.foundations[1].last.suit, 'clubs');
      expect(meta.present.foundations[1].last.rank, 4);
      expect(
        hintCycle(meta.present).any((p) => p.from.area == PileArea.foundation),
        isFalse,
      );
    },
  );

  test(
    'Hint does not wrap a Foundation pull with sending that card back up',
    () {
      final opening = board(
        foundations: [
          [c('clubs', 1), c('clubs', 2), c('clubs', 3)],
          [c('spades', 1), c('spades', 2)],
          [],
          [],
        ],
        tableau: [
          [c('diamonds', 4)],
          [c('hearts', 4), c('spades', 3), c('hearts', 2)],
          [],
          [],
          [],
          [],
          [],
        ],
      );
      var meta = GameMeta(
        present: opening.copyWith(seenFaceUp: {faceUpTableKey(opening)}),
        past: const [],
      );
      expect(
        hintCycle(meta.present).single,
        HintPlay(
          from: const PileRef.foundation(0),
          cardIndex: 2,
          onto: const PileRef.tableau(0),
        ),
      );
      meta = reduceMeta(
        meta,
        const GameMetaAction(
          DropAction(
            PileRef.tableau(0),
            from: PileRef.foundation(0),
            cardIndex: 2,
          ),
        ),
      );
      final afterPull = hintCycle(meta.present);
      expect(
        afterPull.any(
          (p) =>
              p.from == const PileRef.tableau(0) &&
              p.onto == const PileRef.foundation(0),
        ),
        isFalse,
        reason: '3♣ going back up would wrap with 2♥ moving onto it',
      );
      expect(
        afterPull.single,
        HintPlay(
          from: const PileRef.tableau(1),
          cardIndex: 2,
          onto: const PileRef.tableau(0),
        ),
      );

      final keys = <String>{boardKey(meta.present)};
      for (var i = 0; i < 6; i++) {
        final cycle = hintCycle(meta.present);
        if (cycle.isEmpty) break;
        final play = cycle.first;
        if (!legalHintPlays(meta.present).contains(play)) break;
        meta = reduceMeta(
          meta,
          GameMetaAction(
            DropAction(play.onto, from: play.from, cardIndex: play.cardIndex),
          ),
        );
        expect(
          keys.add(boardKey(meta.present)),
          isTrue,
          reason: 'Hint followed a loop at step $i',
        );
      }
      expect(meta.present.foundations[1].last.suit, 'spades');
      expect(meta.present.foundations[1].last.rank, 3);
      expect(
        hintCycle(meta.present).where(legalHintPlays(meta.present).contains),
        isEmpty,
      );
    },
  );

  test(
    'Hint last-resort pulls a Foundation 3 when that unlocks a Stock play',
    () {
      final state = board(
        stock: [c('clubs', 2, faceUp: false)],
        foundations: [
          [c('hearts', 1), c('hearts', 2), c('hearts', 3)],
          [],
          [],
          [],
        ],
        tableau: [
          [c('spades', 4)],
          [],
          [],
          [],
          [],
          [],
          [],
        ],
      );
      expect(
        hintCycle(state).any(
          (p) =>
              p.from == const PileRef.foundation(0) &&
              p.onto == const PileRef.tableau(0),
        ),
        isTrue,
      );
      expect(hasActiveHint(state), isTrue);
    },
  );

  test(
    'Hint does not last-resort pull a Foundation 3 that unlocks nothing',
    () {
      final state = board(
        foundations: [
          [c('hearts', 1), c('hearts', 2), c('hearts', 3)],
          [],
          [],
          [],
        ],
        tableau: [
          [c('spades', 4)],
          [],
          [],
          [],
          [],
          [],
          [],
        ],
      );
      expect(
        hintCycle(state).any((p) => p.from.area == PileArea.foundation),
        isFalse,
      );
      expect(hasActiveHint(state), isFalse);
    },
  );

  test(
    'Hint does not last-resort pull a Foundation 3 while Stock still holds a play',
    () {
      final state = board(
        stock: [c('clubs', 1, faceUp: false)],
        foundations: [
          [c('hearts', 1), c('hearts', 2), c('hearts', 3)],
          [],
          [],
          [],
        ],
        tableau: [
          [c('spades', 4)],
          [],
          [],
          [],
          [],
          [],
          [],
        ],
      );
      expect(
        hintCycle(state).any((p) => p.from.area == PileArea.foundation),
        isFalse,
      );
    },
  );

  test(
    'Hint does not send a pulled Foundation card back up after later draws',
    () {
      final opening = board(
        stock: [
          for (var rank = 6; rank <= 11; rank++)
            c('diamonds', rank, faceUp: false),
        ],
        foundations: [
          [c('clubs', 1), c('clubs', 2), c('clubs', 3)],
          [c('spades', 1), c('spades', 2)],
          [],
          [],
        ],
        tableau: [
          [c('diamonds', 4)],
          [c('hearts', 4), c('spades', 3), c('hearts', 2)],
          [],
          [],
          [],
          [],
          [],
        ],
      );
      var meta = GameMeta(
        present: opening.copyWith(seenFaceUp: {faceUpTableKey(opening)}),
        past: const [],
      );
      meta = reduceMeta(
        meta,
        const GameMetaAction(
          DropAction(
            PileRef.tableau(0),
            from: PileRef.foundation(0),
            cardIndex: 2,
          ),
        ),
      );
      bool sendsClubs3Up(HintPlay p) =>
          p.from == const PileRef.tableau(0) &&
          p.onto == const PileRef.foundation(0);
      final waitingTwo = HintPlay(
        from: const PileRef.tableau(1),
        cardIndex: 2,
        onto: const PileRef.tableau(0),
      );
      for (var i = 0; i < 6; i++) {
        meta = reduceMeta(meta, const GameMetaAction(DrawAction()));
        final cycle = hintCycle(meta.present);
        expect(
          cycle.any(sendsClubs3Up),
          isFalse,
          reason: '3♣ going back up after draw ${i + 1}',
        );
        expect(cycle, contains(waitingTwo));
      }
    },
  );

  test(
    'Hint can pull a just-played Foundation card after an unplayable draw',
    () {
      final opening = board(
        stock: [
          for (var rank = 6; rank <= 11; rank++)
            c('diamonds', rank, faceUp: false),
        ],
        foundations: [
          [c('clubs', 1), c('clubs', 2), c('clubs', 3)],
          [],
          [],
          [],
        ],
        tableau: [
          [c('diamonds', 5), c('clubs', 4)],
          [c('hearts', 3)],
          [],
          [],
          [],
          [],
          [],
        ],
      );
      var meta = GameMeta(
        present: opening.copyWith(seenFaceUp: {faceUpTableKey(opening)}),
        past: const [],
      );
      meta = reduceMeta(
        meta,
        const GameMetaAction(
          DropAction(
            PileRef.foundation(0),
            from: PileRef.tableau(0),
            cardIndex: 1,
          ),
        ),
      );
      bool pullsClubs4(HintPlay p) =>
          p.from == const PileRef.foundation(0) &&
          p.onto == const PileRef.tableau(0);
      expect(hintCycle(meta.present).any(pullsClubs4), isFalse);
      meta = reduceMeta(meta, const GameMetaAction(DrawAction()));
      expect(hintCycle(meta.present).any(pullsClubs4), isTrue);
    },
  );

  test(
    'Hint still shows a loop-stopped new play when Stock and Waste are empty',
    () {
      final opening = board(
        tableau: [
          [c('hearts', 1)],
          [],
          [],
          [],
          [],
          [],
          [],
        ],
      );
      final state = opening.copyWith(
        seenFaceUp: {faceUpTableKey(opening)},
        hintLoopStops: [
          HintLoopStop(
            cardId: 'hearts-1',
            from: const PileRef.foundation(1),
            onto: const PileRef.tableau(0),
          ),
        ],
      );
      expect(hasActiveHint(state), isTrue);
      expect(hintCycle(state), isNotEmpty);
      expect(
        hintCycle(state).any((p) => p.from == const PileRef.tableau(0)),
        isTrue,
      );
    },
  );

  test(
    'Hint still shows a loop-stopped new play when leftover Stock cannot play',
    () {
      final opening = board(
        stock: [c('clubs', 9, faceUp: false)],
        tableau: [
          [c('hearts', 1)],
          [],
          [],
          [],
          [],
          [],
          [],
        ],
      );
      final state = opening.copyWith(
        seenFaceUp: {faceUpTableKey(opening)},
        hintLoopStops: [
          HintLoopStop(
            cardId: 'hearts-1',
            from: const PileRef.foundation(1),
            onto: const PileRef.tableau(0),
          ),
        ],
      );
      expect(hasActiveHint(state), isTrue);
      expect(
        hintCycle(state).any((p) => p.from == const PileRef.tableau(0)),
        isTrue,
      );
    },
  );

  test(
    'Hint does not last-resort a loop-stopped Tableau rehome that unlocks nothing',
    () {
      final opening = board(
        stock: [c('clubs', 9, faceUp: false)],
        tableau: [
          [c('spades', 8), c('hearts', 7)],
          [c('clubs', 8)],
          [c('diamonds', 13)],
          [],
          [],
          [],
          [],
        ],
      );
      final state = opening.copyWith(
        seenFaceUp: {faceUpTableKey(opening)},
        hintLoopStops: [
          HintLoopStop(
            cardId: 'hearts-7',
            from: const PileRef.tableau(1),
            onto: const PileRef.tableau(0),
          ),
        ],
      );
      expect(
        hintCycle(state).any(
          (p) =>
              p.from == const PileRef.tableau(0) &&
              p.onto == const PileRef.tableau(1),
        ),
        isFalse,
      );
      expect(hasActiveHint(state), isFalse);
    },
  );
}
