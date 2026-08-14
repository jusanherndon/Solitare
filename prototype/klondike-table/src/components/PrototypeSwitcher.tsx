import { useEffect } from 'react';
import { Pressable, StyleSheet, Text, View } from 'react-native';

export type VariantKey = 'A' | 'B' | 'C';

export const VARIANTS: { key: VariantKey; name: string }[] = [
  { key: 'A', name: 'Classic top row' },
  { key: 'B', name: 'Thumb dock' },
  { key: 'C', name: 'Side rails' },
];

type Props = {
  current: VariantKey;
  onChange: (key: VariantKey) => void;
};

/** Floating prototype switcher — not part of the product design. */
export function PrototypeSwitcher({ current, onChange }: Props) {
  const idx = VARIANTS.findIndex((v) => v.key === current);

  const cycle = (dir: -1 | 1) => {
    const next = (idx + dir + VARIANTS.length) % VARIANTS.length;
    onChange(VARIANTS[next].key);
  };

  useEffect(() => {
    if (typeof window === 'undefined') return;
    const onKey = (e: KeyboardEvent) => {
      const t = e.target as HTMLElement | null;
      if (t && (t.tagName === 'INPUT' || t.tagName === 'TEXTAREA' || t.isContentEditable)) {
        return;
      }
      if (e.key === 'ArrowLeft') cycle(-1);
      if (e.key === 'ArrowRight') cycle(1);
    };
    window.addEventListener('keydown', onKey);
    return () => window.removeEventListener('keydown', onKey);
  }, [idx]);

  const label = VARIANTS[idx];
  return (
    <View style={[styles.bar, { pointerEvents: 'box-none' }]}>
      <View style={styles.pill}>
        <Pressable onPress={() => cycle(-1)} style={styles.arrow} hitSlop={8}>
          <Text style={styles.arrowText}>‹</Text>
        </Pressable>
        <Text style={styles.label} numberOfLines={1}>
          {label.key} — {label.name}
        </Text>
        <Pressable onPress={() => cycle(1)} style={styles.arrow} hitSlop={8}>
          <Text style={styles.arrowText}>›</Text>
        </Pressable>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  bar: {
    position: 'absolute',
    left: 0,
    right: 0,
    bottom: 10,
    alignItems: 'center',
    zIndex: 100,
  },
  pill: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#111',
    borderRadius: 999,
    paddingHorizontal: 6,
    paddingVertical: 6,
    maxWidth: '92%',
    borderWidth: 1,
    borderColor: '#444',
  },
  arrow: {
    width: 36,
    height: 36,
    alignItems: 'center',
    justifyContent: 'center',
  },
  arrowText: {
    color: '#fff',
    fontSize: 28,
    lineHeight: 30,
    fontWeight: '600',
  },
  label: {
    color: '#fff',
    fontSize: 13,
    fontWeight: '600',
    paddingHorizontal: 6,
    minWidth: 140,
    textAlign: 'center',
  },
});
