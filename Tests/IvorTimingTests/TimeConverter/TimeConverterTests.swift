// © 2026 John Gary Pusey (see LICENSE.md)

@testable import IvorTiming
import Testing
import XestiNumbers
import XestiTools

struct TimeConverterTests {
}

// MARK: -

extension TimeConverterTests {
    @Test
    func beatTime_beforeFirstEntry() {
        let t120 = Tempo(120)
        var tmap = TempoMap()

        tmap.insert(beatTime: BeatTime(1), tempo: t120)

        let tconv = TimeConverter(tempoMap: tmap)

        #expect(tconv.beatTime(at: WallTime(0)) == BeatTime(0))
        #expect(tconv.beatTime(at: WallTime(1_000_000)) == beat(1, 2))
    }

    @Test
    func beatTime_constantTempo120() {
        let t120 = Tempo(120)
        var tmap = TempoMap()

        tmap.insert(beatTime: .zero, tempo: t120)

        let tconv = TimeConverter(tempoMap: tmap)

        #expect(tconv.beatTime(at: WallTime(0)) == BeatTime(0))
        #expect(tconv.beatTime(at: WallTime(1_000_000)) == beat(1, 2))
        #expect(tconv.beatTime(at: WallTime(2_000_000)) == BeatTime(1))
    }

    @Test
    func beatTime_constantTempo60() {
        let tconv = TimeConverter(tempoMap: TempoMap())

        #expect(tconv.beatTime(at: WallTime(0)) == BeatTime(0))
        #expect(tconv.beatTime(at: WallTime(2_000_000)) == beat(1, 2))
        #expect(tconv.beatTime(at: WallTime(4_000_000)) == BeatTime(1))
    }

    @Test
    func dottedQuarter67_isExactOverFiveMinutes() {
        // METER_TABLE.md 1.10: ♩. = 67 is 201/8 whole notes per minute, stored exactly, so five
        // minutes is exactly 1005/8 whole notes.
        let tconv = TimeConverter(tempoMap: TempoMap(defaultTempo: dottedQuarter(67)))
        let fiveMinutes = WallTime(300_000_000)

        #expect(tconv.beatTime(at: fiveMinutes) == beat(1_005, 8))
        #expect(tconv.wallTime(at: beat(1_005, 8)) == fiveMinutes)
        #expect(tconv.wallTime(at: tconv.beatTime(at: fiveMinutes)) == fiveMinutes)
    }

    @Test
    func dottedQuarter67_roundTripWithEntry() {
        var tmap = TempoMap()

        tmap.insert(beatTime: .zero, tempo: dottedQuarter(67))

        let tconv = TimeConverter(tempoMap: tmap)
        let beatTime = tconv.beatTime(at: WallTime(300_000_000))

        #expect(abs(beatTime.numberValue.doubleValue - 125.625) < 0.0001)
        #expect(abs(tconv.wallTime(at: beatTime).doubleValue - 300) < 0.00001)
    }

    @Test
    func roundTrip() {
        let tconv    = TimeConverter(tempoMap: TempoMap())
        let beatTime = beat(3, 4)
        let wallTime = tconv.wallTime(at: beatTime)

        #expect(tconv.beatTime(at: wallTime) == beatTime)
    }

    // Two entries at the same tempo keeps arithmetic rational, testing the
    // multi-entry code path without transcendental rounding error.
    @Test
    func roundTrip_multiEntry() {
        let t120 = Tempo(120)
        var tmap = TempoMap()

        tmap.insert(beatTime: BeatTime(0), tempo: t120)
        tmap.insert(beatTime: BeatTime(1), tempo: t120)

        let tconv = TimeConverter(tempoMap: tmap)
        let beatTime = beat(1, 2)
        let wallTime = tconv.wallTime(at: beatTime)

        #expect(tconv.beatTime(at: wallTime) == beatTime)
    }

    @Test
    func wallTime_beforeFirstEntry() {
        let t120 = Tempo(120)
        var tmap = TempoMap()

        tmap.insert(beatTime: BeatTime(1), tempo: t120)

        let tconv = TimeConverter(tempoMap: tmap)

        #expect(tconv.wallTime(at: BeatTime(0)) == WallTime(0))
        #expect(tconv.wallTime(at: beat(1, 2)) == WallTime(1_000_000))
    }

    @Test
    func wallTime_constantTempo120() {
        let t120 = Tempo(120)
        var tmap = TempoMap()

        tmap.insert(beatTime: .zero, tempo: t120)

        let tconv = TimeConverter(tempoMap: tmap)

        #expect(tconv.wallTime(at: BeatTime(0)) == WallTime(0))
        #expect(tconv.wallTime(at: beat(1, 2)) == WallTime(1_000_000))
        #expect(tconv.wallTime(at: BeatTime(1)) == WallTime(2_000_000))
    }

    @Test
    func wallTime_constantTempo60() {
        let tconv = TimeConverter(tempoMap: TempoMap())

        #expect(tconv.wallTime(at: BeatTime(0)) == WallTime(0))
        #expect(tconv.wallTime(at: beat(1, 2)) == WallTime(2_000_000))
        #expect(tconv.wallTime(at: BeatTime(1)) == WallTime(4_000_000))
    }

    @Test
    func wallTime_decreasingTempo_isMonotone() {
        let t120 = Tempo(120)
        let t60  = Tempo(60)
        var tmap = TempoMap()

        tmap.insert(beatTime: BeatTime(0), tempo: t120)
        tmap.insert(beatTime: BeatTime(1), tempo: t60)

        let tconv = TimeConverter(tempoMap: tmap)

        let wt1 = tconv.wallTime(at: beat(1, 4))
        let wt2 = tconv.wallTime(at: beat(1, 2))
        let wt3 = tconv.wallTime(at: beat(3, 4))

        #expect(wt1 < wt2)
        #expect(wt2 < wt3)
        #expect(tconv.beatTime(at: wt1) < tconv.beatTime(at: wt2))
        #expect(tconv.beatTime(at: wt2) < tconv.beatTime(at: wt3))
    }

    @Test
    func wallTime_defaultTempo_wholeNoteLastsFourSeconds() {
        let tconv = TimeConverter(tempoMap: TempoMap())

        #expect(tconv.wallTime(at: BeatTime(1)) == WallTime(4_000_000))
        #expect(tconv.wallTime(at: beat(1, 4)) == WallTime(1_000_000))
    }

    @Test
    func wallTime_varyingTempo_isMonotone() {
        let t60  = Tempo(60)
        let t120 = Tempo(120)
        var tmap = TempoMap()

        tmap.insert(beatTime: BeatTime(0), tempo: t60)
        tmap.insert(beatTime: BeatTime(1), tempo: t120)

        let tconv = TimeConverter(tempoMap: tmap)

        let wt1 = tconv.wallTime(at: beat(1, 4))
        let wt2 = tconv.wallTime(at: beat(1, 2))
        let wt3 = tconv.wallTime(at: beat(3, 4))

        #expect(wt1 < wt2)
        #expect(wt2 < wt3)
        #expect(tconv.beatTime(at: wt1) < tconv.beatTime(at: wt2))
        #expect(tconv.beatTime(at: wt2) < tconv.beatTime(at: wt3))
    }
}
