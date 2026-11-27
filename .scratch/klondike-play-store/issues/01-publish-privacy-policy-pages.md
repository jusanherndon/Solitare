# Publish the Klondike Solitaire privacy policy on GitHub Pages

Type: task
Status: resolved
GitHub: #15 — https://github.com/jusanherndon/Solitare/issues/15

Moved from [Klondike Solitaire spec](../klondike-solitaire-spec/map.md) `08`.
Shared with [Publish the Klondike Solitaire privacy policy on GitHub Pages](../klondike-app-store/issues/01-publish-privacy-policy-pages.md) — one URL, one publish; claim and resolve both together.

Depends on [What privacy policy does Klondike Solitaire publish, and where is it hosted?](https://github.com/jusanherndon/Solitare/issues/9).

## Question

Can we publish the locked privacy policy as public HTML on GitHub Pages at `https://jusanherndon.github.io/Solitare/privacy/`?

## Done when

- Repo contains the policy HTML (or Markdown that builds to HTML) matching the #9 wording constraints, with the app name **Solitaire Collection** published by Justin Herndon. Data practices stay as in #9: no personal data leaves the device; resume and Undo on-device only; no analytics/ads/crash SDKs; nothing to delete remotely; contact jherndon111@gmail.com. Do not add a new data practice for future variants.
- GitHub Pages is enabled for this repo and the URL returns HTTPS HTML (not PDF), publicly, without login or geo-block.
- The live page is clearly labeled as a privacy policy and names the app and publisher.
- A comment on this ticket links the live URL and the source path in the repo.
- The sibling ticket on [Post Klondike Solitaire to the App Store](../klondike-app-store/map.md) is resolved with the same answer.

Not store submission and not the product app — the hosted policy artifact the listings and About screen will point at.

## Answer

Yes. `https://jusanherndon.github.io/Solitare/privacy/` returns public HTTPS HTML, with no login. The page is labeled Privacy Policy and names **Solitaire Collection**, published by Justin Herndon. Wording stays on the locked facts: no personal data leaves the device; resume and Undo stay on the device; no analytics, ads, or crash SDKs; nothing to delete remotely; contact jherndon111@gmail.com.

Source: `Solitare/privacy/index.html` in [jusanherndon/jusanherndon.github.io](https://github.com/jusanherndon/jusanherndon.github.io), merged by [pull request 2](https://github.com/jusanherndon/jusanherndon.github.io/pull/2) (`a3d15bc`). That repo already publishes GitHub Pages from `master` `/`, which is what serves this URL. The Solitaire product repo does not host the page.

Same answer on the sibling ticket.

## Comments

### agent — 2026-11-27

The page is published from the personal site, not this repo. Source: `Solitare/privacy/index.html` in `jusanherndon/jusanherndon.github.io`, branch `privacy-policy`. Pull request: https://github.com/jusanherndon/jusanherndon.github.io/pull/2

The page is labeled Privacy Policy and names **Solitaire Collection**, published by Justin Herndon. Wording stays on the locked facts: no personal data leaves the device; resume and Undo stay on the device; no analytics, ads, or crash SDKs; nothing to delete remotely; contact jherndon111@gmail.com.

That pull request is merged. `https://jusanherndon.github.io/Solitare/privacy/` is live. The Solitare product-repo pull request for this page was closed and its branch deleted.
