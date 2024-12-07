import Foundation
import XCTest

func inWorkingDir(
    _ name: String,
    work: (_ workDir: URL, _ zippedFileURL: URL, _ unzippedFileURL: URL) async throws -> Void
) async throws {
    let rootWorkDir = URL.tempDir.appendingPathComponent("swift-gzip-tests")
    let testWorkDir = rootWorkDir.appendingPathComponent(name)
    try remakeDir(at: testWorkDir)
    defer { try? FileManager.default.removeItem(at: testWorkDir) }
    let sourceZippedFileURL = try XCTUnwrap(Bundle.module.resourceURL?.appendingPathComponent("test.png.gz"))
    let sourceUnzippedFileURL = try XCTUnwrap(Bundle.module.resourceURL?.appendingPathComponent("test.png"))
    let destinationZippedFileURL = testWorkDir.appendingPathComponent("test.png.gz")
    let destinationUnzippedFileURL = testWorkDir.appendingPathComponent("test.png")
    try FileManager.default.copyItem(at: sourceZippedFileURL, to: destinationZippedFileURL)
    try FileManager.default.copyItem(at: sourceUnzippedFileURL, to: destinationUnzippedFileURL)
    try await work(testWorkDir, destinationZippedFileURL, destinationUnzippedFileURL)
}

func remakeDir(at url: URL) throws {
    if FileManager.default.fileExists(atPath: url.path) {
        try FileManager.default.removeItem(at: url)
    }
    try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
}

private extension URL {
    static var tempDir: URL {
        #if swift(>=5.9)
        if #available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, visionOS 1.0, *) {
            URL.temporaryDirectory
        } else {
            FileManager.default.temporaryDirectory
        }
        #else
        if #available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *) {
            URL.temporaryDirectory
        } else {
            FileManager.default.temporaryDirectory
        }
        #endif
    }
}
