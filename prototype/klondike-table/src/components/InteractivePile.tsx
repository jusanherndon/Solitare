import { useRef } from 'react';
import {
  PanResponder,
  Pressable,
  StyleSheet,
  View,
  type GestureResponderEvent,
} from 'react-native';
import { CardView } from './CardView';

type Size = { width: number; height: number };
type PileId =
  | { area: 'stock' }
  | { area: 'waste' }
  | { area: 'foundation'; index: number }
  | { area: 'tableau'; index: number };

type Props = {
  pile: PileId;
  cards: any[];
  size: Size;
  selectedIds: Set<string>;
  emptyLabel?: string;
  fanOffset?: number;
  onTap: (pile: PileId, cardIndex?: number) => void;
  onDrop: (onto: PileId) => void;
  onSelectForDrag?: (pile: PileId, cardIndex: number) => void;
  registerHit?: (pile: PileId, ref: View | null) => void;
  hitTest?: (x: number, y: number) => PileId | null;
};

/**
 * Tap select / destination, or drag with PanResponder (no gesture-handler).
 */
export function InteractivePile({
  pile,
  cards,
  size,
  selectedIds,
  emptyLabel,
  fanOffset = 0,
  onTap,
  onDrop,
  onSelectForDrag,
  registerHit,
  hitTest,
}: Props) {
  const wrapRef = useRef<View>(null);
  const dragging = useRef(false);
  const origin = useRef({ x: 0, y: 0 });

  const pan = useRef(
    PanResponder.create({
      onStartShouldSetPanResponder: () => false,
      onMoveShouldSetPanResponder: (_e, g) => Math.abs(g.dx) + Math.abs(g.dy) > 6,
      onPanResponderGrant: () => {
        dragging.current = true;
        const idx = Math.max(0, cards.length - 1);
        onSelectForDrag?.(pile, idx);
      },
      onPanResponderRelease: (e: GestureResponderEvent) => {
        const { pageX, pageY } = e.nativeEvent;
        const target = hitTest?.(pageX, pageY);
        if (target) onDrop(target);
        dragging.current = false;
      },
      onPanResponderTerminate: () => {
        dragging.current = false;
      },
    }),
  ).current;

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
        style={{ width: size.width, height }}
        {...pan.panHandlers}
      >
        {cards.length === 0 ? (
          <Pressable onPress={() => onTap(pile)}>
            <CardView width={size.width} height={size.height} emptyLabel={emptyLabel} />
          </Pressable>
        ) : (
          cards.map((card, i) => (
            <Pressable
              key={card.id}
              onPress={() => onTap(pile, i)}
              style={{ position: 'absolute', top: i * fanOffset, left: 0 }}
            >
              <CardView
                card={card}
                width={size.width}
                height={size.height}
                selected={selectedIds.has(card.id)}
              />
            </Pressable>
          ))
        )}
      </View>
    );
  }

  const top = cards.length ? cards[cards.length - 1] : undefined;
  return (
    <View ref={wrapRef} onLayout={onLayout} {...pan.panHandlers}>
      <Pressable
        onPress={() => onTap(pile, cards.length ? cards.length - 1 : undefined)}
        style={styles.hit}
      >
        <CardView
          card={top}
          width={size.width}
          height={size.height}
          selected={top ? selectedIds.has(top.id) : false}
          emptyLabel={emptyLabel}
        />
      </Pressable>
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
        <CardView width={size.width} height={size.height} emptyLabel="Ø" />
      )}
    </Pressable>
  );
}

const styles = StyleSheet.create({
  hit: { alignSelf: 'flex-start' },
});
