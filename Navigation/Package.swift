// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Navigation",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Navigation",
            targets: ["Navigation"]
        )
    ],
    targets: [
        .target(
            name: "Navigation",
            path: "Sources"
        )
    ]
)
