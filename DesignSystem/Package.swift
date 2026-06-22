// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DesignSystem",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "DesignSystem",
            targets: ["DesignSystem"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/SnapKit/SnapKit",
            from: "6.0.0"
        ),
        .package(
            url: "https://github.com/CombineCommunity/CombineCocoa.git",
            from: "0.4.1"
        ),
    ],
    targets: [
        .target(
            name: "DesignSystem",
            dependencies: [
                .product(name: "SnapKit", package: "SnapKit"),
                .product(name: "CombineCocoa", package: "CombineCocoa"),
            ],
            path: "Sources",
            resources: [.process("Resources")],
            swiftSettings: [.defaultIsolation(.none)]
        ),
    ],
    swiftLanguageModes: [.v5]
)
