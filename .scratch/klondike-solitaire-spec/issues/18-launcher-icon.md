# What launcher icon should the Android APK and iOS IPA use?

Type: prototype
Status: open

Related: [What bugs or changes turn up when the owner runs the prototype on Android?](issues/17-android-playtest.md), [What App Store icon and 6.9″ screenshots does v1 use?](../../klondike-app-store/issues/04-app-store-listing-visuals.md), [What Play icon, feature graphic, and screenshots does v1 use?](../../klondike-play-store/issues/04-play-listing-visuals.md).

## Question

The Flutter tree still ships the default launcher mark. Sideloaded APKs and IPAs show that generic icon on the phone home screen. What launcher icon should v1 use for **both** Android and iOS (one art, both binaries)?

Decide the look (felt, Fomin/Atlas cards, no Bicycle marks). Produce sizes the Flutter project needs (`android/` mipmaps, iOS `AppIcon` including the 1024 in the binary). Play’s 512 listing icon and Apple’s 1024 listing/binary icon should reuse this art — do not invent a second mark on the store maps.

Starting sketches (not locked) live on `prototype/listing-visuals`: A Ace on felt, B corner crop, C fan.

Phones only. This is not store screenshots or the Play feature graphic. Installing an iOS build still waits on [Can we build and install the Klondike table prototype on iOS locally?](issues/07-ios-local-prototype-build.md); the art can still land in `ios/` without a Mac.
