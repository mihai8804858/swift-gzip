import Foundation
#if os(Linux)
import CZlib
#else
import zlib
#endif

extension GzipDecompressor {
    /// Asynchronously decompress file at `inputURL` using `zlib` and save decompressed file at `outputURL`.
    ///
    /// - Parameter inputURL: Path of file to decompress.
    /// - Parameter outputURL: Path where to save the decompressed file.
    ///
    /// - Throws: `GzipError`
    public func unzip(inputURL: URL, outputURL: URL) async throws {
        try await withCheckedThrowingContinuation { continuation in
            do {
                try unzip(inputURL: inputURL, outputURL: outputURL)
                continuation.resume()
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }

    /// Decompress file at `inputURL` using `zlib` and save decompressed file at `outputURL`.
    ///
    /// - Parameter inputURL: Path of file to decompress.
    /// - Parameter outputURL: Path where to save the decompressed file.
    ///
    /// - Throws: `GzipError`
    public func unzip(inputURL: URL, outputURL: URL) throws {
        guard let input = InputStream(fileAtPath: inputURL.path) else {
            throw GzipError(kind: .stream, message: "Could not open input file stream")
        }
        guard let output = OutputStream(toFileAtPath: outputURL.path, append: false) else {
            throw GzipError(kind: .stream, message: "Could not open output file stream")
        }
        try unzip(inputStream: input, outputStream: output)
    }
}
