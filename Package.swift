// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SwiftModalPicker",
    platforms: [
        .iOS(.v9),
        .tvOS(.v9),
        .watchOS(.v2),
        .macOS(.v10_10)
    ],
    products: [
        .library(
            name: "SwiftModalPicker",
            targets: ["SwiftModalPicker"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftModalPicker",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "SwiftModalPickerTests",
            dependencies: ["SwiftModalPicker"],
            path: "Tests"
        ),
    ]
)
