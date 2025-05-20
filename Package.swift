// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "swift-gzip",
    platforms: [
        .iOS(.v14),
        .tvOS(.v14),
        .visionOS(.v1),
        .macOS(.v12),
        .macCatalyst(.v14),
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
    swiftLanguageModes: [.v6]
)
