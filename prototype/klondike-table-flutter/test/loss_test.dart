import 'package:flutter_test/flutter_test.dart';
import 'package:klondike_table/game/deal.dart';
import 'package:klondike_table/game/rules.dart';

PlayingCard _c(String suit, int rank, {bool faceUp = true}) =>
    PlayingCard(id: '$suit-$rank', suit: suit, rank: rank, faceUp: faceUp);

GameState _board({
  List<PlayingCard> stock = const [],
  List<PlayingCard> waste = const [],
  List<List<PlayingCard>>? foundations,
  List<List<PlayingCard>>? tableau,
  bool won = false,
}) {
  return GameState(
    stock: stock,
    waste: waste,
    foundations: foundations ?? const [[], [], [], []],
    tableau: tableau ?? [[], [], [], [], [], [], []],
    won: won,
  );
}

void main() {
  test('opening deal is not a loss', () {
    expect(isLoss(dealGame(1)), isFalse);
  });

  test('full Foundations is a win, not a loss', () {
    final foundations = [
      for (final suit in suits) [for (var r = 1; r <= 13; r++) _c(suit, r)],
    ];
    final state = _board(foundations: foundations, won: true);
    expect(isWin(state.foundations), isTrue);
    expect(isLoss(state), isFalse);
  });

  test('empty Stock and Waste with no Tableau play is a loss', () {
    final state = _board(
      tableau: [
        [_c('hearts', 2)],
        [],
        [],
        [],
        [],
        [],
        [],
      ],
    );
    expect(isLoss(state), isTrue);
  });

  test('a King on Tableau with an empty pile is not a loss', () {
    final state = _board(
      tableau: [
        [_c('spades', 13)],
        [],
        [],
        [],
        [],
        [],
        [],
      ],
    );
    expect(isLoss(state), isFalse);
  });

  test('cards left in Stock are not a loss', () {
    final state = _board(
      stock: [_c('clubs', 5, faceUp: false)],
      tableau: [
        [_c('hearts', 2)],
        [],
        [],
        [],
        [],
        [],
        [],
      ],
    );
    expect(isLoss(state), isFalse);
  });
}
