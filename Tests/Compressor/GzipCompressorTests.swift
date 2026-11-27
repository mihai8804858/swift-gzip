import Foundation
import Testing
@testable import SwiftGzip

@Suite struct GzipCompressorTests {
    // Don't compare gzip bytes directly: gzip output isn't guaranteed to be byte-identical
    // across platforms/zlib builds (header fields, Huffman encoding choices, etc.).
    // Instead, round-trip through the decompressor and compare with the original.

    @Test func zipURL() async throws {
        try await inWorkingDir("zip-url") { workDir, _, unzippedURL in
            let outputURL = workDir.appendingPathComponent("output.png.gz")
            try await GzipCompressor().zip(inputURL: unzippedURL, outputURL: outputURL)
            let outputData = try Data(contentsOf: outputURL)
            let unzippedOutput: Data = try await GzipDecompressor().unzip(data: outputData)
            let expectedUnzipped = try Data(contentsOf: unzippedURL)
            #expect(unzippedOutput == expectedUnzipped)
        }
    }

    @Test func zipURLAsync() async throws {
        try await inWorkingDir("zip-url-async") { workDir, _, unzippedURL in
            let outputURL = workDir.appendingPathComponent("output.png.gz")
            try await GzipCompressor().zip(inputURL: unzippedURL, outputURL: outputURL)
            let outputData = try Data(contentsOf: outputURL)
            let unzippedOutput: Data = try await GzipDecompressor().unzip(data: outputData)
            let expectedUnzipped = try Data(contentsOf: unzippedURL)
            #expect(unzippedOutput == expectedUnzipped)
        }
    }

    @Test func zipStream() async throws {
        try await inWorkingDir("zip-stream") { workDir, _, unzippedURL in
            let outputURL = workDir.appendingPathComponent("output.png.gz")
            let inputStream = try #require(InputStream(fileAtPath: unzippedURL.path))
            let outputStream = try #require(OutputStream(toFileAtPath: outputURL.path, append: false))
            try await GzipCompressor().zip(inputStream: inputStream, outputStream: outputStream)
            let outputData = try Data(contentsOf: outputURL)
            let unzippedOutput: Data = try await GzipDecompressor().unzip(data: outputData)
            let expectedUnzipped = try Data(contentsOf: unzippedURL)
            #expect(unzippedOutput == expectedUnzipped)
        }
    }

    @Test func zipStreamAsync() async throws {
        try await inWorkingDir("zip-stream-async") { workDir, _, unzippedURL in
            let outputURL = workDir.appendingPathComponent("output.png.gz")
            let inputStream = try #require(InputStream(fileAtPath: unzippedURL.path))
            let outputStream = try #require(OutputStream(toFileAtPath: outputURL.path, append: false))
            try await GzipCompressor().zip(inputStream: inputStream, outputStream: outputStream)
            let outputData = try Data(contentsOf: outputURL)
            let unzippedOutput: Data = try await GzipDecompressor().unzip(data: outputData)
            let expectedUnzipped = try Data(contentsOf: unzippedURL)
            #expect(unzippedOutput == expectedUnzipped)
        }
    }

    @Test func zipData() async throws {
        try await inWorkingDir("zip-data") { _, _, unzippedURL in
            let inputData = try Data(contentsOf: unzippedURL)
            let outputData = try await GzipCompressor().zip(data: inputData)
            let unzippedOutput = try await GzipDecompressor().unzip(data: outputData)
            #expect(unzippedOutput == inputData)
        }
    }

    @Test func zipDataAsync() async throws {
        try await inWorkingDir("zip-data-async") { _, _, unzippedURL in
            let inputData = try Data(contentsOf: unzippedURL)
            let outputData = try await GzipCompressor().zip(data: inputData)
            let unzippedOutput = try await GzipDecompressor().unzip(data: outputData)
            #expect(unzippedOutput == inputData)
        }
    }

    @Test func zipBytes() async throws {
        try await inWorkingDir("zip-bytes") { _, _, unzippedURL in
            let inputData = try Data(contentsOf: unzippedURL)
            let outputBytes = try await GzipCompressor().zip(bytes: [UInt8](inputData))
            let unzippedOutput = try await GzipDecompressor().unzip(data: Data(outputBytes))
            #expect(unzippedOutput == inputData)
        }
    }

    @Test func zipBytesAsync() async throws {
        try await inWorkingDir("zip-bytes-async") { _, _, unzippedURL in
            let inputData = try Data(contentsOf: unzippedURL)
            let outputBytes = try await GzipCompressor().zip(bytes: [UInt8](inputData))
            let unzippedOutput = try await GzipDecompressor().unzip(data: Data(outputBytes))
            #expect(unzippedOutput == inputData)
        }
    }
}
