// © 2025–2026 John Gary Pusey (see LICENSE.md)

public import XestiNumbers

extension BeatDuration {
    /// Returns the sum of two beat durations.
    ///
    /// - Parameter dur1:   The first beat duration.
    /// - Parameter dur2:   The second beat duration.
    ///
    /// - Returns:  The sum of `dur1` and `dur2`.
    public static func + (dur1: Self,
                          dur2: Self) -> Self {
        BeatDuration(dur1.numberValue + dur2.numberValue)
    }

    /// Adds a beat duration to another in place.
    ///
    /// - Parameter dur1:   The beat duration to update.
    /// - Parameter dur2:   The beat duration to add.
    public static func += (dur1: inout Self,
                           dur2: Self) {
        dur1 = dur1 + dur2
    }

    /// Returns the difference of two beat durations.
    ///
    /// - Parameter dur1:   The beat duration to subtract from.
    /// - Parameter dur2:   The beat duration to subtract.
    ///
    /// - Returns:  The difference of `dur1` and `dur2`.
    public static func - (dur1: Self,
                          dur2: Self) -> Self {
        BeatDuration(dur1.numberValue - dur2.numberValue)
    }

    /// Subtracts a beat duration from another in place.
    ///
    /// - Parameter dur1:   The beat duration to update.
    /// - Parameter dur2:   The beat duration to subtract.
    public static func -= (dur1: inout Self,
                           dur2: Self) {
        dur1 = dur1 - dur2
    }

    /// Returns this beat duration scaled by a factor.
    ///
    /// - Parameter dur:     The beat duration to scale.
    /// - Parameter factor:  The scaling factor.
    ///
    /// - Returns:  The product of `dur` and `factor`.
    public static func * (dur: Self,
                          factor: Number) -> Self {
        BeatDuration(dur.numberValue * factor)
    }

    /// Scales this beat duration by a factor in place.
    ///
    /// - Parameter dur:     The beat duration to update.
    /// - Parameter factor:  The scaling factor.
    public static func *= (dur: inout Self,
                           factor: Number) {
        dur = dur * factor
    }
}
