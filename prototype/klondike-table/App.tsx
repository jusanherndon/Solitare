/**
 * PROTOTYPE for #6 — throwaway Expo phone/web shell.
 * Expo is vendored at ../../vendor/expo (ADR-0001).
 */
import { useEffect, useReducer } from 'react';
import { Platform, StyleSheet, Text, useWindowDimensions, View } from 'react-native';
import { initMeta, reduceMeta } from './game/history.js';
import { DragOverlayProvider } from './src/components/DragOverlay';
import { KlondikeTable } from './src/variants/Layouts';

export default function App() {
  const { width, height } = useWindowDimensions();
  const webScale = Platform.OS === 'web' ? 0.5 : 1;
  const uiScale =
    Math.min(2.25, Math.max(1, Math.min(width, height) / 780)) * webScale;
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
