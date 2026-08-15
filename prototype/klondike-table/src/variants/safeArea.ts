import { useMemo } from 'react';
import {
  Dimensions,
  Platform,
  StatusBar,
  TurboModuleRegistry,
  useWindowDimensions,
} from 'react-native';

export type Insets = { top: number; bottom: number; left: number; right: number };

function readWebSafeArea(): Insets {
  if (typeof document === 'undefined') {
    return { top: 0, bottom: 0, left: 0, right: 0 };
  }
  const probe = document.createElement('div');
  probe.style.cssText =
    'position:fixed;left:0;top:0;visibility:hidden;pointer-events:none;padding:env(safe-area-inset-top,0px) env(safe-area-inset-right,0px) env(safe-area-inset-bottom,0px) env(safe-area-inset-left,0px)';
  document.body.appendChild(probe);
  const s = getComputedStyle(probe);
  const insets = {
    top: parseFloat(s.paddingTop) || 0,
    right: parseFloat(s.paddingRight) || 0,
    bottom: parseFloat(s.paddingBottom) || 0,
    left: parseFloat(s.paddingLeft) || 0,
  };
  document.body.removeChild(probe);
  return insets;
}

function readNativeSafeArea(): Insets {
  try {
    const mod = TurboModuleRegistry.get('RNCSafeAreaContext') as
      | { getConstants?: () => { initialWindowMetrics?: { insets?: Insets } } }
      | null;
    const insets = mod?.getConstants?.()?.initialWindowMetrics?.insets;
    if (insets && typeof insets.top === 'number') {
      return {
        top: insets.top || 0,
        bottom: insets.bottom || 0,
        left: insets.left || 0,
        right: insets.right || 0,
      };
    }
  } catch {
    // No safe-area native module (still fine on a throwaway prototype).
  }

  const screen = Dimensions.get('screen');
  const window = Dimensions.get('window');
  const status = StatusBar.currentHeight ?? 0;
  const leftover = Math.max(0, screen.height - window.height);
  const landscape = window.width > window.height;
  if (Platform.OS === 'android') {
    const bottom =
      leftover === 0 ? 28 : leftover > status ? leftover - status : leftover;
    return { top: status, bottom: Math.max(24, bottom), left: 0, right: 0 };
  }
  return {
    top: landscape ? 0 : 47,
    bottom: landscape ? 21 : 34,
    left: landscape ? 47 : 0,
    right: landscape ? 47 : 0,
  };
}

/**
 * Device insets without adding safe-area-context (ADR-0001).
 * Prefers the native safe-area module when Expo Go/APK provides it.
 */
export function useSafeAreaInsetsApprox(): Insets {
  const { width, height } = useWindowDimensions();
  return useMemo(() => {
    if (Platform.OS === 'web') return readWebSafeArea();
    return readNativeSafeArea();
  }, [width, height]);
}
