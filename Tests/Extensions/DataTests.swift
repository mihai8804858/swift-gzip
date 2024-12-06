import XCTest
import Foundation
@testable import SwiftGzip

final class DataTests: XCTestCase {
    func testIsGzipped() async throws {
        try await inWorkingDir("data-is-gzipped") { _, zippedFileURL, unzippedFileURL in
            let zippedData = try Data(contentsOf: zippedFileURL)
            let unzippedData = try Data(contentsOf: unzippedFileURL)
            XCTAssert(zippedData.isGzipped)
            XCTAssertFalse(unzippedData.isGzipped)
        }
    }
}
