# What launcher icon should the Android APK and iOS IPA use?

Type: prototype
Status: resolved

Related: [What bugs or changes turn up when the owner runs the prototype on Android?](issues/17-android-playtest.md), [What App Store icon and 6.9″ screenshots does v1 use?](../../klondike-app-store/issues/04-app-store-listing-visuals.md), [What Play icon, feature graphic, and screenshots does v1 use?](../../klondike-play-store/issues/04-play-listing-visuals.md).

## Question

The Flutter tree still ships the default launcher mark. Sideloaded APKs and IPAs show that generic icon on the phone home screen. What launcher icon should v1 use for **both** Android and iOS (one art, both binaries)? The name under the icon is **Solitaire Collection**.

Decide the look (felt, Fomin/Atlas cards, no Bicycle marks). Produce sizes the Flutter project needs (`android/` mipmaps, iOS `AppIcon` including the 1024 in the binary). Play’s 512 listing icon and Apple’s 1024 listing/binary icon should reuse this art — do not invent a second mark on the store maps.

The store listing locked **A — Ace on felt** on [What App Store icon and 6.9″ screenshots does v1 use?](../../klondike-app-store/issues/04-app-store-listing-visuals.md). That art is the launcher icon in `android/` mipmaps and `ios/` AppIcon, including the 1024. Do not invent a second mark.

Phones only. This is not store screenshots or the Play feature graphic. Installing an iOS build still waits on [Can we build and install the Klondike table prototype on iOS locally?](issues/07-ios-local-prototype-build.md); the art can still land in `ios/` without a Mac.

## Answer

**A — Ace on felt**, full-bleed. Source: `listing-visuals/icons/a-ace-on-felt-app.svg` (opaque felt, no pre-rounded corners; the phone masks the icon). The rounded listing SVG stays the store mock.

That art is now the launcher mark:

- Android mipmaps `ic_launcher.png` (48, 72, 96, 144, 192)
- iOS `AppIcon` set, including the 1024, RGB with no alpha
- Web `favicon.png`, `Icon-192.png`, `Icon-512.png`, and the maskable pair

The name under the icon is **Solitaire Collection** (`android:label`, `CFBundleDisplayName`, web manifest and title). `CFBundleName` is **Solitaire** so it stays inside Apple’s short-name length.
