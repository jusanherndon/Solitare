import { Pressable, StyleSheet, Text, useWindowDimensions, View } from 'react-native';
import { useSafeAreaInsetsApprox } from './safeArea';
import { InteractivePile, StockPile } from '../components/InteractivePile';
import { useHitRegistry } from '../components/useHitRegistry';
import { SUIT_GLYPH, SUITS } from '../../game/rules.js';

type Game = {
  state: any;
  selected: Set<string>;
  tap: (pile: any, cardIndex?: number) => void;
  select: (pile: any, cardIndex?: number) => void;
  drop: (onto: any) => void;
  draw: () => void;
  newGame: () => void;
};

function NewGameButton({ onPress }: { onPress: () => void }) {
  return (
    <Pressable onPress={onPress} style={styles.newGame}>
      <Text style={styles.newGameText}>New Game</Text>
    </Pressable>
  );
}

function WinBanner({ visible }: { visible: boolean }) {
  if (!visible) return null;
  return (
    <View style={styles.win}>
      <Text style={styles.winText}>Win</Text>
    </View>
  );
}

/** A — Classic: Stock/Waste left, Foundations right, Tableau below. */
export function VariantA({ game }: { game: Game }) {
  const insets = useSafeAreaInsetsApprox();
  const { width, height } = useWindowDimensions();
  const landscape = width > height;
  const boardMax = landscape ? Math.min(width - 24, 820) : Math.min(width - 20, 430);
  const pad = 10;
  const gap = landscape ? 8 : 4;
  const avail = boardMax - pad * 2;
  const cardW = Math.min(64, Math.floor((avail - gap * 6) / 7));
  const cardH = Math.round(cardW * 1.4);
  const topCardW = Math.min(cardW, Math.floor((avail - gap * 5) / 6));
  const topCardH = Math.round(topCardW * 1.4);
  const fan = Math.max(14, Math.round(cardH * 0.22));
  const { state, selected, tap, select, drop, draw, newGame } = game;
  const { registerHit, hitTest } = useHitRegistry();

  return (
    <View
      style={[
        styles.root,
        { paddingTop: insets.top + 8, paddingBottom: insets.bottom + 56, alignItems: 'center' },
      ]}
    >
      <View style={{ width: boardMax, paddingHorizontal: pad, flex: 1 }}>
        <View style={styles.topBar}>
          <Text style={styles.variantHint}>Classic top row</Text>
          <NewGameButton onPress={newGame} />
        </View>
        <View style={[styles.row, { gap, marginBottom: landscape ? 12 : 16 }]}>
          <StockPile
            count={state.stock.length}
            size={{ width: topCardW, height: topCardH }}
            onDraw={draw}
          />
          <InteractivePile
            pile={{ area: 'waste' }}
            cards={state.waste}
            size={{ width: topCardW, height: topCardH }}
            selectedIds={selected}
            emptyLabel="Waste"
            onTap={tap}
            onDrop={drop}
            onSelectForDrag={select}
            registerHit={registerHit}
            hitTest={hitTest}
          />
          <View style={{ width: Math.max(12, topCardW * 0.35) }} />
          {state.foundations.map((pile: any[], index: number) => (
            <InteractivePile
              key={index}
              pile={{ area: 'foundation', index }}
              cards={pile}
              size={{ width: topCardW, height: topCardH }}
              selectedIds={selected}
              emptyLabel={(SUIT_GLYPH as Record<string, string>)[SUITS[index]]}
              onTap={tap}
              onDrop={drop}
              onSelectForDrag={select}
              registerHit={registerHit}
              hitTest={hitTest}
            />
          ))}
        </View>
        <View style={[styles.row, { gap, alignItems: 'flex-start', flex: 1 }]}>
          {state.tableau.map((pile: any[], index: number) => (
            <InteractivePile
              key={index}
              pile={{ area: 'tableau', index }}
              cards={pile}
              size={{ width: cardW, height: cardH }}
              selectedIds={selected}
              fanOffset={fan}
              emptyLabel=" "
              onTap={tap}
              onDrop={drop}
              onSelectForDrag={select}
              registerHit={registerHit}
              hitTest={hitTest}
            />
          ))}
        </View>
      </View>
      <WinBanner visible={state.won} />
    </View>
  );
}

