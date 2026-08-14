/** PROTOTYPE — Klondike reducer. Pure; portable into the real app later. */

import { dealGame } from './deal.js';
import {
  canStackOnFoundation,
  canStackOnTableau,
  getPile,
  isWin,
  tableauRunIsLegal,
} from './rules.js';

function cloneState(state) {
  return {
    stock: state.stock.map((c) => ({ ...c })),
    waste: state.waste.map((c) => ({ ...c })),
    foundations: state.foundations.map((p) => p.map((c) => ({ ...c }))),
    tableau: state.tableau.map((p) => p.map((c) => ({ ...c }))),
    selection: state.selection
      ? { ...state.selection, from: { ...state.selection.from } }
      : null,
    won: state.won,
  };
}

function setPile(state, pile, cards) {
  switch (pile.area) {
    case 'stock':
      state.stock = cards;
      break;
    case 'waste':
      state.waste = cards;
      break;
    case 'foundation':
      state.foundations[pile.index] = cards;
      break;
    case 'tableau':
      state.tableau[pile.index] = cards;
      break;
  }
}

function samePile(a, b) {
  if (a.area !== b.area) return false;
  if (a.area === 'foundation' && b.area === 'foundation') return a.index === b.index;
  if (a.area === 'tableau' && b.area === 'tableau') return a.index === b.index;
  return true;
}

function takeSelection(state, sel) {
  const pile = getPile(state, sel.from);
  if (sel.from.area === 'stock') return null;
  if (sel.from.area === 'waste' || sel.from.area === 'foundation') {
    if (pile.length === 0) return null;
    return [pile[pile.length - 1]];
  }
  if (!tableauRunIsLegal(pile, sel.cardIndex)) return null;
  return pile.slice(sel.cardIndex);
}

function removeSelection(state, sel, count) {
  const pile = getPile(state, sel.from).slice();
  if (sel.from.area === 'waste' || sel.from.area === 'foundation') {
    pile.pop();
  } else if (sel.from.area === 'tableau') {
    pile.splice(sel.cardIndex, count);
    if (pile.length > 0 && !pile[pile.length - 1].faceUp) {
      pile[pile.length - 1] = { ...pile[pile.length - 1], faceUp: true };
    }
  }
  setPile(state, sel.from, pile);
}

function canDrop(moving, onto, state) {
  if (moving.length === 0) return false;
  const head = moving[0];
  if (onto.area === 'stock' || onto.area === 'waste') return false;
  if (onto.area === 'foundation') {
    if (moving.length !== 1) return false;
    return canStackOnFoundation(head, state.foundations[onto.index]);
  }
  const targetPile = state.tableau[onto.index];
  const target = targetPile.length ? targetPile[targetPile.length - 1] : undefined;
  return canStackOnTableau(head, target);
}

function applyDrop(state, onto, from, cardIndex) {
  const next = cloneState(state);
  // Drag can name the source directly; tap→tap uses existing selection.
  if (from) {
    next.selection = { from, cardIndex: cardIndex ?? 0 };
  }
  if (!next.selection) return state;
  const sel = next.selection;
  if (samePile(sel.from, onto)) {
    next.selection = null;
    return next;
  }
  const moving = takeSelection(next, sel);
  if (!moving || !canDrop(moving, onto, next)) {
    next.selection = null;
    return next;
  }
  removeSelection(next, sel, moving.length);
  const dest = getPile(next, onto).slice();
  dest.push(...moving.map((c) => ({ ...c, faceUp: true })));
  setPile(next, onto, dest);
  next.selection = null;
  next.won = isWin(next.foundations);
  return next;
}

function applySelect(state, pile, cardIndex) {
  if (pile.area === 'stock') return state;
  const cards = getPile(state, pile);
  if (cards.length === 0) return { ...state, selection: null };

  if (pile.area === 'waste' || pile.area === 'foundation') {
    return { ...state, selection: { from: pile, cardIndex: cards.length - 1 } };
  }

  const idx = cardIndex ?? cards.length - 1;
  if (idx < 0 || idx >= cards.length || !cards[idx].faceUp) return state;
  if (!tableauRunIsLegal(cards, idx)) return state;
  return { ...state, selection: { from: pile, cardIndex: idx } };
}

function applyAutoMove(state, from, cardIndex) {
  if (from.area === 'stock') return state;
  const cards = getPile(state, from);
  if (cards.length === 0) return { ...state, selection: null };

  let idx = cardIndex;
  if (from.area === 'waste' || from.area === 'foundation') {
    idx = cards.length - 1;
  } else {
    idx = cardIndex ?? cards.length - 1;
    if (idx < 0 || idx >= cards.length || !cards[idx].faceUp) {
      return { ...state, selection: null };
    }
    if (!tableauRunIsLegal(cards, idx)) return { ...state, selection: null };
  }

  const moving = takeSelection(state, { from, cardIndex: idx });
  if (!moving) return { ...state, selection: null };

  // Prefer Foundations (e.g. 2 → matching Ace), then any legal Tableau.
  for (let i = 0; i < 4; i++) {
    const onto = { area: 'foundation', index: i };
    if (canDrop(moving, onto, state)) {
      return applyDrop(state, onto, from, idx);
    }
  }
  for (let i = 0; i < 7; i++) {
    const onto = { area: 'tableau', index: i };
    if (from.area === 'tableau' && from.index === i) continue;
    if (canDrop(moving, onto, state)) {
      return applyDrop(state, onto, from, idx);
    }
  }
  return { ...state, selection: null };
}

function applyTap(state, pile, cardIndex) {
  if (pile.area === 'stock') return reduce(state, { type: 'DRAW' });
  if (state.selection) return applyDrop(state, pile);
  return applySelect(state, pile, cardIndex);
}

function draw(state) {
  const next = cloneState(state);
  next.selection = null;
  if (next.stock.length === 0) {
    // Computer Klondike: recycle Waste → Stock (unlimited passes).
    // Flip the Waste pile face-down onto the Stock so drawing continues.
    if (next.waste.length === 0) return next;
    next.stock = next.waste
      .slice()
      .reverse()
      .map((c) => ({ ...c, faceUp: false }));
    next.waste = [];
    return next;
  }
  const card = next.stock.pop();
  next.waste.push({ ...card, faceUp: true });
  return next;
}

export function reduce(state, action) {
  switch (action.type) {
    case 'NEW_GAME':
      return dealGame(action.seed ?? Date.now());
    case 'DRAW':
      return draw(state);
    case 'TAP':
      return applyTap(state, action.pile, action.cardIndex);
    case 'SELECT':
      return applySelect(state, action.pile, action.cardIndex);
    case 'DROP':
      return applyDrop(state, action.onto, action.from, action.cardIndex);
    case 'AUTO_MOVE':
      return applyAutoMove(state, action.pile, action.cardIndex);
    case 'CLEAR_SELECTION':
      return { ...state, selection: null };
    default:
      return state;
  }
}

export function selectedCardIds(state) {
  const ids = new Set();
  if (!state.selection) return ids;
  const cards = takeSelection(state, state.selection);
  if (!cards) return ids;
  for (const c of cards) ids.add(c.id);
  return ids;
}
