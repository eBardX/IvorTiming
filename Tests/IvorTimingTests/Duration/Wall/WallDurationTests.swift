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
    func description() {
        #expect(WallDuration(0).description == "0")
        #expect(WallDuration(1_500_000).description == "1.5")
        #expect(WallDuration(1_000_001).description == "1.000001")
    }

    @Test
    func divided() {
        #expect(WallDuration(4).divided(by: 2) == WallDuration(2))
    }

    @Test
    func divided_byZero() {
        #expect(WallDuration(4).divided(by: 0) == nil)
    }

    @Test
    func divided_negativeFactor_returnsNil() {
        #expect(WallDuration(2).divided(by: -1) == nil)
    }

    @Test
    func doubleValue() {
        #expect(WallDuration(0).doubleValue == 0)
        #expect(WallDuration(1_500_000).doubleValue == 1.5)
        #expect(WallDuration(250_000).doubleValue == 0.25)
    }

    @Test
    func formatted() {
        let plain = WallDuration(1_500_000).formatted().characters.reduce(into: "") { $0.append($1) }

        #expect(plain == "1.500")
    }

    @Test
    func hashable() {
        let set: Set<WallDuration> = [WallDuration(1), WallDuration(1), WallDuration(2)]

        #expect(set.count == 2)
    }

    @Test
    func init_doubleValue() {
        #expect(WallDuration(doubleValue: 0) == WallDuration(0))
        #expect(WallDuration(doubleValue: -0.0) == WallDuration(0))
        #expect(WallDuration(doubleValue: 1.5) == WallDuration(1_500_000))
    }

    @Test
    func init_doubleValue_invalid_returnsNil() {
        #expect(WallDuration(doubleValue: -1) == nil)
        #expect(WallDuration(doubleValue: -0.000001) == nil)
        #expect(WallDuration(doubleValue: .infinity) == nil)
        #expect(WallDuration(doubleValue: -.infinity) == nil)
        #expect(WallDuration(doubleValue: .nan) == nil)
        #expect(WallDuration(doubleValue: 0x1p64 / 1_000_000) == nil)
    }

    @Test
    func init_doubleValue_roundsToMicrosecond() {
        #expect(WallDuration(doubleValue: 1.0000004) == WallDuration(1_000_000))
        #expect(WallDuration(doubleValue: 1.0000006) == WallDuration(1_000_001))
    }

    @Test
    func init_doubleValue_roundsTiesToEven() {
        #expect(WallDuration(doubleValue: 1.0 / 128) == WallDuration(7_812))     // 7,812.5 µs
        #expect(WallDuration(doubleValue: 3.0 / 128) == WallDuration(23_438))    // 23,437.5 µs
    }

    @Test
    func init_numberValue() {
        #expect(WallDuration(numberValue: 0) == WallDuration(0))
        #expect(WallDuration(numberValue: Number(numerator: 3, denominator: 2)) == WallDuration(1_500_000))
        #expect(WallDuration(numberValue: Number(numerator: 1_001, denominator: 30_000)) == WallDuration(33_367))
        #expect(WallDuration(numberValue: Number(1.5)) == WallDuration(1_500_000))
        #expect(WallDuration(numberValue: Number(1.000001)) == WallDuration(1_000_001))
    }

    @Test
    func init_numberValue_invalid_returnsNil() {
        #expect(WallDuration(numberValue: -1) == nil)
        #expect(WallDuration(numberValue: Number(numerator: -1, denominator: 1_000_000)) == nil)
        #expect(WallDuration(numberValue: .positiveInfinity) == nil)
        #expect(WallDuration(numberValue: .negativeInfinity) == nil)
        #expect(WallDuration(numberValue: .nan) == nil)
        #expect(WallDuration(numberValue: Number(UInt.max) / 1_000_000 + Number(numerator: 1, denominator: 1_000_000)) == nil)
    }

    @Test
    func init_numberValue_largest() {
        #expect(WallDuration(numberValue: Number(UInt.max) / 1_000_000) == WallDuration(uintValue: .max))
    }

    @Test
    func init_numberValue_roundsTiesToEven() {
        #expect(WallDuration(numberValue: Number(numerator: 1, denominator: 2_000_000)) == WallDuration(0))
        #expect(WallDuration(numberValue: Number(numerator: 3, denominator: 2_000_000)) == WallDuration(2))
    }

    @Test
    func init_seconds() {
        #expect(WallDuration(seconds: 0) == WallDuration(0))
        #expect(WallDuration(seconds: 1.5) == WallDuration(1_500_000))
    }

    @Test
    func init_seconds_invalid_traps() async {
        await #expect(processExitsWith: .failure) {
            _ = WallDuration(seconds: -1)
        }
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
    func multiplied_negativeFactor_returnsNil() {
        #expect(WallDuration(2).multiplied(by: -1) == nil)
    }

    @Test
    func numberValue() {
        #expect(WallDuration(1_500_000).numberValue == Number(numerator: 3, denominator: 2))
        #expect(WallDuration(1_000_001).numberValue == Number(numerator: 1_000_001, denominator: 1_000_000))
    }

    @Test
    func plain() {
        #expect(WallDuration(0).plain == "0")
        #expect(WallDuration(1_000_000).plain == "1")
        #expect(WallDuration(1_500_000).plain == "1.5")
        #expect(WallDuration(1_050_000).plain == "1.05")
        #expect(WallDuration(1_005_000).plain == "1.005")
        #expect(WallDuration(1_000_001).plain == "1.000001")
    }

    @Test
    func plain_negative_returnsNil() {
        #expect(WallDuration(plain: "-1") == nil)
    }

    @Test
    func plain_roundTrip() {
        #expect(WallDuration(plain: "1") == WallDuration(1_000_000))
        #expect(WallDuration(plain: "1.5") == WallDuration(1_500_000))
        #expect(WallDuration(plain: "1.05") == WallDuration(1_050_000))
        #expect(WallDuration(plain: "1.005") == WallDuration(1_005_000))
        #expect(WallDuration(plain: "1.000001") == WallDuration(1_000_001))
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
