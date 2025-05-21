# SwiftGzip

`SwiftGzip` is a framework that enables compressing / decompressing data, files and streams using `zlib`.

The framework uses `InputStream` and `OutputStream` for compression / decompression without the need to copy the whole data in memory. At most, the framework will allocate only 2 buffers of `256 kb` each for processing.

[![CI](https://github.com/mihai8804858/swift-gzip/actions/workflows/ci.yml/badge.svg)](https://github.com/mihai8804858/swift-gzip/actions/workflows/ci.yml) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmihai8804858%2Fswift-gzip%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/mihai8804858/swift-gzip) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmihai8804858%2Fswift-gzip%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/mihai8804858/swift-gzip)

## Installation

You can add `swift-gzip` to an Xcode project by adding it to your project as a package.

> https://github.com/mihai8804858/swift-gzip

If you want to use `swift-gzip` in a [SwiftPM](https://swift.org/package-manager/) project, it's as simple as adding it to your `Package.swift`:

``` swift
dependencies: [
    .package(url: "https://github.com/mihai8804858/swift-gzip", branch: "main")
]
```

And then adding the product to any target that needs access to the library:

```swift
.product(name: "SwiftGzip", package: "swift-gzip")
```

## Quick Start

Just import `SwiftGzip` in your project to access the API:

```swift
import SwiftGzip
```

* `isGzipped`

Verify if given `Data`, `[UInt8]` or `URL` is compressed in gzip format:
```swift
[UInt8](...).isGzipped
Data(...).isGzipped
URL(...).isGzipped
```

* `zip`

```swift
let compressor = GzipCompressor(level: .bestCompression)

// Compress `Data`
let zipped = try await compressor.zip(data: data)

// Compress `[UInt8]`
let zipped = try await compressor.zip(bytes: bytes)

// Compress file
let inputURL = URL(...)
let outputURL = URL(...)
try await compressor.zip(inputURL: inputURL, outputURL: outputURL)

// Compress data stream
let inputStream = InputStream(...)
let outputStream = OutputStream(...)
try await compressor.zip(inputStream: inputStream, outputStream: outputStream)
```

* `unzip`

```swift
let decompressor = GzipDecompressor()

// Decompress `Data`
let unzipped = try await compressor.unzip(data: data)

// Decompress `[UInt8]`
let unzipped = try await compressor.unzip(bytes: bytes)

// Decompress file
let inputURL = URL(...)
let outputURL = URL(...)
try await compressor.unzip(inputURL: inputURL, outputURL: outputURL)

// Decompress data stream
let inputStream = InputStream(...)
let outputStream = OutputStream(...)
try await compressor.unzip(inputStream: inputStream, outputStream: outputStream)
```

## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.
