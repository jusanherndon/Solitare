#!/usr/bin/env bash
# Bootstrap vendored Expo + the table prototype (ADR-0001).
# Single Expo codebase for phone and web.
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
npm install --omit=dev --prefix "$root/vendor/expo"
npm install --omit=dev --prefix "$root/vendor/babel-preset-expo"
npm install --omit=dev --prefix "$root/vendor/expo-status-bar"
# Peers Metro/Babel resolve from vendor/expo/node_modules when using file: links
npm install --prefix "$root/vendor/expo" react-refresh@0.14.2
npm install --prefix "$root/vendor/babel-preset-expo" react-refresh@0.14.2
npm install --prefix "$root/prototype/klondike-table"
# Web (react-native-web) must resolve from vendored expo sources too
ln -sfn "$root/prototype/klondike-table/node_modules/react-native-web" \
  "$root/vendor/expo/node_modules/react-native-web" 2>/dev/null || true
echo "Ready. Run: npm run prototype:table  (Expo Go on phone, or press w for web)"
