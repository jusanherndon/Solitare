/** PROTOTYPE — deal a Klondike Game. No DOM. */

import { SUITS } from './rules.js';

function mulberry32(seed) {
  let t = seed >>> 0;
  return () => {
    t += 0x6d2b79f5;
    let r = Math.imul(t ^ (t >>> 15), 1 | t);
    r ^= r + Math.imul(r ^ (r >>> 7), 61 | r);
    return ((r ^ (r >>> 14)) >>> 0) / 4294967296;
  };
}

function buildDeck() {
  const deck = [];
  for (const suit of SUITS) {
    for (let rank = 1; rank <= 13; rank++) {
      deck.push({ id: `${suit}-${rank}`, suit, rank, faceUp: false });
    }
  }
  return deck;
}

function shuffle(deck, seed) {
  const rand = mulberry32(seed);
  const out = deck.slice();
  for (let i = out.length - 1; i > 0; i--) {
    const j = Math.floor(rand() * (i + 1));
    [out[i], out[j]] = [out[j], out[i]];
  }
  return out;
}

/** Standard Klondike deal: Tableau piles 1–7, tops face-up; rest face-down Stock. */
export function dealGame(seed = Date.now()) {
  const deck = shuffle(buildDeck(), seed);
  let i = 0;
  const tableau = [];
  for (let col = 0; col < 7; col++) {
    const pile = [];
    for (let n = 0; n <= col; n++) {
      const card = { ...deck[i++] };
      card.faceUp = n === col;
      pile.push(card);
    }
    tableau.push(pile);
  }
  const stock = deck.slice(i).map((c) => ({ ...c, faceUp: false }));
  return {
    stock,
    waste: [],
    foundations: [[], [], [], []],
    tableau,
    selection: null,
    won: false,
  };
}
