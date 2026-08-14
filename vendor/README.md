# Vendored dependencies

Editable local copies of packages we own in-tree (ADR-0001). The app depends on these via `file:../../vendor/<name>` instead of resolving them only from the registry.

## What’s here

| Package | Why |
|---------|-----|
| `expo` | App framework (Expo SDK). Edit JS/TS under `expo/src/` to try changes. |
| `expo-status-bar` | Status bar helper used by the prototype. |
| `babel-preset-expo` | Metro/Babel preset required to bundle an Expo app. |

React and React Native stay as normal npm installs — they are peers of Expo and too large/native to treat as casual edits.

Expo’s *own* transitive packages (`@expo/cli`, Metro helpers, etc.) install into `vendor/expo/node_modules` when you bootstrap (gitignored). You edit Expo under `vendor/expo/src/`; you don’t commit that `node_modules` tree.

## First-time setup

```bash
# 1) Install each vendored package’s own dependencies (gitignored node_modules)
npm install --omit=dev --prefix vendor/expo
npm install --omit=dev --prefix vendor/babel-preset-expo
npm install --omit=dev --prefix vendor/expo-status-bar

# 2) Install the phone prototype (links file: → vendor/)
npm install --prefix prototype/klondike-table

# 3) Run
npm run prototype:table
```

## Editing Expo

1. Change files under `vendor/expo/src/` (or other vendored packages).
2. Restart Metro with a clean cache: `cd prototype/klondike-table && npx expo start -c`
3. Deep native changes may need a [dev client](https://docs.expo.dev/develop/development-builds/introduction/) — Expo Go only ships its own native binaries.

## Refreshing a vendor copy

```bash
cd vendor
rm -rf expo
mkdir _pack && cd _pack
npm pack expo@57.0.13
tar -xzf expo-*.tgz && mv package ../expo
cd .. && rm -rf _pack
npm install --omit=dev --prefix expo
```

Bump the version deliberately; don’t casually float to “latest”.
