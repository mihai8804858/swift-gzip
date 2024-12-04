// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "swift-gzip",
    platforms: [
        .iOS(.v15),
        .tvOS(.v15),
        .visionOS(.v1),
        .macOS(.v12),
        .macCatalyst(.v15),
        .watchOS(.v8)
    ],
    products: [
        .library(name: "SwiftGzip", targets: ["SwiftGzip"])
    ],
    targets: [
        .target(
            name: "SwiftGzip",
            resources: [.copy("Resources/PrivacyInfo.xcprivacy")],
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")],
            linkerSettings: [.linkedLibrary("z")]
        ),
        .testTarget(
            name: "SwiftGzipTests",
            dependencies: [.target(name: "SwiftGzip")],
            resources: [
                .copy("Resources/test.png"),
                .copy("Resources/test.png.gz")
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)
