import Foundation
import Testing
@testable import SwiftGzip

@Suite struct GzipDecompressorTests {
    @Test func unzipURL() async throws {
        try await inWorkingDir("unzip-url") { workDir, zippedURL, unzippedURL in
            let outputURL = workDir.appendingPathComponent("output.png")
            try GzipDecompressor().unzip(inputURL: zippedURL, outputURL: outputURL)
            let outputData = try Data(contentsOf: outputURL)
            let expectedData = try Data(contentsOf: unzippedURL)
            #expect(outputData == expectedData)
        }
    }

    @Test func unzipURLAsync() async throws {
        try await inWorkingDir("unzip-url-async") { workDir, zippedURL, unzippedURL in
            let outputURL = workDir.appendingPathComponent("output.png")
            try await GzipDecompressor().unzip(inputURL: zippedURL, outputURL: outputURL)
            let outputData = try Data(contentsOf: outputURL)
            let expectedData = try Data(contentsOf: unzippedURL)
            #expect(outputData == expectedData)
        }
    }

    @Test func unzipStream() async throws {
        try await inWorkingDir("unzip-stream") { workDir, zippedURL, unzippedURL in
            let outputURL = workDir.appendingPathComponent("output.png")
            let inputStream = try #require(InputStream(fileAtPath: zippedURL.path))
            let outputStream = try #require(OutputStream(toFileAtPath: outputURL.path, append: false))
            try GzipDecompressor().unzip(inputStream: inputStream, outputStream: outputStream)
            let outputData = try Data(contentsOf: outputURL)
            let expectedData = try Data(contentsOf: unzippedURL)
            #expect(outputData == expectedData)
        }
    }

    @Test func unzipStreamAsync() async throws {
        try await inWorkingDir("unzip-stream-async") { workDir, zippedURL, unzippedURL in
            let outputURL = workDir.appendingPathComponent("output.png")
            let inputStream = try #require(InputStream(fileAtPath: zippedURL.path))
            let outputStream = try #require(OutputStream(toFileAtPath: outputURL.path, append: false))
            try await GzipDecompressor().unzip(inputStream: inputStream, outputStream: outputStream)
            let outputData = try Data(contentsOf: outputURL)
            let expectedData = try Data(contentsOf: unzippedURL)
            #expect(outputData == expectedData)
        }
    }

    @Test func unzipData() async throws {
        try await inWorkingDir("unzip-data") { _, zippedURL, unzippedURL in
            let inputData = try Data(contentsOf: zippedURL)
            let outputData = try GzipDecompressor().unzip(data: inputData)
            let expectedData = try Data(contentsOf: unzippedURL)
            #expect(outputData == expectedData)
        }
    }

    @Test func unzipDataAsync() async throws {
        try await inWorkingDir("unzip-data-async") { _, zippedURL, unzippedURL in
            let inputData = try Data(contentsOf: zippedURL)
            let outputData = try await GzipDecompressor().unzip(data: inputData)
            let expectedData = try Data(contentsOf: unzippedURL)
            #expect(outputData == expectedData)
        }
    }

    @Test func unzipBytes() async throws {
        try await inWorkingDir("unzip-bytes") { _, zippedURL, unzippedURL in
            let inputBytes = [UInt8](try Data(contentsOf: zippedURL))
            let outputBytes = try GzipDecompressor().unzip(bytes: inputBytes)
            let expectedBytes = [UInt8](try Data(contentsOf: unzippedURL))
            #expect(outputBytes == expectedBytes)
        }
    }

    @Test func unzipBytesAsync() async throws {
        try await inWorkingDir("unzip-bytes-async") { _, zippedURL, unzippedURL in
            let inputBytes = [UInt8](try Data(contentsOf: zippedURL))
            let outputBytes = try await GzipDecompressor().unzip(bytes: inputBytes)
            let expectedBytes = [UInt8](try Data(contentsOf: unzippedURL))
            #expect(outputBytes == expectedBytes)
        }
    }
}
