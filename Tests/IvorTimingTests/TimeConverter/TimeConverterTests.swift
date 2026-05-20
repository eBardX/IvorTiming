// © 2026 John Gary Pusey (see LICENSE.md)

@testable import IvorTiming
import Testing
import XestiNumbers

struct TimeConverterTests {
}

// MARK: -

extension TimeConverterTests {
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
    func wallTime_constantTempo60() {
        let tconv = TimeConverter(TempoMap())

        #expect(tconv.wallTime(at: BeatTime(0)) == WallTime(0))
        #expect(tconv.wallTime(at: BeatTime(2)) == WallTime(2))
        #expect(tconv.wallTime(at: BeatTime(4)) == WallTime(4))
    }

    @Test
    func roundTrip() {
        let tconv    = TimeConverter(TempoMap())
        let beatTime = BeatTime(3)
        let wallTime = tconv.wallTime(at: beatTime)

        #expect(tconv.beatTime(at: wallTime) == beatTime)
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
}
