/** PROTOTYPE — pure Klondike rules helpers. No DOM. */

export const SUITS = ['spades', 'hearts', 'diamonds', 'clubs'];

export const RANK_LABEL = {
  1: 'A',
  2: '2',
  3: '3',
  4: '4',
  5: '5',
  6: '6',
  7: '7',
  8: '8',
  9: '9',
  10: '10',
  11: 'J',
  12: 'Q',
  13: 'K',
};

export const SUIT_GLYPH = {
  spades: '♠',
  hearts: '♥',
  diamonds: '♦',
  clubs: '♣',
};

export function isRed(suit) {
  return suit === 'hearts' || suit === 'diamonds';
}

export function canStackOnTableau(moving, target) {
  if (!target) return moving.rank === 13;
  return isRed(moving.suit) !== isRed(target.suit) && moving.rank === target.rank - 1;
}

export function canStackOnFoundation(moving, pile) {
  if (pile.length === 0) return moving.rank === 1;
  const top = pile[pile.length - 1];
  return moving.suit === top.suit && moving.rank === top.rank + 1;
}

export function getPile(state, pile) {
  switch (pile.area) {
    case 'stock':
      return state.stock;
    case 'waste':
      return state.waste;
    case 'foundation':
      return state.foundations[pile.index];
    case 'tableau':
      return state.tableau[pile.index];
    default:
      return [];
  }
}

export function isWin(foundations) {
  return foundations.every((p) => p.length === 13);
}

export function tableauRunIsLegal(pile, cardIndex) {
  if (cardIndex < 0 || cardIndex >= pile.length) return false;
  if (!pile[cardIndex].faceUp) return false;
  for (let i = cardIndex; i < pile.length - 1; i++) {
    const a = pile[i];
    const b = pile[i + 1];
    if (!b.faceUp) return false;
    if (!canStackOnTableau(b, a)) return false;
  }
  return true;
}
