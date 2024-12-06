import XCTest
import Foundation
@testable import SwiftGzip

final class GzipDecompressorTests: XCTestCase {
    func testUnzipURL() async throws {
        try await inWorkingDir("unzip-url") { workDir, zippedURL, unzippedURL in
            let outputURL = workDir.appendingPathComponent("output.png")
            try GzipDecompressor().unzip(inputURL: zippedURL, outputURL: outputURL)
            let outputData = try Data(contentsOf: outputURL) as NSData
            let expectedData = try Data(contentsOf: unzippedURL) as NSData
            XCTAssert(outputData.isEqual(to: expectedData))
        }
    }

    func testUnzipURLAsync() async throws {
        try await inWorkingDir("unzip-url-async") { workDir, zippedURL, unzippedURL in
            let outputURL = workDir.appendingPathComponent("output.png")
            try await GzipDecompressor().unzip(inputURL: zippedURL, outputURL: outputURL)
            let outputData = try Data(contentsOf: outputURL) as NSData
            let expectedData = try Data(contentsOf: unzippedURL) as NSData
            XCTAssert(outputData.isEqual(to: expectedData))
        }
    }

    func testUnzipStream() async throws {
        try await inWorkingDir("unzip-stream") { workDir, zippedURL, unzippedURL in
            let outputURL = workDir.appendingPathComponent("output.png")
            let inputStream = try XCTUnwrap(InputStream(fileAtPath: zippedURL.path))
            let outputStream = try XCTUnwrap(OutputStream(toFileAtPath: outputURL.path, append: false))
            try GzipDecompressor().unzip(inputStream: inputStream, outputStream: outputStream)
            let outputData = try Data(contentsOf: outputURL) as NSData
            let expectedData = try Data(contentsOf: unzippedURL) as NSData
            XCTAssert(outputData.isEqual(to: expectedData))
        }
    }

    func testUnzipStreamAsync() async throws {
        try await inWorkingDir("unzip-stream-async") { workDir, zippedURL, unzippedURL in
            let outputURL = workDir.appendingPathComponent("output.png")
            let inputStream = try XCTUnwrap(InputStream(fileAtPath: zippedURL.path))
            let outputStream = try XCTUnwrap(OutputStream(toFileAtPath: outputURL.path, append: false))
            try await GzipDecompressor().unzip(inputStream: inputStream, outputStream: outputStream)
            let outputData = try Data(contentsOf: outputURL) as NSData
            let expectedData = try Data(contentsOf: unzippedURL) as NSData
            XCTAssert(outputData.isEqual(to: expectedData))
        }
    }

    func testUnzipData() async throws {
        try await inWorkingDir("unzip-data") { _, zippedURL, unzippedURL in
            let inputData = try Data(contentsOf: zippedURL)
            let outputData = try GzipDecompressor().unzip(data: inputData)
            let expectedData = try Data(contentsOf: unzippedURL) as NSData
            XCTAssert((outputData as NSData).isEqual(to: expectedData))
        }
    }

    func testUnzipDataAsync() async throws {
        try await inWorkingDir("unzip-data-async") { _, zippedURL, unzippedURL in
            let inputData = try Data(contentsOf: zippedURL)
            let outputData = try await GzipDecompressor().unzip(data: inputData)
            let expectedData = try Data(contentsOf: unzippedURL) as NSData
            XCTAssert((outputData as NSData).isEqual(to: expectedData))
        }
    }

    func testUnzipBytes() async throws {
        try await inWorkingDir("unzip-bytes") { _, zippedURL, unzippedURL in
            let inputData = try Data(contentsOf: zippedURL)
            let inputBytes = inputData.withUnsafeBytes { buffer in
                let baseAddress = buffer.bindMemory(to: UInt8.self).baseAddress
                let bufferPointer = UnsafeBufferPointer(start: baseAddress, count: inputData.count)
                return [UInt8](bufferPointer)
            }
            let outputBytes = try GzipDecompressor().unzip(bytes: inputBytes)
            let expectedData = try Data(contentsOf: unzippedURL)
            let expectedBytes = expectedData.withUnsafeBytes { buffer in
                let baseAddress = buffer.bindMemory(to: UInt8.self).baseAddress
                let bufferPointer = UnsafeBufferPointer(start: baseAddress, count: expectedData.count)
                return [UInt8](bufferPointer)
            }
            XCTAssert(outputBytes == expectedBytes)
        }
    }

    func testUnzipBytesAsync() async throws {
        try await inWorkingDir("unzip-bytes-async") { _, zippedURL, unzippedURL in
            let inputData = try Data(contentsOf: zippedURL)
            let inputBytes = inputData.withUnsafeBytes { buffer in
                let baseAddress = buffer.bindMemory(to: UInt8.self).baseAddress
                let bufferPointer = UnsafeBufferPointer(start: baseAddress, count: inputData.count)
                return [UInt8](bufferPointer)
            }
            let outputBytes = try await GzipDecompressor().unzip(bytes: inputBytes)
            let expectedData = try Data(contentsOf: unzippedURL)
            let expectedBytes = expectedData.withUnsafeBytes { buffer in
                let baseAddress = buffer.bindMemory(to: UInt8.self).baseAddress
                let bufferPointer = UnsafeBufferPointer(start: baseAddress, count: expectedData.count)
                return [UInt8](bufferPointer)
            }
            XCTAssert(outputBytes == expectedBytes)
        }
    }
}
