// © 2025–2026 John Gary Pusey (see LICENSE.md)

import Foundation
@testable import IvorTiming
import Testing
import XestiNumbers

struct WallTimeTests {
}

// MARK: -

extension WallTimeTests {
    @Test
    func advancingInPlace() {
        var time = WallTime(1)

        time += WallDuration(2)

        #expect(time == WallTime(3))
    }

    @Test
    func codable() throws {
        let original = WallTime(3)
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(WallTime.self, from: data)

        #expect(decoded == original)
    }

    @Test
    func comparable() {
        #expect(WallTime(1) < WallTime(2))
        #expect(WallTime(1) == WallTime(1)) // swiftlint:disable:this identical_operands
    }

    @Test
    func duration_to_backward() {
        let result = WallTime(3).duration(to: WallTime(1))

        #expect(result?.duration == WallDuration(2))
        #expect(result?.direction == .backward)
    }

    @Test
    func duration_to_forward() {
        let result = WallTime(1).duration(to: WallTime(3))

        #expect(result?.duration == WallDuration(2))
        #expect(result?.direction == .forward)
    }

    @Test
    func duration_to_same() {
        let result = WallTime(2).duration(to: WallTime(2))

        #expect(result?.duration == .zero)
        #expect(result?.direction == .same)
    }

    @Test
    func fraction() {
        let start = WallTime(0)
        let end = WallTime(4)

        #expect(WallTime(0).fraction(from: start, through: end) == 0.0)
        #expect(WallTime(2).fraction(from: start, through: end) == 0.5)
        #expect(WallTime(4).fraction(from: start, through: end) == 1.0)
    }

    @Test
    func hashable() {
        let set: Set<WallTime> = [WallTime(1), WallTime(1), WallTime(2)]

        #expect(set.count == 2)
    }

    @Test
    func init_invalid() {
        #expect(WallTime(numberValue: -1) == nil)
    }

    @Test
    func init_valid() {
        #expect(WallTime(numberValue: 0) != nil)
        #expect(WallTime(numberValue: 1) != nil)
    }

    @Test
    func isValid() {
        #expect(WallTime.isValid(Number(0)))
        #expect(WallTime.isValid(Number(1)))
        #expect(!WallTime.isValid(Number(-1)))
    }

    @Test
    func moved_backward() {
        #expect(WallTime(3).moved(by: DirectedDuration(duration: WallDuration(2), direction: .backward)) == WallTime(1))
        #expect(WallTime(0).moved(by: DirectedDuration(duration: WallDuration(1), direction: .backward)) == nil)
    }

    @Test
    func moved_forward() {
        #expect(WallTime(1).moved(by: DirectedDuration(duration: WallDuration(2), direction: .forward)) == WallTime(3))
    }

    @Test
    func moved_same() {
        #expect(WallTime(1).moved(by: DirectedDuration(duration: WallDuration.zero, direction: .same)) == WallTime(1))
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

    @Test
    func zero() throws {
        let z = try #require(WallTime(numberValue: 0))

        #expect(z == .zero)
    }
}
