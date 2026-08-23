import 'package:flutter/widgets.dart';

import '../game/history.dart';
import '../game/reducer.dart';
import '../game/rules.dart';
import 'board_metrics.dart';
import 'card_view.dart';
import 'drag_overlay.dart';
import 'interactive_pile.dart';

class KlondikeTable extends StatefulWidget {
  const KlondikeTable({super.key});

  @override
  State<KlondikeTable> createState() => _KlondikeTableState();
}

class _KlondikeTableState extends State<KlondikeTable> {
  GameMeta _meta = initMeta(42);
  final _hits = HitRegistry();
  final _drag = DragController();

  GameState get _state => _meta.present;

  void _dispatch(GameAction action) {
    setState(() {
      _meta = reduceMeta(_meta, GameMetaAction(action));
    });
  }

  void _undo() {
    setState(() {
      _meta = reduceMeta(_meta, const UndoMetaAction());
    });
  }

  @override
  void dispose() {
    _drag.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final view = View.of(context);
    final metrics = computeBoardMetrics(
      size: media.size,
      padding: media.padding,
      fontScale: media.textScaler.scale(1),
      touch: coarsePointer(view),
    );
    final selected = selectedCardIds(_state);
    final card = CardSize(metrics.cardW, metrics.cardH);

    return ColoredBox(
      color: const Color(0xFF1F6B45),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              metrics.pad + metrics.insets.left,
              metrics.insets.top + 8,
              metrics.pad + metrics.insets.right,
              metrics.insets.bottom + 12,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: metrics.boardMax),
                child: Column(
                  children: [
                    _TopBar(
                      canUndo: _meta.past.isNotEmpty,
                      uiScale: metrics.uiScale,
                      onUndo: _undo,
                      onNewGame: () => _dispatch(const NewGameAction()),
                    ),
                    SizedBox(height: 10 * metrics.uiScale.clamp(0.8, 1.4)),
                    _TopRow(
                      state: _state,
                      metrics: metrics,
                      card: card,
                      selected: selected,
                      hits: _hits,
                      drag: _drag,
                      onTap: (pile, i) => _dispatch(TapAction(pile, i)),
                      onAutoMove: (pile, i) =>
                          _dispatch(AutoMoveAction(pile, i)),
                      onDrop: (onto, from, i) => _dispatch(
                        DropAction(onto, from: from, cardIndex: i),
                      ),
                      onDraw: () => _dispatch(const DrawAction()),
                    ),
                    SizedBox(height: metrics.landscape ? 12 : 16),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var i = 0; i < 7; i++) ...[
                            if (i > 0) SizedBox(width: metrics.gap),
                            InteractivePile(
                              pile: PileRef.tableau(i),
                              cards: _state.tableau[i],
                              size: card,
                              fanOffset: metrics.fan,
                              emptyLabel: ' ',
                              selectedIds: selected,
                              hits: _hits,
                              drag: _drag,
                              onTap: (pile, idx) =>
                                  _dispatch(TapAction(pile, idx)),
                              onAutoMove: (pile, idx) =>
                                  _dispatch(AutoMoveAction(pile, idx)),
                              onDrop: (onto, from, idx) => _dispatch(
                                DropAction(onto, from: from, cardIndex: idx),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: metrics.insets.top + 4,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Text(
                'Double-click auto-move · drag · tap → tap',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0x59FFFFFF),
                  fontSize: (10 * metrics.uiScale).roundToDouble(),
                ),
              ),
            ),
          ),
          DragOverlay(controller: _drag),
          if (_state.won)
            Center(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xBF000000),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                  child: Text(
                    'Win',
                    style: TextStyle(
                      color: const Color(0xFFFFD54F),
                      fontSize: (28 * metrics.uiScale).roundToDouble(),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.canUndo,
    required this.uiScale,
    required this.onUndo,
    required this.onNewGame,
  });

  final bool canUndo;
  final double uiScale;
  final VoidCallback onUndo;
  final VoidCallback onNewGame;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _ChromeButton(
          label: 'Undo',
          uiScale: uiScale,
          enabled: canUndo,
          onTap: onUndo,
        ),
        const SizedBox(width: 8),
        _ChromeButton(
          label: 'New Game',
          uiScale: uiScale,
          onTap: onNewGame,
        ),
      ],
    );
  }
}

class _ChromeButton extends StatelessWidget {
  const _ChromeButton({
    required this.label,
    required this.uiScale,
    required this.onTap,
    this.enabled = true,
  });

  final String label;
  final double uiScale;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Opacity(
        opacity: enabled ? 1 : 0.4,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0x59000000),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0x40FFFFFF)),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: (14 * uiScale).roundToDouble(),
              vertical: (8 * uiScale).roundToDouble(),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: const Color(0xFFFFFFFF),
                fontSize: (13 * uiScale).roundToDouble(),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TopRow extends StatelessWidget {
  const _TopRow({
    required this.state,
    required this.metrics,
    required this.card,
    required this.selected,
    required this.hits,
    required this.drag,
    required this.onTap,
    required this.onAutoMove,
    required this.onDrop,
    required this.onDraw,
  });

  final GameState state;
  final BoardMetrics metrics;
  final CardSize card;
  final Set<String> selected;
  final HitRegistry hits;
  final DragController drag;
  final void Function(PileRef pile, int? cardIndex) onTap;
  final void Function(PileRef pile, int? cardIndex) onAutoMove;
  final void Function(PileRef onto, PileRef from, int cardIndex) onDrop;
  final VoidCallback onDraw;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StockPile(count: state.stock.length, size: card, onDraw: onDraw),
        SizedBox(width: metrics.gap),
        InteractivePile(
          pile: const PileRef.waste(),
          cards: state.waste,
          size: card,
          emptyLabel: 'Waste',
          selectedIds: selected,
          hits: hits,
          drag: drag,
          onTap: onTap,
          onAutoMove: onAutoMove,
          onDrop: onDrop,
        ),
        SizedBox(width: (metrics.cardW * 0.35).clamp(12, 40)),
        for (var i = 0; i < 4; i++) ...[
          if (i > 0) SizedBox(width: metrics.gap),
          InteractivePile(
            pile: PileRef.foundation(i),
            cards: state.foundations[i],
            size: card,
            emptyLabel: '',
            selectedIds: selected,
            hits: hits,
            drag: drag,
            onTap: onTap,
            onAutoMove: onAutoMove,
            onDrop: onDrop,
          ),
        ],
      ],
    );
  }
}
