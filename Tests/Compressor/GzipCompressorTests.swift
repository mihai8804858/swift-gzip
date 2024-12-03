import Testing
import Foundation
@testable import SwiftGzip

@Suite struct GzipCompressorTests {
    @Test func zipURL() async throws {
        try await inWorkingDir("zip-url") { workDir, zippedURL, unzippedURL in
            let outputURL = workDir.appendingPathComponent("output.png.gz")
            try GzipCompressor().zip(inputURL: unzippedURL, outputURL: outputURL)
            let outputData = try Data(contentsOf: outputURL) as NSData
            let expectedData = try Data(contentsOf: zippedURL) as NSData
            #expect(outputData.isEqual(to: expectedData))
        }
    }

    @Test func zipURLAsync() async throws {
        try await inWorkingDir("zip-url-async") { workDir, zippedURL, unzippedURL in
            let outputURL = workDir.appendingPathComponent("output.png.gz")
            try await GzipCompressor().zip(inputURL: unzippedURL, outputURL: outputURL)
            let outputData = try Data(contentsOf: outputURL) as NSData
            let expectedData = try Data(contentsOf: zippedURL) as NSData
            #expect(outputData.isEqual(to: expectedData))
        }
    }

    @Test func zipStream() async throws {
        try await inWorkingDir("zip-stream") { workDir, zippedURL, unzippedURL in
            let outputURL = workDir.appendingPathComponent("output.png.gz")
            let inputStream = try #require(InputStream(fileAtPath: unzippedURL.path))
            let outputStream = try #require(OutputStream(toFileAtPath: outputURL.path, append: false))
            try GzipCompressor().zip(inputStream: inputStream, outputStream: outputStream)
            let outputData = try Data(contentsOf: outputURL) as NSData
            let expectedData = try Data(contentsOf: zippedURL) as NSData
            #expect(outputData.isEqual(to: expectedData))
        }
    }

    @Test func zipStreamAsync() async throws {
        try await inWorkingDir("zip-stream-async") { workDir, zippedURL, unzippedURL in
            let outputURL = workDir.appendingPathComponent("output.png.gz")
            let inputStream = try #require(InputStream(fileAtPath: unzippedURL.path))
            let outputStream = try #require(OutputStream(toFileAtPath: outputURL.path, append: false))
            try await GzipCompressor().zip(inputStream: inputStream, outputStream: outputStream)
            let outputData = try Data(contentsOf: outputURL) as NSData
            let expectedData = try Data(contentsOf: zippedURL) as NSData
            #expect(outputData.isEqual(to: expectedData))
        }
    }

    @Test func zipData() async throws {
        try await inWorkingDir("zip-data") { _, zippedURL, unzippedURL in
            let inputData = try Data(contentsOf: unzippedURL)
            let outputData = try GzipCompressor().zip(data: inputData)
            let expectedData = try Data(contentsOf: zippedURL) as NSData
            #expect((outputData as NSData).isEqual(to: expectedData))
        }
    }

    @Test func zipDataAsync() async throws {
        try await inWorkingDir("zip-data-async") { _, zippedURL, unzippedURL in
            let inputData = try Data(contentsOf: unzippedURL)
            let outputData = try await GzipCompressor().zip(data: inputData)
            let expectedData = try Data(contentsOf: zippedURL) as NSData
            #expect((outputData as NSData).isEqual(to: expectedData))
        }
    }

    @Test func zipBytes() async throws {
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
            #expect(outputBytes == expectedBytes)
        }
    }

    @Test func zipBytesAsync() async throws {
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
            #expect(outputBytes == expectedBytes)
        }
    }
}
