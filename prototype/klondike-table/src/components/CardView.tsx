import { StyleSheet, Text, View } from 'react-native';
import { RANK_LABEL, SUIT_GLYPH, isRed } from '../../game/rules.js';

type Props = {
  card?: { id: string; suit: string; rank: number; faceUp: boolean };
  width: number;
  height: number;
  emptyLabel?: string;
  selected?: boolean;
};

const noSelect = {
  userSelect: 'none',
  WebkitUserSelect: 'none',
  MozUserSelect: 'none',
  msUserSelect: 'none',
  WebkitUserDrag: 'none',
  WebkitTouchCallout: 'none',
} as const;

export function CardView({ card, width, height, emptyLabel, selected }: Props) {
  const pad = Math.max(3, width * 0.05);
  const inner = Math.max(8, width - pad * 2);
  // Rank + suit in the peek: small enough that both lines fit on a stacked card.
  const corner = Math.min(Math.round(inner * 0.7), Math.max(11, Math.round(width * 0.24)));
  const empty = Math.min(inner, Math.max(11, Math.round(width * 0.17)));
  const radius = Math.max(6, Math.round(width * 0.1));
  const type = {
    includeFontPadding: false as const,
  };

  if (!card) {
    return (
      <View style={[styles.slot, { width, height, borderRadius: radius }]}>
        {emptyLabel ? (
          <Text
            style={[styles.emptyLabel, { fontSize: empty, lineHeight: empty, ...type }]}
            selectable={false}
          >
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
          { width, height, borderRadius: radius, padding: pad, overflow: 'hidden' },
        ]}
      >
        <View style={styles.backInner} />
      </View>
    );
  }

  const color = isRed(card.suit) ? '#c62828' : '#1a1a1a';
  const rankLabel = (RANK_LABEL as Record<number, string>)[card.rank];
  const suitGlyph = (SUIT_GLYPH as Record<string, string>)[card.suit];
  const cornerBlock = corner * 2;
  const remainH = height - pad * 2 - cornerBlock - 2;
  const center = remainH >= 18 && inner >= 18 ? Math.min(Math.round(inner * 0.85), remainH) : 0;

  return (
    <View
      style={[
        styles.face,
        { width, height, borderRadius: radius, padding: pad, overflow: 'hidden' },
        selected && styles.selected,
      ]}
    >
      <Text style={[styles.corner, { color, fontSize: corner, lineHeight: corner, ...type }]} selectable={false}>
        {rankLabel}
      </Text>
      <Text style={[styles.corner, { color, fontSize: corner, lineHeight: corner, ...type }]} selectable={false}>
        {suitGlyph}
      </Text>
      {center >= 18 ? (
        <Text
          style={[styles.center, { color, fontSize: center, lineHeight: center, ...type }]}
          selectable={false}
        >
          {suitGlyph}
        </Text>
      ) : null}
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
  selected: {
    borderWidth: 2,
    borderColor: '#ffd54f',
    backgroundColor: '#fff8e1',
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
