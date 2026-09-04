// © 2025–2026 John Gary Pusey (see LICENSE.md)

@testable import IvorTiming
import Testing
import XestiNumbers

struct WallDurationArithmeticTests {
}

// MARK: -

extension WallDurationArithmeticTests {
    @Test
    func addingInPlace() {
        var dur = WallDuration(1)

        dur += WallDuration(2)

        #expect(dur == WallDuration(3))
    }

    @Test
    func operators() {
        #expect(WallDuration(1) + WallDuration(2) == WallDuration(3))
        #expect(WallDuration(3) - WallDuration(1) == WallDuration(2))
        #expect(WallDuration(2) * Number(3) == WallDuration(6))
    }

    @Test
    func scalingInPlace() {
        var dur = WallDuration(2)

        dur *= Number(3)

        #expect(dur == WallDuration(6))
    }

    @Test
    func subtractingInPlace() {
        var dur = WallDuration(3)

        dur -= WallDuration(1)

        #expect(dur == WallDuration(2))
    }
}
