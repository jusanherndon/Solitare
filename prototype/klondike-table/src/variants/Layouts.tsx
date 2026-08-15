import { Pressable, StyleSheet, Text, View } from 'react-native';
import { selectedCardIds } from '../../game/reducer.js';
import { useBoardMetrics } from './boardMetrics';
import { InteractivePile, StockPile } from '../components/InteractivePile';
import { useHitRegistry } from '../components/useHitRegistry';

type Game = {
  state: any;
  canUndo: boolean;
  tap: (pile: any, cardIndex?: number) => void;
  autoMove: (pile: any, cardIndex?: number) => void;
  drop: (onto: any, from?: any, cardIndex?: number) => void;
  draw: () => void;
  newGame: () => void;
  undo: () => void;
};

function ChromeButton({
  label,
  onPress,
  uiScale,
  disabled,
}: {
  label: string;
  onPress: () => void;
  uiScale: number;
  disabled?: boolean;
}) {
  return (
    <Pressable
      onPress={onPress}
      disabled={disabled}
      style={[
        styles.newGame,
        {
          paddingHorizontal: Math.round(14 * uiScale),
          paddingVertical: Math.round(8 * uiScale),
          opacity: disabled ? 0.4 : 1,
        },
      ]}
    >
      <Text style={[styles.newGameText, { fontSize: Math.round(13 * uiScale) }]}>
        {label}
      </Text>
    </Pressable>
  );
}

function ActionRow({ game, uiScale }: { game: Game; uiScale: number }) {
  return (
    <View style={styles.actionRow}>
      <ChromeButton
        label="Undo"
        onPress={game.undo}
        uiScale={uiScale}
        disabled={!game.canUndo}
      />
      <ChromeButton label="New Game" onPress={game.newGame} uiScale={uiScale} />
    </View>
  );
}

function WinBanner({ visible, uiScale }: { visible: boolean; uiScale: number }) {
  if (!visible) return null;
  return (
    <View style={styles.win}>
      <Text style={[styles.winText, { fontSize: Math.round(28 * uiScale) }]}>Win</Text>
    </View>
  );
}

/** Classic top row: Stock/Waste left, Foundations right, Tableau below. */
export function KlondikeTable({ game }: { game: Game }) {
  const m = useBoardMetrics();
  const insets = m.insets;
  const { state, tap, autoMove, drop, draw } = game;
  const { registerHit, hitTest, refresh } = useHitRegistry();
  const selectedIds = selectedCardIds(state);

  return (
    <View
      style={[
        styles.root,
        {
          paddingTop: insets.top + 8,
          paddingBottom: insets.bottom + 12,
          alignItems: 'center',
        },
      ]}
    >
      <View style={{ width: '100%', maxWidth: m.boardMax, paddingHorizontal: m.pad, flex: 1 }}>
        <View style={styles.topBar}>
          <View />
          <ActionRow game={game} uiScale={m.uiScale} />
        </View>
        <View
          style={[
            styles.row,
            { gap: m.gap, marginBottom: m.landscape ? 12 : 16 },
          ]}
        >
          <StockPile
            count={state.stock.length}
            size={{ width: m.topCardW, height: m.topCardH }}
            onDraw={draw}
          />
          <InteractivePile
            pile={{ area: 'waste' }}
            cards={state.waste}
            size={{ width: m.topCardW, height: m.topCardH }}
            emptyLabel="Waste"
            onTap={tap}
            onAutoMove={autoMove}
            onDrop={drop}
            registerHit={registerHit}
            hitTest={hitTest}
            refreshHits={refresh}
            selectedIds={selectedIds}
          />
          <View style={{ width: Math.max(12, m.topCardW * 0.35) }} />
          {state.foundations.map((pile: any[], index: number) => (
            <InteractivePile
              key={index}
              pile={{ area: 'foundation', index }}
              cards={pile}
              size={{ width: m.topCardW, height: m.topCardH }}
              emptyLabel=""
              onTap={tap}
              onAutoMove={autoMove}
              onDrop={drop}
              registerHit={registerHit}
              hitTest={hitTest}
              refreshHits={refresh}
              selectedIds={selectedIds}
            />
          ))}
        </View>
        <View style={[styles.row, { gap: m.gap, alignItems: 'flex-start', flex: 1, overflow: 'visible' }]}>
          {state.tableau.map((pile: any[], index: number) => (
            <InteractivePile
              key={index}
              pile={{ area: 'tableau', index }}
              cards={pile}
              size={{ width: m.cardW, height: m.cardH }}
              fanOffset={m.fan}
              emptyLabel=" "
              onTap={tap}
              onAutoMove={autoMove}
              onDrop={drop}
              registerHit={registerHit}
              hitTest={hitTest}
              refreshHits={refresh}
              selectedIds={selectedIds}
            />
          ))}
        </View>
      </View>
      <WinBanner visible={state.won} uiScale={m.uiScale} />
    </View>
  );
}

const styles = StyleSheet.create({
  root: { flex: 1, backgroundColor: '#1f6b45', overflow: 'visible' },
  topBar: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'flex-end',
    marginBottom: 10,
  },
  actionRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
  },
  row: { flexDirection: 'row', overflow: 'visible' },
  newGame: {
    backgroundColor: 'rgba(0,0,0,0.35)',
    borderRadius: 8,
    borderWidth: 1,
    borderColor: 'rgba(255,255,255,0.25)',
  },
  newGameText: {
    color: '#fff',
    fontWeight: '700',
    textAlign: 'center',
  },
  win: {
    position: 'absolute',
    alignSelf: 'center',
    top: '40%',
    backgroundColor: 'rgba(0,0,0,0.75)',
    paddingHorizontal: 28,
    paddingVertical: 14,
    borderRadius: 12,
  },
  winText: { color: '#ffd54f', fontWeight: '800' },
});
