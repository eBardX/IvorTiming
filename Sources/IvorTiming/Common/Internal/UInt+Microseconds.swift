// © 2026 John Gary Pusey (see LICENSE.md)

internal import XestiNumbers

// Converts a number of seconds to a whole number of microseconds, the resolution of `WallTime`
// and `WallDuration`. Both forms round to the nearest microsecond, rounding ties to even, and
// fail if the seconds are negative, not finite, or too many microseconds to fit in a `UInt`.
extension UInt {

    // MARK: Internal Initializers

    internal init?(microsecondsFromSeconds seconds: Double) {
        guard seconds.isFinite,
              seconds >= 0
        else { return nil }

        let microseconds = (seconds * 1_000_000).rounded(.toNearestOrEven)

        //
        // `Double(UInt.max)` rounds up to exactly 2⁶⁴, so compare against that bound with `<`:
        //
        guard microseconds < 0x1p64
        else { return nil }

        self.init(microseconds)
    }

    internal init?(microsecondsFromSeconds seconds: Number) {
        guard seconds.isRational,
              !seconds.isNegative
        else { return nil }

        //
        // An inexact number is a floating-point value, so convert it as one. Making it exact
        // instead would approximate it by a simple fraction, which can be off by a microsecond
        // or more:
        //
        guard seconds.isExact
        else { self.init(microsecondsFromSeconds: seconds.doubleValue); return }

        //
        // `round(_:)` rounds ties to even, matching the `Double` form:
        //
        let microseconds = round(seconds * 1_000_000)

        guard microseconds <= Number(UInt.max)
        else { return nil }

        self.init(microseconds.uintValue)
    }
}
