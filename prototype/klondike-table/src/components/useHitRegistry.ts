import { useCallback, useRef } from 'react';
import type { View } from 'react-native';

type PileId =
  | { area: 'stock' }
  | { area: 'waste' }
  | { area: 'foundation'; index: number }
  | { area: 'tableau'; index: number };

type Entry = { pile: PileId; view: View };

function pileKey(pile: PileId) {
  if (pile.area === 'foundation' || pile.area === 'tableau') {
    return `${pile.area}-${pile.index}`;
  }
  return pile.area;
}

/** measureInWindow hit-testing — no gesture-handler dependency. */
export function useHitRegistry() {
  const map = useRef(new Map<string, Entry>());

  const register = useCallback((pile: PileId, view: View | null) => {
    const key = pileKey(pile);
    if (!view) {
      map.current.delete(key);
      return;
    }
    map.current.set(key, { pile, view });
  }, []);

  const hitTest = useCallback((pageX: number, pageY: number): PileId | null => {
    let best: PileId | null = null;
    let bestArea = Infinity;
    const entries = [...map.current.values()];
    // Synchronous measure is awkward; use cached layout if we refresh on layout.
    // Fall back: iterate and measureInWindow (async) — for prototype, store last rects.
    for (const entry of entries) {
      const anyEntry = entry as Entry & { rect?: { x: number; y: number; w: number; h: number } };
      const r = anyEntry.rect;
      if (!r) continue;
      if (pageX >= r.x && pageX <= r.x + r.w && pageY >= r.y && pageY <= r.y + r.h) {
        const area = r.w * r.h;
        if (area < bestArea) {
          bestArea = area;
          best = entry.pile;
        }
      }
    }
    return best;
  }, []);

  const registerHit = useCallback((pile: PileId, view: View | null) => {
    register(pile, view);
    if (!view) return;
    view.measureInWindow((x, y, w, h) => {
      const key = pileKey(pile);
      const entry = map.current.get(key);
      if (entry) {
        (entry as any).rect = { x, y, w, h };
      }
    });
  }, [register]);

  return { registerHit, hitTest };
}
