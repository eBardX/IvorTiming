// © 2025–2026 John Gary Pusey (see LICENSE.md)

internal import XestiTools

extension TempoMap {

    // MARK: Internal Type Methods

    //
    // Keeps the first occurrence of each exact duplicate (same beat time, tempo, and
    // extras — `Entry`'s own `==` already excludes identity) and drops the rest,
    // matching the rule `insert(beatTime:tempo:extras:)` applies to a live tempo map.
    //
    internal static func deduplicated(_ entries: [Entry]) -> [Entry] {
        var result: [Entry] = []

        for entry in entries where !result.contains(entry) {
            result.append(entry)
        }

        return result
    }

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

    internal func firstIndex(entryID: EntryID) -> Int? {
        entries.firstIndex { $0.entryID == entryID }
    }

    internal func insertionIndex(for beatTime: BeatTime) -> Int {
        entries.firstIndex { beatTime < $0.beatTime } ?? entries.endIndex
    }
}
