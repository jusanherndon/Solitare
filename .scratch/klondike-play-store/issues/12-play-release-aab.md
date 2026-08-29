# Can we produce a Play-uploadable release AAB?

Type: task
Status: open
Blocked by: 06

HITL for keystore passwords and keeping `*.jks` / `key.properties` out of git.

Depends on [How do we produce a Play Android App Bundle from this Flutter project?](issues/09-flutter-play-aab.md). Path: `docs/research/flutter-play-aab.md`.

## Question

Can we produce a Play-uploadable **release** Android App Bundle of Klondike Solitaire, signed with an upload key (not debug)?

Follow the locked path: `keytool` → `android/key.properties` (not committed) → Gradle `signingConfigs.release` instead of debug → `flutter build appbundle`. Artifact under `build/app/outputs/bundle/release/` (`app.aab` or `app-release.aab`). API 36 is already the Flutter 3.47.2 default — do not bump SDKs. Play App Signing (Google holds the app signing key) happens on first Console upload, not in this ticket.

Set `applicationId` from [What bundle ID and application ID does v1 use?](issues/06-store-identifiers.md) before this build — the package name is fixed on first Play upload. Do not upload here; that is [Can we run the closed test and apply for production?](issues/11-run-closed-test-apply-production.md).

## Done when

- Release `signingConfig` is no longer debug; keystore and `key.properties` are private (gitignored).
- `flutter build appbundle` from the Flutter tree writes a release `.aab` at the documented path.
- A comment on this ticket records that path — not keystore passwords.
