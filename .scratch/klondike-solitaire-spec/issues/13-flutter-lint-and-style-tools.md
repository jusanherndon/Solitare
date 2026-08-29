# Which Flutter analyzer, lint, and format tools should this repo use?

Type: research
Status: resolved

Related: toolkit decision (Flutter, `prototype/klondike-table-flutter`) and ADR-0001 (prefer few dependencies).

## Question

Which official and widely used Flutter/Dart automated tools should this repo adopt so agents and humans catch errors early and keep a consistent coding style?

The Flutter tree already has `prototype/klondike-table-flutter/analysis_options.yaml` including `package:flutter_lints/flutter.yaml`, but `pubspec.yaml` does not declare `flutter_lints`. Start there. Owner is new to app development; prefer a small, well-documented set over a large custom rule pile.

Research against primary sources (dart.dev, flutter.dev, package READMEs owned by the Dart/Flutter teams or the lint-set authors). Cover at least:

- **Analyzer and lints.** `flutter analyze` / `dart analyze`, `analysis_options.yaml`, the `lints` vs `flutter_lints` presets, and whether a stricter published set (for example `very_good_analysis`) is worth the extra rules for a beginner solo project. Call out useful extra rules that catch real bugs (null-safety leftovers, discarded futures, unawaited calls) vs style-only noise.
- **Style enforcement.** `dart format` (what it does and does not decide), `dart fix`, and whether quote/line-length/import rules should live in `analysis_options.yaml` or be left to the formatter.
- **Other error-catching automation** that is not CI: analyzer plugins / `custom_lint`, `flutter test`, and anything else first-party that would have caught mistakes in this prototype. Skip store submission and GitHub Actions — CI stays out of scope on this map until the spec exists. Do name which commands would later belong in CI so a follow-up task can wire them.

Recommend one stack: packages to add (if any), `analysis_options.yaml` shape, and the local commands a beginner should run. Plan, don’t implement. Do not add dependencies or change the prototype in this ticket.

## Done when

- Findings cite primary sources and compare the current `flutter_lints` include against at least one stricter alternative and “analyzer defaults only.”
- A single recommended stack is named: lint preset, format policy, and any extra tools — with a short “why this, not that” for a beginner + few-dependencies project.
- Local commands are listed (`flutter analyze`, `dart format`, tests, etc.). CI is named only as “later,” not set up.

## Answer

**Use the official Flutter lint preset plus the Dart formatter and tests.** One extra pub package (`flutter_lints`), default 80-column `dart format`, `flutter analyze`, and `flutter test`. Do not adopt `very_good_analysis`, DCM, `custom_lint`, or `pedantic`. A follow-up task applies this; this ticket does not change the prototype.

### Recommended stack

