// © 2026 John Gary Pusey (see LICENSE.md)

internal import XestiNumbers
internal import XestiTools

extension TimeConverter {

    // MARK: Internal Nested Types

    internal struct Entry {

        // MARK: Internal Initializers

        internal init(beatTime: BeatTime,
                      tempo: Tempo) {
            self.beatDuration = 0
            self.beatTime = beatTime
            self.tempo = tempo
            self.tempoChange = 0
            self.wallDuration = 0
            self.wallTime = 0
        }

        // MARK: Internal Instance Properties

        internal let beatTime: BeatTime
        internal let tempo: Tempo

        internal var beatDuration: BeatDuration
        internal var tempoChange: Number
        internal var wallDuration: WallDuration
        internal var wallTime: WallTime
    }
}

// MARK: - Sendable

extension TimeConverter.Entry: Sendable {
}
