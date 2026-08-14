# One-codebase toolkit for Klondike Solitaire

**Ticket:** [Which one-codebase toolkit should a beginner use to ship Klondike Solitaire?](https://github.com/jusanherndon/Solitare/issues/2)
**Map:** [Map: Klondike Solitaire spec](https://github.com/jusanherndon/Solitare/issues/1)

## Question

Which shared codebase should a beginner use to ship Klondike Solitaire to the Apple App Store and Google Play?

Constraints that matter for this spec:

- One shared codebase for both stores
- Phones only, portrait and landscape
- Classic Klondike: Tableau, Foundation, Stock, Waste; tap and drag; undo and resume a Game
- No accounts, no backend
- Owner is new to app development

## Recommendation

**Use Expo (the React Native framework).**

It is the only realistic beginner option whose first-party docs cover the whole path this spec needs: one JavaScript/TypeScript project for Android and iOS, local persistence for resume, tap and drag in the official tutorial, and store binaries plus uploads without a local Mac.

Flutter is the closest runner-up for a custom card layout. It loses for this owner because shipping iOS officially requires macOS and Xcode on the machine that builds the binary.

## How the options were judged

A toolkit fits if a new app developer can learn it and ship a local-only phone Game to both stores. Claims below come from the vendor that owns the product, not from blog roundups.

| Constraint | Why it matters here |
| --- | --- |
| One codebase | Map: one shared codebase for both stores |
| Beginner can ship | Owner is new to app development |
| iOS + Android store binaries | Destination is App Store and Google Play |
| Local persistence | Resume a Game; no accounts, no backend |
| Tap and drag | Cards move on the Tableau, Foundation, Stock, and Waste |
| Portrait and landscape | Phones only, both orientations |

Web, desktop, TV, and tablet targets are out of scope. A toolkit that *can* also target them is fine if phones remain the product.

## Expo (React Native framework)

### What it is

Expo is an open-source framework for apps that run natively on Android, iOS, and the web.[^expo-core] React Native's own getting-started guide says the best way to experience React Native is through a Framework, and it names Expo as that Framework for a new app.[^rn-framework]

Expo's docs open with a single JavaScript/TypeScript project that runs natively on users' devices, and they advertise launching to stores with no prior experience.[^expo-home] The official tutorial builds one app that runs on Android, iOS, and web from a single codebase, in about two hours.[^expo-tutorial]

Expo Go is documented as a playground for students and learners.[^expo-core] With the `expo` package, Expo lists "Develop apps without Xcode or Android Studio" as a first-class feature.[^expo-core]

### Shipping to both stores

EAS Build is a hosted service that builds app binaries for Expo and React Native projects. `eas build --platform all` produces installable Android and iOS binaries. EAS can provision and manage signing credentials. iOS cloud builds run on Expo's macOS runners; Android builds run on Linux.[^eas-build]

EAS Submit is the recommended upload path to Google Play Console (`.aab`) and App Store Connect (`.ipa`). Expo documents that this works from any OS, including Windows and Linux for iOS.[^eas-submit]

A later session still needs Apple Developer Program and Google Play enrollment. Those sit outside this map. The toolkit question is whether a beginner can produce and upload both binaries from one project. Expo's first-party path says yes, without installing Xcode locally.

### Local-only Game state

Klondike here has no accounts and no backend. Resume needs on-device storage.

Expo documents several local stores. `expo-sqlite` is a database that persists across app restarts.[^expo-store] Async Storage is documented as unencrypted persistent key-value storage, "a good choice for storing small amounts of data" and "user preferences or app state."[^expo-store] Either is enough to serialize a Game (Tableau, Foundation, Stock, Waste, undo stack) and restore it.

### Tap, drag, portrait, landscape

The official Expo tutorial has a chapter that adds tap and pan (drag) with React Native Gesture Handler and Reanimated — the same gestures a card Game uses to move a card.[^expo-gestures]

App config `orientation` accepts `default`, `portrait`, or `landscape`, and defaults to no lock.[^expo-app-config] `expo-screen-orientation` can lock or listen for portrait/landscape at runtime.[^expo-orientation] Phones-only is a store-listing and layout choice, not a toolkit limit.

### Fit

Expo matches every constraint: one codebase, beginner tutorial that includes drag, local persistence, both stores, no Mac required for the cloud build/submit path.

## Flutter

### What it is

Flutter is Google's UI toolkit for natively compiled apps for mobile, web, and desktop from a single codebase.[^flutter-faq] It is designed for mobile apps that run on both Android and iOS.[^flutter-faq] Flutter says it lowers the bar to entry and that people with very little programming experience have used it for prototyping and app development.[^flutter-faq] The language is Dart.

### Shipping to both stores

Android: `flutter build appbundle` produces a Play Store `.aab`.[^flutter-android]

iOS: Flutter's release guide is explicit — "Xcode is required to build and release your app. You must use a device running macOS to follow this guide."[^flutter-ios] iOS setup is Xcode, command-line tools, licenses, the iOS Simulator, and CocoaPods.[^flutter-ios-setup]

That is a real beginner gate. This spec does not assume the owner has a Mac. Flutter can still ship to both stores *if* a Mac is available. Without one, the official iOS path stops.

### Local-only Game state, tap, drag, orientation

`shared_preferences` persists key-value data on each Flutter platform.[^flutter-prefs] Official gesture docs cover tap, drag, and pan via `GestureDetector`.[^flutter-gestures] A cookbook recipe shows `LongPressDraggable` / `DragTarget` for drag-and-drop.[^flutter-drag] `OrientationBuilder` and `SystemChrome.setPreferredOrientations` cover portrait and landscape.[^flutter-orientation]

Flutter is a strong fit for a custom card table. It is not the best fit for a beginner who must also produce an iOS binary.

### Fit

Second place. Same product capabilities as Expo for a local Klondike Game. Higher local toolchain cost, a new language, and an official Mac requirement for iOS release.

## Other realistic options (not recommended)

### Bare React Native (no Framework)

React Native allows this, and then tells new apps not to do it. Without a Framework you set up Android Studio and Xcode yourself and assemble navigation, native APIs, and dependencies.[^rn-framework] Expo is the Framework React Native recommends for a new project.[^rn-framework] Bare RN adds work this spec does not need.

### Capacitor (web in a native shell)

Capacitor is a native runtime for web apps on iOS, Android, and web.[^capacitor] A beginner who already writes HTML/CSS/JS could wrap a local Game.

Official environment setup: iOS needs macOS, Xcode, and Xcode Command Line Tools. Capacitor mentions cloud iOS builds (Ionic Appflow) if you do not have a Mac, then "highly recommended" to have the tools locally to test.[^capacitor-env] That is a weaker beginner-ship story than Expo's documented EAS path, and card drag is not taught as a first-party mobile tutorial the way Expo and Flutter teach it.

### .NET MAUI

.NET MAUI builds Android, iOS, macOS, and Windows from one C# / XAML codebase.[^maui] Official note: "Building apps for iOS and macOS requires a Mac."[^maui] The audience is developers who want Visual Studio and C#. That is not this owner.

### Kotlin Multiplatform

JetBrains documents KMP as sharing *application logic* between iOS and Android, with platform-specific code "when you need to implement a native UI."[^kmp-first] The official first-app wizard's iOS default is "Do not share UI." The generated tree is an Android Gradle app, an Xcode `iosApp`, and a shared logic module with `expect`/`actual` splits.[^kmp-first] Compose Multiplatform can share UI, but that is an extra stack on top of Gradle, Xcode, and Kotlin. Running iOS from the tutorial still launches Xcode tooling.[^kmp-first]

That is two native apps plus a shared module, or a shared-UI setup aimed at people who already know Android/iOS. It is not a beginner one-codebase toolkit for a local card Game.

## Comparison against this spec

| Toolkit | One UI codebase | Beginner path | iOS binary without a local Mac (official) | Local persist | Tap + drag (official) | Portrait + landscape |
| --- | --- | --- | --- | --- | --- | --- |
| **Expo** | Yes[^expo-core] | Tutorial + Expo Go; RN recommends it[^expo-tutorial][^rn-framework] | Yes — EAS cloud Mac + submit from any OS[^eas-build][^eas-submit] | SQLite / Async Storage[^expo-store] | Tutorial pan + tap[^expo-gestures] | Config + API[^expo-app-config][^expo-orientation] |
| Flutter | Yes[^flutter-faq] | Approachable; Dart is new[^flutter-faq] | No — macOS + Xcode required[^flutter-ios] | `shared_preferences`[^flutter-prefs] | `GestureDetector` / draggable[^flutter-gestures] | `OrientationBuilder`[^flutter-orientation] |
| Bare React Native | Yes | RN says use a Framework[^rn-framework] | No — local Xcode/Android Studio[^rn-framework] | Same family as Expo | Community libraries | Possible, more setup |
| Capacitor | Web UI + native shell[^capacitor] | Web skills help; native IDEs still | Cloud mentioned; Mac "highly recommended"[^capacitor-env] | Web storage APIs | Not a first-party card-drag tutorial | Web/CSS + native config |
| .NET MAUI | Yes[^maui] | C# / Visual Studio audience[^maui] | No — Mac required[^maui] | Platform APIs exist | Platform gestures | Supported |
| Kotlin Multiplatform | Logic shared; UI often native[^kmp-first] | Gradle + Xcode + expect/actual[^kmp-first] | No — Xcode iOS app[^kmp-first] | You implement it | You implement it per UI | You implement it |

## Why Expo, in one paragraph

This app is a local Klondike Game on phones: one deal, Tableau / Foundation / Stock / Waste, tap and drag, undo, resume, Win when every Foundation is Ace through King. There is no server to justify a heavier stack. Expo is the toolkit whose owner (and React Native's owner) document a beginner path from `npx create-expo-app` to both stores, including drag gestures and on-device storage, and whose official iOS build/submit path does not require the developer to own a Mac. Flutter would also render this Game well; it is the right fallback if the owner later prefers Dart and already has macOS.

## Sources

[^expo-home]: [Expo documentation home](https://docs.expo.dev/) — "Build one JavaScript/TypeScript project that runs natively on all your users' devices"; "Ship apps with zero config or no prior experience."
[^expo-core]: [Expo Core concepts](https://docs.expo.dev/core-concepts/) — open-source framework for Android, iOS, and web; Expo Go for learners; develop without Xcode or Android Studio.
[^expo-tutorial]: [Tutorial: Using React Native and Expo](https://docs.expo.dev/tutorial/introduction/) — one codebase for Android, iOS, and web; about two hours; includes adding gestures.
[^expo-gestures]: [Add gestures (Expo tutorial)](https://docs.expo.dev/tutorial/gestures/) — tap and pan (drag) with React Native Gesture Handler and Reanimated.
[^expo-store]: [Store data (Expo)](https://docs.expo.dev/develop/user-interface/store-data/) — `expo-sqlite` persists across restarts; Async Storage for app state.
[^expo-app-config]: [app.json / app config `orientation`](https://docs.expo.dev/versions/latest/config/app/) — `default` / `portrait` / `landscape`; default is no lock.
[^expo-orientation]: [expo-screen-orientation](https://docs.expo.dev/versions/latest/sdk/screen-orientation/) — lock and listen for portrait/landscape.
[^eas-build]: [EAS Build](https://docs.expo.dev/build/introduction/) — `eas build --platform all`; managed signing; iOS on Expo macOS cloud, Android on Linux.
[^eas-submit]: [Submit to app stores](https://docs.expo.dev/deploy/submit-to-app-stores/) — EAS Submit recommended; works from Windows and Linux for iOS.
[^rn-framework]: [Get Started with React Native](https://reactnative.dev/docs/environment-setup) — best path is a Framework; Expo is the named Framework; new apps should use one.
[^flutter-faq]: [Flutter FAQ](https://docs.flutter.dev/resources/faq) — single codebase; Android and iOS; approachable; Dart.
[^flutter-android]: [Build and release an Android app](https://docs.flutter.dev/deployment/android) — `flutter build appbundle` for Play.
[^flutter-ios]: [Build and release an iOS app](https://docs.flutter.dev/deployment/ios) — Xcode required; must use macOS.
[^flutter-ios-setup]: [Set up iOS development](https://docs.flutter.dev/platform-integration/ios/setup) — Xcode, licenses, Simulator, CocoaPods.
[^flutter-prefs]: [Store key-value data on disk](https://docs.flutter.dev/cookbook/persistence/key-value) — `shared_preferences`.
[^flutter-gestures]: [Taps, drags, and other gestures](https://docs.flutter.dev/ui/interactivity/gestures) — `GestureDetector` tap/drag/pan.
[^flutter-drag]: [Drag a UI element](https://docs.flutter.dev/cookbook/effects/drag-a-widget) — `LongPressDraggable` and `DragTarget`.
[^flutter-orientation]: [Update the UI based on orientation](https://docs.flutter.dev/cookbook/design/orientation) — `OrientationBuilder`; `setPreferredOrientations`.
[^capacitor]: [Capacitor documentation](https://capacitorjs.com/docs) — native runtime for web apps on iOS, Android, and web.
[^capacitor-env]: [Capacitor environment setup](https://capacitorjs.com/docs/getting-started/environment-setup) — iOS requires macOS and Xcode; cloud builds mentioned; local Mac highly recommended.
[^maui]: [What is .NET MAUI?](https://learn.microsoft.com/en-us/dotnet/maui/what-is-maui) — one C# / XAML codebase; iOS/macOS builds require a Mac.
[^kmp-first]: [Create your Kotlin Multiplatform app](https://kotlinlang.org/docs/multiplatform/multiplatform-create-first-app.html) — share logic; default iOS UI not shared; Android module + Xcode `iosApp` + `expect`/`actual`.
