/// Debug move log from the Undo stack. No Flutter.
library;

import 'deal.dart';
import 'hint.dart';
import 'history.dart';
import 'rules.dart';

String? debugLastMove(GameMeta meta) {
  if (meta.past.isEmpty) return null;
  return '${meta.past.length}. ${_describeMove(meta.past.last, meta.present)}';
}

String debugMoveLog(GameMeta meta) {
  final header = debugGameLine(meta.present, undos: meta.past.length);
  final states = [...meta.past, meta.present];
  if (states.length < 2) {
    return '$header\n(no moves yet)';
  }
  final lines = <String>[header];
  for (var i = 1; i < states.length; i++) {
    lines.add('$i. ${_describeMove(states[i - 1], states[i])}');
  }
  return lines.join('\n');
}

String _cardLabel(PlayingCard card) {
  final rank = rankLabel[card.rank] ?? '${card.rank}';
  final suit = suitGlyph[card.suit] ?? card.suit;
  return '$rank$suit';
}

String _pileLabel(PileRef pile) {
  switch (pile.area) {
    case PileArea.stock:
      return 'Stock';
    case PileArea.waste:
      return 'Waste';
    case PileArea.foundation:
      return 'Foundation ${pile.index + 1}';
    case PileArea.tableau:
      return 'Tableau ${pile.index + 1}';
  }
}

Map<String, PileRef> _homes(GameState state) {
  final homes = <String, PileRef>{};
  for (final c in state.stock) {
    homes[c.id] = const PileRef.stock();
  }
  for (final c in state.waste) {
    homes[c.id] = const PileRef.waste();
  }
  for (var i = 0; i < 4; i++) {
    for (final c in state.foundations[i]) {
      homes[c.id] = PileRef.foundation(i);
    }
  }
  for (var i = 0; i < 7; i++) {
    for (final c in state.tableau[i]) {
      homes[c.id] = PileRef.tableau(i);
    }
  }
  return homes;
}

String _tag(GameState before, HintPlay play) {
  if (lastResortHintPlays(before).contains(play)) return 'last-resort';
  if (hintCycle(before).contains(play)) return 'Hint';
  return 'not Hint';
}

String _describeMove(GameState before, GameState after) {
  final beforeHomes = _homes(before);
  final afterHomes = _homes(after);
  final moved = <PlayingCard>[];
  for (final card in [
    ...after.stock,
    ...after.waste,
    for (final p in after.foundations) ...p,
    for (final p in after.tableau) ...p,
  ]) {
    final from = beforeHomes[card.id];
    final onto = afterHomes[card.id];
    if (from == null || onto == null) continue;
    if (from.sameAs(onto)) continue;
    moved.add(card);
  }

  final played = moved.where((card) {
    final onto = afterHomes[card.id]!;
    return onto.area == PileArea.tableau || onto.area == PileArea.foundation;
  }).toList();

  if (played.isEmpty) {
    if (before.waste.isNotEmpty && after.waste.isEmpty) return 'Recycle';
    final drawn = [
      for (final card in after.waste)
        if (beforeHomes[card.id]?.area == PileArea.stock) _cardLabel(card),
    ];
    if (drawn.isEmpty) return 'Draw';
    return 'Draw ${drawn.join(' ')}';
  }

  final from = beforeHomes[played.first.id]!;
  final onto = afterHomes[played.first.id]!;
  final source = getPile(before, from);
  played.sort((a, b) {
    final ia = source.indexWhere((c) => c.id == a.id);
    final ib = source.indexWhere((c) => c.id == b.id);
    return ia.compareTo(ib);
  });
  final head = played.first;
  final cardIndex = source.indexWhere((c) => c.id == head.id);
  final play = HintPlay(from: from, cardIndex: cardIndex, onto: onto);
  final empty = onto.area == PileArea.tableau && getPile(before, onto).isEmpty;
  final dest = empty ? '${_pileLabel(onto)} empty' : _pileLabel(onto);
  return '${_cardLabel(head)} ${_pileLabel(from)} → $dest (${_tag(before, play)})';
}
