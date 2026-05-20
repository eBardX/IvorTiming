// © 2026 John Gary Pusey (see LICENSE.md)

private import XestiNumbers
private import XestiTools

/// A type that converts between beat time and wall time.
///
/// Create a `TimeConverter` from a ``TempoMap`` and use it to convert times.
/// The converter captures the tempo map\xe2\x80\x99s state at the moment of creation and
/// is unaffected by subsequent changes to the source map.
public struct TimeConverter {

    // MARK: Public Initializers

    /// Creates a time converter from the given tempo map.
    ///
    /// - Parameter tempoMap:   The tempo map to snapshot.
    public init(_ tempoMap: TempoMap) {
        self.defaultTempo = tempoMap.defaultTempo
        self.entries = tempoMap.entries.map {
            Entry(beatTime: $0.beatTime,
                  tempo: $0.tempo)
        }

        updateDerivedProperties()
    }

    // MARK: Internal Instance Properties

    internal var entries: [Entry]

    // MARK: Private Instance Properties

    private let defaultTempo: Tempo
}

// MARK: -

extension TimeConverter {

    // MARK: Public Instance Methods

    /// Returns the beat time corresponding to the given wall time.
    ///
    /// - Parameter wallTime:   The wall time to convert.
    ///
    /// - Returns:  The ``BeatTime`` corresponding to `wallTime`.
    public func beatTime(at wallTime: WallTime) -> BeatTime {
        guard !entries.isEmpty
        else { return BeatTime(wallTime.numberValue * (defaultTempo.numberValue / Tempo.default.numberValue)) }

        if wallTime < entries[0].wallTime {
            return BeatTime(wallTime.numberValue * entries[0].tempo.numberValue / Tempo.default.numberValue)
        }

        let entry = entries[floorIndex(for: wallTime)]
        let tempoChange = entry.tempoChange
        let wallFraction = (wallTime - entry.wallTime).numberValue / entry.wallDuration.numberValue

        if tempoChange < 0 {
            let scale = sqrt(-tempoChange / entry.tempo.numberValue)
            let fraction = tanh(wallFraction * atanh(scale)) / scale

            return entry.beatTime + entry.beatDuration * fraction
        }

        if tempoChange > 0 {
            let scale = sqrt(tempoChange / entry.tempo.numberValue)
            let fraction = tan(wallFraction * atan(scale)) / scale

            return entry.beatTime + entry.beatDuration * fraction
        }

        return entry.beatTime + entry.beatDuration * wallFraction
    }

    /// Returns the wall time corresponding to the given beat time.
    ///
    /// - Parameter beatTime:   The beat time to convert.
    ///
    /// - Returns:  The ``WallTime`` corresponding to `beatTime`.
    public func wallTime(at beatTime: BeatTime) -> WallTime {
        guard !entries.isEmpty
        else { return WallTime(beatTime.numberValue * (Tempo.default.numberValue / defaultTempo.numberValue)) }

        if beatTime < entries[0].beatTime {
            return WallTime(beatTime.numberValue * Tempo.default.numberValue / entries[0].tempo.numberValue)
        }

        let entry = entries[floorIndex(for: beatTime)]
        let tempoChange = entry.tempoChange
        let beatFraction = (beatTime - entry.beatTime).numberValue / entry.beatDuration.numberValue

        if tempoChange < 0 {
            let scale = sqrt(-tempoChange / entry.tempo.numberValue)
            let fraction = atanh(beatFraction * scale) / atanh(scale)

            return entry.wallTime + entry.wallDuration * fraction
        }

        if tempoChange > 0 {
            let scale = sqrt(tempoChange / entry.tempo.numberValue)
            let fraction = atan(beatFraction * scale) / atan(scale)

            return entry.wallTime + entry.wallDuration * fraction
        }

        return entry.wallTime + entry.wallDuration * beatFraction
    }
}

// MARK: - Sendable

extension TimeConverter: Sendable {
}
