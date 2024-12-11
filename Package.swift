// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "StikSource",
    platforms: [
        .iOS(.v15),         // iOS support
        .macOS(.v12)        // macOS support (macOS 12 Monterey and above)
    ],
    products: [
        .library(name: "StikSource", targets: ["StikSource"]),
    ],
    dependencies: [],
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
