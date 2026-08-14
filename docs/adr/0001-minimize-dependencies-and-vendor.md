# Minimize npm dependencies; vendor what we need

Prefer a small dependency surface over the usual Expo/React Native package sprawl. Add a package only when it clearly earns its keep; otherwise copy (vendor) the specific code we need into the repo, or write a thin local equivalent. The goal is a codebase a beginner can understand and ship without chasing transitive updates and opaque native modules.

This constrains — it does not replace — the Expo choice: still one JS/TS codebase for both stores, but keep the app’s `package.json` lean and treat third-party code as something we own when we pull it in.

**Practice:** Expo SDK packages we depend on live under `vendor/` (see `vendor/README.md`) and are linked with `file:` dependencies so their sources are editable in-tree. React and React Native stay as registry installs (peers / native binaries).