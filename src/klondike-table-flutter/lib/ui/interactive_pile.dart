import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../game/rules.dart';
import 'card_view.dart';
import 'drag_overlay.dart';

const dragThreshold = 14.0;
const doubleTapMs = 350;

class InteractivePile extends StatefulWidget {
  const InteractivePile({
    super.key,
    required this.pile,
    required this.cards,
    required this.size,
    this.emptyLabel,
    this.fanOffset = 0,
    required this.onTap,
    required this.onAutoMove,
    required this.onDrop,
    required this.hits,
    required this.drag,
    this.selectedIds = const {},
    this.hiddenIds = const {},
    this.wasteFan = false,
  });

  final PileRef pile;
  final List<PlayingCard> cards;
  final CardSize size;
  final String? emptyLabel;
  final double fanOffset;
  final void Function(PileRef pile, int? cardIndex) onTap;
  final void Function(PileRef pile, int? cardIndex) onAutoMove;
  final void Function(PileRef onto, PileRef from, int cardIndex) onDrop;
  final HitRegistry hits;
  final DragController drag;
  final Set<String> selectedIds;
  final Set<String> hiddenIds;
  final bool wasteFan;

  @override
  State<InteractivePile> createState() => _InteractivePileState();
}

class _InteractivePileState extends State<InteractivePile> {
  final _key = GlobalKey();
  _Gesture? _gesture;
  DateTime? _lastTapAt;
  int? _lastTapIndex;
  int? _pointer;

  @override
  void dispose() {
    _unbindPointer();
    widget.hits.register(widget.pile, null);
    super.dispose();
  }

  void _registerBox() {
    final box = _key.currentContext?.findRenderObject() as RenderBox?;
    widget.hits.register(widget.pile, box);
  }

  int _pickIndex(double localY) {
    final cards = widget.cards;
    if (cards.isEmpty) return 0;
    if (widget.wasteFan) return cards.length - 1;
    final fan = widget.fanOffset;
    if (fan <= 0) return cards.length - 1;
    var idx = (localY / fan).floor().clamp(0, cards.length - 1);
    while (idx < cards.length - 1 && !cards[idx].faceUp) {
      idx++;
    }
    if (!cards[idx].faceUp) idx = cards.length - 1;
    return idx;
  }

  double _wasteFanX() => widget.size.width * 0.32;

  int _wasteFanCount() {
    if (!widget.wasteFan || widget.cards.isEmpty) return 0;
    return widget.cards.length < 3 ? widget.cards.length : 3;
  }

  Offset _topOrigin(Offset pileOrigin) {
    final n = _wasteFanCount();
    if (n <= 1) return pileOrigin;
    return pileOrigin + Offset(_wasteFanX() * (n - 1), 0);
  }

  void _fireTapOrDouble(int cardIndex) {
    final now = DateTime.now();
    final prev = _lastTapAt;
    if (prev != null &&
        now.difference(prev).inMilliseconds <= doubleTapMs &&
        _lastTapIndex == cardIndex) {
      _lastTapAt = null;
      _lastTapIndex = null;
      widget.onAutoMove(widget.pile, cardIndex);
      return;
    }
    _lastTapAt = now;
    _lastTapIndex = cardIndex;
    widget.onTap(widget.pile, cardIndex);
  }

  void _bindPointer(int pointer) {
    _unbindPointer();
    _pointer = pointer;
    GestureBinding.instance.pointerRouter.addRoute(pointer, _route);
  }

  void _unbindPointer() {
    final pointer = _pointer;
    if (pointer == null) return;
    GestureBinding.instance.pointerRouter.removeRoute(pointer, _route);
    _pointer = null;
  }

  void _route(PointerEvent event) {
    if (event is PointerMoveEvent) {
      _onMove(event.position);
    } else if (event is PointerUpEvent || event is PointerCancelEvent) {
      _unbindPointer();
      _onEnd(event.position);
    }
  }

  void _onDown(Offset global, Offset local) {
    final box = _key.currentContext?.findRenderObject() as RenderBox?;
    final origin = box?.localToGlobal(Offset.zero) ?? global - local;
    _gesture = _Gesture(
      start: global,
      cardIndex: _pickIndex(local.dy),
      pileOrigin: _topOrigin(origin),
    );
  }

  void _onMove(Offset global) {
    final g = _gesture;
    if (g == null) return;
    final delta = global - g.start;
    if (!g.dragging && delta.distance >= dragThreshold) {
      g.dragging = true;
      final cards = widget.cards;
      final lifted = widget.fanOffset > 0
          ? cards.sublist(g.cardIndex)
          : (cards.isEmpty ? const <PlayingCard>[] : [cards.last]);
      if (lifted.isEmpty) return;
      final originY =
          g.pileOrigin.dy +
          (widget.fanOffset > 0 ? g.cardIndex * widget.fanOffset : 0);
      widget.drag.setVisual(
        DragVisual(
          cards: lifted,
          origin: Offset(g.pileOrigin.dx, originY),
          delta: delta,
          size: widget.size,
          fanOffset: widget.fanOffset,
        ),
      );
      setState(() {});
    }
    if (g.dragging) {
      widget.drag.updateOffset(delta);
    }
  }

