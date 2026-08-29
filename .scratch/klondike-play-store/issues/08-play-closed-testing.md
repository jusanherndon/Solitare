# What exact Play Console closed-testing steps does a personal account need before production?

Type: research
Status: resolved

Depends on [What do Apple and Google require to list a free no-account phone game?](https://github.com/jusanherndon/Solitare/issues/5) (12 testers / 14 consecutive days is already a locked fact). Enrollment is a separate task: [Can we enroll in Play Console as an individual?](issues/07-play-console-enrollment.md).

## Question

What exact Play Console steps does a **personal** developer account need so Klondike Solitaire can apply for production access?

Research against Google Play Console primary help. Cover at least:

- Closed testing vs internal testing vs open testing; which track counts toward the 12/14 gate.
- How testers opt in (email lists, Google Groups, copy link); what “opted in” means vs merely invited.
- The 14 consecutive days clock: when it starts, what breaks it, whether replacing testers resets it.
- How to apply for production access after the gate; what Google reviews.
- Whether an Organization account would skip this gate (fact for the spec — do not recommend switching unless the docs say it is the only path).
- What binary the closed test needs (AAB, Play App Signing) at a high level — deep signing is [How do we produce a Play Android App Bundle from this Flutter project?](issues/09-flutter-play-aab.md).

Do not recruit testers or enroll in this ticket. Plan, don’t implement.

## Done when

- Findings cite support.google.com Play Console help, fetched as current.
- A beginner checklist names the track, tester count, clock, and production-access application — without walking through a live Console.

## Answer

Personal accounts after 13 Nov 2023 must finish Dashboard setup, roll an **AAB** to **closed testing**, get **12 testers who actually opt in** (email/Group list + Published opt-in link; invite alone does not count), keep those 12 opted in for **14 consecutive days** (clock is per tester from opt-in; opt-out/rejoin restarts that person; replacements do not reset everyone), then **Dashboard → Apply for production** (three form sections; typical review ≤7 days). Internal does not count; open testing is locked until approval. Organization accounts are not documented as having this gate. Checklist and citations: `docs/research/play-closed-testing.md`.
