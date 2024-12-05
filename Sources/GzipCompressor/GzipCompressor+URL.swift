import Foundation
import zlib

extension GzipCompressor {
    /// Asynchronously compress file at `inputURL` using `zlib` and save compressed file at `outputURL`.
    ///
    /// - Parameter inputURL: Path of file to compress.
    /// - Parameter outputURL: Path where to save the compressed file.
    ///
    /// - Throws: `GzipError`
    public func zip(inputURL: URL, outputURL: URL) async throws {
        try await withCheckedThrowingContinuation { continuation in
            do {
                try zip(inputURL: inputURL, outputURL: outputURL)
                continuation.resume()
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }

    /// Compress file at `inputURL` using `zlib` and save compressed file at `outputURL`.
    ///
    /// - Parameter inputURL: Path of file to compress.
    /// - Parameter outputURL: Path where to save the compressed file.
    ///
    /// - Throws: `GzipError`
    public func zip(inputURL: URL, outputURL: URL) throws {
        guard let input = InputStream(fileAtPath: inputURL.path) else {
            throw GzipError(kind: .stream, message: "Could not open input file stream")
        }
        guard let output = OutputStream(toFileAtPath: outputURL.path, append: false) else {
            throw GzipError(kind: .stream, message: "Could not open output file stream")
        }
        try zip(inputStream: input, outputStream: output)
    }
}
