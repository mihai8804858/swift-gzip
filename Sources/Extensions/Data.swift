import Foundation

extension Data {
    /// Whether the data is compressed in gzip format.
    public var isGzipped: Bool {
        starts(with: GzipConstants.magicNumber)
    }
}
