// © 2025–2026 John Gary Pusey (see LICENSE.md)

import Foundation
@testable import IvorTiming
import Testing
import XestiNumbers
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
    func description() {
        #expect(WallTime(0).description == "0")
        #expect(WallTime(1_500_000).description == "1.5")
        #expect(WallTime(1_000_001).description == "1.000001")
    }

    @Test
    func doubleValue() {
        #expect(WallTime(0).doubleValue == 0)
        #expect(WallTime(1_500_000).doubleValue == 1.5)
        #expect(WallTime(250_000).doubleValue == 0.25)
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
        let plain = WallTime(1_500_000).formatted().characters.reduce(into: "") { $0.append($1) }

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
    func init_doubleValue() {
        #expect(WallTime(doubleValue: 0) == WallTime(0))
        #expect(WallTime(doubleValue: -0.0) == WallTime(0))
        #expect(WallTime(doubleValue: 1.5) == WallTime(1_500_000))
    }

    @Test
    func init_doubleValue_invalid_returnsNil() {
        #expect(WallTime(doubleValue: -1) == nil)
        #expect(WallTime(doubleValue: -0.000001) == nil)
        #expect(WallTime(doubleValue: .infinity) == nil)
        #expect(WallTime(doubleValue: -.infinity) == nil)
        #expect(WallTime(doubleValue: .nan) == nil)
        #expect(WallTime(doubleValue: 0x1p64 / 1_000_000) == nil)
    }

    @Test
    func init_doubleValue_roundsToMicrosecond() {
        #expect(WallTime(doubleValue: 1.0000004) == WallTime(1_000_000))
        #expect(WallTime(doubleValue: 1.0000006) == WallTime(1_000_001))
    }

    @Test
    func init_doubleValue_roundsTiesToEven() {
        #expect(WallTime(doubleValue: 1.0 / 128) == WallTime(7_812))     // 7,812.5 µs
        #expect(WallTime(doubleValue: 3.0 / 128) == WallTime(23_438))    // 23,437.5 µs
    }

    @Test
    func init_numberValue() {
        #expect(WallTime(numberValue: 0) == WallTime(0))
        #expect(WallTime(numberValue: Number(numerator: 3, denominator: 2)) == WallTime(1_500_000))
        #expect(WallTime(numberValue: Number(numerator: 1_001, denominator: 30_000)) == WallTime(33_367))
        #expect(WallTime(numberValue: Number(1.5)) == WallTime(1_500_000))
        #expect(WallTime(numberValue: Number(1.000001)) == WallTime(1_000_001))
    }

    @Test
    func init_numberValue_invalid_returnsNil() {
        #expect(WallTime(numberValue: -1) == nil)
        #expect(WallTime(numberValue: Number(numerator: -1, denominator: 1_000_000)) == nil)
        #expect(WallTime(numberValue: .positiveInfinity) == nil)
        #expect(WallTime(numberValue: .negativeInfinity) == nil)
        #expect(WallTime(numberValue: .nan) == nil)
        #expect(WallTime(numberValue: Number(UInt.max) / 1_000_000 + Number(numerator: 1, denominator: 1_000_000)) == nil)
    }

    @Test
    func init_numberValue_largest() {
        #expect(WallTime(numberValue: Number(UInt.max) / 1_000_000) == WallTime(uintValue: .max))
    }

    @Test
    func init_numberValue_roundsTiesToEven() {
        #expect(WallTime(numberValue: Number(numerator: 1, denominator: 2_000_000)) == WallTime(0))
        #expect(WallTime(numberValue: Number(numerator: 3, denominator: 2_000_000)) == WallTime(2))
    }

    @Test
    func init_seconds() {
        #expect(WallTime(seconds: 0) == WallTime(0))
        #expect(WallTime(seconds: 1.5) == WallTime(1_500_000))
    }

    @Test
    func init_seconds_invalid_traps() async {
        await #expect(processExitsWith: .failure) {
            _ = WallTime(seconds: -1)
        }
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
    func numberValue() {
        #expect(WallTime(1_500_000).numberValue == Number(numerator: 3, denominator: 2))
        #expect(WallTime(1_000_001).numberValue == Number(numerator: 1_000_001, denominator: 1_000_000))
    }

    @Test
    func plain() {
        #expect(WallTime(0).plain == "0")
        #expect(WallTime(1_000_000).plain == "1")
        #expect(WallTime(1_500_000).plain == "1.5")
        #expect(WallTime(1_050_000).plain == "1.05")
        #expect(WallTime(1_005_000).plain == "1.005")
        #expect(WallTime(1_000_001).plain == "1.000001")
    }

    @Test
    func plain_negative_returnsNil() {
        #expect(WallTime(plain: "-1") == nil)
    }

    @Test
    func plain_roundTrip() {
        #expect(WallTime(plain: "1") == WallTime(1_000_000))
        #expect(WallTime(plain: "1.5") == WallTime(1_500_000))
        #expect(WallTime(plain: "1.05") == WallTime(1_050_000))
        #expect(WallTime(plain: "1.005") == WallTime(1_005_000))
        #expect(WallTime(plain: "1.000001") == WallTime(1_000_001))
        #expect(WallTime(plain: "not a number") == nil)
    }

    @Test
    func zero() throws {
        let z = try #require(WallTime(uintValue: 0))

        #expect(z == .zero)
    }
}
