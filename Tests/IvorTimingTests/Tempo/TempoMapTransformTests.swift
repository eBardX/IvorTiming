// © 2025–2026 John Gary Pusey (see LICENSE.md)

@testable import IvorTiming
import Testing
import XestiNumbers

struct TempoMapTransformTests {
}

// MARK: -

extension TempoMapTransformTests {
    @Test
    func augment_invalidFactor() {
        var map = TempoMap()

        #expect(throws: TempoMap.Error.self) {
            try map.augment(by: Number(0))
        }
    }

    @Test
    func augment_scalesBeatTimes() throws {
        var map = TempoMap()
        let t120 = try #require(Tempo(uintValue: 120))
        let t140 = try #require(Tempo(uintValue: 140))

        map.insert(beatTime: 1, tempo: t120)
        map.insert(beatTime: 3, tempo: t140)

        try map.augment(by: Number(2))

        var beatTimes: [BeatTime] = []

        map.forEach { _, beatTime, _, _ in
            beatTimes.append(beatTime)
        }

        #expect(beatTimes.sorted() == [1, 5])
    }

    @Test
    func diminish_invalidFactor() {
        var map = TempoMap()

        #expect(throws: TempoMap.Error.self) {
            try map.diminish(by: Number(0))
        }
    }

    @Test
    func diminish_scalesBeatTimes() throws {
        var map = TempoMap()
        let t120 = try #require(Tempo(uintValue: 120))
        let t140 = try #require(Tempo(uintValue: 140))

        map.insert(beatTime: 2, tempo: t120)
        map.insert(beatTime: 6, tempo: t140)

        try map.diminish(by: Number(2))

        var beatTimes: [BeatTime] = []

        map.forEach { _, beatTime, _, _ in
            beatTimes.append(beatTime)
        }

        #expect(beatTimes.sorted() == [2, 4])
    }

    @Test
    func move_shiftsBeatTimes() throws {
        var map = TempoMap()

        map.insert(beatTime: 0, tempo: .default)

        let directedDuration = try #require(BeatTime(0).duration(to: 2))

        try map.move(by: directedDuration)

        var beatTimes: [BeatTime] = []

        map.forEach { _, beatTime, _, _ in
            beatTimes.append(beatTime)
        }

        #expect(beatTimes == [2])
    }

    @Test
    func reverse_mirrorsBeatTimes() throws {
        var map = TempoMap()
        let t120 = try #require(Tempo(uintValue: 120))

        map.insert(beatTime: 0, tempo: .default)
        map.insert(beatTime: 2, tempo: t120)

        try map.reverse()

        var beatTimes: [BeatTime] = []

        map.forEach { _, beatTime, _, _ in
            beatTimes.append(beatTime)
        }

        #expect(beatTimes.sorted() == [0, 2])
    }

    @Test
    func augment_invalidAnchorThrows() {
        var map = TempoMap()

        map.insert(beatTime: 2, tempo: .default)

        #expect(throws: TempoMap.Error.invalidAnchor) {
            try map.augment(by: Number(2), anchor: 3)
        }
    }

    @Test
    func augment_validAnchorDoesNotThrow() throws {
        var map = TempoMap()

        map.insert(beatTime: 2, tempo: .default)

        try map.augment(by: Number(2), anchor: 2)

        var beatTimes: [BeatTime] = []

        map.forEach { _, beatTime, _, _ in
            beatTimes.append(beatTime)
        }

        #expect(beatTimes == [2])
    }

    @Test
    func augment_entryIDsRestrictsAffectedEntries() throws {
        var map = TempoMap()
        let t120 = try #require(Tempo(uintValue: 120))

        let entryID1 = map.insert(beatTime: 0, tempo: .default).entryID

        map.insert(beatTime: 4, tempo: t120)

        try map.augment(by: Number(2), entryIDs: [entryID1])

        var beatTimes: [BeatTime] = []

        map.forEach { _, beatTime, _, _ in
            beatTimes.append(beatTime)
        }

        #expect(beatTimes.sorted() == [0, 4])
    }

    @Test
    func augment_nilAnchorWithEntryIDsUsesSelectedRange() throws {
        var map = TempoMap()
        let t120 = try #require(Tempo(uintValue: 120))
        let t140 = try #require(Tempo(uintValue: 140))

        map.insert(beatTime: 0, tempo: .default)

        let entryID10 = map.insert(beatTime: 10, tempo: t120).entryID
        let entryID14 = map.insert(beatTime: 14, tempo: t140).entryID

        try map.augment(by: Number(2), entryIDs: [entryID10, entryID14])

        var beatTime10: BeatTime?
        var beatTime14: BeatTime?

        map.forEach { entryID, beatTime, _, _ in
            if entryID == entryID10 {
                beatTime10 = beatTime
            }

            if entryID == entryID14 {
                beatTime14 = beatTime
            }
        }

        //
        // Anchored to the selected entries' own low bound (10), not the whole map's
        // (0), so the selected entry at 10 stays put while the one at 14 stretches
        // relative to it:
        //
        #expect(beatTime10 == 10)
        #expect(beatTime14 == 18)
    }

    @Test
    func reverse_invalidAnchorThrows() throws {
        var map = TempoMap()
        let t120 = try #require(Tempo(uintValue: 120))

        map.insert(beatTime: 0, tempo: .default)
        map.insert(beatTime: 2, tempo: t120)

        #expect(throws: TempoMap.Error.invalidAnchor) {
            try map.reverse(within: BeatTime(1)...3)
        }
    }

    @Test
    func reverse_validAnchorDoesNotThrow() throws {
        var map = TempoMap()
        let t120 = try #require(Tempo(uintValue: 120))

        map.insert(beatTime: 0, tempo: .default)
        map.insert(beatTime: 2, tempo: t120)

        try map.reverse(within: BeatTime(0)...2)

        var beatTimes: [BeatTime] = []

        map.forEach { _, beatTime, _, _ in
            beatTimes.append(beatTime)
        }

        #expect(beatTimes.sorted() == [0, 2])
    }

    @Test
    func reverse_entryIDsSelectionIsSelfContained() throws {
        var map = TempoMap()
        let t120 = try #require(Tempo(uintValue: 120))
        let t140 = try #require(Tempo(uintValue: 140))

        map.insert(beatTime: 0, tempo: .default)

        let phraseID1 = map.insert(beatTime: 10, tempo: t120).entryID
        let phraseID2 = map.insert(beatTime: 12, tempo: t140).entryID

        map.insert(beatTime: 20, tempo: .default)

        try map.reverse(entryIDs: [phraseID1, phraseID2])

        var phraseBeatTimes: [BeatTime] = []

        map.forEach { entryID, beatTime, _, _ in
            if entryID == phraseID1 || entryID == phraseID2 {
                phraseBeatTimes.append(beatTime)
            }
        }

        //
        // Mirrored around its own bounds (10...12), not the whole map's (0...20), so
        // the phrase lands back within its own span rather than somewhere else
        // entirely:
        //
        #expect(phraseBeatTimes.sorted() == [10, 12])

        var allBeatTimes: [BeatTime] = []

        map.forEach { _, beatTime, _, _ in
            allBeatTimes.append(beatTime)
        }

        //
        // The entries outside the selection are untouched:
        //
        #expect(allBeatTimes.sorted() == [0, 10, 12, 20])
    }

    @Test
    func move_entryIDsRestrictsAffectedEntries() throws {
        var map = TempoMap()
        let t120 = try #require(Tempo(uintValue: 120))

        let entryID1 = map.insert(beatTime: 0, tempo: .default).entryID

        map.insert(beatTime: 4, tempo: t120)

        let directedDuration = try #require(BeatTime(0).duration(to: 2))

        try map.move(by: directedDuration, entryIDs: [entryID1])

        var beatTimes: [BeatTime] = []

        map.forEach { _, beatTime, _, _ in
            beatTimes.append(beatTime)
        }

        #expect(beatTimes.sorted() == [2, 4])
    }
}
