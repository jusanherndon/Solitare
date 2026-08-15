import { createContext, useCallback, useContext, useMemo, useRef, useState, type ReactNode } from 'react';
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
  const hostRef = useRef<View>(null);
  const hostAt = useRef({ x: 0, y: 0 });
  const [visual, setVisualState] = useState<DragVisual | null>(null);

  const measureHost = useCallback(() => {
    hostRef.current?.measureInWindow((x, y) => {
      hostAt.current = { x, y };
    });
  }, []);

  const setVisual = useCallback((next: DragVisual | null) => {
    if (next) measureHost();
    setVisualState(next);
  }, [measureHost]);

  const updateOffset = useCallback((dx: number, dy: number) => {
    setVisualState((prev) => (prev ? { ...prev, dx, dy } : prev));
  }, []);

  const api = useMemo(
    () => ({ visual, setVisual, updateOffset }),
    [visual, setVisual, updateOffset],
  );

  const ox = hostAt.current.x;
  const oy = hostAt.current.y;

  return (
    <DragOverlayContext.Provider value={api}>
      <View
        ref={hostRef}
        collapsable={false}
        style={styles.host}
        onLayout={measureHost}
      >
        {children}
        {visual ? (
          <View
            pointerEvents="none"
            collapsable={false}
            style={styles.layer}
          >
            {visual.cards.map((card, i) => (
              <View
                key={card.id}
                pointerEvents="none"
                collapsable={false}
                style={{
                  position: 'absolute',
                  left: visual.originX - ox,
                  top: visual.originY - oy + i * visual.fanOffset,
                  transform: [{ translateX: visual.dx }, { translateY: visual.dy }],
                  elevation: 80 + i,
                  zIndex: 80 + i,
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
    zIndex: 80,
    elevation: 80,
    overflow: 'visible',
    backgroundColor: 'transparent',
  },
});
