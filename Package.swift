// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SwiftModalPicker",
    platforms: [
        .iOS(.v11)
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
