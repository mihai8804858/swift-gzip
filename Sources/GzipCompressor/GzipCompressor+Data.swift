import Foundation
import zlib

extension GzipCompressor {
    /// Asynchronously compress `data` using `zlib`.
    ///
    /// - Parameter data: Data to compress.
    ///
    /// - Returns: Gzip-compressed `Data` instance.
    /// - Throws: `GzipError`
    public func zip(data: Data) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            do {
                let data = try zip(data: data)
                continuation.resume(returning: data)
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }

    /// Compress `data` using `zlib`.
    ///
    /// - Parameter data: Data to compress.
    ///
    /// - Returns: Gzip-compressed `Data` instance.
    /// - Throws: `GzipError`
    public func zip(data: Data) throws -> Data {
        let input = InputStream(data: data)
        let output = OutputStream(toMemory: ())
        try zip(inputStream: input, outputStream: output)
        guard let outputData = output.property(forKey: .dataWrittenToMemoryStreamKey) as? Data else {
            throw GzipError(kind: .stream, message: "Cannot read data from output stream")
        }

        return outputData
    }
}
