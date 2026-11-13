// © 2025–2026 John Gary Pusey (see LICENSE.md)

@testable import IvorTiming
import Testing
import XestiNumbers
import XestiTools

struct TempoMapTransformTests {
}

// MARK: -

extension TempoMapTransformTests {
    @Test
    func augment_entryIDsRestrictsAffectedEntries() throws {
        var map = TempoMap()
        let t120 = Tempo(120)

        let entryID1 = map.insert(beatTime: 0, tempo: .default).entryID

        map.insert(beatTime: 4, tempo: t120)

        try map.augment(by: Number(2), entryIDs: [entryID1])

        var beatTimes: [BeatTime] = []

        for entry in map {
            beatTimes.append(entry.beatTime)
        }

        #expect(beatTimes.sorted() == [0, 4])
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
    func augment_invalidFactor() {
        var map = TempoMap()

        #expect(throws: TempoMap.Error.self) {
            try map.augment(by: Number(0))
        }
    }

    @Test
    func augment_nilAnchorWithEntryIDsUsesSelectedRange() throws {
        var map = TempoMap()
        let t120 = Tempo(120)
        let t140 = Tempo(140)

        map.insert(beatTime: 0, tempo: .default)

        let entryID10 = map.insert(beatTime: 10, tempo: t120).entryID
        let entryID14 = map.insert(beatTime: 14, tempo: t140).entryID

        try map.augment(by: Number(2), entryIDs: [entryID10, entryID14])

        var beatTime10: BeatTime?
        var beatTime14: BeatTime?

        for entry in map {
            if entry.entryID == entryID10 {
                beatTime10 = entry.beatTime
            }

            if entry.entryID == entryID14 {
                beatTime14 = entry.beatTime
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
    func augment_scalesBeatTimes() throws {
        var map = TempoMap()
        let t120 = Tempo(120)
        let t140 = Tempo(140)

        map.insert(beatTime: 1, tempo: t120)
        map.insert(beatTime: 3, tempo: t140)

        try map.augment(by: Number(2))

        var beatTimes: [BeatTime] = []

        for entry in map {
            beatTimes.append(entry.beatTime)
        }

        #expect(beatTimes.sorted() == [1, 5])
    }

    @Test
    func augment_validAnchorDoesNotThrow() throws {
        var map = TempoMap()

        map.insert(beatTime: 2, tempo: .default)

        try map.augment(by: Number(2), anchor: 2)

        var beatTimes: [BeatTime] = []

        for entry in map {
            beatTimes.append(entry.beatTime)
        }

        #expect(beatTimes == [2])
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
        let t120 = Tempo(120)
        let t140 = Tempo(140)

        map.insert(beatTime: 2, tempo: t120)
        map.insert(beatTime: 6, tempo: t140)

        try map.diminish(by: Number(2))

        var beatTimes: [BeatTime] = []

        for entry in map {
            beatTimes.append(entry.beatTime)
        }

        #expect(beatTimes.sorted() == [2, 4])
    }

    @Test
    func move_entryIDsRestrictsAffectedEntries() throws {
        var map = TempoMap()
        let t120 = Tempo(120)

        let entryID1 = map.insert(beatTime: 0, tempo: .default).entryID

        map.insert(beatTime: 4, tempo: t120)

        let directedDuration = try #require(BeatTime(0).duration(to: 2))

        try map.move(by: directedDuration, entryIDs: [entryID1])

        var beatTimes: [BeatTime] = []

        for entry in map {
            beatTimes.append(entry.beatTime)
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

        for entry in map {
            beatTimes.append(entry.beatTime)
        }

        #expect(beatTimes == [2])
    }

    @Test
    func quantize_entryIDsRestrictsAffectedEntries() throws {
        var map = TempoMap()
        let t120 = Tempo(120)
        let t140 = Tempo(140)

        let entryID1 = map.insert(beatTime: BeatTime(0.49), tempo: t120).entryID
        let entryID2 = map.insert(beatTime: BeatTime(4.49), tempo: t140).entryID

        let quantizer = try BeatQuantizer(factors: [1])

        map.quantize(using: quantizer, entryIDs: [entryID1])

        var beatTimesByID: [TempoMap.EntryID: BeatTime] = [:]

        for entry in map {
            beatTimesByID[entry.entryID] = entry.beatTime
        }

        #expect(beatTimesByID[entryID1] == 0)
        #expect(beatTimesByID[entryID2] == BeatTime(4.49))
    }

    @Test
    func quantize_snapsBeatTimesToGrid() throws {
        var map = TempoMap()
        let t120 = Tempo(120)
        let t140 = Tempo(140)

        map.insert(beatTime: BeatTime(0.49), tempo: t120)
        map.insert(beatTime: BeatTime(3.6), tempo: t140)

        let quantizer = try BeatQuantizer(factors: [1])

        map.quantize(using: quantizer)

        var beatTimes: [BeatTime] = []

        for entry in map {
            beatTimes.append(entry.beatTime)
        }

        #expect(beatTimes.sorted() == [0, 4])
    }

    @Test
    func reverse_entryIDsSelectionIsSelfContained() throws {
        var map = TempoMap()
        let t120 = Tempo(120)
        let t140 = Tempo(140)

        map.insert(beatTime: 0, tempo: .default)

        let phraseID1 = map.insert(beatTime: 10, tempo: t120).entryID
        let phraseID2 = map.insert(beatTime: 12, tempo: t140).entryID

        map.insert(beatTime: 20, tempo: .default)

        try map.reverse(entryIDs: [phraseID1, phraseID2])

        var phraseBeatTimes: [BeatTime] = []

        for entry in map {
            if entry.entryID == phraseID1 || entry.entryID == phraseID2 {
                phraseBeatTimes.append(entry.beatTime)
            }
        }

        //
        // Mirrored around its own bounds (10...12), not the whole map's (0...20), so
        // the phrase lands back within its own span rather than somewhere else
        // entirely:
        //
        #expect(phraseBeatTimes.sorted() == [10, 12])

        var allBeatTimes: [BeatTime] = []

        for entry in map {
            allBeatTimes.append(entry.beatTime)
        }

        //
        // The entries outside the selection are untouched:
        //
        #expect(allBeatTimes.sorted() == [0, 10, 12, 20])
    }

    @Test
    func reverse_invalidAnchorThrows() throws {
        var map = TempoMap()
        let t120 = Tempo(120)

        map.insert(beatTime: 0, tempo: .default)
        map.insert(beatTime: 2, tempo: t120)

        #expect(throws: TempoMap.Error.invalidAnchor) {
            try map.reverse(within: BeatTime(1)...3)
        }
    }

    @Test
    func reverse_mirrorsBeatTimes() throws {
        var map = TempoMap()
        let t120 = Tempo(120)

        map.insert(beatTime: 0, tempo: .default)
        map.insert(beatTime: 2, tempo: t120)

        try map.reverse()

        var beatTimes: [BeatTime] = []

        for entry in map {
            beatTimes.append(entry.beatTime)
        }

        #expect(beatTimes.sorted() == [0, 2])
    }

    @Test
    func reverse_rampPlaysAsForwardRamp() throws {
        //
        // A reversed accelerando is a ritardando, played with the same curve as one written
        // forwards: 60→120 over 0–4, reversed, must read at every beat exactly like 120→60
        // over 0–4. It is deliberately *not* the original curve run backwards in time.
        //
        let t60 = Tempo(60)
        let t120 = Tempo(120)

        var reversed = TempoMap()

        reversed.insert(beatTime: 0, tempo: t60)
        reversed.insert(beatTime: 4, tempo: t120)

        try reversed.reverse()

        var forward = TempoMap()

        forward.insert(beatTime: 0, tempo: t120)
        forward.insert(beatTime: 4, tempo: t60)

        let beatTimes: [BeatTime] = [0, 1, 2, 3, 4]

        #expect(beatTimes.map { reversed[$0] } == beatTimes.map { forward[$0] })

        //
        // The ritardando eases in, as the accelerando did: 105 at beat 2, not the 75 that the
        // original curve run backwards would give.
        //
        #expect(reversed[2] == Tempo(105))
    }

    @Test
    func reverse_stepPairReversesWithItsSegments() throws {
        //
        // A step is two entries at the same beat time: the old tempo, then the new
        // one (the last entry at a beat time wins). Reversing 60 for 0–4, 120 for
        // 4–8 must give 120 for 0–4, 60 for 4–8: the pair at 4 swaps order, and
        // both segments stay flat rather than turning into ramps.
        //
        let t60 = Tempo(60)
        let t120 = Tempo(120)

        var map = TempoMap()

        map.insert(beatTime: 0, tempo: t60)
        map.insert(beatTime: 4, tempo: t60)
        map.insert(beatTime: 4, tempo: t120)
        map.insert(beatTime: 8, tempo: t120)

        try map.reverse()

        var beatTimes: [BeatTime] = []
        var tempos: [Tempo] = []

        for entry in map {
            beatTimes.append(entry.beatTime)
            tempos.append(entry.tempo)
        }

        #expect(beatTimes == [0, 4, 4, 8])
        #expect(tempos == [t120, t120, t60, t60])
        #expect(map[2] == t120)
        #expect(map[4] == t60)
        #expect(map[6] == t60)
    }

    @Test
    func reverse_validAnchorDoesNotThrow() throws {
        var map = TempoMap()
        let t120 = Tempo(120)

        map.insert(beatTime: 0, tempo: .default)
        map.insert(beatTime: 2, tempo: t120)

        try map.reverse(within: BeatTime(0)...2)

        var beatTimes: [BeatTime] = []

        for entry in map {
            beatTimes.append(entry.beatTime)
        }

        #expect(beatTimes.sorted() == [0, 2])
    }

    @Test
    func scaleUnits_anchorAtZero() {
        var tmap = TempoMap()

        tmap.insert(beatTime: BeatTime(0), tempo: Tempo(240, unit: dur(1, 8)))
        tmap.insert(beatTime: BeatTime(1), tempo: Tempo(120, unit: dur(1, 8)))

        tmap.scaleUnits(by: 2, from: .zero)

        #expect(tmap.map(\.beatTime) == [BeatTime(0), BeatTime(1)])
        #expect(tmap.map(\.tempo) == [Tempo(240), Tempo(120)])
    }

    @Test
    func scaleUnits_anchorBeforeFirstEntry() {
        var tmap = TempoMap()

        tmap.insert(beatTime: BeatTime(2), tempo: Tempo(120))

        let before = TimeConverter(tempoMap: tmap)

        tmap.scaleUnits(by: 2, from: BeatTime(1))

        // The unscaled entry at the anchor keeps ♩ = 120 governing everything before it.
        #expect(tmap.map(\.beatTime) == [BeatTime(1), BeatTime(1), BeatTime(2)])
        #expect(tmap.map(\.tempo) == [Tempo(120), Tempo(120, unit: dur(1, 2)), Tempo(120, unit: dur(1, 2))])

        let after = TimeConverter(tempoMap: tmap)

        #expect(after.wallTime(at: beat(1, 2)) == before.wallTime(at: beat(1, 2)))
        #expect(after.wallTime(at: BeatTime(1)) == WallTime(2_000_000))
        #expect(after.wallTime(at: BeatTime(2)) == WallTime(3_000_000))
    }

    @Test
    func scaleUnits_anchorInsideRamp() {
        var tmap = TempoMap()

        tmap.insert(beatTime: BeatTime(0), tempo: Tempo(60))
        tmap.insert(beatTime: BeatTime(2), tempo: Tempo(120))

        let rampBefore = tmap[beat(1, 2)]
        let wallBefore = TimeConverter(tempoMap: tmap).wallTime(at: BeatTime(1))

        tmap.scaleUnits(by: 2, from: BeatTime(1))

        // Halfway through the ramp, the speed is ♩ = 75: kept, then stepped to 𝅗 = 75.
        #expect(tmap.map(\.beatTime) == [BeatTime(0), BeatTime(1), BeatTime(1), BeatTime(2)])
        #expect(tmap.map(\.tempo) == [Tempo(60), Tempo(75), Tempo(75, unit: dur(1, 2)), Tempo(120, unit: dur(1, 2))])

        // The first half of the ramp keeps its exact shape.
        #expect(tmap[beat(1, 2)] == rampBefore)

        let wallAfter = TimeConverter(tempoMap: tmap).wallTime(at: BeatTime(1))

        #expect(abs(wallAfter.doubleValue - wallBefore.doubleValue) < 0.000002)
    }

    @Test
    func scaleUnits_diminish() {
        var tmap = TempoMap()

        tmap.insert(beatTime: BeatTime(0), tempo: dottedQuarter(90))

        tmap.scaleUnits(by: frac(1, 3), from: .zero)

        #expect(tmap.map(\.tempo) == [Tempo(90, unit: dur(1, 8))])
    }

    @Test
    func scaleUnits_emptyMap() {
        var tmap = TempoMap()

        tmap.scaleUnits(by: 2, from: .zero)

        #expect(tmap.map(\.beatTime) == [BeatTime(0)])
        #expect(tmap.map(\.tempo) == [Tempo(60, unit: dur(1, 2))])
    }

    @Test
    func scaleUnits_emptyMap_anchorAfterZero() {
        var tmap = TempoMap(defaultTempo: Tempo(120))

        tmap.scaleUnits(by: 2, from: BeatTime(1))

        #expect(tmap.map(\.beatTime) == [BeatTime(1), BeatTime(1)])
        #expect(tmap.map(\.tempo) == [Tempo(120), Tempo(120, unit: dur(1, 2))])

        let tconv = TimeConverter(tempoMap: tmap)

        #expect(tconv.wallTime(at: BeatTime(1)) == WallTime(2_000_000))
        #expect(tconv.wallTime(at: BeatTime(3)) == WallTime(4_000_000))
    }

    @Test
    func scaleUnits_entryAtAnchor() {
        var tmap = TempoMap()

        tmap.insert(beatTime: BeatTime(0), tempo: Tempo(60))

        let (entryID, _) = tmap.insert(beatTime: BeatTime(1), tempo: Tempo(60), extras: extras())

        tmap.scaleUnits(by: 2, from: BeatTime(1))

        // Without the unscaled copy, [0, 1) would ramp from 15 to 30 whole notes per minute.
        #expect(tmap.map(\.beatTime) == [BeatTime(0), BeatTime(1), BeatTime(1)])
        #expect(tmap.map(\.tempo) == [Tempo(60), Tempo(60), Tempo(60, unit: dur(1, 2))])
        #expect(tmap[beat(1, 2)] == Tempo(60))

        // The original entry keeps its identity and extras; the inserted copy has none.
        let scaled = tmap[tmap.index(tmap.startIndex, offsetBy: 2)]

        #expect(scaled.entryID == entryID)
        #expect(scaled.extras == extras())
        #expect(tmap[tmap.index(after: tmap.startIndex)].extras == nil)
    }

    @Test
    func scaleUnits_factorOneIsNoOp() {
        var tmap = TempoMap()

        tmap.insert(beatTime: BeatTime(1), tempo: Tempo(60))

        let original = tmap

        tmap.scaleUnits(by: 1, from: beat(1, 2))

        #expect(tmap == original)
    }

    @Test
    func scaleUnits_keepsSoundAfterAugment() throws {
        var tmap = TempoMap()

        tmap.insert(beatTime: BeatTime(0), tempo: Tempo(240, unit: dur(1, 8)))
        tmap.insert(beatTime: beat(3, 8), tempo: Tempo(120, unit: dur(1, 8)))

        let before = TimeConverter(tempoMap: tmap)

        try tmap.augment(by: 2, anchor: .zero)
        tmap.scaleUnits(by: 2, from: .zero)

        let after = TimeConverter(tempoMap: tmap)

        // METER_TABLE.md 1.6: 3/8 at ♪ = 240, × 2 → 3/4 at ♩ = 240.
        #expect(tmap.first?.tempo == Tempo(240))
        #expect(abs(after.wallTime(at: beat(3, 4)).doubleValue - before.wallTime(at: beat(3, 8)).doubleValue) < 0.000002)
        #expect(abs(after.wallTime(at: beat(3, 2)).doubleValue - before.wallTime(at: beat(3, 4)).doubleValue) < 0.000002)
    }
}
