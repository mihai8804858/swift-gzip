import Testing
import Foundation
@testable import SwiftGzip

@Suite struct URLTests {
    @Test func isGzipped() async throws {
        try await inWorkingDir("url-is-gzipped") { _, zippedFileURL, unzippedFileURL in
            #expect(zippedFileURL.isGzipped)
            #expect(unzippedFileURL.isGzipped == false)
        }
    }
}
