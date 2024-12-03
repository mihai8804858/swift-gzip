import zlib

public enum CompressionLevel: Hashable, Sendable {
    case noCompression
    case defaultCompression
    case bestSpeed
    case bestCompression

    var zlibLevel: Int32 {
        switch self {
        case .noCompression: Z_NO_COMPRESSION
        case .defaultCompression: Z_DEFAULT_COMPRESSION
        case .bestSpeed: Z_BEST_SPEED
        case .bestCompression: Z_BEST_COMPRESSION
        }
    }
}
