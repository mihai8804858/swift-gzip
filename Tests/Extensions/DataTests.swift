import Testing
import Foundation
@testable import SwiftGzip

@Suite struct DataTests {
    @Test func isGzipped() async throws {
        try await inWorkingDir("data-is-gzipped") { _, zippedFileURL, unzippedFileURL in
            let zippedData = try Data(contentsOf: zippedFileURL)
            let unzippedData = try Data(contentsOf: unzippedFileURL)
            #expect(zippedData.isGzipped)
            #expect(unzippedData.isGzipped == false)
        }
    }
}
