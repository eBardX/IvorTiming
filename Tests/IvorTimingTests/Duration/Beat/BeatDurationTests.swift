// © 2025–2026 John Gary Pusey (see LICENSE.md)

import Foundation
@testable import IvorTiming
import Testing
import XestiNumbers

struct BeatDurationTests {
}

// MARK: -

extension BeatDurationTests {
    @Test
    func adding() {
        #expect(BeatDuration(1).adding(BeatDuration(2)) == BeatDuration(3))
        #expect(BeatDuration.zero.adding(.zero) == .zero)
    }

    @Test
    func addingInPlace() {
        var dur = BeatDuration(1)

        dur += BeatDuration(2)

        #expect(dur == BeatDuration(3))
    }

    @Test
    func codable() throws {
        let original = BeatDuration(3)
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(BeatDuration.self, from: data)

        #expect(decoded == original)
    }

    @Test
    func comparable() {
        #expect(BeatDuration(1) < BeatDuration(2))
        #expect(BeatDuration(1) == BeatDuration(1)) // swiftlint:disable:this identical_operands
        #expect(BeatDuration(2) > BeatDuration(1))
    }

    @Test
    func divided() {
        #expect(BeatDuration(4).divided(by: 2) == BeatDuration(2))
    }

    @Test
    func hashable() {
        let set: Set<BeatDuration> = [BeatDuration(1), BeatDuration(1), BeatDuration(2)]

        #expect(set.count == 2)
    }

    @Test
    func init_invalid() {
        #expect(BeatDuration(numberValue: -1) == nil)
    }

    @Test
    func init_valid() {
        #expect(BeatDuration(numberValue: 0) != nil)
        #expect(BeatDuration(numberValue: 1) != nil)
    }

    @Test
    func isValid() {
        #expect(BeatDuration.isValid(Number(0)))
        #expect(BeatDuration.isValid(Number(1)))
        #expect(!BeatDuration.isValid(Number(-1)))
    }

    @Test
    func isZero() {
        #expect(BeatDuration.zero.isZero)
        #expect(!BeatDuration(1).isZero)
    }

    @Test
    func multiplied() {
        #expect(BeatDuration(2).multiplied(by: 3) == BeatDuration(6))
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
    func subtracting() {
        #expect(BeatDuration(3).subtracting(BeatDuration(1)) == BeatDuration(2))
        #expect(BeatDuration(1).subtracting(BeatDuration(3)) == nil)
    }

    @Test
    func subtractingInPlace() {
        var dur = BeatDuration(3)

        dur -= BeatDuration(1)

        #expect(dur == BeatDuration(2))
    }

    @Test
    func zero() throws {
        let z = try #require(BeatDuration(numberValue: 0))

        #expect(z == .zero)
        #expect(z.isZero)
    }
}
