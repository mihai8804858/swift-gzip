import Foundation
import Testing
@testable import SwiftGzip

@Suite struct UInt8Tests {
    @Test func isGzipped() async throws {
        try await inWorkingDir("uint8-is-gzipped") { _, zippedFileURL, unzippedFileURL in
            let zippedBytes = [UInt8](try Data(contentsOf: zippedFileURL))
            let unzippedBytes = [UInt8](try Data(contentsOf: unzippedFileURL))
            #expect(zippedBytes.isGzipped)
            #expect(!unzippedBytes.isGzipped)
        }
    }
}
