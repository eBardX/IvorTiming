// © 2026 John Gary Pusey (see LICENSE.md)

@testable import IvorTiming
import Testing

struct BeatDurationCommonTests {
}

// MARK: -

extension BeatDurationCommonTests {
    @Test
    func dottedEighth() {
        #expect(BeatDuration.dottedEighth == dur(3, 16))
        #expect(BeatDuration.dottedEighth == BeatDuration.eighth * frac(3, 2))
    }

    @Test
    func dottedHalf() {
        #expect(BeatDuration.dottedHalf == dur(3, 4))
        #expect(BeatDuration.dottedHalf == BeatDuration.half * frac(3, 2))
    }

    @Test
    func dottedQuarter() {
        #expect(BeatDuration.dottedQuarter == dur(3, 8))
        #expect(BeatDuration.dottedQuarter == BeatDuration.quarter * frac(3, 2))
    }

    @Test
    func eighth() {
        #expect(BeatDuration.eighth == dur(1, 8))
    }

    @Test
    func half() {
        #expect(BeatDuration.half == dur(1, 2))
    }

    @Test
    func quarter() {
        #expect(BeatDuration.quarter == dur(1, 4))
    }

    @Test
    func sixteenth() {
        #expect(BeatDuration.sixteenth == dur(1, 16))
    }

    @Test
    func whole() {
        #expect(BeatDuration.whole == dur(1))
    }
}
