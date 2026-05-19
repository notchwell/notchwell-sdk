# Notchwell SDK

> Build extensions for [Notchwell](https://notchwell.app) — the macOS app that turns your MacBook notch into a focus surface.

The Notchwell SDK is a native Swift Package. Extensions compile to `.notchext` bundles that the Notchwell host app loads at runtime.

## Status

Pre-alpha. The public API is unstable until v1.0. Notchwell itself is in early development; the SDK ships alongside the host.

## Requirements

- macOS 14.0 (Sonoma) or later
- Swift 6.0 or later
- Xcode is **not** required — extensions build from the command line with `swift build`

## Quickstart

```swift
// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "MyExtension",
    platforms: [.macOS(.v14)],
    dependencies: [
        .package(url: "https://github.com/notchwell/notchwell-sdk", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "MyExtension",
            dependencies: [.product(name: "NotchwellSDK", package: "notchwell-sdk")]
        ),
    ]
)
```

```swift
import NotchwellSDK
import SwiftUI

@NotchExtension(
    identifier: "com.example.my-extension",
    displayName: "My Extension",
    version: "1.0.0",
    author: "Your Name",
    permissions: [.timer]
)
struct MyExtension: Activity {
    var compact: some CompactView {
        EarRight {
            Text("Hello")
        }
    }

    var expanded: some ExpandedView {
        ExpandedPanel(tab: "Hello") {
            Text("Hello from the expanded panel")
        }
    }
}
```

## Project layout

```
notchwell-sdk/
├── Package.swift
├── Sources/
│   ├── NotchwellSDK/          # Public API surface
│   └── NotchwellSDKMacros/    # The @NotchExtension macro implementation
└── Tests/
    ├── NotchwellSDKTests/
    └── NotchwellSDKMacrosTests/
```

## Documentation

Full SDK reference and extension development guide will be published when the SDK reaches its first stable release.

The architectural decisions and capability surface are tracked via [OpenSpec](https://github.com/notchwell/notchwell/tree/main/openspec) in the main Notchwell repository.

## License

MIT — see [`LICENSE`](./LICENSE).

The Notchwell application is proprietary and distributed separately.

## Contributing

The SDK accepts contributions under the Developer Certificate of Origin (DCO). Sign your commits with `git commit -s`. Detailed contributor guidelines will be published before this repo goes fully public.

For now, the SDK is developed in lockstep with the main Notchwell repository. File issues and discuss design changes at <https://github.com/notchwell/notchwell>.
