/// PROTOTYPE — pure Klondike rules helpers. No Flutter.

const suits = ['spades', 'hearts', 'diamonds', 'clubs'];

const rankLabel = {
  1: 'A',
  2: '2',
  3: '3',
  4: '4',
  5: '5',
  6: '6',
  7: '7',
  8: '8',
  9: '9',
  10: '10',
  11: 'J',
  12: 'Q',
  13: 'K',
};

const suitGlyph = {
  'spades': '♠',
  'hearts': '♥',
  'diamonds': '♦',
  'clubs': '♣',
};

class PlayingCard {
  const PlayingCard({
    required this.id,
    required this.suit,
    required this.rank,
    required this.faceUp,
  });

  final String id;
  final String suit;
  final int rank;
  final bool faceUp;

  PlayingCard copyWith({bool? faceUp}) => PlayingCard(
        id: id,
        suit: suit,
        rank: rank,
        faceUp: faceUp ?? this.faceUp,
      );
}

enum PileArea { stock, waste, foundation, tableau }

class PileRef {
  const PileRef._(this.area, this.index);
  const PileRef.stock() : this._(PileArea.stock, 0);
  const PileRef.waste() : this._(PileArea.waste, 0);
  const PileRef.foundation(int index) : this._(PileArea.foundation, index);
  const PileRef.tableau(int index) : this._(PileArea.tableau, index);

  final PileArea area;
  final int index;

  bool sameAs(PileRef other) {
    if (area != other.area) return false;
    if (area == PileArea.foundation || area == PileArea.tableau) {
      return index == other.index;
    }
    return true;
  }

  @override
  bool operator ==(Object other) => other is PileRef && sameAs(other);

  @override
  int get hashCode => Object.hash(area, index);
}

class Selection {
  const Selection({required this.from, required this.cardIndex});
  final PileRef from;
  final int cardIndex;
}

class GameState {
  const GameState({
    required this.stock,
    required this.waste,
    required this.foundations,
    required this.tableau,
    this.selection,
    this.won = false,
  });

  final List<PlayingCard> stock;
  final List<PlayingCard> waste;
  final List<List<PlayingCard>> foundations;
  final List<List<PlayingCard>> tableau;
  final Selection? selection;
  final bool won;
}

bool isRed(String suit) => suit == 'hearts' || suit == 'diamonds';

bool canStackOnTableau(PlayingCard moving, PlayingCard? target) {
  if (target == null) return moving.rank == 13;
  return isRed(moving.suit) != isRed(target.suit) &&
      moving.rank == target.rank - 1;
}

bool canStackOnFoundation(PlayingCard moving, List<PlayingCard> pile) {
  if (pile.isEmpty) return moving.rank == 1;
  final top = pile.last;
  return moving.suit == top.suit && moving.rank == top.rank + 1;
}

List<PlayingCard> getPile(GameState state, PileRef pile) {
  switch (pile.area) {
    case PileArea.stock:
      return state.stock;
    case PileArea.waste:
      return state.waste;
    case PileArea.foundation:
      return state.foundations[pile.index];
    case PileArea.tableau:
      return state.tableau[pile.index];
  }
}

bool isWin(List<List<PlayingCard>> foundations) =>
    foundations.every((p) => p.length == 13);

bool tableauRunIsLegal(List<PlayingCard> pile, int cardIndex) {
  if (cardIndex < 0 || cardIndex >= pile.length) return false;
  if (!pile[cardIndex].faceUp) return false;
  for (var i = cardIndex; i < pile.length - 1; i++) {
    final a = pile[i];
    final b = pile[i + 1];
    if (!b.faceUp) return false;
    if (!canStackOnTableau(b, a)) return false;
  }
  return true;
}
