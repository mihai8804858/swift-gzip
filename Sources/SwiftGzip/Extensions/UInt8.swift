extension [UInt8] {
    /// Whether the bytes are compressed in gzip format.
    public var isGzipped: Bool {
        return starts(with: GzipConstants.magicNumber)
    }
}
