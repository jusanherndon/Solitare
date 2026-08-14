import { useCallback, useRef } from 'react';
import type { View } from 'react-native';

export type PileId =
  | { area: 'stock' }
  | { area: 'waste' }
  | { area: 'foundation'; index: number }
  | { area: 'tableau'; index: number };

type Rect = { x: number; y: number; w: number; h: number };
type Entry = { pile: PileId; view: View; rect?: Rect };

function pileKey(pile: PileId) {
  if (pile.area === 'foundation' || pile.area === 'tableau') {
    return `${pile.area}-${pile.index}`;
  }
  return pile.area;
}

/** measureInWindow hit-testing — no gesture-handler dependency. */
export function useHitRegistry() {
  const map = useRef(new Map<string, Entry>());

  const registerHit = useCallback((pile: PileId, view: View | null) => {
    const key = pileKey(pile);
    if (!view) {
      map.current.delete(key);
      return;
    }
    const entry: Entry = map.current.get(key) ?? { pile, view };
    entry.view = view;
    entry.pile = pile;
    map.current.set(key, entry);
    view.measureInWindow((x, y, w, h) => {
      const cur = map.current.get(key);
      if (cur) cur.rect = { x, y, w, h };
    });
  }, []);

  const refresh = useCallback(() => {
    for (const [key, entry] of map.current) {
      entry.view.measureInWindow((x, y, w, h) => {
        const cur = map.current.get(key);
        if (cur) cur.rect = { x, y, w, h };
      });
    }
  }, []);

  const hitTest = useCallback((pageX: number, pageY: number): PileId | null => {
    let best: PileId | null = null;
    let bestArea = Infinity;
    for (const entry of map.current.values()) {
      const r = entry.rect;
      if (!r || r.w <= 0 || r.h <= 0) continue;
      if (
        pageX >= r.x &&
        pageX <= r.x + r.w &&
        pageY >= r.y &&
        pageY <= r.y + r.h
      ) {
        const area = r.w * r.h;
        if (area < bestArea) {
          bestArea = area;
          best = entry.pile;
        }
      }
    }
    return best;
  }, []);

  return { registerHit, hitTest, refresh };
}
