# PROTOTYPE — listing visuals

Throwaway. Not the shipped art. Answers: what App Store icon and 6.9″ screenshots v1 uses, from the current Flutter table. Store name is **Solitaire Collection**.

Three families, `?variant=A|B|C`, bottom bar, or arrow keys:

| Key | Icon | Feature graphic |
| --- | --- | --- |
| **A** | Ace of spades on felt | Landscape table plus the name |
| **B** | Corner crop of A♠ | Mark plus a sentence, no table |
| **C** | Fan of three cards | Cards only, small name |

Screenshots are shared. Portrait frames are 1320×2868. Landscape is 2868×1320. Placeholder card drawing from the current app, not Fomin faces.

## Run

```bash
python3 -m http.server 8082
```

Open http://localhost:8082/?variant=A

Recapture from the current table:

```bash
cd src/klondike-table-flutter
flutter test tool/listing_shots.dart
```
