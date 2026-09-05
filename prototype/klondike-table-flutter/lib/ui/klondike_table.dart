import 'dart:async';

import 'package:flutter/widgets.dart';

import '../game/finish.dart';
import '../game/hint.dart';
import '../game/history.dart';
import '../game/reducer.dart';
import '../game/rules.dart';
import 'board_metrics.dart';
import 'card_view.dart';
import 'drag_overlay.dart';
import 'interactive_pile.dart';

const _dockH = 88.0;
const _dockReserve = 100.0;

class KlondikeTable extends StatefulWidget {
  const KlondikeTable({
    super.key,
    required this.meta,
    required this.onAction,
    required this.onStart,
    required this.onRequestNewGame,
    this.playEnabled = true,
    this.finishing = false,
    this.fastFinish = false,
  });

  final GameMeta meta;
  final void Function(MetaAction action) onAction;
  final VoidCallback onStart;
  final VoidCallback onRequestNewGame;
  final bool playEnabled;
  final bool finishing;
  final bool fastFinish;

  static const finishFlight = Duration(milliseconds: 650);
  static const fastFinishFlight = Duration(milliseconds: 325);

  @override
  State<KlondikeTable> createState() => KlondikeTableState();
}

class KlondikeTableState extends State<KlondikeTable>
    with TickerProviderStateMixin {
  final _hits = HitRegistry();
  final _drag = DragController();
  late final AnimationController _ghost;
  late final AnimationController _flight;
  HintCursor? _cursor;
  HintPlay? _ghostPlay;
  FinishPlay? _flightPlay;

  GameState get _state => widget.meta.present;

  Duration get _finishFlight => widget.fastFinish
      ? KlondikeTable.fastFinishFlight
      : KlondikeTable.finishFlight;

  @override
  void initState() {
    super.initState();
    _ghost = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    );
    _ghost.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _cursor?.advance();
        setState(() => _ghostPlay = null);
      }
    });
    _flight = AnimationController(vsync: this, duration: _finishFlight);
    _rebuildCycle();
    if (widget.finishing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(_runFinish());
      });
    }
  }

  @override
  void didUpdateWidget(KlondikeTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (boardKey(oldWidget.meta.present) != boardKey(_state)) {
      _cancelGhost();
      _rebuildCycle();
    }
    if (widget.fastFinish != oldWidget.fastFinish) {
      _flight.duration = _finishFlight;
    }
    if (widget.finishing && !oldWidget.finishing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(_runFinish());
      });
    }
  }

  var _runningFinish = false;

  Future<void> _runFinish() async {
    if (_runningFinish) return;
    _runningFinish = true;
    try {
      while (mounted && widget.finishing && !_state.won) {
        final play = nextFinishPlay(_state);
        if (play == null) break;
        setState(() => _flightPlay = play);
        await _flight.forward(from: 0);
        if (!mounted) return;
        setState(() => _flightPlay = null);
        final stepped = applyFinishStep(_state);
        widget.onAction(const FinishStepMetaAction());
        if (isWin(stepped.foundations)) break;
        await Future<void>.delayed(Duration.zero);
      }
    } finally {
      _runningFinish = false;
    }
  }

  void _rebuildCycle() {
    _cursor = HintCursor(hintCycle(_state));
  }

  void _cancelGhost({bool advance = false}) {
    _ghost.stop();
    _ghost.reset();
    if (advance) _cursor?.advance();
    _ghostPlay = null;
  }

  void _dispatch(GameAction action) {
    _cancelGhost();
    widget.onAction(GameMetaAction(action));
  }

  void _onHint() {
    final cursor = _cursor ?? HintCursor(hintCycle(_state));
    _cursor = cursor;
    if (cursor.isEmpty) return;
    if (_ghostPlay != null) {
      setState(() => _cancelGhost(advance: true));
      return;
    }
    setState(() {
      _ghostPlay = cursor.current;
      _ghost.forward(from: 0);
    });
  }

  @override
  void dispose() {
    _ghost.dispose();
    _flight.dispose();
    _drag.dispose();
    super.dispose();
  }

  Offset _pileOrigin(PileRef pile, int cardIndex, BoardMetrics metrics) {
    final base = _hits.origin(pile) ?? Offset.zero;
    if (pile.area == PileArea.tableau) {
      return base + Offset(0, cardIndex * metrics.fan);
    }
    if (pile.area == PileArea.waste && _state.drawType == DrawType.drawThree) {
      final n = _state.waste.length < 3 ? _state.waste.length : 3;
      if (n > 1) {
        return base + Offset(metrics.cardW * 0.32 * (n - 1), 0);
      }
    }
    return base;
  }

  List<PlayingCard> _ghostCards(HintPlay play) {
    final pile = getPile(_state, play.from);
    if (play.from.area == PileArea.tableau) {
      return pile.sublist(play.cardIndex);
    }
    if (pile.isEmpty) return const [];
    return [pile.last];
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final metrics = computeBoardMetrics(
      size: media.size,
      padding: media.padding,
      fontScale: media.textScaler.scale(1),
      touch: coarsePointer(),
      chromeTop: 0,
      chromeBottom: _dockReserve,
    );
    final selected = selectedCardIds(_state);
    final card = CardSize(metrics.cardW, metrics.cardH);
    final hintEmpty = _cursor?.isEmpty ?? true;
    final play = _ghostPlay;
    final hidden = <String>{
      if (_flightPlay != null) ...[getPile(_state, _flightPlay!.from).last.id],
    };

    return AbsorbPointer(
      absorbing: !widget.playEnabled || widget.finishing,
      child: ColoredBox(
        color: const Color(0xFF1F6B45),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                metrics.pad + metrics.insets.left,
                metrics.insets.top + 8,
                metrics.pad + metrics.insets.right,
                metrics.insets.bottom + 12 + _dockReserve,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: metrics.boardMax),
                  child: Column(
                    children: [
                      _TopRow(
                        state: _state,
                        metrics: metrics,
                        card: card,
                        selected: selected,
                        hiddenIds: hidden,
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
                                hiddenIds: hidden,
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
            _ThumbDock(
              insets: media.padding,
              canUndo: widget.meta.past.isNotEmpty,
              hintEnabled: !hintEmpty,
              onHint: _onHint,
              onUndo: () {
                _cancelGhost();
                widget.onAction(const UndoMetaAction());
              },
              onNewGame: () {
                _cancelGhost();
                widget.onRequestNewGame();
              },
              onStart: () {
                _cancelGhost();
                widget.onStart();
              },
            ),
            DragOverlay(controller: _drag),
            if (play != null)
              AnimatedBuilder(
                animation: _ghost,
                builder: (context, _) {
                  final t = Curves.easeInOut.transform(_ghost.value);
                  final from = _pileOrigin(play.from, play.cardIndex, metrics);
                  final destIdx = play.onto.area == PileArea.tableau
                      ? getPile(_state, play.onto).length
                      : 0;
                  final to = _pileOrigin(play.onto, destIdx, metrics);
                  final pos = Offset.lerp(from, to, t)!;
                  final cards = _ghostCards(play);
                  return IgnorePointer(
                    child: Opacity(
                      opacity: (1 - (t - 0.75).clamp(0.0, 1.0) * 4).clamp(
                        0.0,
                        0.85,
                      ),
                      child: Stack(
                        children: [
                          for (var i = 0; i < cards.length; i++)
                            Positioned(
                              left: pos.dx,
                              top: pos.dy + i * metrics.fan,
                              child: CardView(card: cards[i], size: card),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            if (_flightPlay != null)
              AnimatedBuilder(
                animation: _flight,
                builder: (context, _) {
                  final flight = _flightPlay!;
                  final t = Curves.easeInOut.transform(_flight.value);
                  final fromPile = getPile(_state, flight.from);
                  final from = _pileOrigin(
                    flight.from,
                    fromPile.length - 1,
                    metrics,
                  );
                  final to = _pileOrigin(flight.onto, 0, metrics);
                  final pos = Offset.lerp(from, to, t)!;
                  return IgnorePointer(
                    child: Stack(
                      children: [
                        Positioned(
                          left: pos.dx,
                          top: pos.dy,
                          child: CardView(card: fromPile.last, size: card),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _ThumbDock extends StatelessWidget {
  const _ThumbDock({
    required this.insets,
    required this.canUndo,
    required this.hintEnabled,
    required this.onHint,
    required this.onUndo,
    required this.onNewGame,
    required this.onStart,
  });

  final EdgeInsets insets;
  final bool canUndo;
  final bool hintEnabled;
  final VoidCallback onHint;
  final VoidCallback onUndo;
  final VoidCallback onNewGame;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: insets.left + 8,
      right: insets.right + 8,
      bottom: insets.bottom + 4,
      child: SizedBox(
        height: _dockH,
        child: Row(
          children: [
            _tile('Hint', onHint, enabled: hintEnabled),
            const SizedBox(width: 8),
            _tile('Undo', onUndo, enabled: canUndo),
            const SizedBox(width: 8),
            _tile('New Game', onNewGame),
            const SizedBox(width: 8),
            _tile('Start', onStart),
          ],
        ),
      ),
    );
  }

  Widget _tile(String label, VoidCallback onTap, {bool enabled = true}) {
    return Expanded(
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Opacity(
          opacity: enabled ? 1 : 0.35,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xF2143D28),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFFFD54F), width: 2),
            ),
            child: Center(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                ),
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
    required this.hiddenIds,
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
  final Set<String> hiddenIds;
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
          key: ValueKey(state.drawType),
          pile: const PileRef.waste(),
          cards: state.waste,
          size: card,
          emptyLabel: 'Waste',
          selectedIds: selected,
          hiddenIds: hiddenIds,
          hits: hits,
          drag: drag,
          onTap: onTap,
          onAutoMove: onAutoMove,
          onDrop: onDrop,
          wasteFan: state.drawType == DrawType.drawThree,
        ),
        SizedBox(
          width:
              (metrics.cardW *
                      (state.drawType == DrawType.drawThree ? 0.7 : 0.35))
                  .clamp(12, 48),
        ),
        for (var i = 0; i < 4; i++) ...[
          if (i > 0) SizedBox(width: metrics.gap),
          InteractivePile(
            pile: PileRef.foundation(i),
            cards: state.foundations[i],
            size: card,
            emptyLabel: '',
            selectedIds: selected,
            hiddenIds: hiddenIds,
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
