/// PROTOTYPE — deal a Klondike Game. No Flutter.
library;

import 'rules.dart';

int _u32(int x) => x & 0xFFFFFFFF;

int _imul(int a, int b) => (a.toSigned(32) * b.toSigned(32)).toSigned(32);

double Function() mulberry32(int seed) {
  var t = _u32(seed);
  return () {
    t = _u32(t + 0x6D2B79F5);
    var r = _imul(t ^ (t >>> 15), 1 | t);
    r = r ^ (r + _imul(r ^ (r >>> 7), 61 | r));
    return _u32(r ^ (r >>> 14)) / 4294967296;
  };
}

List<PlayingCard> buildDeck() {
  final deck = <PlayingCard>[];
  for (final suit in suits) {
    for (var rank = 1; rank <= 13; rank++) {
      deck.add(
        PlayingCard(id: '$suit-$rank', suit: suit, rank: rank, faceUp: false),
      );
    }
  }
  return deck;
}

List<PlayingCard> shuffle(List<PlayingCard> deck, int seed) {
  final rand = mulberry32(seed);
  final out = [...deck];
  for (var i = out.length - 1; i > 0; i--) {
    final j = (rand() * (i + 1)).floor();
    final tmp = out[i];
    out[i] = out[j];
    out[j] = tmp;
  }
  return out;
}

/// Standard Klondike deal: Tableau piles 1–7, tops face-up; rest face-down Stock.
GameState dealGame({int? seed, DrawType drawType = DrawType.drawOne}) {
  final deck = shuffle(
    buildDeck(),
    seed ?? DateTime.now().millisecondsSinceEpoch,
  );
  var i = 0;
  final tableau = <List<PlayingCard>>[];
  for (var col = 0; col < 7; col++) {
    final pile = <PlayingCard>[];
    for (var n = 0; n <= col; n++) {
      pile.add(deck[i++].copyWith(faceUp: n == col));
    }
    tableau.add(pile);
  }
  final stock = [for (final c in deck.skip(i)) c.copyWith(faceUp: false)];
  final dealt = GameState(
    stock: stock,
    waste: const [],
    foundations: const [[], [], [], []],
    tableau: tableau,
    drawType: drawType,
  );
  return dealt.copyWith(seenFaceUp: {faceUpTableKey(dealt)});
}
