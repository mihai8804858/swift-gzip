import Foundation
#if os(Linux)
import CZlib
#else
import zlib
#endif

extension GzipCompressor {
    /// Asynchronously compress bytes (`[UInt8]`) using `zlib`.
    ///
    /// - Parameter bytes: Bytes to compress.
    ///
    /// - Returns: Gzip-compressed bytes (`[UInt8]`) instance.
    /// - Throws: `GzipError`
    public func zip(bytes: [UInt8]) async throws -> [UInt8] {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                let data = try zip(bytes: bytes)
                continuation.resume(returning: data)
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }

    /// Compress bytes (`[UInt8]`) using `zlib`.
    ///
    /// - Parameter bytes: Bytes to compress.
    ///
    /// - Returns: Gzip-compressed bytes (`[UInt8]`) instance.
    /// - Throws: `GzipError`
    public func zip(bytes: [UInt8]) throws -> [UInt8] {
        let unzippedData = Data(bytes)
        let input = InputStream(data: unzippedData)
        let output = OutputStream(toMemory: ())
        try zip(inputStream: input, outputStream: output)
        guard let outputData = output.property(forKey: .dataWrittenToMemoryStreamKey) as? Data else {
            throw GzipError(kind: .stream, message: "Cannot read data from output stream")
        }

        return [UInt8](outputData)
    }
}
