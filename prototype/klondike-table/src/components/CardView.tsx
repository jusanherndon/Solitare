import { StyleSheet, Text, View } from 'react-native';
import { RANK_LABEL, SUIT_GLYPH, isRed } from '../../game/rules.js';

type Props = {
  card?: { id: string; suit: string; rank: number; faceUp: boolean };
  width: number;
  height: number;
  selected?: boolean;
  emptyLabel?: string;
};

export function CardView({ card, width, height, selected, emptyLabel }: Props) {
  if (!card) {
    return (
      <View style={[styles.slot, { width, height }, selected && styles.selected]}>
        {emptyLabel ? <Text style={styles.emptyLabel}>{emptyLabel}</Text> : null}
      </View>
    );
  }

  if (!card.faceUp) {
    return (
      <View style={[styles.back, { width, height }, selected && styles.selected]}>
        <View style={styles.backInner} />
      </View>
    );
  }

  const color = isRed(card.suit) ? '#c62828' : '#1a1a1a';
  const rankLabel = (RANK_LABEL as Record<number, string>)[card.rank];
  const suitGlyph = (SUIT_GLYPH as Record<string, string>)[card.suit];
  return (
    <View style={[styles.face, { width, height }, selected && styles.selected]}>
      <Text style={[styles.corner, { color }]}>
        {rankLabel}
        {suitGlyph}
      </Text>
      <Text style={[styles.center, { color }]}>{suitGlyph}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  slot: {
    borderRadius: 6,
    borderWidth: 1.5,
    borderColor: 'rgba(255,255,255,0.28)',
    borderStyle: 'dashed',
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: 'rgba(0,0,0,0.12)',
  },
  emptyLabel: {
    color: 'rgba(255,255,255,0.45)',
    fontSize: 11,
    fontWeight: '600',
  },
  back: {
    borderRadius: 6,
    backgroundColor: '#1e3a5f',
    borderWidth: 1,
    borderColor: 'rgba(255,255,255,0.35)',
    padding: 3,
  },
  backInner: {
    flex: 1,
    borderRadius: 3,
    borderWidth: 1,
    borderColor: 'rgba(255,255,255,0.2)',
    backgroundColor: '#2a5080',
  },
  face: {
    borderRadius: 6,
    backgroundColor: '#f7f3ea',
    borderWidth: 1,
    borderColor: '#cfc6b4',
    padding: 3,
  },
  corner: {
    fontSize: 11,
    fontWeight: '700',
    letterSpacing: -0.5,
  },
  center: {
    flex: 1,
    textAlign: 'center',
    textAlignVertical: 'center',
    fontSize: 22,
    fontWeight: '600',
  },
  selected: {
    borderColor: '#ffd54f',
    borderWidth: 2,
  },
});
