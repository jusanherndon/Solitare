# PROTOTYPE — listing visuals (icon, feature graphic, screenshots)

Throwaway. Answers: *What icon, feature graphic, and screenshots does v1 use?*

Three families, switchable with `?variant=A|B|C` or the bottom bar / arrow keys:

| Key | Icon | Feature graphic (1024×500) |
| --- | --- | --- |
| **A** | Ace of spades, slight tilt, on felt | Landscape table crop + name |
| **B** | Extreme A♠ corner crop | Mark + listing copy, no table photo |
| **C** | Fan of three cards (back + faces) | Cards only; tiny name |

Screenshots are the Flutter table (`prototype/klondike-table-flutter`), seed 42, phone metrics. Same three shots on every family.

## Run

From this directory:

```bash
python3 -m http.server 8082
```

Open http://localhost:8082/?variant=A

Recapture table shots (writes `shots/*.png`):

```bash
cd ../klondike-table-flutter
flutter test test/listing_shots_test.dart
```

Placeholder cards (cream / navy), not Fomin/Atlas yet. No “For Kids” / “For Children”. Steal bits across A/B/C; this is not the shipped art.
