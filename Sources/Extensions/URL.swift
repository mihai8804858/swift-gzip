import Foundation

extension URL {
    /// Whether the file at this `URL` is compressed in gzip format.
    public var isGzipped: Bool {
        guard let stream = InputStream(url: self) else { return false }
        stream.open()
        defer { stream.close() }
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: GzipConstants.magicNumber.count)
        defer { buffer.deallocate() }
        let read = stream.read(buffer, maxLength: GzipConstants.magicNumber.count)
        if read < 0 {
            debugPrint(stream.streamError.map { "\($0)" } ?? "Failure reading input stream")
            return false
        } else {
            return Data(bytes: buffer, count: read).isGzipped
        }
    }
}
