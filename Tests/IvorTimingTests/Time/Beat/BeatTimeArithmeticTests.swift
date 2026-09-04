// © 2025–2026 John Gary Pusey (see LICENSE.md)

@testable import IvorTiming
import Testing
import XestiNumbers

struct BeatTimeArithmeticTests {
}

// MARK: -

extension BeatTimeArithmeticTests {
    @Test
    func advancingInPlace() {
        var time = BeatTime(1)

        time += BeatDuration(2)

        #expect(time == BeatTime(3))
    }

    @Test
    func operators() {
        #expect(BeatTime(1) + BeatDuration(2) == BeatTime(3))
        #expect(BeatTime(3) - BeatDuration(2) == BeatTime(1))
        #expect(BeatTime(3) - BeatTime(1) == BeatDuration(2))
    }

    @Test
    func retreatingInPlace() {
        var time = BeatTime(3)

        time -= BeatDuration(2)

        #expect(time == BeatTime(1))
    }

    @Test
    func scaling() {
        #expect(BeatTime(2) * Number(3) == BeatTime(6))
    }

    @Test
    func scalingInPlace() {
        var time = BeatTime(2)

        time *= Number(3)

        #expect(time == BeatTime(6))
    }
}
