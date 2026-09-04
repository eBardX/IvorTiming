// © 2025–2026 John Gary Pusey (see LICENSE.md)

@testable import IvorTiming
import Testing
import XestiNumbers

struct WallTimeArithmeticTests {
}

// MARK: -

extension WallTimeArithmeticTests {
    @Test
    func advancingInPlace() {
        var time = WallTime(1)

        time += WallDuration(2)

        #expect(time == WallTime(3))
    }

    @Test
    func operators() {
        #expect(WallTime(1) + WallDuration(2) == WallTime(3))
        #expect(WallTime(3) - WallDuration(2) == WallTime(1))
        #expect(WallTime(3) - WallTime(1) == WallDuration(2))
    }

    @Test
    func retreatingInPlace() {
        var time = WallTime(3)

        time -= WallDuration(2)

        #expect(time == WallTime(1))
    }

    @Test
    func scaling() {
        #expect(WallTime(2) * Number(3) == WallTime(6))
    }

    @Test
    func scalingInPlace() {
        var time = WallTime(2)

        time *= Number(3)

        #expect(time == WallTime(6))
    }
}
