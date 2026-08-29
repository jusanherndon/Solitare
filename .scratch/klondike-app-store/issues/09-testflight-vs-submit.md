# Do we use TestFlight before Submit for Review?

Type: grilling
Status: open
Blocked by: 08

Depends on [How do we produce a store-signed iOS build from this Flutter project?](issues/07-flutter-ios-store-build.md) (upload creates a processed build; Internal TestFlight and Submit for Review are separate Connect steps after that).

## Question

After the first store-signed IPA is in App Store Connect, do we send that build to **TestFlight** (internal and/or external) before **Submit for Review**, or submit the processed build to App Review without a TestFlight pass?

Phones only, English, no accounts. Do not invent a beta program beyond what v1 needs to get listed. External TestFlight has its own review; say if we skip it.
