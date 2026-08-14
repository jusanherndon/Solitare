import { useEffect, useRef, useState } from 'react';
import { Pressable, StyleSheet, View } from 'react-native';
import { CardView } from './CardView';
import { useDragOverlay } from './DragOverlay';
import type { PileId } from './useHitRegistry';

type Size = { width: number; height: number };

type Props = {
  pile: PileId;
  cards: any[];
  size: Size;
  emptyLabel?: string;
  fanOffset?: number;
  onTap: (pile: PileId, cardIndex?: number) => void;
  onAutoMove: (pile: PileId, cardIndex?: number) => void;
  onDrop: (onto: PileId, from: PileId, cardIndex: number) => void;
  registerHit?: (pile: PileId, ref: View | null) => void;
  hitTest?: (x: number, y: number) => PileId | null;
  refreshHits?: () => void;
};

const DRAG_THRESHOLD = 14;
const DOUBLE_TAP_MS = 350;

export function pileAttr(pile: PileId): string {
  if (pile.area === 'foundation' || pile.area === 'tableau') {
    return `${pile.area}:${pile.index}`;
  }
  return pile.area;
}

export function parsePileAttr(attr: string | null | undefined): PileId | null {
  if (!attr) return null;
  if (attr === 'stock' || attr === 'waste') return { area: attr };
  const [area, index] = attr.split(':');
  if (area === 'foundation' || area === 'tableau') {
    return { area, index: Number(index) };
  }
  return null;
}

function pileKey(pile: PileId): string {
  return pileAttr(pile);
}

function samePile(a: PileId, b: PileId): boolean {
  return pileKey(a) === pileKey(b);
}

function pagePoint(e: any) {
  const n = e.nativeEvent ?? e;
  return {
    pageX: n.pageX ?? n.clientX ?? 0,
    pageY: n.pageY ?? n.clientY ?? 0,
    locationY: n.locationY ?? 0,
  };
}

function resolveDropTarget(
  pageX: number,
  pageY: number,
  hitTest?: (x: number, y: number) => PileId | null,
): PileId | null {
  // Web: DOM hit-test is more reliable than cached measure rects.
  // Ignore elements marked as the in-flight drag ghost.
  if (typeof document !== 'undefined' && typeof document.elementFromPoint === 'function') {
    const ghosts = document.querySelectorAll('[data-dragging="1"]');
    const prev: string[] = [];
    ghosts.forEach((node, i) => {
      const el = node as HTMLElement;
      prev[i] = el.style.pointerEvents;
      el.style.pointerEvents = 'none';
    });
    const el = document.elementFromPoint(pageX, pageY) as HTMLElement | null;
    ghosts.forEach((node, i) => {
      (node as HTMLElement).style.pointerEvents = prev[i] ?? '';
    });
    const node = el?.closest?.('[data-pile]') as HTMLElement | null;
    const parsed = parsePileAttr(node?.getAttribute('data-pile'));
    if (parsed) return parsed;
  }
  return hitTest?.(pageX, pageY) ?? null;
}

/**
 * Unified pointer handling: small movement = tap; drag follows the finger
 * and drops via hit-test. Double-tap/click auto-moves to Foundation then Tableau.
 */
