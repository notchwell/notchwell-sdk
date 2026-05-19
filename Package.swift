// swift-tools-version: 6.0

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "NotchwellSDK",
    platforms: [
        .macOS(.v14),
    ],
    products: [
        .library(
            name: "NotchwellSDK",
            targets: ["NotchwellSDK"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax", from: "601.0.0"),
    ],
    targets: [
        .macro(
            name: "NotchwellSDKMacros",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),

        .target(
            name: "NotchwellSDK",
            dependencies: ["NotchwellSDKMacros"]
        ),

        .testTarget(
            name: "NotchwellSDKTests",
            dependencies: ["NotchwellSDK"]
        ),

        .testTarget(
            name: "NotchwellSDKMacrosTests",
            dependencies: [
                "NotchwellSDKMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
