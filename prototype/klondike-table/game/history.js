/** Undo history around the pure Klondike reducer. Selection-only changes are skipped. */

import { dealGame } from './deal.js';
import { reduce } from './reducer.js';

function boardKey(state) {
  // Ignore selection — only pile contents matter for undo steps.
  return JSON.stringify({
    stock: state.stock,
    waste: state.waste,
    foundations: state.foundations,
    tableau: state.tableau,
    won: state.won,
  });
}

export function initMeta(seed = 42) {
  return { present: dealGame(seed), past: [] };
}

export function reduceMeta(state, action) {
  if (action.type === 'UNDO') {
    if (state.past.length === 0) return state;
    const past = state.past.slice();
    const present = past.pop();
    return { present, past };
  }

  if (action.type === 'NEW_GAME') {
    return { present: reduce(state.present, action), past: [] };
  }

  const next = reduce(state.present, action);
  if (boardKey(next) === boardKey(state.present)) {
    // Selection-only or no-op — update present without a history entry
    return next === state.present ? state : { ...state, present: next };
  }

  return {
    present: next,
    past: [...state.past, state.present],
  };
}
