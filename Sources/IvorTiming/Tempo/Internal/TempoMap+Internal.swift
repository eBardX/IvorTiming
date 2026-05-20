// © 2025–2026 John Gary Pusey (see LICENSE.md)

internal import XestiTools

extension TempoMap {

    // MARK: Internal Type Methods

    internal static func hasExtras(in entries: [Entry]) -> Bool {
        entries.contains { $0.extras != nil }
    }

    // MARK: Internal Instance Methods

    internal func firstIndex(beatTime: BeatTime,
                             tempo: Tempo,
                             extras: Extras?) -> Int? {
        entries.firstIndex {
            (beatTime, tempo, extras) == ($0.beatTime, $0.tempo, $0.extras)
        }
    }

    internal func insertionIndex(for beatTime: BeatTime) -> Int {
        entries.firstIndex { beatTime < $0.beatTime } ?? entries.endIndex
    }
}
