// swift-tools-version: 5.10

import PackageDescription

var targets: [PackageDescription.Target] = []

// Declare CZlib only on Linux.
#if os(Linux)
targets.append(
    .systemLibrary(
        name: "CZlib",
        path: "Sources/CZlib"
    )
)
#endif

var swiftGzipDependencies: [Target.Dependency] = []
#if os(Linux)
swiftGzipDependencies.append(.target(name: "CZlib"))
#endif

var swiftGzipLinkerSettings: [LinkerSetting] = []
#if !os(Linux)
// On Linux, CZlib's modulemap already links `-lz`.
swiftGzipLinkerSettings.append(.linkedLibrary("z"))
#endif

targets.append(
    .target(
        name: "SwiftGzip",
        dependencies: swiftGzipDependencies,
        path: "Sources",
        resources: [.copy("Resources/PrivacyInfo.xcprivacy")],
        swiftSettings: [.enableExperimentalFeature("StrictConcurrency")],
        linkerSettings: swiftGzipLinkerSettings
    )
)

targets.append(
    .testTarget(
        name: "SwiftGzipTests",
        dependencies: [.target(name: "SwiftGzip")],
        resources: [
            .copy("Resources/test.png"),
            .copy("Resources/test.png.gz")
        ]
    )
)

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
    targets: targets,
    swiftLanguageVersions: [.v5]
)
