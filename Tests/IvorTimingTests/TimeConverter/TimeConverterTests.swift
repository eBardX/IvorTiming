// © 2026 John Gary Pusey (see LICENSE.md)

@testable import IvorTiming
import Testing
import XestiNumbers

struct TimeConverterTests {
}

// MARK: -

extension TimeConverterTests {
    @Test
    func beatTime_beforeFirstEntry() throws {
        let t120  = try #require(Tempo(uintValue: 120))
        let tconv = TimeConverter(TempoMap().inserting(beatTime: BeatTime(4),
                                                       tempo: t120))

        #expect(tconv.beatTime(at: WallTime(0)) == BeatTime(0))
        #expect(tconv.beatTime(at: WallTime(1)) == BeatTime(2))
    }

    @Test
    func beatTime_constantTempo120() throws {
        let t120  = try #require(Tempo(uintValue: 120))
        let tconv = TimeConverter(TempoMap().inserting(beatTime: .zero,
                                                       tempo: t120))

        #expect(tconv.beatTime(at: WallTime(0)) == BeatTime(0))
        #expect(tconv.beatTime(at: WallTime(1)) == BeatTime(2))
        #expect(tconv.beatTime(at: WallTime(2)) == BeatTime(4))
    }

    @Test
    func beatTime_constantTempo60() {
        let tconv = TimeConverter(TempoMap())

        #expect(tconv.beatTime(at: WallTime(0)) == BeatTime(0))
        #expect(tconv.beatTime(at: WallTime(2)) == BeatTime(2))
        #expect(tconv.beatTime(at: WallTime(4)) == BeatTime(4))
    }

    @Test
    func roundTrip() {
        let tconv    = TimeConverter(TempoMap())
        let beatTime = BeatTime(3)
        let wallTime = tconv.wallTime(at: beatTime)

        #expect(tconv.beatTime(at: wallTime) == beatTime)
    }

    // Two entries at the same tempo keeps arithmetic rational, testing the
    // multi-entry code path without transcendental rounding error.
    @Test
    func roundTrip_multiEntry() throws {
        let t120  = try #require(Tempo(uintValue: 120))
        let tconv = TimeConverter(TempoMap()
            .inserting(beatTime: BeatTime(0), tempo: t120)
            .inserting(beatTime: BeatTime(4), tempo: t120))
        let beatTime = BeatTime(2)
        let wallTime = tconv.wallTime(at: beatTime)

        #expect(tconv.beatTime(at: wallTime) == beatTime)
    }

    @Test
    func wallTime_beforeFirstEntry() throws {
        let t120  = try #require(Tempo(uintValue: 120))
        let tconv = TimeConverter(TempoMap().inserting(beatTime: BeatTime(4),
                                                       tempo: t120))

        #expect(tconv.wallTime(at: BeatTime(0)) == WallTime(0))
        #expect(tconv.wallTime(at: BeatTime(2)) == WallTime(1))
    }

    @Test
    func wallTime_constantTempo120() throws {
        let t120  = try #require(Tempo(uintValue: 120))
        let tconv = TimeConverter(TempoMap().inserting(beatTime: .zero,
                                                       tempo: t120))

        #expect(tconv.wallTime(at: BeatTime(0)) == WallTime(0))
        #expect(tconv.wallTime(at: BeatTime(2)) == WallTime(1))
        #expect(tconv.wallTime(at: BeatTime(4)) == WallTime(2))
    }

    @Test
    func wallTime_constantTempo60() {
        let tconv = TimeConverter(TempoMap())

        #expect(tconv.wallTime(at: BeatTime(0)) == WallTime(0))
        #expect(tconv.wallTime(at: BeatTime(2)) == WallTime(2))
        #expect(tconv.wallTime(at: BeatTime(4)) == WallTime(4))
    }

    @Test
    func wallTime_varyingTempo_isMonotone() throws {
        let t60  = try #require(Tempo(uintValue: 60))
        let t120 = try #require(Tempo(uintValue: 120))
        let tconv = TimeConverter(TempoMap()
            .inserting(beatTime: BeatTime(0), tempo: t60)
            .inserting(beatTime: BeatTime(4), tempo: t120))

        let wt1 = tconv.wallTime(at: BeatTime(1))
        let wt2 = tconv.wallTime(at: BeatTime(2))
        let wt3 = tconv.wallTime(at: BeatTime(3))

        #expect(wt1 < wt2)
        #expect(wt2 < wt3)
        #expect(tconv.beatTime(at: wt1) < tconv.beatTime(at: wt2))
        #expect(tconv.beatTime(at: wt2) < tconv.beatTime(at: wt3))
    }
}
