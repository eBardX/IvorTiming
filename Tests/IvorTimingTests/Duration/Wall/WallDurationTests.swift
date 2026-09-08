// © 2025–2026 John Gary Pusey (see LICENSE.md)

import Foundation
@testable import IvorTiming
import Testing
import XestiNumbers
import XestiTools

struct WallDurationTests {
}

// MARK: -

extension WallDurationTests {
    @Test
    func adding() {
        #expect(WallDuration(1).adding(WallDuration(2)) == WallDuration(3))
        #expect(WallDuration.zero.adding(.zero) == .zero)
    }

    @Test
    func adding_overflow() {
        #expect(WallDuration(uintValue: .max)?.adding(WallDuration(1)) == nil)
    }

    @Test
    func codable() throws {
        let original = WallDuration(3)
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(WallDuration.self, from: data)

        #expect(decoded == original)
    }

    @Test
    func comparable() {
        #expect(WallDuration(1) < WallDuration(2))
        #expect(WallDuration(1) == WallDuration(1)) // swiftlint:disable:this identical_operands
    }

    @Test
    func divided() {
        #expect(WallDuration(4).divided(by: 2) == WallDuration(2))
    }

    @Test
    func formatted() {
        let plain = WallDuration(1_500).formatted().characters.reduce(into: "") { $0.append($1) }

        #expect(plain == "1.500")
    }

    @Test
    func hashable() {
        let set: Set<WallDuration> = [WallDuration(1), WallDuration(1), WallDuration(2)]

        #expect(set.count == 2)
    }

    @Test
    func init_uintValue() {
        #expect(WallDuration(uintValue: 0) != nil)
        #expect(WallDuration(uintValue: 1) != nil)
    }

    @Test
    func isZero() {
        #expect(WallDuration.zero.isZero)
        #expect(!WallDuration(1).isZero)
    }

    @Test
    func multiplied() {
        #expect(WallDuration(2).multiplied(by: 3) == WallDuration(6))
    }

    @Test
    func plain() {
        #expect(WallDuration(0).plain == "0.")
        #expect(WallDuration(1_000).plain == "1.")
        #expect(WallDuration(1_500).plain == "1.5")
        #expect(WallDuration(1_050).plain == "1.05")
        #expect(WallDuration(1_005).plain == "1.005")
    }

    @Test
    func plain_roundTrip() {
        #expect(WallDuration(plain: "1") == WallDuration(1_000))
        #expect(WallDuration(plain: "1.5") == WallDuration(1_500))
        #expect(WallDuration(plain: "1.05") == WallDuration(1_050))
        #expect(WallDuration(plain: "1.005") == WallDuration(1_005))
        #expect(WallDuration(plain: "not a number") == nil)
    }

    @Test
    func subtracting() {
        #expect(WallDuration(3).subtracting(WallDuration(1)) == WallDuration(2))
        #expect(WallDuration(1).subtracting(WallDuration(3)) == nil)
    }

    @Test
    func zero() throws {
        let z = try #require(WallDuration(uintValue: 0))

        #expect(z == .zero)
        #expect(z.isZero)
    }
}
