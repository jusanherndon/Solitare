import { useEffect, useState } from 'react';
import { PixelRatio, Platform, useWindowDimensions } from 'react-native';
import { useSafeAreaInsetsApprox } from './safeArea';

const CARD_RATIO = 1.4;
/** Chrome (buttons, hint) is sized relative to this phone-ish card width. */
const REF_CARD_W = 64;

function coarsePointer(): boolean {
  if (Platform.OS !== 'web') return true;
  return typeof window !== 'undefined' && !!window.matchMedia?.('(pointer: coarse)').matches;
}

function readWebViewport(): { width: number; height: number } | null {
  if (typeof window === 'undefined') return null;
  const vp = window.visualViewport;
  return {
    width: Math.round(vp?.width ?? window.innerWidth),
    height: Math.round(vp?.height ?? window.innerHeight),
  };
}

/**
 * Visible CSS box + density + text scale from the device.
 * Native: RN window. Web: visualViewport (browser chrome / pinch-zoom).
 */
function useViewport() {
  const win = useWindowDimensions();
  const [web, setWeb] = useState(readWebViewport);

  useEffect(() => {
    if (Platform.OS !== 'web' || typeof window === 'undefined') return;
    const sync = () => setWeb(readWebViewport());
    sync();
    window.addEventListener('resize', sync);
    window.visualViewport?.addEventListener('resize', sync);
    return () => {
      window.removeEventListener('resize', sync);
      window.visualViewport?.removeEventListener('resize', sync);
    };
  }, []);

  if (Platform.OS !== 'web') return win;
  return {
    width: web?.width || win.width,
    height: web?.height || win.height,
    scale: win.scale,
    fontScale: win.fontScale,
  };
}

/**
 * Phone: fill the device.
 * Desktop: a centered table with a comfortable card cap — not wall-to-wall.
 */
export function useBoardMetrics() {
  const { width, height, fontScale } = useViewport();
  const insets = useSafeAreaInsetsApprox();
  const touch = coarsePointer();
  const landscape = width > height;
  const short = Math.min(width, height);

  const fanRatio = landscape ? (touch ? 0.3 : 0.34) : touch ? 0.45 : 0.36;
  const minCard = touch ? 32 : 28;
  // Mouse/desktop: ~playing-card-on-a-table. Grows a little on tall monitors, never fills them.
  const maxCard = touch
    ? 100
    : Math.round(Math.min(84, Math.max(68, short * 0.055)));

  const pad = touch ? 8 : 20;
  const gap = touch ? 6 : 10;
  const chromeH =
    insets.top +
    insets.bottom +
    8 +
    12 +
    Math.round(48 * Math.min(fontScale, 1.3)) +
    10 +
    (landscape ? 12 : 16) +
    (touch ? 56 : 32);

  const availW = Math.max(0, width - insets.left - insets.right - pad * 2);
  const availH = Math.max(0, height - chromeH);

  // Peek must clear rank + suit on two lines.
  const fanFor = (w: number) => {
    const inner = Math.max(8, w - Math.max(3, w * 0.05) * 2);
    const label = Math.min(Math.round(inner * 0.7), Math.max(11, Math.round(w * 0.24)));
    const inset = Math.max(3, Math.round(w * 0.05));
    const readable = label * 2 + inset + 6;
    return Math.max(readable, Math.round(w * CARD_RATIO * fanRatio));
  };

  const heightFor = (w: number) => {
    const h = w * CARD_RATIO;
    return h + h + fanFor(w) * 6;
  };

  let cardW = Math.floor((availW - gap * 6) / 7);
  cardW = Math.min(cardW, maxCard);
  while (cardW > minCard && heightFor(cardW) > availH) cardW -= 1;
  cardW = Math.max(minCard, Math.min(maxCard, cardW));
  cardW = PixelRatio.roundToNearestPixel(cardW);

  const cardH = PixelRatio.roundToNearestPixel(cardW * CARD_RATIO);
  const maxFan = Math.floor((availH - cardH - cardH) / 6);
  const fan = Math.max(8, Math.min(fanFor(cardW), maxFan > 0 ? maxFan : fanFor(cardW)));
  const topCardW = cardW;
  const topCardH = cardH;
  const boardMax = 7 * cardW + 6 * gap + pad * 2;
  const chromeScale = Math.max(0.9, Math.min(touch ? 1.15 : 1.05, cardW / REF_CARD_W));
  const uiScale = chromeScale * fontScale;

  return {
    width,
    height,
    landscape,
    uiScale,
    fontScale,
    boardMax,
    gap,
    pad,
    cardW,
    cardH,
    topCardW,
    topCardH,
    fan,
    insets,
  };
}
