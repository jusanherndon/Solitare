# PROTOTYPE — Klondike table look & play (#6)

**Throwaway.** Answers: *How should the Klondike table look and play on a phone in portrait and landscape?*

One Expo codebase for **phone and web** (vendored Expo under `vendor/` per ADR-0001). Edit the framework in `vendor/`; React / React Native stay normal npm peers.

## Run

```bash
npm run prototype:table
```

Scan the QR with **Expo Go** on a phone. On a computer the browser should open automatically; if not, open the URL Expo prints (usually http://localhost:8081).

Rotate (or resize the browser) to compare portrait vs landscape.

## Edit Expo

- `vendor/expo/src/` — main SDK entrypoints
- `vendor/babel-preset-expo/`

See `vendor/README.md`. After edits: `npx expo start -c`.

## Variants (bottom bar)

| Key | Name |
|-----|------|
| A | Classic top row |
| B | Thumb dock |
| C | Side rails |

## Play

Tap → tap destination, or drag. Stock is draw-one, one pass (no redeal). New Game reshuffles.
