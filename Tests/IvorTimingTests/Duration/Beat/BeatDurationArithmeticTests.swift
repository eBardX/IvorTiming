// © 2025–2026 John Gary Pusey (see LICENSE.md)

@testable import IvorTiming
import Testing
import XestiNumbers

struct BeatDurationArithmeticTests {
}

// MARK: -

extension BeatDurationArithmeticTests {
    @Test
    func addingInPlace() {
        var dur = BeatDuration(1)

        dur += BeatDuration(2)

        #expect(dur == BeatDuration(3))
    }

    @Test
    func operators() {
        #expect(BeatDuration(1) + BeatDuration(2) == BeatDuration(3))
        #expect(BeatDuration(3) - BeatDuration(1) == BeatDuration(2))
        #expect(BeatDuration(2) * Number(3) == BeatDuration(6))
    }

    @Test
    func scalingInPlace() {
        var dur = BeatDuration(2)

        dur *= Number(3)

        #expect(dur == BeatDuration(6))
    }

    @Test
    func subtractingInPlace() {
        var dur = BeatDuration(3)

        dur -= BeatDuration(1)

        #expect(dur == BeatDuration(2))
    }
}
