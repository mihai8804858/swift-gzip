import XCTest
import Foundation
@testable import SwiftGzip

final class URLTests: XCTestCase {
    func testIsGzipped() async throws {
        try await inWorkingDir("url-is-gzipped") { _, zippedFileURL, unzippedFileURL in
            XCTAssert(zippedFileURL.isGzipped)
            XCTAssertFalse(unzippedFileURL.isGzipped)
        }
    }
}
