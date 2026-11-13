# ``IvorTiming``

@Metadata {
    @PageColor(blue)
}

Musical time, duration, and tempo types.

## Overview

The IvorTiming framework provides musical time, duration, and tempo types
written in Swift. Both beat-based (measured in whole notes) and wall-clock
representations of time and duration are supported, along with tempo-based
types for converting between the two and a quantizer for snapping beat times to
rhythmic grid points.

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

See <doc:UsingIvorTiming> for a full guide to times and durations, tempo maps,
conversion, quantization, and error handling.

## Topics

### Guides

- <doc:UsingIvorTiming>

### Time

- ``BeatTime``
- ``WallTime``
- ``TimeProtocol``
- ``TimeBasis``
- ``TimeDirection``

### Duration

- ``BeatDuration``
- ``WallDuration``
- ``DirectedDuration``
- ``DurationProtocol``

### Tempo

- ``Tempo``
- ``TempoMap``
- ``TimeConverter``

### Quantization

- ``BeatQuantizer``

### Errors

- ``ParseError``
