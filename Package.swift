// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "StikSource",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "StikSource",
            targets: ["StikSource"]
        ),
    ],
    targets: [
        .target(
            name: "StikSource",
            dependencies: []
        ),
        .testTarget(
            name: "StikSourceTests",
            dependencies: ["StikSource"]
        ),
    ]
)

