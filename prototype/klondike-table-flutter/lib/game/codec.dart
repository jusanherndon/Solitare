/// JSON snapshot of an unfinished Game + Undo stack. No selection.
library;

import 'dart:convert';

import 'rules.dart';
import 'history.dart';

Map<String, Object?> _cardJson(PlayingCard c) => {
  'id': c.id,
  'suit': c.suit,
  'rank': c.rank,
  'faceUp': c.faceUp,
};

PlayingCard _card(Map<String, dynamic> j) => PlayingCard(
  id: j['id'] as String,
  suit: j['suit'] as String,
  rank: j['rank'] as int,
  faceUp: j['faceUp'] as bool,
);

Map<String, Object?> _stateJson(GameState s) => {
  'stock': [for (final c in s.stock) _cardJson(c)],
  'waste': [for (final c in s.waste) _cardJson(c)],
  'foundations': [
    for (final p in s.foundations) [for (final c in p) _cardJson(c)],
  ],
  'tableau': [
    for (final p in s.tableau) [for (final c in p) _cardJson(c)],
  ],
  'won': s.won,
  'drawType': s.drawType.name,
  'seenFaceUp': s.seenFaceUp.toList(),
};

GameState _state(Map<String, dynamic> j) => GameState(
  stock: [
    for (final c in j['stock'] as List<dynamic>)
      _card(c as Map<String, dynamic>),
  ],
  waste: [
    for (final c in j['waste'] as List<dynamic>)
      _card(c as Map<String, dynamic>),
  ],
  foundations: [
    for (final p in j['foundations'] as List<dynamic>)
      [for (final c in p as List<dynamic>) _card(c as Map<String, dynamic>)],
  ],
  tableau: [
    for (final p in j['tableau'] as List<dynamic>)
      [for (final c in p as List<dynamic>) _card(c as Map<String, dynamic>)],
  ],
  won: j['won'] as bool? ?? false,
  drawType: j['drawType'] == 'drawThree'
      ? DrawType.drawThree
      : DrawType.drawOne,
  seenFaceUp: {
    for (final k in (j['seenFaceUp'] as List<dynamic>? ?? const []))
      k as String,
  },
);

String encodeMeta(GameMeta meta) => jsonEncode({
  'present': _stateJson(meta.present),
  'past': [for (final s in meta.past) _stateJson(s)],
  'finishContinued': meta.finishContinued,
});

GameMeta decodeMeta(String raw) {
  final j = jsonDecode(raw) as Map<String, dynamic>;
  return GameMeta(
    present: _state(j['present'] as Map<String, dynamic>),
    past: [
      for (final s in j['past'] as List<dynamic>)
        _state(s as Map<String, dynamic>),
    ],
    finishContinued: j['finishContinued'] as bool? ?? false,
  );
}
