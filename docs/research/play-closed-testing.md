# Play closed testing: how a personal account reaches production access

**Ticket:** [What exact Play Console closed-testing steps does a personal account need before production?](../../.scratch/klondike-play-store/issues/08-play-closed-testing.md)

**Locked fact (do not re-litigate):** personal Play Console accounts created after 13 November 2023 need **12 closed testers opted in for 14 consecutive days**, then an application for production access. ([App testing requirements](https://support.google.com/googleplay/android-developer/answer/14151465); earlier findings: [store-listing-requirements.md](store-listing-requirements.md))

**Out of scope here:** enrolling, recruiting testers, uploading a binary, or Play App Signing / Flutter AAB details ([sibling ticket](../../.scratch/klondike-play-store/issues/09-flutter-play-aab.md)).

Sources are Google Play Console Help on support.google.com, fetched 2026-08-29.

---

## Who the 12/14 gate applies to

Google Play requires **personal** developer accounts **created after 13 November 2023** to run a closed test that meets the 12/14 criteria before the app is eligible for public distribution. Until then, **Production** (`Test and release > Production`) and **Pre-registration** stay disabled. ([App testing requirements](https://support.google.com/googleplay/android-developer/answer/14151465); [Get started with Play Console](https://support.google.com/googleplay/android-developer/answer/6112435); [Create and set up your app](https://support.google.com/googleplay/android-developer/answer/9859152))

The Get started article labels the testing-requirements step **(Personal accounts only)**. ([Get started with Play Console](https://support.google.com/googleplay/android-developer/answer/6112435))

You must also **complete app setup** in Play Console before a closed test can start. ([App testing requirements](https://support.google.com/googleplay/android-developer/answer/14151465))

---

## Which track counts toward the 12/14 gate

Only **closed testing** counts.

| Track | What it is | Counts toward 12/14? |
| --- | --- | --- |
| Internal testing | Up to 100 chosen testers; fast (minutes); can start **before** app setup is complete. Optional, recommended first. | **No.** Access requirement is “None.” |
| Closed testing | Targeted testers you control. Requires completed app setup. | **Yes.** This is the required track. |
| Open testing | Anyone can join from Google Play. | **No.** Available only **after** you gain production access. |
| Production | Public on Google Play. | **No.** Disabled until you apply and are approved. |

([App testing requirements](https://support.google.com/googleplay/android-developer/answer/14151465); [Set up an open, closed, or internal test](https://support.google.com/googleplay/android-developer/answer/9845334); [Prepare and roll out a release](https://support.google.com/googleplay/android-developer/answer/9859348))

You can run an internal test **at the same time** as a closed test, but a user who has opted into **internal** testing is **not eligible** for the closed (or open) test until they opt **out** of internal and then opt **in** to closed. Those people do not count toward the 12 until they are on the closed track. ([Set up an open, closed, or internal test](https://support.google.com/googleplay/android-developer/answer/9845334))

The default closed-testing page has one initial closed track; you can create extra named closed tracks for teams. The 12/14 article talks about testers opted in to **your closed test**, not extra tracks specifically. Use the **initial closed testing** track for the production-access gate unless Console later shows otherwise. ([Set up an open, closed, or internal test](https://support.google.com/googleplay/android-developer/answer/9845334); [App testing requirements](https://support.google.com/googleplay/android-developer/answer/14151465))

---

## How testers get in: invited vs opted in

Two different actions. Only the second counts.

**Invited (not enough):** you put people on an email list or in a Google Group and assign that list/group to the closed track. That makes them *eligible*. It does **not** make them opted in. ([Set up an open, closed, or internal test](https://support.google.com/googleplay/android-developer/answer/9845334))

**Opted in (counts):** the person must **actively opt into** the closed test program. To be eligible for a test track, a user must (1) be included in the track’s tester configuration **and** (2) **actively opt into** the corresponding test program. ([Set up an open, closed, or internal test](https://support.google.com/googleplay/android-developer/answer/9845334))

### Closed-test tester setup (Console path)

1. `Test and release > Testing > Closed testing` → **Manage track** → **Testers**.
2. Choose access:
   - **Email** (default): create or select email lists (up to 200 lists; 2,000 addresses per list; 50 lists per track). Add addresses as comma-separated text or a CSV (CSV **overwrites** the previous list; UTF-8 with BOM is rejected).
   - **Google Groups:** enter `yourgroupname@googlegroups.com`. Only members of that group can join. Group members must **join the group first**, then opt in.
3. Add a feedback URL or email (shown on the tester opt-in page).
4. **Copy the shareable / opt-in link** and send it to testers.
5. **Save changes.**

([Set up an open, closed, or internal test](https://support.google.com/googleplay/android-developer/answer/9845334))

Testers need a Google Account or Google Workspace account. ([Set up an open, closed, or internal test](https://support.google.com/googleplay/android-developer/answer/9845334))

### What the opt-in link does

- The opt-in link appears only when app status is **Published**. **Draft** and **Pending publication** do not show it. First publish of a test can take **several hours** before the link works; later changes can also take several hours. ([Set up an open, closed, or internal test](https://support.google.com/googleplay/android-developer/answer/9845334))
- After clicking the link, the tester sees tester responsibilities and a second control to **opt in**. **Each tester must opt in using the link.** ([Set up an open, closed, or internal test](https://support.google.com/googleplay/android-developer/answer/9845334))
- Before open testing or production, closed testers generally **cannot find the app by searching** Play; share the Play Store URL or the opt-in link. Once the closed test is published, app status can be **Closed testing**: discoverable in the sense that **selected testers** can install it, not that any Play user can. ([Set up an open, closed, or internal test](https://support.google.com/googleplay/android-developer/answer/9845334); [Publish your app](https://support.google.com/googleplay/android-developer/answer/9859751))
- After install, the device updates to the test version in a few minutes. Test versions do **not** get public Play ratings. Testers can send private feedback through Play on open/closed tests; you should still give them a feedback channel. ([Set up an open, closed, or internal test](https://support.google.com/googleplay/android-developer/answer/9845334))

Google’s own best-practice line: tell testers they must **remain opted in continuously for at least 14 days**. ([App testing requirements](https://support.google.com/googleplay/android-developer/answer/14151465))

---

## The 14 consecutive days clock

The requirement is **not** “a closed test existed for 14 days.” It is: when you apply, **at least 12 testers are opted in right then**, and those testers have been opted in **continuously for the preceding 14 days**. ([App testing requirements](https://support.google.com/googleplay/android-developer/answer/14151465))

**When it starts (per tester):** on the day that tester **opts in**, not the day you add their email or share the link. The earliest apply date is 14 days after the **12th currently opted-in** tester first opted in, if those 12 never left.

**What breaks a tester’s count:**

- Opt in, stay fewer than 14 days, then **opt out** → they do **not** count. ([App testing requirements](https://support.google.com/googleplay/android-developer/answer/14151465))
- Opt out and later opt back in → the 14 days **restart**; only **consecutive** days count. ([App testing requirements](https://support.google.com/googleplay/android-developer/answer/14151465))

**Replacing testers** does **not** reset a global clock. Play Console Help describes a **per-tester** consecutive-opt-in window. A replacement starts their own 14 days. You still need **12 people who are opted in on apply day and have each been opted in for the previous 14 consecutive days**. If you swap someone out before their 14 days (or they leave), you need another tester who already has (or will complete) 14 consecutive days.

Play Console Help does **not** say that uploading a new closed-test AAB, changing the email list, or adding extra testers resets the 14-day period. It only describes opt-out / re-opt-in as breaking continuity.

**Pausing the track** (`Pause track`) ends the test: testers stop getting updates; the app stays installed. Help does not say whether pause clears opt-in status. Do not pause the closed track during the 14 days if you can avoid it. ([Set up an open, closed, or internal test](https://support.google.com/googleplay/android-developer/answer/9845334))

**Engagement is separate from the numeric gate.** The 12/14 count is opt-in continuity. When you apply, Google also asks whether testers used the features and whether usage looked like production use. “Insufficient tester engagement” is a listed reason you may be told to **keep running** the closed test even after the calendar looks right. ([App testing requirements](https://support.google.com/googleplay/android-developer/answer/14151465))

---

## How to apply for production access (and what Google reviews)

After the 12/14 criteria are met:

1. Open the app **Dashboard** in Play Console.
2. Click **Apply for production**.
3. Complete three form sections, then **Apply**. Leaving the page or clicking **Discard** without **Next** / **Apply** does **not** save. ([App testing requirements](https://support.google.com/googleplay/android-developer/answer/14151465))

| Section | What you answer |
| --- | --- |
| About your closed test | How easy recruiting was; whether testers used all features; whether usage matched expected production behavior (and any differences); a **summary of tester feedback** and how you collected it. |
| About your app/game | Target audience (be specific); value proposition (for a game: what makes it unique); estimated first-year install range. Answers are **not** shown on the public listing and do not change Console feature access. |
| About your production readiness | Changes you made from the closed test; how you decided the app is ready for production. |

([App testing requirements](https://support.google.com/googleplay/android-developer/answer/14151465))

**What happens next:** Google reviews the submission. The **account owner** gets email. Review **usually takes seven days or less**, sometimes longer. ([App testing requirements](https://support.google.com/googleplay/android-developer/answer/14151465))

**If approved:** Production (`Test and release > Production`) and Open testing become available. You still roll out a production release separately. ([App testing requirements](https://support.google.com/googleplay/android-developer/answer/14151465))

**If not approved / more testing required:** listed reasons include **fewer than 12 opted-in testers** or **insufficient tester engagement**. Keep the closed test running. ([App testing requirements](https://support.google.com/googleplay/android-developer/answer/14151465))

**What reviewers expect besides the form:** you are responsible for policy compliance **before** you apply. Review is not a debugging service. Help calls out: content/features/monetization policy; accurate target age and listing; **stable, no broken functionality / crashes / missing screens**; and **working login credentials in Console** if the app requires sign-in (Klondike Solitaire has no accounts, so that last item should not apply). ([App testing requirements](https://support.google.com/googleplay/android-developer/answer/14151465))

The closed-test form exists to check that the app was **thoroughly tested**, to protect users from low quality, malware, and fraud. ([App testing requirements](https://support.google.com/googleplay/android-developer/answer/14151465))

---

## Organization accounts (fact only)

Play Console Help states the 12/14 closed-test production-access gate for **personal** accounts created after 13 November 2023. The dedicated article is titled for **new personal developer accounts**. Get started marks testing requirements **(Personal accounts only)**. ([App testing requirements](https://support.google.com/googleplay/android-developer/answer/14151465); [Get started with Play Console](https://support.google.com/googleplay/android-developer/answer/6112435))

**Organization** accounts are a separate type (D-U-N-S required). Help says personal and organization accounts have **the same functionality** and does **not** describe this 12/14 gate for Organization accounts. It also does **not** say switching to Organization is required, or is the only path, for a personal hobby game. ([Choose a developer account type](https://support.google.com/googleplay/android-developer/answer/13634885))

Do not switch account type for this gate unless a later official page says otherwise.

---

## Binary for the closed test (high level)

New apps since August 2021 must publish with an **Android App Bundle (AAB)**, not a standalone APK. Google Play builds device-specific APKs from that bundle. Using app bundles requires **Play App Signing**. ([Inspect app versions / Latest releases and bundles](https://support.google.com/googleplay/android-developer/answer/9844279); [Create and set up your app](https://support.google.com/googleplay/android-developer/answer/9859152))

Closed-test release path: `Test and release > Testing > Closed testing` → **Manage track** → **Create new release**. If that button is disabled, finish outstanding **Dashboard** setup tasks. First release: follow on-screen **Play App Signing** setup, then **add app bundles**. Legacy apps created before August 2021 may still add APKs; that exception does not apply to a new Klondike listing. Then save, preview, **Start rollout**. ([Prepare and roll out a release](https://support.google.com/googleplay/android-developer/answer/9859348))

Creating the app also requires accepting the **Play App Signing Terms of Service**. Package name is **fixed** once you upload the first artifact. ([Create and set up your app](https://support.google.com/googleplay/android-developer/answer/9859152); [Set up an open, closed, or internal test](https://support.google.com/googleplay/android-developer/answer/9845334))

Signing-key and Flutter AAB production steps belong on the sibling AAB ticket.

Internal testing can take an AAB **before** full app setup and is useful as a dry run; it still does **not** replace the closed-test gate. Apps **only** on internal testing are exempt from the Data safety section; closed testing is a published track, so finish Dashboard content tasks (including the items Play marks mandatory) before relying on the closed release. ([Set up an open, closed, or internal test](https://support.google.com/googleplay/android-developer/answer/9845334); [Set up your app on the app dashboard](https://support.google.com/googleplay/android-developer/answer/9859454))

---

## Adjacent personal-account step (not the 12/14 clock)

New personal accounts (early 2024 onward) must also **verify access to a real Android device** (non-rooted, Android 10+) with the Play Console mobile app before the app can be made available on Google Play. Home page task: scan QR, sign in as the **account owner**, tap **Verify**. Separate from closed testing; both sit on the personal-account path to public release. ([Get started with Play Console](https://support.google.com/googleplay/android-developer/answer/6112435); [Device verification requirements](https://support.google.com/googleplay/android-developer/answer/14316361))

---

## Beginner checklist (plan only — do not run Console in this ticket)

1. **Account:** personal Play Console account created after 13 Nov 2023. Production stays locked until the closed-test gate plus application. Organization is not documented as a skip.
2. **Create the app** (`Home > Create app`): name Klondike Solitaire, Game, free, support email, policy / export / Play App Signing declarations.
3. **Finish Dashboard mandatory setup** (store listing, app content, and other tasks Play marks required). Closed testing cannot start until setup is complete. **Create new release** stays disabled until those tasks are done.
4. **Binary:** upload an **AAB** to the **closed testing** track and complete first-release Play App Signing. Do not use a debug APK as the Play artifact. (Build details: sibling AAB ticket.)
5. **Track that counts:** **Closed testing** only. Internal is optional and does not count. Open testing is unavailable until production access is granted. Anyone opted into **internal** must leave internal before they can opt into closed.
6. **Invite ≥12 people** (email list and/or Google Group) **and send the opt-in link**. Being on the list is not enough. Each tester must open the link and **opt in**. Link exists only when status is **Published**.
7. **Clock:** keep **at least 12 testers opted in for 14 consecutive days**. The clock is **per tester**, starting at **opt-in**. Opt-out then re-join restarts that person. Replacing a tester does not reset everyone else; the replacement needs their own 14 days. Ask testers to stay opted in and actually use the Game (engagement is reviewed).
8. **Apply:** Dashboard → **Apply for production** → answer the three sections (closed test, app/game, readiness), including a **feedback summary**. Typical review ≤7 days. Approval unlocks Production and open testing; you still roll out a production release. Rejection for thin engagement or fewer than 12 opted-in testers means continue the closed test.
9. **Also:** device verification via the Play Console app if Home still shows that task.
