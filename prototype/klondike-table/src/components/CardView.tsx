import { StyleSheet, Text, View } from 'react-native';
import { RANK_LABEL, SUIT_GLYPH, isRed } from '../../game/rules.js';

type Props = {
  card?: { id: string; suit: string; rank: number; faceUp: boolean };
  width: number;
  height: number;
  emptyLabel?: string;
};

const noSelect = {
  userSelect: 'none',
  WebkitUserSelect: 'none',
  MozUserSelect: 'none',
  msUserSelect: 'none',
  WebkitUserDrag: 'none',
  WebkitTouchCallout: 'none',
} as const;

export function CardView({ card, width, height, emptyLabel }: Props) {
  const corner = Math.max(11, Math.round(width * 0.2));
  const center = Math.max(18, Math.round(width * 0.4));
  const empty = Math.max(11, Math.round(width * 0.17));
  const radius = Math.max(6, Math.round(width * 0.1));

  if (!card) {
    return (
      <View style={[styles.slot, { width, height, borderRadius: radius }]}>
        {emptyLabel ? (
          <Text style={[styles.emptyLabel, { fontSize: empty }]} selectable={false}>
            {emptyLabel}
          </Text>
        ) : null}
      </View>
    );
  }

  if (!card.faceUp) {
    return (
      <View
        style={[
          styles.back,
          { width, height, borderRadius: radius, padding: Math.max(3, width * 0.05) },
        ]}
      >
        <View style={styles.backInner} />
      </View>
    );
  }

  const color = isRed(card.suit) ? '#c62828' : '#1a1a1a';
  const rankLabel = (RANK_LABEL as Record<number, string>)[card.rank];
  const suitGlyph = (SUIT_GLYPH as Record<string, string>)[card.suit];
  return (
    <View
      style={[
        styles.face,
        { width, height, borderRadius: radius, padding: Math.max(3, width * 0.05) },
      ]}
    >
      <Text style={[styles.corner, { color, fontSize: corner }]} selectable={false}>
        {rankLabel}
        {suitGlyph}
      </Text>
      <Text style={[styles.center, { color, fontSize: center }]} selectable={false}>
        {suitGlyph}
      </Text>
    </View>
  );
}

const styles = StyleSheet.create({
  slot: {
    borderWidth: 1.5,
    borderColor: 'rgba(255,255,255,0.28)',
    borderStyle: 'dashed',
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: 'rgba(0,0,0,0.12)',
    ...noSelect,
  },
  emptyLabel: {
    color: 'rgba(255,255,255,0.45)',
    fontWeight: '600',
    ...noSelect,
  },
  back: {
    backgroundColor: '#1e3a5f',
    borderWidth: 1,
    borderColor: 'rgba(255,255,255,0.35)',
    ...noSelect,
  },
  backInner: {
    flex: 1,
    borderRadius: 3,
    borderWidth: 1,
    borderColor: 'rgba(255,255,255,0.2)',
    backgroundColor: '#2a5080',
  },
  face: {
    backgroundColor: '#f7f3ea',
    borderWidth: 1,
    borderColor: '#cfc6b4',
    ...noSelect,
  },
  corner: {
    fontWeight: '700',
    letterSpacing: -0.5,
    ...noSelect,
  },
  center: {
    flex: 1,
    textAlign: 'center',
    textAlignVertical: 'center',
    fontWeight: '600',
    ...noSelect,
  },
});
