import { Platform, useWindowDimensions } from 'react-native';

/**
 * Native (Expo Go / APK): fill the phone.
 * Web: dampen size so large monitors don’t blow up the table (old 0.5× feel).
 */
export function useBoardMetrics() {
  const { width, height } = useWindowDimensions();
  const landscape = width > height;
  const short = Math.min(width, height);
  const long = Math.max(width, height);
  const isWeb = Platform.OS === 'web';
  const webScale = isWeb ? 0.5 : 1;

  // ~780px short side ≈ phone landscape / small laptop; 1440p short ≈ 1440 → ~1.85×
  const uiScale = Math.min(2.25, Math.max(1, short / 780)) * webScale;

  const boardMax = Math.round(
    (landscape
      ? Math.min(width - 24, Math.round(Math.min(long * 0.88, short * 1.55)))
      : Math.min(width - 16, Math.round(short * 0.98))) * (isWeb ? webScale : 1),
  );

  const gap = Math.max(isWeb ? 2 : 4, Math.round((landscape ? 8 : 6) * uiScale));
  const pad = Math.max(isWeb ? 5 : 6, Math.round(10 * uiScale));
  const avail = boardMax - pad * 2;

  // Fill the row — seven Tableau columns drive card width.
  const minCard = isWeb ? 24 : 40;
  const cardW = Math.max(minCard, Math.floor((avail - gap * 6) / 7));
  const cardH = Math.round(cardW * 1.4);
  const topCardW = Math.min(cardW, Math.floor((avail - gap * 5) / 6));
  const topCardH = Math.round(topCardW * 1.4);
  // Peek enough that face-down stacks read as separate cards on phones.
  const fan = Math.max(isWeb ? 7 : 18, Math.round(cardH * (isWeb ? 0.2 : 0.3)));

  return {
    width,
    height,
    landscape,
    uiScale,
    boardMax,
    gap,
    pad,
    cardW,
    cardH,
    topCardW,
    topCardH,
    fan,
  };
}
