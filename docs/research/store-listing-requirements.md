# Store listing requirements: free, no-account, no-ads Klondike

**Ticket:** [What do Apple and Google require to list a free no-account phone game?](https://github.com/jusanherndon/Solitare/issues/5)

**Constraints (this map):** free, no accounts, no ads, no in-app purchases, English only, phones only (portrait and landscape), no personal data collected. Store name: Klondike Solitaire. Enrollment and uploads are out of scope for this map; fees below are facts for the spec only.

Sources are Apple and Google primary docs, fetched 2026-08-13.

---

## Enrollment (facts for the spec; do not enroll in this map)

- **Apple Developer Program:** 99 USD per membership year (local currency during enrollment). Individual enrollment needs an Apple Account with two-factor authentication, legal name, and a non-P.O.-box address. Organization enrollment additionally needs a D-U-N-S Number and a public organization website. ([Become a member](https://developer.apple.com/programs/enroll/))
- **Google Play Console:** US$25 one-time registration fee. Sign-up requires age 18+. Personal and Organization account types exist; personal accounts created after 13 November 2023 must complete closed testing before production (see [Other hard requirements](#other-hard-requirements)). ([Get started with Play Console](https://support.google.com/googleplay/android-developer/answer/6112435))

---

## Privacy policy

A public privacy policy is a **hard requirement on both stores**, even when the app collects no personal data.

### Apple

- **Listing:** A privacy policy URL is required for all iOS apps. A “Privacy Choices” URL is optional. ([Manage app privacy](https://developer.apple.com/help/app-store-connect/manage-app-information/manage-app-privacy/); [App privacy details](https://developer.apple.com/app-store/app-privacy-details/))
- **In-app:** Guideline 5.1.1(i) — *all* apps must include a link to the privacy policy in App Store Connect **and** within the app in an easily accessible manner. The policy must identify what data, if any, is collected and how it is used; confirm equal protection by any third party that receives data; and explain retention/deletion and how a user can revoke consent or request deletion. ([App Review Guidelines 5.1.1](https://developer.apple.com/app-store/review/guidelines/))
- Guideline 5.1.1(v) matches this map: if the app has no significant account-based features, people must be able to use it without a login; apps may not require personal information except when it is core functionality or required by law.

### Google Play

- **Every app** must post a privacy policy link in Play Console **and** a privacy policy link or text inside the app. Apps that access no personal and sensitive user data must still submit a privacy policy. The policy must be on an active, publicly accessible, **non-geofenced URL (no PDFs)** and **non-editable**; it must be clearly labeled as a privacy policy; it must name the developer/entity from the store listing or name the app; and it must cover data types accessed/collected/used/shared, a privacy contact, secure handling, and retention/deletion. ([User Data policy — Privacy Policy](https://support.google.com/googleplay/android-developer/answer/10144311))
- Completing the Data safety form also requires a privacy policy URL. Apps that collect no user data still complete the form and can state that nothing is collected or shared. ([Data safety](https://support.google.com/googleplay/android-developer/answer/10787469))
- Account-deletion machinery applies only if the app lets users create an account. This map has no accounts, so that extra Play Console URL is not required. ([User Data policy — Account Deletion](https://support.google.com/googleplay/android-developer/answer/10144311))

### Spec implications for “no personal data”

- Keep game state (resume, undo) **on device**. Apple’s “collect” means transmitting data off device and retaining it longer than needed to service a real-time request; on-device processing is not collected and need not appear on the Privacy Nutrition Label. ([App privacy details](https://developer.apple.com/app-store/app-privacy-details/)) Play’s “collect” is the same idea: transmitting data off the device. ([Data safety](https://support.google.com/googleplay/android-developer/answer/10787469))
- Do not ship analytics, ads, crash-reporting, or other third-party SDKs that send data off device. Both stores make the developer responsible for third-party code. ([App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/); [User Data policy](https://support.google.com/googleplay/android-developer/answer/10144311))
- The policy text still has to exist and say, plainly, that the app collects no personal data (and what, if anything, stays on the device). Wording is a later ticket; this ticket only records that a hosted URL + in-app link are mandatory.

---

## Privacy nutrition labels / Data safety (declare “none”)

### Apple — App Privacy questions

Required to submit new apps and updates. In App Store Connect, answer whether you or third-party partners collect data. If no: select “No, we do not collect data from this app” and publish. Responses appear on the product page. ([Manage app privacy](https://developer.apple.com/help/app-store-connect/manage-app-information/manage-app-privacy/); [App privacy details](https://developer.apple.com/app-store/app-privacy-details/))

### Google Play — Data safety form

Required for every app published on Play, including closed/open/production tracks (internal testing only is exempt). Even apps that collect no user data must complete the form **and** link a privacy policy; the form may state that no user data is collected or shared. Users then see that “no data collected” treatment on the listing. ([Data safety](https://support.google.com/googleplay/android-developer/answer/10787469))

---

## Age rating / content rating

### Apple

- Age rating is a **required** App Information property. Complete the questionnaire (content descriptors, in-app controls, capabilities). Apple assigns a global rating plus region-specific ratings. An **Unrated** app cannot be published on the App Store. ([Set an app age rating](https://developer.apple.com/help/app-store-connect/manage-app-information/set-an-app-age-rating/); [Age ratings values](https://developer.apple.com/help/app-store-connect/reference/app-information/age-ratings-values-and-definitions))
- Current global bands: **4+, 9+, 13+, 16+, 18+**. ([Updated age ratings](https://developer.apple.com/news/?id=ks775ehf); [Age ratings values](https://developer.apple.com/help/app-store-connect/reference/app-information/age-ratings-values-and-definitions))
- Guideline 2.3.6: answer honestly so parental controls work. ([App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/))
- For a no-ads, no-chat, no-UGC, no-gambling Klondike Game with classic cards, the questionnaire should yield **4+** if answers are accurate (no objectionable material). Do **not** opt into **Made for Kids** unless the spec wants the Kids category: that choice is irreversible after approval and locks the app into Kids Category rules (no outbound links/purchases except behind a parental gate; no third-party analytics/ads). ([Set an app age rating](https://developer.apple.com/help/app-store-connect/manage-app-information/set-an-app-age-rating/); Guideline [1.3 Kids Category](https://developer.apple.com/app-store/review/guidelines/))
- Guideline 2.3.8: the phrases “For Kids” / “For Children” in name, subtitle, icon, screenshots, or description are reserved for the Kids Category. A 4+ family Game that is **not** in Kids must not use those terms. ([App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/))

### Google Play

- Complete the IARC content-rating questionnaire in Play Console. Unrated apps may be removed. Ratings come from participating authorities and can differ by territory. ([Content rating requirements](https://support.google.com/googleplay/android-developer/answer/188189))
- Separately declare **target audience**. Any age group that includes children triggers [Google Play Families Policies](https://support.google.com/googleplay/android-developer/answer/9893335). Google may override a declaration if listing imagery/terminology looks child-directed. ([Manage target audience](https://support.google.com/googleplay/android-developer/answer/9867159))
- **Spec decision (still open):** CONTEXT describes a family Game. If Play’s target audience includes children, Families policy applies (SDK/data rules; ads-SDK rules are moot with no ads). If the audience is adults only, listing and in-app art must not look child-directed. Either way, declare truthfully.

---

## Listing assets

### Apple (iPhone)

| Asset | Hard requirement | Official spec |
| --- | --- | --- |
| Screenshots | **Yes.** 1–10 images, JPEG/JPG/PNG, **no alpha/transparency**. For an iPhone app, upload a **6.9" display** set (portrait: 1260×2736, 1290×2796, or 1320×2868). If 6.9" is omitted, a 6.5" set is required instead; otherwise Apple scales down. iPad 13" shots are required only if the app runs on iPad — skip them for phones-only. App previews are optional. | [Screenshot specifications](https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications/); [Upload app previews and screenshots](https://developer.apple.com/help/app-store-connect/manage-app-information/upload-app-previews-and-screenshots) |
| Screenshot content | Must show the app **in use**, not title art / splash only. Overlays allowed. Fictional data, not a real person’s. You must own the rights. Metadata (icons, screenshots, previews) must be suitable for a 4+ audience even if the app rates higher. | Guidelines [2.3.3](https://developer.apple.com/app-store/review/guidelines/), [2.3.8](https://developer.apple.com/app-store/review/guidelines/), [2.3.9](https://developer.apple.com/app-store/review/guidelines/) |
| App icon | **Yes**, in the binary (asset catalog / Icon Composer), not as a separate Connect upload. iOS layout size **1024×1024 px**. Changing it later needs a new version. | [Add an app icon](https://developer.apple.com/help/app-store-connect/manage-app-information/add-an-app-icon/); [HIG — App icons](https://developer.apple.com/design/human-interface-guidelines/app-icons) |
| Description | **Required**, ≤4000 characters, plain text (no HTML). | [Platform version information](https://developer.apple.com/help/app-store-connect/reference/app-information/platform-version-information) |
| Keywords | **Required**, up to 100 bytes. | Same |
| Promotional text | Optional, ≤170 characters. | Same |
| Name / subtitle | Name **required**, 2–30 characters. Subtitle optional, ≤30 characters. No trademark stuffing, prices, or other-app names. | [App information](https://developer.apple.com/help/app-store-connect/reference/app-information/app-information); Guideline [2.3.7](https://developer.apple.com/app-store/review/guidelines/) |

If UI is the same across sizes, upload only the highest-resolution required screenshots; they scale down. ([Upload app previews and screenshots](https://developer.apple.com/help/app-store-connect/manage-app-information/upload-app-previews-and-screenshots))

### Google Play (phone)

| Asset | Hard requirement | Official spec |
| --- | --- | --- |
| App icon | **Yes** to publish the listing. 512×512 px, 32-bit PNG with alpha, max 1024 KB; follow Play icon design specs; no ranking/price/category badges. This is the store icon, separate from the launcher icon. | [Add preview assets](https://support.google.com/googleplay/android-developer/answer/9866151) |
| Feature graphic | **Yes** to publish the listing. 1024×500 px, JPEG or 24-bit PNG, no alpha. | Same |
| Screenshots | **Yes:** at least **two** across device types (phones for this map), max 8 per type. JPEG or 24-bit PNG, no alpha; each side 320–3840 px; longest side ≤ 2× shortest. Tablet / TV / Wear / XR shots are required only if those form factors are distributed. Preview video is optional. | Same |
| Short description | **Yes**, ≤80 characters. | [Create and set up your app](https://support.google.com/googleplay/android-developer/answer/9859152); [Add preview assets](https://support.google.com/googleplay/android-developer/answer/9866151) |
| Full description | **Yes**, ≤4000 characters. | [Create and set up your app](https://support.google.com/googleplay/android-developer/answer/9859152) |
| App name | **Yes**, ≤30 characters. Map store name “Klondike Solitaire” fits. | Same; [Metadata policy](https://support.google.com/googleplay/android-developer/answer/9898842) |

Play [Metadata policy](https://support.google.com/googleplay/android-developer/answer/9898842): titles, icons, descriptions, screenshots, and promotional images must be honest, relevant, and suitable for all audiences. No keyword stuffing, unattributed testimonials, ALL CAPS (unless brand), emojis in title/icon/developer name, or ranking/price/Play-program claims.

Highly recommended (not required to list): for games, ≥3 portrait 9:16 shots at ≥1080×1920 (or landscape 16:9 ≥1920×1080) to be eligible for some recommendation surfaces. ([Add preview assets](https://support.google.com/googleplay/android-developer/answer/9866151))

---

## Other required listing / App content fields

### Apple (submit-blocking)

From [App information](https://developer.apple.com/help/app-store-connect/reference/app-information/app-information), [Platform version information](https://developer.apple.com/help/app-store-connect/reference/app-information/platform-version-information), and [Required, localizable, and editable properties](https://developer.apple.com/help/app-store-connect/reference/app-information/required-localizable-and-editable-properties):

- **Primary language:** English.
- **Primary category:** Games; up to two Games subcategories (Card and Family fit this Game). Category must match the core experience. ([Choosing a category](https://developer.apple.com/app-store/categories/); Guideline 2.3.5)
- **Bundle ID** and **SKU** (internal; SKU is not customer-visible).
- **Content Rights** declaration — rights to card art, icon, screenshots (Guideline 5.2.1 / 2.3.9).
- **Copyright** (year + rights holder).
- **Support URL** — must lead to actual contact information (address, email, or phone as local law may require). Guideline 1.5: app and Support URL must make it easy to contact you. ([Platform version information](https://developer.apple.com/help/app-store-connect/reference/app-information/platform-version-information); [Guideline 1.5](https://developer.apple.com/app-store/review/guidelines/))
- **Price:** Free. No IAP products.
- **App Review contact** (name, email, phone) — not customer-visible. Demo login is required only if the app requires sign-in; this map does not.
- **Export compliance:** answered at upload (or via `ITSAppUsesNonExemptEncryption`). HTTPS / OS-provided encryption is typically exempt from extra documentation; a fully offline Game with no custom crypto usually needs no CCATS upload. ([Complying with encryption export regulations](https://developer.apple.com/documentation/security/complying-with-encryption-export-regulations); [Export compliance documentation](https://developer.apple.com/help/app-store-connect/reference/export-compliance-documentation-for-encryption))
- **Digital Services Act:** disclose trader / non-trader status to distribute in the EU; traders must show identification on EU product pages. ([App information](https://developer.apple.com/help/app-store-connect/reference/app-information/app-information))
- Korea / China / Vietnam extra filings apply only if those storefronts are offered and the app meets those criteria (e.g. China game ISBN). Phones-only English Klondike can stay off those storefronts if the spec prefers not to collect those documents.

### Google Play (submit-blocking)

From [Prepare your app for review](https://support.google.com/googleplay/android-developer/answer/9859455) and [Create and set up your app](https://support.google.com/googleplay/android-developer/answer/9859152):

- Default language English (United States, `en-US` is Play’s default). Extra translations are optional; Play may auto-translate listings you do not provide.
- **Free vs paid** at app creation; **game** (not “app”) so it can appear in Play Games.
- **Category + tags** (Card / Casino-style card Game as appropriate — not gambling).
- **Contact email required** on Store settings; website and phone recommended.
- **Ads declaration:** No. House ads and ad SDKs would be “Contains ads”; a “More apps” menu that does not interrupt play is not. Misdeclaration can suspend the app.
- **News / COVID-19 / high-risk permissions:** declare No / none.
- **Play App Signing** terms accepted at creation; uploads are **Android App Bundles**, not raw APKs for new apps.
- **US export laws** acknowledgement at creation.

---

## Other hard requirements

### Phones only

- Apple: iPhone screenshot class only; do not declare iPad (avoids the required 13" screenshot set). ([Screenshot specifications](https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications/))
- Play: phone screenshots satisfy the “minimum two screenshots” rule; 7"/10" tablet, TV, Wear, Automotive, and XR assets are required only if those form factors are distributed. ([Add preview assets](https://support.google.com/googleplay/android-developer/answer/9866151))

### Play production gate for new personal accounts

Personal developer accounts created after 13 November 2023 cannot use Production until a **closed test** has **at least 12 testers opted in for the last 14 consecutive days**, then an application for production access. ([App testing requirements](https://support.google.com/googleplay/android-developer/answer/14151465); [Get started with Play Console](https://support.google.com/googleplay/android-developer/answer/6112435)) Organization accounts are not described as having this 12/14 gate. This is a listing-to-production gate, not an in-app feature, but the spec should record it.

### Play target API level

New apps submitted on or after **31 August 2026** must target **Android 16 (API 36)** or higher. ([Target API level requirements](https://support.google.com/googleplay/android-developer/answer/11926878))

### Minimum functionality / quality (Apple)

Guideline 4.2: the app must be useful, unique, or “app-like,” with lasting entertainment value — a real Klondike Game, not a web wrapping. Guideline 4.1: do not copy another app’s name, icon, or UI. ([App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/))

### What is *not* required for this map

- Ads, IAP, subscriptions, login, ATT tracking prompt (no tracking).
- App preview / Play preview video.
- Localized listings beyond English (Play may still show auto-translations).
- Kids Category (Apple) or Designed for Families badge — optional programs, not needed to list a 4+ / everyone Game.
- Tablet, TV, Wear, or desktop storefronts.

---

## Spec checklist (hard requirements)

Use this as the store-facing section of the Klondike spec. Copy, screenshots, and privacy-policy *wording* remain later tickets; these are the constraints those tickets must satisfy.

1. **Host a public privacy policy URL** (HTML page, not PDF, not geofenced, not a live editable doc) that names Klondike Solitaire (or the seller) and states that no personal data is collected; include retention/deletion language even if the answer is “nothing leaves the device.” Link it in **App Store Connect, Play Console, and inside the app**.
2. **Apple App Privacy:** publish “we do not collect data.” **Play Data safety:** complete the form as no collection / no sharing. Do not add SDKs that would falsify that.
3. **Apple age-rating questionnaire** answered honestly (expect **4+** for this Game). Do **not** select Made for Kids unless a later decision accepts Kids Category lock-in. Do **not** use “For Kids” / “For Children” in metadata unless that category is selected.
4. **Play IARC questionnaire** completed (avoid Unrated). **Target audience** declared; if children are included, Families policy applies.
5. **Ads:** Play Ads declaration = No. No ad SDKs. Price = Free. No IAP. No accounts.
6. **English** primary / default language. Name **Klondike Solitaire** (≤30 characters on both stores).
7. **Apple listing:** 6.9" iPhone screenshots (1–10, exact pixel sizes above, no alpha) showing the Game in use (Tableau / Foundations / Stock / Waste — not splash-only); 1024×1024 icon in the binary; description ≤4000; keywords; copyright; Support URL with real contact info; category Games + Card (and optionally Family); content-rights confirmation.
8. **Play listing:** 512×512 store icon; **1024×500 feature graphic**; ≥2 phone screenshots (recommend ≥3 at 1080×1920 for recommendation eligibility); short description ≤80; full description ≤4000; required contact email; category/tags as a card Game.
9. **Phones only:** no iPad / tablet / TV / Wear storefronts unless the spec later expands (those add extra screenshot classes).
10. **Play personal-account production:** 12 closed testers opted in for 14 consecutive days, then apply for production — unless an Organization Play account is used.
11. **Play binary:** Android App Bundle; target API 36 from 31 August 2026.
12. **Enrollment costs to budget later:** Apple 99 USD/year; Play 25 USD one-time. Do not enroll as part of this map.

---

## Sources

- [App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [App privacy details on the App Store](https://developer.apple.com/app-store/app-privacy-details/)
- [Manage app privacy (App Store Connect Help)](https://developer.apple.com/help/app-store-connect/manage-app-information/manage-app-privacy/)
- [Set an app age rating](https://developer.apple.com/help/app-store-connect/manage-app-information/set-an-app-age-rating/)
- [Age ratings values and definitions](https://developer.apple.com/help/app-store-connect/reference/app-information/age-ratings-values-and-definitions)
- [Updated age ratings in App Store Connect](https://developer.apple.com/news/?id=ks775ehf)
- [Screenshot specifications](https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications/)
- [Upload app previews and screenshots](https://developer.apple.com/help/app-store-connect/manage-app-information/upload-app-previews-and-screenshots)
- [Add an app icon](https://developer.apple.com/help/app-store-connect/manage-app-information/add-an-app-icon/)
- [Human Interface Guidelines — App icons](https://developer.apple.com/design/human-interface-guidelines/app-icons)
- [App information](https://developer.apple.com/help/app-store-connect/reference/app-information/app-information)
- [Platform version information](https://developer.apple.com/help/app-store-connect/reference/app-information/platform-version-information)
- [Required, localizable, and editable properties](https://developer.apple.com/help/app-store-connect/reference/app-information/required-localizable-and-editable-properties)
- [Choosing a category](https://developer.apple.com/app-store/categories/)
- [Become a member — Apple Developer Program](https://developer.apple.com/programs/enroll/)
- [Complying with encryption export regulations](https://developer.apple.com/documentation/security/complying-with-encryption-export-regulations)
- [Export compliance documentation for encryption](https://developer.apple.com/help/app-store-connect/reference/export-compliance-documentation-for-encryption)
- [Get started with Play Console](https://support.google.com/googleplay/android-developer/answer/6112435)
- [Create and set up your app](https://support.google.com/googleplay/android-developer/answer/9859152)
- [Prepare your app for review](https://support.google.com/googleplay/android-developer/answer/9859455)
- [Add preview assets](https://support.google.com/googleplay/android-developer/answer/9866151)
- [User Data policy](https://support.google.com/googleplay/android-developer/answer/10144311)
- [Data safety section](https://support.google.com/googleplay/android-developer/answer/10787469)
- [Content rating requirements](https://support.google.com/googleplay/android-developer/answer/188189)
- [Manage target audience and app content](https://support.google.com/googleplay/android-developer/answer/9867159)
- [Google Play Families Policies](https://support.google.com/googleplay/android-developer/answer/9893335)
- [Metadata policy](https://support.google.com/googleplay/android-developer/answer/9898842)
- [App testing requirements for new personal developer accounts](https://support.google.com/googleplay/android-developer/answer/14151465)
- [Target API level requirements](https://support.google.com/googleplay/android-developer/answer/11926878)
