import Testing
import Foundation
@testable import SwiftGzip

@Suite struct UInt8Tests {
    @Test func isGzipped() async throws {
        try await inWorkingDir("uint8-is-gzipped") { _, zippedFileURL, unzippedFileURL in
            let zippedData = try Data(contentsOf: zippedFileURL)
            let unzippedData = try Data(contentsOf: unzippedFileURL)
            let zippedBytes = zippedData.withUnsafeBytes { buffer in
                let baseAddress = buffer.bindMemory(to: UInt8.self).baseAddress
                let bufferPointer = UnsafeBufferPointer(start: baseAddress, count: zippedData.count)
                return [UInt8](bufferPointer)
            }
            let unzippedBytes = unzippedData.withUnsafeBytes { buffer in
                let baseAddress = buffer.bindMemory(to: UInt8.self).baseAddress
                let bufferPointer = UnsafeBufferPointer(start: baseAddress, count: zippedData.count)
                return [UInt8](bufferPointer)
            }
            #expect(zippedBytes.isGzipped)
            #expect(unzippedBytes.isGzipped == false)
        }
    }
}
