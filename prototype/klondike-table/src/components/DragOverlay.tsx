import { createContext, useCallback, useContext, useMemo, useState, type ReactNode } from 'react';
import { StyleSheet, View } from 'react-native';
import { CardView } from './CardView';

export type DragVisual = {
  cards: any[];
  /** Window position of the first lifted card at drag start. */
  originX: number;
  originY: number;
  dx: number;
  dy: number;
  width: number;
  height: number;
  fanOffset: number;
};

type DragOverlayApi = {
  visual: DragVisual | null;
  setVisual: (visual: DragVisual | null) => void;
  updateOffset: (dx: number, dy: number) => void;
};

const DragOverlayContext = createContext<DragOverlayApi | null>(null);

export function useDragOverlay(): DragOverlayApi {
  const ctx = useContext(DragOverlayContext);
  if (!ctx) {
    return {
      visual: null,
      setVisual: () => {},
      updateOffset: () => {},
    };
  }
  return ctx;
}

export function DragOverlayProvider({ children }: { children: ReactNode }) {
  const [visual, setVisualState] = useState<DragVisual | null>(null);

  const setVisual = useCallback((next: DragVisual | null) => {
    setVisualState(next);
  }, []);

  const updateOffset = useCallback((dx: number, dy: number) => {
    setVisualState((prev) => (prev ? { ...prev, dx, dy } : prev));
  }, []);

  const api = useMemo(
    () => ({ visual, setVisual, updateOffset }),
    [visual, setVisual, updateOffset],
  );

  return (
    <DragOverlayContext.Provider value={api}>
      <View style={styles.host}>
        {children}
        {visual ? (
          <View
            pointerEvents="none"
            style={styles.layer}
            // @ts-expect-error RN web dataset
            dataSet={{ dragging: '1' }}
          >
            {visual.cards.map((card, i) => (
              <View
                key={card.id}
                pointerEvents="none"
                style={{
                  position: 'absolute',
                  left: visual.originX + visual.dx,
                  top: visual.originY + visual.dy + i * visual.fanOffset,
                  zIndex: i + 1,
                }}
              >
                <CardView card={card} width={visual.width} height={visual.height} />
              </View>
            ))}
          </View>
        ) : null}
      </View>
    </DragOverlayContext.Provider>
  );
}

const styles = StyleSheet.create({
  host: {
    flex: 1,
  },
  layer: {
    ...StyleSheet.absoluteFillObject,
    zIndex: 100000,
    elevation: 100000,
  },
});
