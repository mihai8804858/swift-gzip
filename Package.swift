// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "swift-gzip",
    platforms: [
        .iOS(.v14),
        .macOS(.v12),
        .macCatalyst(.v14),
        .tvOS(.v14),
        .visionOS(.v1),
        .watchOS(.v8)
    ],
    products: [
        .library(name: "SwiftGzip", targets: ["SwiftGzip"])
    ],
    targets: [
        .target(
            name: "SwiftGzip",
            dependencies: [.target(name: "CZlib", condition: .when(platforms: [.linux]))],
            path: "Sources",
            resources: [.copy("Resources/PrivacyInfo.xcprivacy")],
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")],
            linkerSettings: [.linkedLibrary("z", .when(platforms: [.iOS, .macOS, .macCatalyst, .tvOS, .visionOS, .watchOS]))]
        ),
        .testTarget(
            name: "SwiftGzipTests",
            dependencies: [.target(name: "SwiftGzip")],
            resources: [
                .copy("Resources/test.png"),
                .copy("Resources/test.png.gz")
            ]
        ),
        .systemLibrary(
            name: "CZlib",
            path: "Sources/CZlib"
        )
    ],
    swiftLanguageModes: [.v6]
)