  void _onEnd(Offset global) {
    final g = _gesture;
    _gesture = null;
    widget.drag.setVisual(null);
    if (mounted && g?.dragging == true) setState(() {});
    if (g == null) return;

    if (g.dragging) {
      final target = widget.hits.hitTest(global);
      if (target != null && !target.sameAs(widget.pile)) {
        widget.onDrop(target, widget.pile, g.cardIndex);
        _lastTapAt = null;
        return;
      }
      if ((global - g.start).distance < dragThreshold * 2) {
        _fireTapOrDouble(g.cardIndex);
      }
      return;
    }
    _fireTapOrDouble(g.cardIndex);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _registerBox());
    final dragging = widget.drag.visual != null && _gesture?.dragging == true;
    final fan = widget.fanOffset;
    final cards = widget.cards;

    late final double height;
    if (fan > 0) {
      height =
          (widget.size.height + fan * (cards.isEmpty ? 0 : cards.length - 1))
              .clamp(widget.size.height, double.infinity);
    } else {
      height = widget.size.height;
    }

    final fanCount = _wasteFanCount();
    final fanX = _wasteFanX();
    final width = fanCount > 1
        ? widget.size.width + fanX * (fanCount - 1)
        : widget.size.width;
    final fanCards = fanCount > 1
        ? widget.cards.sublist(widget.cards.length - fanCount)
        : const <PlayingCard>[];

    return Listener(
      key: _key,
      onPointerDown: (e) {
        _bindPointer(e.pointer);
        _onDown(e.position, e.localPosition);
      },
      child: SizedBox(
        width: width,
        height: height,
        child: fan > 0
            ? Stack(
                clipBehavior: Clip.none,
                children: [
                  if (cards.isEmpty)
                    CardView(size: widget.size, emptyLabel: widget.emptyLabel)
                  else
                    for (var i = 0; i < cards.length; i++)
                      Positioned(
                        top: i * fan,
                        left: 0,
                        child: Opacity(
                          opacity:
                              (dragging && i >= _gesture!.cardIndex) ||
                                  widget.hiddenIds.contains(cards[i].id)
                              ? 0
                              : 1,
                          child: CardView(
                            card: cards[i],
                            size: widget.size,
                            selected: widget.selectedIds.contains(cards[i].id),
                          ),
                        ),
                      ),
                ],
              )
            : fanCount > 1
            ? Stack(
                clipBehavior: Clip.none,
                children: [
                  for (var i = 0; i < fanCards.length; i++)
                    Positioned(
                      left: i * fanX,
                      top: 0,
                      child: Opacity(
                        opacity:
                            (dragging && i == fanCards.length - 1) ||
                                widget.hiddenIds.contains(fanCards[i].id)
                            ? 0
                            : 1,
                        child: CardView(
                          card: fanCards[i],
                          size: widget.size,
                          selected: widget.selectedIds.contains(fanCards[i].id),
                        ),
                      ),
                    ),
                ],
              )
            : Opacity(
                opacity: dragging ? 0 : 1,
                child: CardView(
                  card: () {
                    for (var i = cards.length - 1; i >= 0; i--) {
                      if (!widget.hiddenIds.contains(cards[i].id)) {
                        return cards[i];
                      }
                    }
                    return null;
                  }(),
                  size: widget.size,
                  emptyLabel: widget.emptyLabel,
                  selected:
                      cards.isNotEmpty &&
                      !widget.hiddenIds.contains(cards.last.id) &&
                      widget.selectedIds.contains(cards.last.id),
                ),
              ),
      ),
    );
  }
}

class StockPile extends StatelessWidget {
  const StockPile({
    super.key,
    required this.count,
    required this.size,
    required this.onDraw,
  });

  final int count;
  final CardSize size;
  final VoidCallback onDraw;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDraw,
      child: CardView(
        card: count > 0
            ? const PlayingCard(
                id: 'stock',
                suit: 'spades',
                rank: 1,
                faceUp: false,
              )
            : null,
        size: size,
        emptyLabel: count > 0 ? null : '↻',
      ),
    );
  }
}

class _Gesture {
  _Gesture({
    required this.start,
    required this.cardIndex,
    required this.pileOrigin,
  });

  final Offset start;
  final int cardIndex;
  final Offset pileOrigin;
  bool dragging = false;
}
