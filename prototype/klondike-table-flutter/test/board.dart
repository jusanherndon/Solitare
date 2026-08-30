import 'package:klondike_table/game/rules.dart';

PlayingCard c(String suit, int rank, {bool faceUp = true}) =>
    PlayingCard(id: '$suit-$rank', suit: suit, rank: rank, faceUp: faceUp);

GameState board({
  List<PlayingCard> stock = const [],
  List<PlayingCard> waste = const [],
  List<List<PlayingCard>>? foundations,
  List<List<PlayingCard>>? tableau,
  bool won = false,
  DrawType drawType = DrawType.drawOne,
  Set<String>? seenFaceUp,
}) {
  return GameState(
    stock: stock,
    waste: waste,
    foundations: foundations ?? const [[], [], [], []],
    tableau: tableau ?? [[], [], [], [], [], [], []],
    won: won,
    drawType: drawType,
    seenFaceUp: seenFaceUp ?? const {},
  );
}
