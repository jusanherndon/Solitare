import { useWindowDimensions } from 'react-native';

/** Tiny stand-in for safe-area-context — avoid an extra dependency. */
export function useSafeAreaInsetsApprox() {
  const { width, height } = useWindowDimensions();
  const landscape = width > height;
  // Rough phone notches; good enough for a throwaway prototype.
  return {
    top: landscape ? 0 : 44,
    bottom: landscape ? 0 : 20,
    left: 0,
    right: 0,
  };
}
