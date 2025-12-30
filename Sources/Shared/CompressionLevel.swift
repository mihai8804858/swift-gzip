#if os(Linux)
import CZlib
#else
import zlib
#endif

public enum CompressionLevel: Hashable, Sendable {
    case noCompression
    case defaultCompression
    case bestSpeed
    case bestCompression

    var zlibLevel: Int32 {
        switch self {
        case .noCompression: return Z_NO_COMPRESSION
        case .defaultCompression: return Z_DEFAULT_COMPRESSION
        case .bestSpeed: return Z_BEST_SPEED
        case .bestCompression: return Z_BEST_COMPRESSION
        }
    }
}
