public struct GzipCompressor: Sendable {
    public let level: CompressionLevel
    public let wBits: Int32

    /// Create a new `GzipCompressor` instance.
    ///
    /// The `wBits` parameter allows for managing the size of the history buffer. The possible values are:
    ///
    ///     Value       Window size logarithm    Input
    ///     +9 to +15   Base 2                   Includes zlib header and trailer
    ///     -9 to -15   Absolute value of wbits  No header and trailer
    ///     +25 to +31  Low 4 bits of the value  Includes gzip header and trailing checksum
    ///
    /// - Parameter level: Compression level.
    /// - Parameter wBits: Manage the size of the history buffer.
    public init(level: CompressionLevel = .defaultCompression, wBits: Int32 = GzipConstants.maxWindowBits + 16) {
        self.level = level
        self.wBits = wBits
    }
}
