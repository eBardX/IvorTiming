# IvorTiming

Musical time, duration, and tempo types.

[![Swift 6.3](https://img.shields.io/badge/Swift-6.3-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/platforms-iOS%20%7C%20macOS-lightgrey.svg)](https://developer.apple.com)
[![SwiftPM](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/eBardX/IvorTiming/blob/main/LICENSE.md)

* [Overview](#overview)
* [Requirements](#requirements)
* [Installation](#installation)
    * [Swift Package Manager](#spm_installation)
* [Quick Start](#quick_start)
* [Documentation](#documentation)
* [Reference Documentation](#reference_documentation)
* [Credits](#credits)
* [License](#license)

## <a name="overview">Overview</a>

The IvorTiming framework provides musical time, duration, and tempo types
written in Swift. Both beat-based (measured in whole notes) and wall-clock
representations of time and duration are supported, along with tempo-based
types for converting between the two and a quantizer for snapping beat times to
rhythmic grid points.

## <a name="requirements">Requirements</a>

* iOS 18.0+ / macOS 15.0+
* Swift 6.3 toolchain
* Swift 6 language mode

## <a name="installation">Installation</a>

### <a name="spm_installation">Swift Package Manager</a>

IvorTiming is distributed exclusively through the [Swift Package Manager][spm].

To add IvorTiming to a Swift package, add it to the `dependencies` in your
`Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/eBardX/IvorTiming.git",
             .upToNextMinor(from: "0.18.0"))
]
```

Then add `IvorTiming` to the dependencies of any target that uses it:

```swift
.target(name: "MyTarget",
        dependencies: [.product(name: "IvorTiming",
                                package: "IvorTiming")])
```

To add IvorTiming to an Xcode project, choose **File ▸ Add Package
Dependencies…** and enter the repository URL:

```
https://github.com/eBardX/IvorTiming.git
```

IvorTiming depends on [XestiNumbers][xestinumbers] and
[XestiTools][xestitools]; the Swift Package Manager resolves them
automatically.

## <a name="quick_start">Quick Start</a>

Build a tempo map, convert between beat time and wall time, and quantize a
beat time:

```swift
import IvorTiming

var tempoMap = TempoMap()

tempoMap.insert(beatTime: 0, tempo: Tempo(120))     // ♩ = 120
tempoMap.insert(beatTime: 2, tempo: Tempo(60))      // slow to ♩ = 60 over two whole notes

tempoMap[1].plain                           // "1/4=105" (♩ = 105)

let converter = TimeConverter(tempoMap: tempoMap)

converter.wallTime(at: 1).plain             // "2.090202" (seconds)
converter.beatTime(at: WallTime(doubleValue: 2)!).plain    // "0.96" (whole notes)

let quantizer = try BeatQuantizer(factors: [16, 12])

quantizer.quantize(BeatTime(plain: "0.33")!).plain  // "0 1/3"
```

For the complete story — times and durations, arithmetic, editing and
transforming tempo maps, and error handling — see the [usage guide][guide].

## <a name="documentation">Documentation</a>

* [Using IvorTiming][guide] — a guide to using the public API, published as
  part of the DocC documentation.
* Every public declaration carries a DocC comment.

## <a name="reference_documentation">Reference Documentation</a>

Full [reference documentation][refdoc] is available courtesy of [DocC][docc].

## <a name="credits">Credits</a>

John Gary Pusey (ebardx@gmail.com)

## <a name="license">License</a>

IvorTiming is available under [the MIT license][license].

[docc]:          https://www.swift.org/documentation/docc/
[guide]:         https://eBardX.github.io/ivor-packages-docs/documentation/ivortiming/usingivortiming
[license]:       https://github.com/eBardX/IvorTiming/blob/main/LICENSE.md
[refdoc]:        https://eBardX.github.io/ivor-packages-docs/documentation/ivortiming
[spm]:           https://swift.org/package-manager/
[xestinumbers]:  https://github.com/eBardX/XestiNumbers
[xestitools]:    https://github.com/eBardX/XestiTools
