# Public-domain classic card assets for both stores

**Ticket:** [Which public-domain classic card assets can we ship on both stores?](https://github.com/jusanherndon/Solitare/issues/3)
**Map:** [Map: Klondike Solitaire spec](https://github.com/jusanherndon/Solitare/issues/1)

## Question

Which classic playing-card face and back assets are public domain (or similarly free to use) and allowed in an Apple App Store and Google Play listing? We need a complete 52-card deck plus jokers-optional, plus at least one card back, suitable for a phone Klondike table. Cite licenses and sources. Recommend one set.

## Recommendation

**Ship Dmitry Fomin's English-pattern SVG playing cards (CC0 1.0), plus one of Fomin's matching Atlas-deck card backs (also CC0 1.0).**

| | |
|---|---|
| **Set** | English-pattern SVG playing cards by Dmitry Fomin, with an Atlas-deck back by the same author |
| **Faces (52)** | [Category:SVG English pattern playing cards](https://commons.wikimedia.org/wiki/Category:SVG_English_pattern_playing_cards) — 52 individual 360×540 SVGs, plus the composite [English pattern playing cards deck.svg](https://commons.wikimedia.org/wiki/File:English_pattern_playing_cards_deck.svg) |
| **Back** | [Atlas deck card back blue and brown.svg](https://commons.wikimedia.org/wiki/File:Atlas_deck_card_back_blue_and_brown.svg) (same author, same 360×540 size). Alternate: [Atlas deck card back green and dark red.svg](https://commons.wikimedia.org/wiki/File:Atlas_deck_card_back_green_and_dark_red.svg) |
| **Jokers (optional)** | Not needed for Klondike. If wanted later: [Atlas deck joker black.svg](https://commons.wikimedia.org/wiki/File:Atlas_deck_joker_black.svg) and [Atlas deck joker red.svg](https://commons.wikimedia.org/wiki/File:Atlas_deck_joker_red.svg) (same author, CC0) |
| **License** | [CC0 1.0 Universal](https://creativecommons.org/publicdomain/zero/1.0/) — the author waived copyright worldwide, including commercial use, with no attribution required.[^cc0-deed] [^cc0-legal] [^fomin-deck] [^fomin-back] |
| **Why this set** | Classic red/black English-pattern court cards (the Anglo-American look a Klondike table should have), individual phone-scale SVGs, one author, one license, a back that is not a Bicycle Rider Back. |

Do not ship Bicycle, Bee, Aviator, or Hoyle branding, and do not copy the Bicycle Rider Back. Those names are registered trademarks of the United States Playing Card Company.[^bicycle-about] Apple and Google both require that listing and in-app art be owned or licensed; they do not otherwise ban playing-card faces.[^apple-52] [^play-ip]

## What "classic" means here

The International Playing-Card Society's recommended name for the familiar Anglo-American court cards is the **English pattern** (also called Anglo-American or International). Double-ended courts date from about 1860; corner indices from about 1880. The pattern is used worldwide for 52-card packs.[^ipcs-48]

A Klondike Game deals a 52-card pack onto seven Tableau piles, four Foundations, a Stock, and a Waste. Jokers are not part of that pack. The faces must read at phone size: English A/K/Q/J indices, red hearts and diamonds, black spades and clubs.

Fomin's English-pattern files are that look: own-work SVGs, 360×540, extracted from his 2017 composite, each dedicated CC0 by the copyright holder.[^fomin-deck] [^fomin-ace] [^fomin-king] The Ace of Spades is a large pip, not a branded manufacturer ace.

## Store rules that actually affect card art

Neither store has a playing-card-specific rule. Both require rights to the art, and both forbid trademark confusion.

**Apple — App Store Review Guidelines 5.2 Intellectual Property.** "Make sure your app only includes content that you created or that you have a license to use." Guideline 5.2.1: don't use protected third-party trademarks, copyrighted works, or "misleading, false, or copycat representations" in the app or metadata.[^apple-52]

**Google Play — Intellectual Property.** Apps and listings must not infringe copyright or trademark. "Use only original content you have created for your app and store listing" or "Obtain written documentation or a license for any third-party intellectual property you use." Don't use another party's trademarks (logos or brand names) without permission in a way that could confuse users.[^play-ip]

**CC0 covers the copyright question for this set.** The CC0 deed lets you copy, modify, and distribute the work, including for commercial purposes, without asking permission.[^cc0-deed] The legal code waives copyright and related rights worldwide, including commercial, advertising, and promotional use — which covers in-app faces, the card back on the Stock, and store screenshots.[^cc0-legal] Attribution is not required.

**CC0 does not waive trademarks.** The deed and legal code both say patent and trademark rights are unaffected.[^cc0-deed] [^cc0-legal] Wikimedia Commons likewise warns that reuse can still be limited by trademarks independent of copyright.[^commons-reuse] That is why this spec should use Fomin's checkered Atlas back, not a Rider Back lookalike, and should not put "Bicycle" in the listing.

USPC's About page states that BEE®, BICYCLE®, AVIATOR® and HOYLE® are registered trademarks of the United States Playing Card Company.[^bicycle-about] Bicycle's German glossary describes the Rider Back as their typical classic card-back design (the angel on a bicycle), in production since 1887.[^bicycle-rider] Apple 5.2.1's ban on copycat representations and Play's trademark-confusion rule both point the same way: do not ship that back, and do not name the app as if it were a Bicycle product. The map already names the listing **Klondike Solitaire**.

## Candidates compared

### 1. Recommended — Fomin English-pattern faces + Fomin Atlas back (CC0)

- **Owner:** Dmitry Fomin (Дмитрий Фомин), Wikimedia Commons, 2017. Source: own work.[^fomin-deck]
- **License:** CC0 1.0 on the composite, on sampled faces (Ace of Spades, King of Hearts), and on the Atlas backs and jokers.[^fomin-deck] [^fomin-ace] [^fomin-king] [^fomin-back] [^fomin-joker]
- **Contents:** All 52 English-pattern faces as separate SVGs in [Category:SVG English pattern playing cards](https://commons.wikimedia.org/wiki/Category:SVG_English_pattern_playing_cards) (54 files including the composites). No English-pattern back in that category. Two CC0 Atlas backs and two CC0 jokers live in [Category:SVG Atlasnye playing cards](https://commons.wikimedia.org/wiki/Category:SVG_Atlasnye_playing_cards), same author, same 360×540 canvas.[^atlas-cat]
- **Phone table:** Vector, 360×540 (~2:3). Poker-size physical cards are about 63×88 mm (~5:7); this is close enough to scale cleanly for Tableau, Foundation, Stock, and Waste on a phone.
- **Store fit:** CC0 is a license/waiver Apple and Google accept as "you have a license to use." No Bicycle marks. Keep the Atlas back (a blue-and-brown diagonal check), which is Fomin's own work, not a Rider Back.

Wikimedia does not warrant license tags; Commons tells reusers to verify each file.[^commons-reuse] Spot-checks of the composite, Ace of Spades, King of Hearts, Atlas back, and black joker all show the same CC0 statement from the copyright holder.

### 2. Complete CC0 sheet — *English pattern playing cards deck PLUS CC0.svg*

[File:English pattern playing cards deck PLUS CC0.svg](https://commons.wikimedia.org/wiki/File:English_pattern_playing_cards_deck_PLUS_CC0.svg) (Linux_dr / Loren Osborn, 5 March 2024) is one SVG of all 54 faces plus several backs, published CC0.[^plus-cc0] Faces are Fomin's. The Bellot LGPL back that had been in an earlier PLUS sheet was removed and replaced with original four-color backs; a blue rounded-rectangle back and blank are Guy vandegrift's; English "Joker" labels and an embellished Ace of Spades are Osborn's own work.[^plus-cc0]

Use this only as a fallback if a single sheet is easier to slice. Prefer Fomin's individual files: they are already one-card SVGs, the Ace of Spades stays a plain pip, and every file is one author.

Do **not** use the mixed-license predecessor [English pattern playing cards deck PLUS.svg](https://commons.wikimedia.org/wiki/File:English_pattern_playing_cards_deck_PLUS.svg). That sheet included David Bellot's LGPL 2.1 card back, so the whole derivative is LGPL 2.1, not CC0.

### 3. David Bellot SVG-cards (LGPL 2.1+) — usable, worse license, wrong pattern

Bellot's 2005 SVG-cards are a full 52 plus jokers and many backs. The author released them under LGPL, not public domain, and objected when clip-art copies were retagged PD.[^bellot-gnome] [^bellot-clipart] The current fork [htdebeer/SVG-cards](https://github.com/htdebeer/SVG-cards) is LGPL-2.1 and still quotes Bellot: use in games is allowed, including in non-free software, **if you provide the card source and the LGPL license**.[^svg-cards-readme] Wikimedia's copy of `Svg-cards-2.0.svg` is tagged LGPL 2.1+.[^bellot-commons]

LGPL is a license, so it can satisfy Apple 5.2 / Play IP if you comply. It is copyleft: keep the SVG source available and ship the license. Courts are Paris-pattern French, not English-pattern. For a free App Store + Play Klondike, CC0 English-pattern files are the simpler rights story.

### 4. Byron Knoll vector playing cards (public domain) — no back

Knoll's 2011 blog post is the author's grant: he made the deck in Inkscape and released the images into the public domain for any purpose without attribution.[^knoll-blog] Wikimedia hosts the set, including black and red jokers.[^knoll-cat] OpenGameArt redistributes it and notes the set has **no card backs**.[^oga-knoll]

Two reasons not to pick this as the ship set: (1) no back, so it fails the ticket as a complete table; (2) Knoll based the Ace of Spades on artwork by Suzanne Tyson, and a later post says the face cards were scanned from physical cards then vectorized.[^knoll-blog] [^knoll-march] CC0/PD from Knoll does not clear third-party rights in those sources. Fomin's files are labeled own work.

### 5. Kenney Playing Cards Pack (CC0) — not classic illustrated cards

Kenney's first-party support page: all assets on the asset pages are CC0 / public domain, usable in commercial projects, attribution optional.[^kenney-support] The [Playing Cards Pack](https://kenney.nl/assets/playing-cards-pack) is therefore free to ship. It is pixel-art / simplified game art, not English-pattern court cards. Out for "classic playing cards" on a Klondike table.

### 6. Fomin Atlasnye (Atlas) deck as the *faces* — complete, wrong pattern

Fomin also published a full Atlasnye deck: 52 faces, two jokers, two backs, all CC0, based on A.I. Charlemagne's 19th-century sketches (themselves PD by age).[^atlas-cat] [^fomin-back] That is a Russian Atlas pattern, not the English pattern IPCS describes. Keep Atlas for the **back** (and optional jokers); use English-pattern files for the faces the player sees on the Tableau and Foundations.

## What to put on the phone table

| Role | Asset |
|---|---|
| Face-up Tableau, Foundation, Waste | Fomin English-pattern SVGs, one file per rank/suit |
| Face-down Tableau and Stock | Atlas deck card back blue and brown (or the green/dark-red twin) |
| Win | Same 52 faces built Ace-through-King on the four Foundations — no joker required |

Rasterize the SVGs to PNG at 2×/3× if the toolkit prefers bitmaps. That is a format change, not a new copyright. Keep a copy of each Commons file page (or the SVG metadata) in the repo so store review can see the CC0 grant if asked.[^play-ip]

## Do not ship

- Bicycle / Bee / Aviator / Hoyle names, logos, Rider Back, or a close copy of those marks.[^bicycle-about] [^bicycle-rider] [^apple-52]
- Bellot SVG-cards unless the spec later accepts LGPL source-and-license obligations.[^svg-cards-readme]
- The mixed-license PLUS.svg sheet that still contains Bellot's back.
- Kenney (or other cartoon/pixel) packs as the classic table art.
- Any deck whose Ace of Spades, jokers, or back copy a current manufacturer's branded designs.

## Sources

[^fomin-deck]: [File:English pattern playing cards deck.svg](https://commons.wikimedia.org/wiki/File:English_pattern_playing_cards_deck.svg) — Dmitry Fomin, 2017, own work, CC0 1.0. Category lists all 52 extracted face files.

[^fomin-ace]: [File:English pattern ace of spades.svg](https://commons.wikimedia.org/wiki/File:English_pattern_ace_of_spades.svg) — Fomin, own work, extracted from the composite, CC0 1.0, 360×540.

[^fomin-king]: [File:English pattern king of hearts.svg](https://commons.wikimedia.org/wiki/File:English_pattern_king_of_hearts.svg) — Fomin, own work, CC0 1.0, 360×540.

[^fomin-back]: [File:Atlas deck card back blue and brown.svg](https://commons.wikimedia.org/wiki/File:Atlas_deck_card_back_blue_and_brown.svg) — Fomin, 25 February 2017, own work, CC0 1.0, 360×540.

[^fomin-joker]: [File:Atlas deck joker black.svg](https://commons.wikimedia.org/wiki/File:Atlas_deck_joker_black.svg) — Fomin, own work, CC0 1.0. Red twin: [Atlas deck joker red.svg](https://commons.wikimedia.org/wiki/File:Atlas_deck_joker_red.svg).

[^atlas-cat]: [Category:SVG Atlasnye playing cards](https://commons.wikimedia.org/wiki/Category:SVG_Atlasnye_playing_cards) — 52 Atlas faces, two backs, two jokers.

[^plus-cc0]: [File:English pattern playing cards deck PLUS CC0.svg](https://commons.wikimedia.org/wiki/File:English_pattern_playing_cards_deck_PLUS_CC0.svg) — Linux_dr, 5 March 2024, CC0 1.0. Source note: Fomin faces; vandegrift blue back and blank; Osborn four-color backs, English Joker names, embellished Ace of Spades; Bellot LGPL back removed.

[^cc0-deed]: [CC0 1.0 Universal deed](https://creativecommons.org/publicdomain/zero/1.0/) — waiver of copyright including commercial use; trademarks not affected.

[^cc0-legal]: [CC0 1.0 legal code](https://creativecommons.org/publicdomain/zero/1.0/legalcode) — §2 Waiver (worldwide, commercial); §3 public-license fallback; §4(a) trademarks not waived.

[^commons-reuse]: [Commons:Reusing content outside Wikimedia](https://commons.wikimedia.org/wiki/Commons:Reusing_content_outside_Wikimedia) — no Wikimedia warranty; verify each file; trademarks and other non-copyright limits may still apply.

[^ipcs-48]: International Playing-Card Society, [Pattern Sheet 48: the English pattern](https://i-p-c-s.org/pattern/ps-48.html) (July 1994). 52-card packs; double-ended courts ~1860; indices ~1880; worldwide use including USPCC.

[^apple-52]: Apple, [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/), §5.2 and §5.2.1 (Intellectual Property).

[^play-ip]: Google Play, [Intellectual Property](https://support.google.com/googleplay/android-developer/answer/9888072?hl=en) — copyright, trademark, and "license for any third-party intellectual property."

[^bicycle-about]: Bicycle / USPC, [About](https://bicyclecards.com/about) — "BEE®, BICYCLE®, AVIATOR® and HOYLE® are registered trademarks of The United States Playing Card Company."

[^bicycle-rider]: Bicycle Cards Deutschland, [Rider Back](https://de.bicyclecards.com/glossar/rider-back/) — first-party description of the classic Bicycle card-back design.

[^bellot-gnome]: David Bellot, [SVG cards](https://mail.gnome.org/archives/games-list/2004-June/msg00004.html), GNOME games-list, 15 June 2004 — released under an LGPL license.

[^bellot-clipart]: David Bellot, [License problem for cards clipart](https://lists.freedesktop.org/pipermail/clipart/2005-October/004484.html), Open Clip Art Library list, 17 October 2005 — SVG-cards is LGPL, "not as Public Domain."

[^svg-cards-readme]: [htdebeer/SVG-cards README](https://github.com/htdebeer/SVG-cards/blob/master/README.md) — License: LGPL-2.1; quotes Bellot: provide the source and the LGPL license; usable in non-free software; Paris-pattern courts; jokers and backs included.

[^bellot-commons]: [File:Svg-cards-2.0.svg](https://commons.wikimedia.org/wiki/File:Svg-cards-2.0.svg) — David Bellot, source svg-cards.sourceforge.net, GNU LGPL 2.1 or later.

[^knoll-blog]: Byron Knoll, [Vector Playing Cards](http://byronknoll.blogspot.com/2011/03/vector-playing-cards.html), 2011 — public domain; Ace of Spades based on artwork by Suzanne Tyson.

[^knoll-march]: Byron Knoll, [March 2011 archive](http://byronknoll.blogspot.com/2011/03/) — later post: face-card designs scanned from physical cards and vectorized.

[^knoll-cat]: [Category:Playing cards set by Byron Knoll](https://commons.wikimedia.org/wiki/Category:Playing_cards_set_by_Byron_Knoll) — includes Black joker.svg and Red joker.svg.

[^oga-knoll]: OpenGameArt, [Playing Cards (Vector & PNG)](https://opengameart.org/content/playing-cards-vector-png) — Knoll set; comments note the absence of card backs.

[^kenney-support]: Kenney, [Support](https://kenney.nl/support) — "all game assets on the asset pages are public domain licensed (CC0)"; commercial use allowed; attribution not required.
