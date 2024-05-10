// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

public let package = Package(
    name: "AdyenCardReveal",
    platforms: [
        .iOS("13.0"),
    ],
    products: [
        .library(
            name: "AdyenCardReveal",
            targets: ["AdyenCardReveal"]
        ),
    ],
    targets: [
        .binaryTarget(
            name: "AdyenCardReveal",
            path: "AdyenCardReveal/XCFramework/Dynamic/AdyenCardReveal.xcframework"
        ),
    ]
)
