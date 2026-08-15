/**
 * PROTOTYPE for #6 — throwaway Expo phone/web shell.
 * Expo is vendored at ../../vendor/expo (ADR-0001).
 */
import { useEffect, useReducer } from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { initMeta, reduceMeta } from './game/history.js';
import { DragOverlayProvider } from './src/components/DragOverlay';
import { useBoardMetrics } from './src/variants/boardMetrics';
import { KlondikeTable } from './src/variants/Layouts';

export default function App() {
  const { uiScale } = useBoardMetrics();
  const [meta, dispatch] = useReducer(reduceMeta, undefined, () => initMeta(42));
  const state = meta.present;

  // Web: stop the browser's native text-selection highlight while dragging cards.
  useEffect(() => {
    if (typeof document === 'undefined') return;
    const block = (e: Event) => e.preventDefault();
    document.addEventListener('selectstart', block);
    document.addEventListener('dragstart', block);
    return () => {
      document.removeEventListener('selectstart', block);
      document.removeEventListener('dragstart', block);
    };
  }, []);

  const game = {
    state,
    canUndo: meta.past.length > 0,
    tap: (pile: any, cardIndex?: number) => dispatch({ type: 'TAP', pile, cardIndex }),
    autoMove: (pile: any, cardIndex?: number) =>
      dispatch({ type: 'AUTO_MOVE', pile, cardIndex }),
    drop: (onto: any, from?: any, cardIndex?: number) =>
      dispatch({ type: 'DROP', onto, from, cardIndex }),
    draw: () => dispatch({ type: 'DRAW' }),
    newGame: () => dispatch({ type: 'NEW_GAME' }),
    undo: () => dispatch({ type: 'UNDO' }),
  };

  return (
    <DragOverlayProvider>
      <View style={styles.root}>
        <KlondikeTable game={game} />
        <View style={[styles.hint, { pointerEvents: 'none' }]}>
          <Text style={[styles.hintText, { fontSize: Math.round(10 * uiScale) }]}>
            Double-click auto-move · drag · tap → tap
          </Text>
        </View>
      </View>
    </DragOverlayProvider>
  );
}

const noSelect = {
  userSelect: 'none',
  WebkitUserSelect: 'none',
  MozUserSelect: 'none',
  msUserSelect: 'none',
  WebkitUserDrag: 'none',
  WebkitTouchCallout: 'none',
} as const;

const styles = StyleSheet.create({
  root: {
    flex: 1,
    backgroundColor: '#1f6b45',
    ...noSelect,
  },
  hint: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    alignItems: 'center',
    paddingTop: 4,
  },
  hintText: {
    color: 'rgba(255,255,255,0.35)',
    ...noSelect,
  },
});