/** B — Thumb dock */
export function VariantB({ game }: { game: Game }) {
  const insets = useSafeAreaInsetsApprox();
  const { width, height } = useWindowDimensions();
  const landscape = width > height;
  const gap = landscape ? 8 : 4;
  const avail = width - 20;
  const cardW = Math.min(64, Math.floor((avail - gap * 6) / 7));
  const cardH = Math.round(cardW * 1.4);
  const fan = Math.max(12, Math.round(cardH * (landscape ? 0.18 : 0.2)));
  const { state, selected, tap, select, drop, draw, newGame } = game;
  const { registerHit, hitTest } = useHitRegistry();

  return (
    <View
      style={[
        styles.root,
        {
          paddingTop: insets.top + 6,
          paddingBottom: insets.bottom + 56,
          paddingHorizontal: 8,
        },
      ]}
    >
      <View style={[styles.row, { gap, justifyContent: 'center', marginBottom: 8 }]}>
        {state.foundations.map((pile: any[], index: number) => (
          <InteractivePile
            key={index}
            pile={{ area: 'foundation', index }}
            cards={pile}
            size={{ width: cardW, height: cardH }}
            selectedIds={selected}
            emptyLabel={(SUIT_GLYPH as Record<string, string>)[SUITS[index]]}
            onTap={tap}
            onDrop={drop}
            onSelectForDrag={select}
            registerHit={registerHit}
            hitTest={hitTest}
          />
        ))}
      </View>
      <View style={[styles.row, { gap, alignItems: 'flex-start', flex: 1 }]}>
        {state.tableau.map((pile: any[], index: number) => (
          <InteractivePile
            key={index}
            pile={{ area: 'tableau', index }}
            cards={pile}
            size={{ width: cardW, height: cardH }}
            selectedIds={selected}
            fanOffset={fan}
            emptyLabel=" "
            onTap={tap}
            onDrop={drop}
            onSelectForDrag={select}
            registerHit={registerHit}
            hitTest={hitTest}
          />
        ))}
      </View>
      <View style={styles.dock}>
        <Text style={styles.dockLabel}>Thumb dock</Text>
        <View style={[styles.row, { gap: 12, alignItems: 'center' }]}>
          <StockPile
            count={state.stock.length}
            size={{ width: cardW, height: cardH }}
            onDraw={draw}
          />
          <InteractivePile
            pile={{ area: 'waste' }}
            cards={state.waste}
            size={{ width: cardW, height: cardH }}
            selectedIds={selected}
            emptyLabel="Waste"
            onTap={tap}
            onDrop={drop}
            onSelectForDrag={select}
            registerHit={registerHit}
            hitTest={hitTest}
          />
          <View style={{ flex: 1 }} />
          <NewGameButton onPress={newGame} />
        </View>
      </View>
      <WinBanner visible={state.won} />
    </View>
  );
}

