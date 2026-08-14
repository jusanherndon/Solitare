/**
 * PROTOTYPE for #6 — throwaway Expo phone/web shell.
 * Expo is vendored at ../../vendor/expo (ADR-0001).
 */
import { useReducer, useState } from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { dealGame } from './game/deal.js';
import { reduce, selectedCardIds } from './game/reducer.js';
import { PrototypeSwitcher, type VariantKey } from './src/components/PrototypeSwitcher';
import { VariantA, VariantB, VariantC } from './src/variants/Layouts';

export default function App() {
  const [variant, setVariant] = useState<VariantKey>('A');
  const [state, dispatch] = useReducer(
    (s: any, a: any) => reduce(s, a),
    undefined,
    () => dealGame(42),
  );

  const game = {
    state,
    selected: selectedCardIds(state),
    tap: (pile: any, cardIndex?: number) => dispatch({ type: 'TAP', pile, cardIndex }),
    select: (pile: any, cardIndex?: number) => dispatch({ type: 'SELECT', pile, cardIndex }),
    drop: (onto: any) => dispatch({ type: 'DROP', onto }),
    draw: () => dispatch({ type: 'DRAW' }),
    newGame: () => dispatch({ type: 'NEW_GAME' }),
  };

  return (
    <View style={styles.root}>
      {variant === 'A' && <VariantA game={game} />}
      {variant === 'B' && <VariantB game={game} />}
      {variant === 'C' && <VariantC game={game} />}
      <View style={[styles.hint, { pointerEvents: 'none' }]}>
        <Text style={styles.hintText}>
          Tap → tap destination · drag · rotate device
        </Text>
      </View>
      {process.env.NODE_ENV !== 'production' ? (
        <PrototypeSwitcher current={variant} onChange={setVariant} />
      ) : null}
    </View>
  );
}

const styles = StyleSheet.create({
  root: { flex: 1, backgroundColor: '#1f6b45' },
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
    fontSize: 10,
  },
});
