import XCTest
import Foundation
@testable import SwiftGzip

final class GzipCompressorTests: XCTestCase {
    func testZipURL() async throws {
        try await inWorkingDir("zip-url") { workDir, zippedURL, unzippedURL in
            let outputURL = workDir.appendingPathComponent("output.png.gz")
            try GzipCompressor().zip(inputURL: unzippedURL, outputURL: outputURL)
            let outputData = try Data(contentsOf: outputURL) as NSData
            let expectedData = try Data(contentsOf: zippedURL) as NSData
            XCTAssert(outputData.isEqual(to: expectedData))
        }
    }

    func testZipURLAsync() async throws {
        try await inWorkingDir("zip-url-async") { workDir, zippedURL, unzippedURL in
            let outputURL = workDir.appendingPathComponent("output.png.gz")
            try await GzipCompressor().zip(inputURL: unzippedURL, outputURL: outputURL)
            let outputData = try Data(contentsOf: outputURL) as NSData
            let expectedData = try Data(contentsOf: zippedURL) as NSData
            XCTAssert(outputData.isEqual(to: expectedData))
        }
    }

    func testZipStream() async throws {
        try await inWorkingDir("zip-stream") { workDir, zippedURL, unzippedURL in
            let outputURL = workDir.appendingPathComponent("output.png.gz")
            let inputStream = try XCTUnwrap(InputStream(fileAtPath: unzippedURL.path))
            let outputStream = try XCTUnwrap(OutputStream(toFileAtPath: outputURL.path, append: false))
            try GzipCompressor().zip(inputStream: inputStream, outputStream: outputStream)
            let outputData = try Data(contentsOf: outputURL) as NSData
            let expectedData = try Data(contentsOf: zippedURL) as NSData
            XCTAssert(outputData.isEqual(to: expectedData))
        }
    }

    func testZipStreamAsync() async throws {
        try await inWorkingDir("zip-stream-async") { workDir, zippedURL, unzippedURL in
            let outputURL = workDir.appendingPathComponent("output.png.gz")
            let inputStream = try XCTUnwrap(InputStream(fileAtPath: unzippedURL.path))
            let outputStream = try XCTUnwrap(OutputStream(toFileAtPath: outputURL.path, append: false))
            try await GzipCompressor().zip(inputStream: inputStream, outputStream: outputStream)
            let outputData = try Data(contentsOf: outputURL) as NSData
            let expectedData = try Data(contentsOf: zippedURL) as NSData
            XCTAssert(outputData.isEqual(to: expectedData))
        }
    }

    func testZipData() async throws {
        try await inWorkingDir("zip-data") { _, zippedURL, unzippedURL in
            let inputData = try Data(contentsOf: unzippedURL)
            let outputData = try GzipCompressor().zip(data: inputData)
            let expectedData = try Data(contentsOf: zippedURL) as NSData
            XCTAssert((outputData as NSData).isEqual(to: expectedData))
        }
    }

    func testZipDataAsync() async throws {
        try await inWorkingDir("zip-data-async") { _, zippedURL, unzippedURL in
            let inputData = try Data(contentsOf: unzippedURL)
            let outputData = try await GzipCompressor().zip(data: inputData)
            let expectedData = try Data(contentsOf: zippedURL) as NSData
            XCTAssert((outputData as NSData).isEqual(to: expectedData))
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
            let outputBytes = try GzipCompressor().zip(bytes: inputBytes)
            let expectedData = try Data(contentsOf: zippedURL)
            let expectedBytes = expectedData.withUnsafeBytes { buffer in
                let baseAddress = buffer.bindMemory(to: UInt8.self).baseAddress
                let bufferPointer = UnsafeBufferPointer(start: baseAddress, count: expectedData.count)
                return [UInt8](bufferPointer)
            }
            XCTAssert(outputBytes == expectedBytes)
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
            let expectedData = try Data(contentsOf: zippedURL)
            let expectedBytes = expectedData.withUnsafeBytes { buffer in
                let baseAddress = buffer.bindMemory(to: UInt8.self).baseAddress
                let bufferPointer = UnsafeBufferPointer(start: baseAddress, count: expectedData.count)
                return [UInt8](bufferPointer)
            }
            XCTAssert(outputBytes == expectedBytes)
        }
    }
}
