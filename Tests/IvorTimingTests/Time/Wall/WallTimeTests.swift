// © 2025–2026 John Gary Pusey (see LICENSE.md)

import Foundation
@testable import IvorTiming
import Testing
import XestiTools

struct WallTimeTests {
}

// MARK: -

extension WallTimeTests {
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
    func formatted() {
        let plain = WallTime(1_500).formatted().characters.reduce(into: "") { $0.append($1) }

        #expect(plain == "1.500")
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
    func init_uintValue() {
        #expect(WallTime(uintValue: 0) != nil)
        #expect(WallTime(uintValue: 1) != nil)
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
    func plain() {
        #expect(WallTime(0).plain == "0")
        #expect(WallTime(1_000).plain == "1")
        #expect(WallTime(1_500).plain == "1.5")
        #expect(WallTime(1_050).plain == "1.05")
        #expect(WallTime(1_005).plain == "1.005")
    }

    @Test
    func plain_roundTrip() {
        #expect(WallTime(plain: "1") == WallTime(1_000))
        #expect(WallTime(plain: "1.5") == WallTime(1_500))
        #expect(WallTime(plain: "1.05") == WallTime(1_050))
        #expect(WallTime(plain: "1.005") == WallTime(1_005))
        #expect(WallTime(plain: "not a number") == nil)
    }

    @Test
    func zero() throws {
        let z = try #require(WallTime(uintValue: 0))

        #expect(z == .zero)
    }
}
