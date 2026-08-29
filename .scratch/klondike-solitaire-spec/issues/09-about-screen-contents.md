# What else does the About screen show besides the Privacy Policy link?

Type: grilling
Status: resolved
GitHub: #16 — https://github.com/jusanherndon/Solitare/issues/16

Depends on [What privacy policy does Klondike Solitaire publish, and where is it hosted?](https://github.com/jusanherndon/Solitare/issues/9). Hosting that URL is [Publish the Klondike Solitaire privacy policy on GitHub Pages](../../klondike-app-store/issues/01-publish-privacy-policy-pages.md) on the store maps.
Depends on [Which public-domain classic card assets can we ship on both stores?](https://github.com/jusanherndon/Solitare/issues/3).

## Question

What does the dedicated About screen contain for v1, beyond the Privacy Policy link that opens `https://jusanherndon.github.io/Solitare/privacy/`?

Decide for the spec: app name / publisher, card-art attribution (Fomin faces + Atlas back from #3), support or contact email (jherndon111@gmail.com is already the privacy contact — same or different for support?), version display, and anything else that must appear. Keep it English-only and phones-only; do not invent Kids/For Children framing unless [Does Play list Klondike Solitaire as including children?](../../klondike-play-store/issues/05-play-target-audience-children.md) says so.

## Answer

v1 About is this inventory, in this order:

1. **Klondike Solitaire**
2. **Justin Herndon**
3. **Version** — the version the binary reports
4. **Support:** `jherndon111@gmail.com` — same address as the privacy policy and store listings; tappable, opens mail
5. **Source** — opens `https://github.com/jusanherndon/Solitare` in the system browser (the product repo; GitHub’s owner link reaches the other repos)
6. **Privacy Policy** — opens `https://jusanherndon.github.io/Solitare/privacy/` in the system browser
7. **Licenses** — Flutter’s standard open-source license list
8. **Card art:** Dmitry Fomin, English-pattern faces and Atlas back, CC0 1.0 — not required by the license; credited anyway

Nothing else on this screen: no personal site, no how-to-play, no rate-the-app, no “For Kids” / “For Children.” How you reach About is [What start screen does the app open to, and what does Settings contain?](issues/11-start-and-settings-screens.md). Do not build this screen in the app until that start screen exists.
