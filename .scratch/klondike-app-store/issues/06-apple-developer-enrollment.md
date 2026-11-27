# Can we enroll in the Apple Developer Program as an individual?

Type: task
Status: resolved

HITL — the owner must enroll; the agent cannot stand in for identity, payment, or two-factor.

Facts already locked on [What do Apple and Google require to list a free no-account phone game?](https://github.com/jusanherndon/Solitare/issues/5): 99 USD per membership year; individual enrollment needs an Apple Account with two-factor authentication, legal name, and a non-P.O.-box address. ([Become a member](https://developer.apple.com/programs/enroll/))

## Question

Can the owner enroll in the Apple Developer Program as an individual and reach a state where App Store Connect can create an app record named Klondike Solitaire?

## Done when

- Owner has an active Apple Developer Program membership (individual).
- A comment on this ticket records that enrollment succeeded (date, individual vs organization) — not passwords, not the full legal address.
- App Store Connect is reachable for this membership.
- Organization / D-U-N-S is out of scope unless the owner switches to that path during enrollment.
- Registering the App ID, creating the Connect record, and uploading an IPA are [Can we produce and upload a store-signed IPA?](issues/08-upload-store-ipa.md). Signing stays **Automatically manage signing** — do not hand-create distribution certificates.

## Answer

Yes, as an individual. On 27 November 2026 the owner submitted the Apple Developer Program application for an individual membership, not an organization. No D-U-N-S number. The store record, when Connect will take it, is **Solitaire Collection**, not Klondike Solitaire. Creating that record and uploading an IPA stay on [Can we produce and upload a store-signed IPA?](issues/08-upload-store-ipa.md).

## Comments

### agent — 2026-11-27

Owner said they had just applied. Recorded individual enrollment, no address and no credentials.
