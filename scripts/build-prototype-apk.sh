#!/usr/bin/env bash
# PROTOTYPE — build a sideloadable Android APK for the Klondike table (#6).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
APP="$ROOT/prototype/klondike-table"
DIST="$APP/dist"
MODE="${1:-eas}"

mkdir -p "$DIST"

echo "Klondike table prototype — Android APK"
echo "App dir: $APP"
echo

ensure_expo() {
  cd "$APP"
  if ! node -e "require('expo/package.json')" >/dev/null 2>&1; then
    echo "expo is not installed in the prototype. Bootstrapping…"
    bash "$ROOT/scripts/bootstrap-vendor.sh"
  fi
  if ! node -e "require('expo/package.json')" >/dev/null 2>&1; then
    echo "Still cannot resolve expo from $APP"
    echo "Try: npm run bootstrap:vendor"
    exit 1
  fi
  local ver
  ver="$(node -e "console.log(require('expo/package.json').version)")"
  echo "Using expo@$ver (vendored)"
}

case "$MODE" in
  help|-h|--help)
    cat <<'EOF'
Usage (from repo root):
  npm run prototype:table:apk:help
  npm run prototype:table:apk          # EAS cloud → APK download link
  npm run prototype:table:apk:local    # local Gradle (needs ANDROID_HOME)

Must run against prototype/klondike-table (this script cds there for you).
Do not run `eas build` from the repo root — Expo won’t be found there.

First time:
  1. npm run bootstrap:vendor          # if expo isn’t installed yet
  2. npx eas-cli login                 # free Expo account
  3. npm run prototype:table:apk

Note: EAS installs vendored Expo’s deps via the app’s eas-build-post-install
script (vendor/*/node_modules are gitignored and otherwise missing on the builder).

Install on phone:
  1. Download/copy the .apk to the phone
  2. Open it → allow “Install unknown apps” if asked
  3. Launch “Klondike Table Prototype”
EOF
    ;;
  eas)
    ensure_expo
    # Avoid EAS inventing a second project at the git root
    rm -f "$ROOT/eas.json" "$ROOT/app.json"
    if ! node -e "const p=require('./package.json'); if(!p.scripts['eas-build-post-install']) process.exit(1)" \
      2>/dev/null; then
      echo "Missing eas-build-post-install in package.json — aborting."
      exit 1
    fi
    if [[ ! -f "$ROOT/scripts/eas-bootstrap-vendor.sh" ]]; then
      echo "Missing scripts/eas-bootstrap-vendor.sh — aborting."
      exit 1
    fi
    echo "Starting EAS cloud build (profile: preview → APK)…"
    echo "Working directory: $APP"
    echo "Hooks will install vendor/expo deps on the builder (fixes missing @expo/cli)."
    npx --yes eas-cli@latest build --platform android --profile preview
    ;;
  local)
    ensure_expo
    if [[ -z "${ANDROID_HOME:-}${ANDROID_SDK_ROOT:-}" ]]; then
      echo "ANDROID_HOME is not set. Install the Android SDK, then re-run:"
      echo "  export ANDROID_HOME=/path/to/Android/Sdk"
      echo "  npm run prototype:table:apk:local"
      exit 1
    fi
    echo "Generating native android/ (expo prebuild)…"
    npx expo prebuild --platform android --no-install
    echo "Building release APK with Gradle…"
    (cd android && ./gradlew assembleRelease)
    APK="$(find android/app/build/outputs/apk -name '*.apk' | head -1)"
    if [[ -z "$APK" ]]; then
      echo "Gradle finished but no APK was found."
      exit 1
    fi
    DEST="$DIST/klondike-table-prototype.apk"
    cp -f "$APK" "$DEST"
    echo
    echo "APK ready: $DEST"
    echo "Copy it to your phone and open it to install."
    ;;
  *)
    echo "Unknown mode: $MODE (use eas, local, or help)"
    exit 1
    ;;
esac
