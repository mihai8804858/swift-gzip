import XCTest
import Foundation
@testable import SwiftGzip

final class GzipCompressorTests: XCTestCase {
    func testZipURL() async throws {
        try await inWorkingDir("zip-url") { workDir, zippedURL, unzippedURL in
            let decompressor = GzipDecompressor()
            let outputURL = workDir.appendingPathComponent("output.png.gz")
            try await GzipCompressor().zip(inputURL: unzippedURL, outputURL: outputURL)
            let outputData = try Data(contentsOf: outputURL)
            // Don't compare gzip bytes directly: gzip output isn't guaranteed to be byte-identical
            // across platforms/zlib builds (header fields, Huffman encoding choices, etc.).
            let unzippedOutput: Data = try await decompressor.unzip(data: outputData)
            let expectedUnzipped = try Data(contentsOf: unzippedURL)
            XCTAssertEqual(unzippedOutput, expectedUnzipped)
        }
    }

    func testZipURLAsync() async throws {
        try await inWorkingDir("zip-url-async") { workDir, zippedURL, unzippedURL in
            let decompressor = GzipDecompressor()
            let outputURL = workDir.appendingPathComponent("output.png.gz")
            try await GzipCompressor().zip(inputURL: unzippedURL, outputURL: outputURL)
            let outputData = try Data(contentsOf: outputURL)
            let unzippedOutput: Data = try await decompressor.unzip(data: outputData)
            let expectedUnzipped = try Data(contentsOf: unzippedURL)
            XCTAssertEqual(unzippedOutput, expectedUnzipped)
        }
    }

    func testZipStream() async throws {
        try await inWorkingDir("zip-stream") { workDir, zippedURL, unzippedURL in
            let decompressor = GzipDecompressor()
            let outputURL = workDir.appendingPathComponent("output.png.gz")
            let inputStream = try XCTUnwrap(InputStream(fileAtPath: unzippedURL.path))
            let outputStream = try XCTUnwrap(OutputStream(toFileAtPath: outputURL.path, append: false))
            try await GzipCompressor().zip(inputStream: inputStream, outputStream: outputStream)
            let outputData = try Data(contentsOf: outputURL)
            let unzippedOutput: Data = try await decompressor.unzip(data: outputData)
            let expectedUnzipped = try Data(contentsOf: unzippedURL)
            XCTAssertEqual(unzippedOutput, expectedUnzipped)
        }
    }

    func testZipStreamAsync() async throws {
        try await inWorkingDir("zip-stream-async") { workDir, zippedURL, unzippedURL in
            let decompressor = GzipDecompressor()
            let outputURL = workDir.appendingPathComponent("output.png.gz")
            let inputStream = try XCTUnwrap(InputStream(fileAtPath: unzippedURL.path))
            let outputStream = try XCTUnwrap(OutputStream(toFileAtPath: outputURL.path, append: false))
            try await GzipCompressor().zip(inputStream: inputStream, outputStream: outputStream)
            let outputData = try Data(contentsOf: outputURL)
            let unzippedOutput: Data = try await decompressor.unzip(data: outputData)
            let expectedUnzipped = try Data(contentsOf: unzippedURL)
            XCTAssertEqual(unzippedOutput, expectedUnzipped)
        }
    }

    func testZipData() async throws {
        try await inWorkingDir("zip-data") { _, zippedURL, unzippedURL in
            let inputData = try Data(contentsOf: unzippedURL)
            let outputData = try await GzipCompressor().zip(data: inputData)
            let unzippedOutput = try await GzipDecompressor().unzip(data: outputData)
            XCTAssertEqual(unzippedOutput, inputData)
        }
    }

    func testZipDataAsync() async throws {
        try await inWorkingDir("zip-data-async") { _, zippedURL, unzippedURL in
            let inputData = try Data(contentsOf: unzippedURL)
            let outputData = try await GzipCompressor().zip(data: inputData)
            let unzippedOutput = try await GzipDecompressor().unzip(data: outputData)
            XCTAssertEqual(unzippedOutput, inputData)
        }
    }

    func testZipBytes() async throws {
        try await inWorkingDir("zip-bytes") { _, zippedURL, unzippedURL in
            let inputData = try Data(contentsOf: unzippedURL)
            let inputBytes = inputData.withUnsafeBytes { buffer in
                let baseAddress = buffer.bindMemory(to: UInt8.self).baseAddress
                let bufferPointer = UnsafeBufferPointer(start: baseAddress, count: inputData.count)
                return [UInt8](bufferPointer)
            }
            let outputBytes = try await GzipCompressor().zip(bytes: inputBytes)
            let outputData = Data(outputBytes)
            let unzippedOutput = try await GzipDecompressor().unzip(data: outputData)
            XCTAssertEqual(unzippedOutput, inputData)
        }
    }

    func testZipBytesAsync() async throws {
        try await inWorkingDir("zip-bytes-async") { _, zippedURL, unzippedURL in
            let inputData = try Data(contentsOf: unzippedURL)
            let inputBytes = inputData.withUnsafeBytes { buffer in
                let baseAddress = buffer.bindMemory(to: UInt8.self).baseAddress
                let bufferPointer = UnsafeBufferPointer(start: baseAddress, count: inputData.count)
                return [UInt8](bufferPointer)
            }
            let outputBytes = try await GzipCompressor().zip(bytes: inputBytes)
            let outputData = Data(outputBytes)
            let unzippedOutput = try await GzipDecompressor().unzip(data: outputData)
            XCTAssertEqual(unzippedOutput, inputData)
        }
    }
}
