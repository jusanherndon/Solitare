# PROTOTYPE — Chrome screens look (start, About, win, loss)

**Throwaway.** Question: *How should the start, About, win, and loss screens look on a phone in portrait and landscape?*

**Owner pick: A — Felt banner.** B and C stay on this branch as the comparison source.

Extends the Flutter table (`Layout A`). Yellow bars are prototype chrome — not part of the design. Contents and buttons are locked on tickets `09`, `11`, and `14`; this pass is look, overlay coverage, and animation.

## Run

```bash
cd prototype/klondike-table-flutter
flutter run            # Linux desktop here; Android device for phone feel
flutter run -d linux
# rotate the window / device for landscape
```

Phone: `flutter run` on a connected Android device, or `flutter build apk`.

## Variants (bottom bar / ← →)

- **A — Felt banner** — same felt and chrome-button language as the table. Centered win card; loss card sits lower, greyscale table, dust.
- **B — Letterbox** — ink poster start; win/loss as cinematic bars with the table visible in the middle window. Card rain on win; greyscale on loss.
- **C — Bottom sheet** — card-fan start; win/loss keep almost all of the table. Slim sheet; gold pulse + sparkles on win; dark sheet + Undo first on loss.

## Preview chips (top bar)

**Start · About · Table · Win · Loss** — jump without playing a Game through. Real buttons also navigate.

Resume is hidden until an unfinished Game exists (New Game, or **Start** from the table). Win/Loss **Start** ends the Game, so Resume hides again.

Support / Source / Privacy / Licenses are stubs (flash or a placeholder page).
