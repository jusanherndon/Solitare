# What bundle ID and application ID does v1 use?

Type: grilling
Status: open

Shared with [What bundle ID and application ID does v1 use?](../klondike-app-store/issues/05-store-identifiers.md) — one reverse-DNS id for both stores; claim and resolve both together.

The Flutter prototype currently uses `com.solitare.klondike_table` with a TODO to pick a unique application ID (`prototype/klondike-table-flutter/android/app/build.gradle.kts`).

## Question

What bundle ID (Apple) and application ID (Play) does v1 Klondike Solitaire use?

Decide the reverse-DNS string (and Apple SKU if it should differ from the bundle ID). It must be unique, stable, and suitable to ship — not a prototype leftover unless that leftover is intentionally the shipping id. Record the iOS SKU (internal, not customer-visible) if it is not the same string.

Play: the package name is **fixed** once the first artifact is uploaded (closed-test AAB counts). Lock this before [Can we run the closed test and apply for production?](issues/11-run-closed-test-apply-production.md).

Do not enroll or upload in this ticket.