export function InteractivePile({
  pile,
  cards,
  size,
  emptyLabel,
  fanOffset = 0,
  onTap,
  onAutoMove,
  onDrop,
  registerHit,
  hitTest,
  refreshHits,
}: Props) {
  const wrapRef = useRef<View>(null);
  const cardsRef = useRef(cards);
  const pileRef = useRef(pile);
  const fanRef = useRef(fanOffset);
  const sizeRef = useRef(size);
  const callbacks = useRef({ onTap, onAutoMove, onDrop, hitTest, refreshHits });
  const overlay = useDragOverlay();
  const overlayRef = useRef(overlay);
  const lastTap = useRef<{ t: number; key: string; cardIndex: number } | null>(null);
  cardsRef.current = cards;
  pileRef.current = pile;
  fanRef.current = fanOffset;
  sizeRef.current = size;
  callbacks.current = { onTap, onAutoMove, onDrop, hitTest, refreshHits };
  overlayRef.current = overlay;

  const gesture = useRef<{
    startX: number;
    startY: number;
    cardIndex: number;
    dragging: boolean;
    pileX: number;
    pileY: number;
    measured: boolean;
    dx: number;
    dy: number;
  } | null>(null);

  const [drag, setDrag] = useState<{
    dx: number;
    dy: number;
    cardIndex: number;
  } | null>(null);

  useEffect(() => {
    registerHit?.(pile, wrapRef.current);
    return () => registerHit?.(pile, null);
  }, [pile, cards.length, size.width, size.height, fanOffset, registerHit]);

  useEffect(() => {
    return () => overlayRef.current.setVisual(null);
  }, []);

  const pickCardIndex = (locationY: number) => {
    const list = cardsRef.current;
    if (list.length === 0) return 0;
    const fan = fanRef.current;
    if (!fan) return list.length - 1;
    let idx = Math.floor(locationY / fan);
    idx = Math.max(0, Math.min(list.length - 1, idx));
    while (idx < list.length - 1 && !list[idx].faceUp) idx++;
    if (!list[idx].faceUp) idx = list.length - 1;
    return idx;
  };

  const clearDragVisual = () => {
    overlayRef.current.setVisual(null);
    setDrag(null);
  };

  const beginOverlay = (cardIndex: number, dx: number, dy: number, pileX: number, pileY: number) => {
    const list = cardsRef.current;
    const fan = fanRef.current;
    const sz = sizeRef.current;
    const lifted = fan > 0 ? list.slice(cardIndex) : list.slice(-1);
    if (lifted.length === 0) return;

    overlayRef.current.setVisual({
      cards: lifted,
      originX: pileX,
      originY: pileY + (fan > 0 ? cardIndex * fan : 0),
      dx,
      dy,
      width: sz.width,
      height: sz.height,
      fanOffset: fan,
    });
  };

  const fireTapOrDouble = (cardIndex: number) => {
    const now = Date.now();
    const key = pileKey(pileRef.current);
    const prev = lastTap.current;
    if (
      prev &&
      now - prev.t <= DOUBLE_TAP_MS &&
      prev.key === key &&
      prev.cardIndex === cardIndex
    ) {
      lastTap.current = null;
      callbacks.current.onAutoMove(pileRef.current, cardIndex);
      return;
    }
    lastTap.current = { t: now, key, cardIndex };
    callbacks.current.onTap(pileRef.current, cardIndex);
  };

  const endGesture = (pageX: number, pageY: number) => {
    const g = gesture.current;
    gesture.current = null;
    clearDragVisual();
    if (!g) return;

    const { onDrop: drop, hitTest: hit } = callbacks.current;
    const dist = Math.hypot(pageX - g.startX, pageY - g.startY);

    if (g.dragging) {
      const target = resolveDropTarget(pageX, pageY, hit);
      if (target && !samePile(target, pileRef.current)) {
        drop(target, pileRef.current, g.cardIndex);
        lastTap.current = null;
        return;
      }
      // Accidental micro-drag or drop on self → treat as click.
      if (dist < DRAG_THRESHOLD * 2) {
        fireTapOrDouble(g.cardIndex);
      }
      return;
    }
    fireTapOrDouble(g.cardIndex);
  };

  const onResponderGrant = (e: any) => {
    if (typeof window !== 'undefined') window.getSelection?.()?.removeAllRanges?.();
    const { pageX, pageY, locationY } = pagePoint(e);
    gesture.current = {
      startX: pageX,
      startY: pageY,
      cardIndex: pickCardIndex(locationY),
      dragging: false,
      pileX: 0,
      pileY: 0,
      measured: false,
      dx: 0,
      dy: 0,
    };
    const node = wrapRef.current as any;
    node?.measureInWindow?.((x: number, y: number) => {
      const g = gesture.current;
      if (!g) return;
      g.pileX = x;
      g.pileY = y;
      g.measured = true;
      // Drag may have started before measure finished — place the ghost now.
      if (g.dragging) {
        beginOverlay(g.cardIndex, g.dx, g.dy, x, y);
      }
    });
    callbacks.current.refreshHits?.();
  };

  const onResponderMove = (e: any) => {
    const g = gesture.current;
    if (!g) return;
    const { pageX, pageY } = pagePoint(e);
    const dx = pageX - g.startX;
    const dy = pageY - g.startY;
    g.dx = dx;
    g.dy = dy;
    if (!g.dragging && Math.hypot(dx, dy) >= DRAG_THRESHOLD) {
      g.dragging = true;
      if (typeof window !== 'undefined') window.getSelection?.()?.removeAllRanges?.();
      if (g.measured) {
        beginOverlay(g.cardIndex, dx, dy, g.pileX, g.pileY);
      }
      callbacks.current.refreshHits?.();
    }
    if (g.dragging) {
      setDrag({ dx, dy, cardIndex: g.cardIndex });
      overlayRef.current.updateOffset(dx, dy);
    }
  };

  const onResponderRelease = (e: any) => {
    const { pageX, pageY } = pagePoint(e);
    endGesture(pageX, pageY);
  };

  const responder = {
    onStartShouldSetResponder: () => true,
    onMoveShouldSetResponder: () => !!gesture.current,
    onResponderTerminationRequest: () => false,
    onResponderGrant,
    onResponderMove,
    onResponderRelease,
    onResponderTerminate: () => {
      gesture.current = null;
      clearDragVisual();
    },
  };

  const webData = {
    dataSet: {
      pile: pileAttr(pile),
    },
  };

  const onLayout = () => {
    registerHit?.(pile, wrapRef.current);
  };

  if (fanOffset > 0) {
    const height = Math.max(
      size.height,
      size.height + fanOffset * Math.max(0, cards.length - 1),
    );
    return (
      <View
        ref={wrapRef}
        onLayout={onLayout}
        style={{ width: size.width, height, zIndex: drag ? 20 : 1, elevation: drag ? 20 : 0 }}
        {...webData}
        {...responder}
      >
        {cards.length === 0 ? (
          <CardView width={size.width} height={size.height} emptyLabel={emptyLabel} />
        ) : (
          cards.map((card, i) => {
            const lifting = !!(drag && i >= drag.cardIndex);
            return (
              <View
                key={card.id}
                pointerEvents="none"
                style={{
                  position: 'absolute',
                  top: i * fanOffset,
                  left: 0,
                  zIndex: i + 1,
                  opacity: lifting ? 0 : 1,
                }}
              >
                <CardView card={card} width={size.width} height={size.height} />
              </View>
            );
          })
        )}
      </View>
    );
  }

  const top = cards.length ? cards[cards.length - 1] : undefined;
  return (
    <View
      ref={wrapRef}
      onLayout={onLayout}
      style={[styles.hit, { zIndex: drag ? 20 : 1, elevation: drag ? 20 : 0 }]}
      {...webData}
      {...responder}
    >
      <View pointerEvents="none" style={{ opacity: drag ? 0 : 1 }}>
        <CardView
          card={top}
          width={size.width}
          height={size.height}
          emptyLabel={emptyLabel}
        />
      </View>
    </View>
  );
}

export function StockPile({
  count,
  size,
  onDraw,
}: {
  count: number;
  size: Size;
  onDraw: () => void;
}) {
  return (
    <Pressable onPress={onDraw} style={styles.hit}>
      {count > 0 ? (
        <CardView
          card={{ id: 'stock', suit: 'spades', rank: 1, faceUp: false }}
          width={size.width}
          height={size.height}
        />
      ) : (
        <CardView width={size.width} height={size.height} emptyLabel="↻" />
      )}
    </Pressable>
  );
}

const styles = StyleSheet.create({
  hit: { alignSelf: 'flex-start' },
});
