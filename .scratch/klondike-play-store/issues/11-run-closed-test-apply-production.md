# Can we run the closed test and apply for production?

Type: task
Status: open
Blocked by: 01, 04, 05, 06, 07, 10, 12

HITL — the owner invites testers and applies; the agent cannot stand in for Play Console as the account owner.

Depends on [What exact Play Console closed-testing steps does a personal account need before production?](issues/08-play-closed-testing.md). Checklist: `docs/research/play-closed-testing.md`.

## Question

Can we run Play **closed testing** for Klondike Solitaire on a personal developer account and **apply for production** after 12 testers have been opted in for 14 consecutive days?

Follow the locked how-to: finish Dashboard mandatory setup, roll an **AAB** to the **closed** track (not internal), send the **Published** opt-in link, keep 12 opted in for 14 days, then Dashboard → **Apply for production** (three form sections, including a tester-feedback summary). Ask testers to stay opted in and play — thin engagement can fail review even when the calendar looks right.

Do not pause the closed track during the 14 days. Device verification (Play Console app, Android 10+) is on [Can we enroll in Play Console as an individual?](issues/07-play-console-enrollment.md) if it is still outstanding.

## Done when

- Closed testing is Published with an AAB; testers received the opt-in link.
- At apply time, at least 12 testers have been opted in continuously for 14 days.
- Production-access application is submitted (or Google’s decision is recorded if already returned).
- A comment on this ticket records dates (rollout, 12th opt-in, apply) — not tester email addresses in the repo.