/** C — Side rails */
export function VariantC({ game }: { game: Game }) {
  const insets = useSafeAreaInsetsApprox();
  const { width, height } = useWindowDimensions();
  const landscape = width > height;
  const railW = landscape ? 72 : 58;
  const midPad = 8;
  const avail = width - railW * 2 - midPad * 2 - 8;
  const gap = landscape ? 8 : 3;
  const cardW = Math.min(landscape ? 70 : 52, Math.floor((avail - gap * 6) / 7));
  const cardH = Math.round(cardW * 1.4);
  const fan = Math.max(12, Math.round(cardH * (landscape ? 0.2 : 0.18)));
  const { state, selected, tap, select, drop, draw, newGame } = game;
  const { registerHit, hitTest } = useHitRegistry();

  return (
    <View
      style={[
        styles.root,
        {
          paddingTop: insets.top + 6,
          paddingBottom: insets.bottom + 56,
          paddingHorizontal: 6,
          flexDirection: 'row',
        },
      ]}
    >
      <View style={[styles.rail, { width: railW }]}>
        <Text style={styles.railTitle}>Found.</Text>
        {state.foundations.map((pile: any[], index: number) => (
          <InteractivePile
            key={index}
            pile={{ area: 'foundation', index }}
            cards={pile}
            size={{ width: cardW, height: cardH }}
            selectedIds={selected}
            emptyLabel={(SUIT_GLYPH as Record<string, string>)[SUITS[index]]}
            onTap={tap}
            onDrop={drop}
            onSelectForDrag={select}
            registerHit={registerHit}
            hitTest={hitTest}
          />
        ))}
      </View>
      <View style={{ flex: 1, paddingHorizontal: midPad }}>
        <Text style={styles.variantHint}>Side rails</Text>
        <View style={[styles.row, { gap, alignItems: 'flex-start', flex: 1 }]}>
          {state.tableau.map((pile: any[], index: number) => (
            <InteractivePile
              key={index}
              pile={{ area: 'tableau', index }}
              cards={pile}
              size={{ width: cardW, height: cardH }}
              selectedIds={selected}
              fanOffset={fan}
              emptyLabel=" "
              onTap={tap}
              onDrop={drop}
              onSelectForDrag={select}
              registerHit={registerHit}
              hitTest={hitTest}
            />
          ))}
        </View>
      </View>
      <View style={[styles.rail, { width: railW, alignItems: 'center' }]}>
        <Text style={styles.railTitle}>Draw</Text>
        <StockPile
          count={state.stock.length}
          size={{ width: cardW, height: cardH }}
          onDraw={draw}
        />
        <InteractivePile
          pile={{ area: 'waste' }}
          cards={state.waste}
          size={{ width: cardW, height: cardH }}
          selectedIds={selected}
          emptyLabel="W"
          onTap={tap}
          onDrop={drop}
          onSelectForDrag={select}
          registerHit={registerHit}
          hitTest={hitTest}
        />
        <View style={{ flex: 1 }} />
        <Pressable onPress={newGame} style={styles.newGameTall}>
          <Text style={styles.newGameText}>New{'\n'}Game</Text>
        </Pressable>
      </View>
      <WinBanner visible={state.won} />
    </View>
  );
}

const styles = StyleSheet.create({
  root: { flex: 1, backgroundColor: '#1f6b45' },
  topBar: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    marginBottom: 10,
  },
  variantHint: {
    color: 'rgba(255,255,255,0.7)',
    fontSize: 13,
    fontWeight: '600',
    marginBottom: 6,
  },
  row: { flexDirection: 'row' },
  newGame: {
    backgroundColor: 'rgba(0,0,0,0.35)',
    paddingHorizontal: 14,
    paddingVertical: 8,
    borderRadius: 8,
    borderWidth: 1,
    borderColor: 'rgba(255,255,255,0.25)',
  },
  newGameTall: {
    backgroundColor: 'rgba(0,0,0,0.35)',
    paddingHorizontal: 8,
    paddingVertical: 10,
    borderRadius: 8,
    borderWidth: 1,
    borderColor: 'rgba(255,255,255,0.25)',
  },
  newGameText: {
    color: '#fff',
    fontWeight: '700',
    fontSize: 13,
    textAlign: 'center',
  },
  dock: {
    backgroundColor: 'rgba(0,0,0,0.28)',
    borderRadius: 14,
    padding: 10,
    marginTop: 8,
    borderWidth: 1,
    borderColor: 'rgba(255,255,255,0.12)',
  },
  dockLabel: {
    color: 'rgba(255,255,255,0.55)',
    fontSize: 11,
    fontWeight: '600',
    marginBottom: 6,
  },
  rail: { gap: 8, paddingVertical: 4 },
  railTitle: {
    color: 'rgba(255,255,255,0.55)',
    fontSize: 11,
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
  winText: { color: '#ffd54f', fontSize: 28, fontWeight: '800' },
});
