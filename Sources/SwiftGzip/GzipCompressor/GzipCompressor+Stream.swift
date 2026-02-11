import Foundation
#if os(Linux)
import CZlib
#else
import zlib
#endif

extension GzipCompressor {
    /// Asynchronously compress data from given `InputStream` using `zlib`
    /// and write compressed data to the `OutputStream`.
    ///
    /// - Parameter inputStream: Input stream from where to read the data for compression.
    /// - Parameter outputStream: Output stream where to write the compressed data.
    ///
    /// - Throws: `GzipError`
    public func zip(inputStream: InputStream, outputStream: OutputStream) async throws {
        try await withCheckedThrowingContinuation { continuation in
            do {
                try zip(inputStream: inputStream, outputStream: outputStream)
                continuation.resume()
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }

    /// Compress data from given `InputStream` using `zlib` and write compressed data to the `OutputStream`.
    ///
    /// - Parameter inputStream: Input stream from where to read the data for compression.
    /// - Parameter outputStream: Output stream where to write the compressed data.
    ///
    /// - Throws: `GzipError`
    public func zip(inputStream: InputStream, outputStream: OutputStream) throws {
        if inputStream.streamStatus == .notOpen { inputStream.open() }
        if outputStream.streamStatus == .notOpen { outputStream.open() }
        defer {
            inputStream.close()
            outputStream.close()
        }

        let inputBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(GzipConstants.chunkSize))
        let outputBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(GzipConstants.chunkSize))
        defer {
            inputBuffer.deallocate()
            outputBuffer.deallocate()
        }

        var stream = z_stream()
        var flush = Z_NO_FLUSH
        let initStatus = deflateInit2_(
            &stream,
            level.zlibLevel,
            Z_DEFLATED,
            Int32(wBits),
            MAX_MEM_LEVEL,
            Z_DEFAULT_STRATEGY,
            ZLIB_VERSION,
            Int32(GzipConstants.streamSize)
        )
        guard initStatus == Z_OK else {
            throw GzipError(code: initStatus, msg: stream.msg)
        }
        defer {
            deflateEnd(&stream)
        }

        repeat {
            let readBytes = inputStream.read(inputBuffer, maxLength: Int(GzipConstants.chunkSize))
            flush = inputStream.streamStatus == .atEnd ? Z_FINISH : Z_NO_FLUSH
            if readBytes < 0 {
                let message = inputStream.streamError.map { "\($0)" } ?? "Failure reading input stream"
                throw GzipError(kind: .stream, message: message)
            } else {
                stream.avail_in = UInt32(readBytes)
                stream.next_in = inputBuffer
                repeat {
                    stream.avail_out = GzipConstants.chunkSize
                    stream.next_out = outputBuffer
                    deflate(&stream, flush)
                    let have = GzipConstants.chunkSize - stream.avail_out
                    if have > 0, outputStream.write(outputBuffer, maxLength: Int(have)) < 0 {
                        let message = outputStream.streamError.map { "\($0)" } ?? "Failure writing to output stream"
                        throw GzipError(kind: .stream, message: message)
                    }
                } while stream.avail_out == 0
            }
        } while flush != Z_FINISH
    }
}
