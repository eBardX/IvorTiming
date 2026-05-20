// © 2025–2026 John Gary Pusey (see LICENSE.md)

public import XestiNumbers

extension WallDuration {
    /// Returns the sum of two wall durations.
    ///
    /// - Parameter dur1:   The first wall duration.
    /// - Parameter dur2:   The second wall duration.
    ///
    /// - Returns:  The sum of `dur1` and `dur2`.
    public static func + (dur1: Self,
                          dur2: Self) -> Self {
        WallDuration(dur1.numberValue + dur2.numberValue)
    }

    /// Adds a wall duration to another in place.
    ///
    /// - Parameter dur1:   The wall duration to update.
    /// - Parameter dur2:   The wall duration to add.
    public static func += (dur1: inout Self,
                           dur2: Self) {
        dur1 = dur1 + dur2
    }

    /// Returns the difference of two wall durations.
    ///
    /// - Parameter dur1:   The wall duration to subtract from.
    /// - Parameter dur2:   The wall duration to subtract.
    ///
    /// - Returns:  The difference of `dur1` and `dur2`.
    public static func - (dur1: Self,
                          dur2: Self) -> Self {
        WallDuration(dur1.numberValue - dur2.numberValue)
    }

    /// Subtracts a wall duration from another in place.
    ///
    /// - Parameter dur1:   The wall duration to update.
    /// - Parameter dur2:   The wall duration to subtract.
    public static func -= (dur1: inout Self,
                           dur2: Self) {
        dur1 = dur1 - dur2
    }

    /// Returns this wall duration scaled by a factor.
    ///
    /// - Parameter dur:     The wall duration to scale.
    /// - Parameter factor:  The scaling factor.
    ///
    /// - Returns:  The product of `dur` and `factor`.
    public static func * (dur: Self,
                          factor: Number) -> Self {
        WallDuration(dur.numberValue * factor)
    }

    /// Scales this wall duration by a factor in place.
    ///
    /// - Parameter dur:     The wall duration to update.
    /// - Parameter factor:  The scaling factor.
    public static func *= (dur: inout Self,
                           factor: Number) {
        dur = dur * factor
    }
}