| Piece | What |
| --- | --- |
| Lint preset | `package:flutter_lints/flutter.yaml` (Flutter team; extends Dart `lints`/`recommended`) |
| Package | Add `flutter_lints` as a **dev_dependency** (`flutter pub add --dev flutter_lints`). `flutter create` already does this ([Flutter pubspec](https://docs.flutter.dev/tools/pubspec#flutter_lints), [migration](https://docs.flutter.dev/release/breaking-changes/flutter-lints-package)). |
| Extra lints | Enable `unawaited_futures` and `discarded_futures` — real async bugs, **not** in `flutter_lints`. Leave `prefer_single_quotes` off. |
| Format | `dart format .` at default **80** columns. Do not set `formatter.page_width`. Quotes and import order are **not** the formatter’s job. |
| Tests | `flutter test` (unit + widget). `flutter_test` is already in `pubspec.yaml`. |
| Fixes | After enabling lints: `dart fix --dry-run`, then `dart fix --apply` if the preview looks right. |

Suggested `analysis_options.yaml` shape (not applied here):

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  exclude:
    - build/**
    - android/**
    - ios/**
    - web/**
    - windows/**
    - macos/**
    - linux/**

linter:
  rules:
    unawaited_futures: true
    discarded_futures: true
```

That matches the `flutter create` template ([flutter_lints 6.0.0](https://pub.dev/packages/flutter_lints)) plus two bug-catching rules. Keep the existing platform/build excludes.

### Why this, not that

**Analyzer defaults only** (no `include:`): the analyzer still reports language-spec errors and warnings, then “defaults to standard checks” if it finds no options file ([Customizing static analysis](https://dart.dev/tools/analysis)). That misses the Dart team’s recommended lints and all Flutter-specific ones (`avoid_print`, `use_build_context_synchronously`, …). Worse for a beginner: fewer catches, no shared style.

**`package:lints` core / recommended:** official Dart sets ([lints 6.1.0](https://pub.dev/packages/lints)). Core = “critical issues… All code should pass.” Recommended = core plus idiomatic style. Flutter apps should use **`flutter_lints`**, which *includes* `package:lints/recommended.yaml` and adds Flutter rules ([flutter.yaml](https://raw.githubusercontent.com/flutter/packages/main/packages/flutter_lints/lib/flutter.yaml)): `avoid_print`, `avoid_unnecessary_containers`, `avoid_web_libraries_in_flutter`, `no_logic_in_create_state`, `prefer_const_constructors_in_immutables`, `sized_box_for_whitespace`, `sort_child_properties_last`, `use_build_context_synchronously`, `use_full_hex_values_for_flutter_colors`, `use_key_in_widget_constructors`. Using only `lints` would drop those. The Dart team “will likely not provide recommendations past `core` and `recommended`” ([lints README](https://pub.dev/packages/lints)).

**`very_good_analysis` 10.3.0:** Very Good Ventures’ internal set ([pub.dev](https://pub.dev/packages/very_good_analysis)), inspired by deprecated `pedantic`. Version 10.0.0 turns on strict language modes *and* a long rule list including `public_member_api_docs`, `prefer_single_quotes`, `lines_longer_than_80_chars`, `prefer_const_constructors`, `require_trailing_commas`, `directives_ordering`, plus the two async rules above ([analysis_options.10.0.0.yaml](https://raw.githubusercontent.com/VeryGoodOpenSource/very_good_analysis/main/lib/analysis_options.10.0.0.yaml)). Too much for a beginner solo game: doc comments on every public member, a third-party preset that moves independently of Flutter, and style rules the formatter does not enforce. Skip.

**`pedantic`:** deprecated; Google’s old internal set. The package tells you to use `lints` or `flutter_lints` instead ([pedantic 1.11.1](https://pub.dev/packages/pedantic)).

**DCM / `dart_code_metrics`:** extra rules and metrics, now a **paid** product ([dcm.dev/pricing](https://dcm.dev/pricing/), [discontinued pub package](https://pub.dev/documentation/dart_code_metrics/latest/)). Conflicts with few-dependencies and a beginner budget. Skip.

**`custom_lint`:** for *writing* project-specific rules ([custom_lint 0.8.1](https://pub.dev/packages/custom_lint)). Needs an analyzer plugin, a second command (`dart run custom_lint` — `dart analyze` does **not** see these lints), and more memory. Overkill until we have a rule the SDK linter cannot express.

**Legacy analyzer plugins:** experimental, one plugin per options file, extra RAM; Dart docs warn against them on machines with <16 GB RAM ([analysis](https://dart.dev/tools/analysis)). Skip.

**`prefer_single_quotes`:** style only. The `flutter create` template leaves it commented. `dart format` does **not** rewrite `'` vs `"` ([dart_style FAQ](https://github.com/dart-lang/dart_style/wiki/FAQ) — changing delimiters is out of charter; use `dart fix` for aggressive edits). Effective Dart says **DO format with `dart format`** and **PREFER 80-character lines**; remaining format rules are “the few things `dart format` cannot fix” ([Effective Dart: Style](https://dart.dev/effective-dart/style)). Leave quotes to whoever typed them.

### Bug-catching vs style

Already in `flutter_lints` (worth keeping):

- `use_build_context_synchronously` — using `BuildContext` after an `await` can crash ([rule](https://dart.dev/tools/linter-rules/use_build_context_synchronously)).
- `avoid_print` — production `print` noise ([rule](https://dart.dev/tools/linter-rules/avoid_print)); Flutter suggests `debugPrint` / `kDebugMode`.

Not in `flutter_lints`; enable locally:

- `unawaited_futures` — forgotten `await` in `async` bodies ([rule](https://dart.dev/tools/linter-rules/unawaited_futures)).
- `discarded_futures` — calling async work from a sync function and dropping the `Future` ([rule](https://dart.dev/tools/linter-rules/discarded_futures)).

Style that `dart format` already owns: wrapping, indent, trailing commas (`automate` is the default; `preserve` is VGA’s choice — don’t copy it). Do not add `lines_longer_than_80_chars`; the formatter is the style guide.

Optional later (not v1 of this stack): analyzer `language: strict-casts / strict-inference / strict-raw-types` catch implicit `dynamic` ([analysis](https://dart.dev/tools/analysis)). Useful, but extra beginner friction on day one.

### Current prototype gap

`prototype/klondike-table-flutter/analysis_options.yaml` already `include`s `package:flutter_lints/flutter.yaml` (the `flutter create` text). `pubspec.yaml` does **not** list `flutter_lints` — only `flutter` and `flutter_test`. The include cannot resolve without the package ([usage step 1](https://pub.dev/packages/flutter_lints)). README currently says “Dart / Flutter SDK only (no pub packages)”; adding `flutter_lints` as a *dev* dependency is the official exception and does not ship in the APK.

### Local commands

From `prototype/klondike-table-flutter`:

```bash
flutter pub get
flutter analyze
dart format .
flutter test
dart fix --dry-run    # then dart fix --apply if the preview is right
```

Use **`flutter analyze`**, not `dart analyze`, in a Flutter tree ([Flutter CLI](https://docs.flutter.dev/reference/flutter-cli)). IDEs with Dart support run the same analyzer ([analysis](https://dart.dev/tools/analysis)). Enable format-on-save ([dart format](https://dart.dev/tools/dart-format)).

`dart analyze` fails the process on errors and warnings, not info-level issues, unless you pass `--fatal-infos` ([dart analyze](https://dart.dev/tools/dart-analyze)).

### Later CI (do not set up now)

Map CI is out of scope until the spec exists. When a follow-up wires it, the same three commands:

```bash
flutter analyze
dart format -o none --set-exit-if-changed .
flutter test
```

`--set-exit-if-changed` is the documented CI hook for format ([dart format](https://dart.dev/tools/dart-format)). Tests: [Testing Flutter apps](https://docs.flutter.dev/testing/overview). No GitHub Actions in this ticket.

### Sources

- [Customizing static analysis](https://dart.dev/tools/analysis) — options file, include, severities, strict modes, formatter keys, plugins
- [dart analyze](https://dart.dev/tools/dart-analyze), [dart format](https://dart.dev/tools/dart-format), [dart fix](https://dart.dev/tools/dart-fix)
- [Effective Dart: Style](https://dart.dev/effective-dart/style) — `dart format` is the whitespace spec; 80 columns
- [dart_style FAQ](https://github.com/dart-lang/dart_style/wiki/FAQ) — formatter does not change quotes; use `dart fix` for other edits
- [package:lints](https://pub.dev/packages/lints), [core.yaml](https://raw.githubusercontent.com/dart-lang/lints/main/lib/core.yaml), [recommended.yaml](https://raw.githubusercontent.com/dart-lang/lints/main/lib/recommended.yaml)
- [package:flutter_lints](https://pub.dev/packages/flutter_lints), [flutter.yaml](https://raw.githubusercontent.com/flutter/packages/main/packages/flutter_lints/lib/flutter.yaml), [Flutter pubspec / flutter_lints](https://docs.flutter.dev/tools/pubspec#flutter_lints), [Introducing flutter_lints](https://docs.flutter.dev/release/breaking-changes/flutter-lints-package)
- [very_good_analysis](https://pub.dev/packages/very_good_analysis), [VGA 10.0.0 rules](https://raw.githubusercontent.com/VeryGoodOpenSource/very_good_analysis/main/lib/analysis_options.10.0.0.yaml)
- [pedantic (deprecated)](https://pub.dev/packages/pedantic), [custom_lint](https://pub.dev/packages/custom_lint), [DCM pricing](https://dcm.dev/pricing/), [dart_code_metrics discontinued](https://pub.dev/documentation/dart_code_metrics/latest/)
- [Testing overview](https://docs.flutter.dev/testing/overview)
