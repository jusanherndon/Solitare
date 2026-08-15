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
  const corner = Math.max(22, Math.round(width * 0.4));
  const empty = Math.max(22, Math.round(width * 0.34));
  const wantedCenter = Math.max(36, Math.round(width * 0.8));
  const center = Math.min(
    wantedCenter,
    Math.max(12, Math.round(height - pad * 2 - corner - 4)),
  );
  const radius = Math.max(6, Math.round(width * 0.1));

  if (!card) {
    return (
      <View style={[styles.slot, { width, height, borderRadius: radius }]}>
        {emptyLabel ? (
          <Text
            style={[styles.emptyLabel, { fontSize: empty, lineHeight: empty, includeFontPadding: false }]}
            selectable={false}
            numberOfLines={1}
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
  return (
    <View
      style={[
        styles.face,
        { width, height, borderRadius: radius, padding: pad, overflow: 'hidden' },
        selected && styles.selected,
      ]}
    >
      <Text
        style={[
          styles.corner,
          { color, fontSize: corner, lineHeight: corner, includeFontPadding: false },
        ]}
        selectable={false}
        numberOfLines={1}
      >
        {rankLabel}
        {suitGlyph}
      </Text>
      {center >= 12 ? (
        <Text
          style={[
            styles.center,
            { color, fontSize: center, lineHeight: center, includeFontPadding: false },
          ]}
          selectable={false}
          numberOfLines={1}
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
