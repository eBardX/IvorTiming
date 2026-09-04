// © 2026 John Gary Pusey (see LICENSE.md)

@testable import IvorTiming
import Testing
import XestiNumbers

struct TimeConverterInternalTests {
}

// MARK: -

extension TimeConverterInternalTests {
    @Test
    func floorIndex_forBeatTime() throws {
        let t120 = try #require(Tempo(uintValue: 120))
        var tmap = TempoMap()

        tmap.insert(beatTime: BeatTime(0), tempo: t120)
        tmap.insert(beatTime: BeatTime(2), tempo: t120)

        let tconv = TimeConverter(tempoMap: tmap)

        #expect(tconv.floorIndex(for: BeatTime(1)) == 0)
        #expect(tconv.floorIndex(for: BeatTime(5)) == 1)
    }

    @Test
    func floorIndex_forWallTime() throws {
        let t120 = try #require(Tempo(uintValue: 120))
        var tmap = TempoMap()

        tmap.insert(beatTime: BeatTime(0), tempo: t120)
        tmap.insert(beatTime: BeatTime(2), tempo: t120)

        let tconv = TimeConverter(tempoMap: tmap)

        #expect(tconv.floorIndex(for: WallTime(0.5)) == 0)
        #expect(tconv.floorIndex(for: WallTime(2)) == 1)
    }

    @Test
    func updateDerivedProperties_computesWallTimes() throws {
        let t120 = try #require(Tempo(uintValue: 120))
        var tmap = TempoMap()

        tmap.insert(beatTime: BeatTime(0), tempo: t120)
        tmap.insert(beatTime: BeatTime(2), tempo: t120)

        var tconv = TimeConverter(tempoMap: tmap)

        tconv.updateDerivedProperties()

        #expect(tconv.entries[0].wallTime == .zero)
        #expect(tconv.entries[0].wallDuration == WallDuration(1))
        #expect(tconv.entries[1].wallTime == WallTime(1))
    }

    @Test
    func updateDerivedProperties_emptyEntries() {
        var tconv = TimeConverter(tempoMap: TempoMap())

        tconv.updateDerivedProperties()

        #expect(tconv.entries.isEmpty)
    }
}
