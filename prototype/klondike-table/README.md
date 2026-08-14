# PROTOTYPE — Klondike table look & play (#6)

**Throwaway.** Answers: *How should the Klondike table look and play on a phone in portrait and landscape?*

One Expo codebase for **phone and web** (vendored Expo under `vendor/` per ADR-0001). Edit the framework in `vendor/`; React / React Native stay normal npm peers.

## Run (web / Expo Go)

```bash
npm run prototype:table
```

Scan the QR with **Expo Go** on a phone. On a computer the browser should open automatically; if not, open the URL Expo prints (usually http://localhost:8081).

Rotate (or resize the browser) to compare portrait vs landscape.

## Install on a phone (APK)

```bash
npm run prototype:table:apk:help   # steps
npm run prototype:table:apk        # EAS cloud APK (Expo login once)
# or, with Android SDK installed:
npm run prototype:table:apk:local  # writes prototype/klondike-table/dist/*.apk
```

Copy the `.apk` to the phone, open it, and allow install from that source if prompted.

Script labels live in root `package.json` → `scriptsHelp`.

## Edit Expo

- `vendor/expo/src/` — main SDK entrypoints
- `vendor/babel-preset-expo/`

See `vendor/README.md`. After edits: `npx expo start -c`.

## Layout

Classic top row: Stock/Waste left, Foundations right, Tableau below. Rotate (or resize the browser) for portrait vs landscape.

## Play

Double-click to auto-move (Foundation first, then Tableau), or drag / tap → tap. Stock is draw-one; tap the empty Stock to recycle the Waste. Undo reverses moves/draws. New Game deals fresh.
