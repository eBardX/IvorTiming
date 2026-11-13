// © 2026 John Gary Pusey (see LICENSE.md)

@testable import IvorTiming
import Testing
import XestiNumbers

struct UIntMicrosecondsTests {
}

// MARK: -

extension UIntMicrosecondsTests {
    @Test
    func init_double() {
        #expect(UInt(microsecondsFromSeconds: 0.0) == 0)
        #expect(UInt(microsecondsFromSeconds: 1.5) == 1_500_000)
        #expect(UInt(microsecondsFromSeconds: 0.000001) == 1)
    }

    @Test
    func init_double_invalid_returnsNil() {
        #expect(UInt(microsecondsFromSeconds: -0.000001) == nil)
        #expect(UInt(microsecondsFromSeconds: Double.infinity) == nil)
        #expect(UInt(microsecondsFromSeconds: -Double.infinity) == nil)
        #expect(UInt(microsecondsFromSeconds: Double.nan) == nil)
        #expect(UInt(microsecondsFromSeconds: 0x1p64 / 1_000_000) == nil)
    }

    @Test
    func init_double_roundsTiesToEven() {
        #expect(UInt(microsecondsFromSeconds: 1.0 / 128) == 7_812)     // 7,812.5 µs
        #expect(UInt(microsecondsFromSeconds: 3.0 / 128) == 23_438)    // 23,437.5 µs
    }

    @Test
    func init_double_roundsToMicrosecond() {
        #expect(UInt(microsecondsFromSeconds: 1.0000004) == 1_000_000)
        #expect(UInt(microsecondsFromSeconds: 1.0000006) == 1_000_001)
    }

    @Test
    func init_number() {
        #expect(UInt(microsecondsFromSeconds: Number(0)) == 0)
        #expect(UInt(microsecondsFromSeconds: frac(3, 2)) == 1_500_000)
        #expect(UInt(microsecondsFromSeconds: frac(1_001, 30_000)) == 33_367)
    }

    @Test
    func init_number_inexact_convertsAsDouble() {
        #expect(UInt(microsecondsFromSeconds: Number(1.5)) == 1_500_000)
        #expect(UInt(microsecondsFromSeconds: Number(1.000001)) == 1_000_001)
    }

    @Test
    func init_number_invalid_returnsNil() {
        #expect(UInt(microsecondsFromSeconds: frac(-1, 1_000_000)) == nil)
        #expect(UInt(microsecondsFromSeconds: Number.positiveInfinity) == nil)
        #expect(UInt(microsecondsFromSeconds: Number.nan) == nil)
        #expect(UInt(microsecondsFromSeconds: Number(UInt.max) / 1_000_000 + frac(1, 1_000_000)) == nil)
    }

    @Test
    func init_number_largest() {
        #expect(UInt(microsecondsFromSeconds: Number(UInt.max) / 1_000_000) == UInt.max)
    }

    @Test
    func init_number_roundsTiesToEven() {
        #expect(UInt(microsecondsFromSeconds: frac(1, 2_000_000)) == 0)
        #expect(UInt(microsecondsFromSeconds: frac(3, 2_000_000)) == 2)
        #expect(UInt(microsecondsFromSeconds: frac(5, 2_000_000)) == 2)
    }
}
