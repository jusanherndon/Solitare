#!/usr/bin/env bash
# EAS cloud hook: vendored Expo’s node_modules are gitignored, so the builder
# must install them or `vendor/expo/bin/cli` cannot resolve @expo/cli.
set -euo pipefail

# EAS runs this with cwd = prototype/klondike-table
APP_DIR="$(pwd)"
REPO_ROOT="$(cd "$APP_DIR/../.." && pwd)"
EXPO_VENDOR="$REPO_ROOT/vendor/expo"
BABEL_VENDOR="$REPO_ROOT/vendor/babel-preset-expo"

echo "[eas-bootstrap-vendor] repo=$REPO_ROOT"
echo "[eas-bootstrap-vendor] expo vendor=$EXPO_VENDOR"

if [[ ! -f "$EXPO_VENDOR/package.json" ]]; then
  echo "[eas-bootstrap-vendor] ERROR: missing $EXPO_VENDOR/package.json"
  echo "[eas-bootstrap-vendor] EAS must upload the monorepo (vendor/ included)."
  exit 1
fi

npm install --omit=dev --prefix "$EXPO_VENDOR"
npm install --omit=dev --prefix "$BABEL_VENDOR"
# babel-preset-expo requires react-refresh/babel at transform time (web + native).
npm install --prefix "$EXPO_VENDOR" react-refresh@0.14.2
npm install --prefix "$BABEL_VENDOR" react-refresh@0.14.2

if [[ ! -d "$EXPO_VENDOR/node_modules/@expo/cli" ]]; then
  echo "[eas-bootstrap-vendor] ERROR: @expo/cli still missing under vendor/expo/node_modules"
  ls -la "$EXPO_VENDOR/node_modules" | head -40 || true
  exit 1
fi

if ! node -e "require.resolve('react-refresh/babel',{paths:['$BABEL_VENDOR']})" >/dev/null 2>&1; then
  echo "[eas-bootstrap-vendor] ERROR: react-refresh/babel missing under babel-preset-expo"
  exit 1
fi

echo "[eas-bootstrap-vendor] OK — @expo/cli and react-refresh/babel are present"
