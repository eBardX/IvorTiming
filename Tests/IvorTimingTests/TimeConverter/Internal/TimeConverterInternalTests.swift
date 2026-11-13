// © 2026 John Gary Pusey (see LICENSE.md)

@testable import IvorTiming
import Testing
import XestiNumbers
import XestiTools

struct TimeConverterInternalTests {
}

// MARK: -

extension TimeConverterInternalTests {
    @Test
    func floorIndex_forBeatTime() {
        let t120 = Tempo(120)
        var tmap = TempoMap()

        tmap.insert(beatTime: BeatTime(0), tempo: t120)
        tmap.insert(beatTime: beat(1, 2), tempo: t120)

        let tconv = TimeConverter(tempoMap: tmap)

        #expect(tconv.floorIndex(for: beat(1, 4)) == 0)
        #expect(tconv.floorIndex(for: beat(5, 4)) == 1)
    }

    @Test
    func floorIndex_forWallTime() {
        let t120 = Tempo(120)
        var tmap = TempoMap()

        tmap.insert(beatTime: BeatTime(0), tempo: t120)
        tmap.insert(beatTime: beat(1, 2), tempo: t120)

        let tconv = TimeConverter(tempoMap: tmap)

        #expect(tconv.floorIndex(for: WallTime(500_000)) == 0)
        #expect(tconv.floorIndex(for: WallTime(2_000_000)) == 1)
    }

    @Test
    func updateDerivedProperties_computesWallTimes() {
        let t120 = Tempo(120)
        var tmap = TempoMap()

        tmap.insert(beatTime: BeatTime(0), tempo: t120)
        tmap.insert(beatTime: beat(1, 2), tempo: t120)

        var tconv = TimeConverter(tempoMap: tmap)

        tconv.updateDerivedProperties()

        #expect(tconv.entries[0].wallTime == .zero)
        #expect(tconv.entries[0].wallDuration == WallDuration(1_000_000))
        #expect(tconv.entries[1].wallTime == WallTime(1_000_000))
    }

    @Test
    func updateDerivedProperties_decreasingTempo() {
        let t120 = Tempo(120)
        let t60  = Tempo(60)
        var tmap = TempoMap()

        tmap.insert(beatTime: BeatTime(0), tempo: t120)
        tmap.insert(beatTime: BeatTime(1), tempo: t60)

        var tconv = TimeConverter(tempoMap: tmap)

        tconv.updateDerivedProperties()

        #expect(tconv.entries[0].tempoChange == -15)
        #expect(tconv.entries[0].wallDuration == WallDuration(2_492_901))
        #expect(tconv.entries[1].wallTime == WallTime(2_492_901))
    }

    @Test
    func updateDerivedProperties_emptyEntries() {
        var tconv = TimeConverter(tempoMap: TempoMap())

        tconv.updateDerivedProperties()

        #expect(tconv.entries.isEmpty)
    }

    @Test
    func updateDerivedProperties_increasingTempo() {
        let t60  = Tempo(60)
        let t120 = Tempo(120)
        var tmap = TempoMap()

        tmap.insert(beatTime: BeatTime(0), tempo: t60)
        tmap.insert(beatTime: BeatTime(1), tempo: t120)

        var tconv = TimeConverter(tempoMap: tmap)

        tconv.updateDerivedProperties()

        #expect(tconv.entries[0].tempoChange == 15)
        #expect(tconv.entries[0].wallDuration == WallDuration(3_141_593))
        #expect(tconv.entries[1].wallTime == WallTime(3_141_593))
    }
}
