// © 2025–2026 John Gary Pusey (see LICENSE.md)

public import XestiNumbers

extension WallTime {
    /// Returns a wall time advanced by a duration.
    ///
    /// - Parameter time:  The wall time to advance.
    /// - Parameter dur:   The wall duration to add.
    ///
    /// - Returns:  The wall time `dur` seconds after `time`.
    public static func + (time: Self,
                          dur: WallDuration) -> Self {
        WallTime(time.numberValue + dur.numberValue)
    }

    /// Advances a wall time by a duration in place.
    ///
    /// - Parameter time:  The wall time to update.
    /// - Parameter dur:   The wall duration to add.
    public static func += (time: inout Self,
                           dur: WallDuration) {
        time = time + dur
    }

    /// Returns a wall time retreated by a duration.
    ///
    /// - Parameter time:  The wall time to retreat.
    /// - Parameter dur:   The wall duration to subtract.
    ///
    /// - Returns:  The wall time `dur` seconds before `time`.
    public static func - (time: Self,
                          dur: WallDuration) -> Self {
        WallTime(time.numberValue - dur.numberValue)
    }

    /// Retreats a wall time by a duration in place.
    ///
    /// - Parameter time:  The wall time to update.
    /// - Parameter dur:   The wall duration to subtract.
    public static func -= (time: inout Self,
                           dur: WallDuration) {
        time = time - dur
    }

    /// Returns the duration between two wall times.
    ///
    /// - Parameter time1:  The first wall time.
    /// - Parameter time2:  The second wall time.
    ///
    /// - Returns:  The wall duration from `time2` to `time1`.
    public static func - (time1: Self,
                          time2: Self) -> WallDuration {
        WallDuration(time1.numberValue - time2.numberValue)
    }

    /// Returns a wall time scaled by a factor.
    ///
    /// - Parameter time:    The wall time to scale.
    /// - Parameter factor:  The scaling factor.
    ///
    /// - Returns:  The product of `time` and `factor`.
    public static func * (time: Self,
                          factor: Number) -> Self {
        WallTime(time.numberValue * factor)
    }

    /// Scales a wall time by a factor in place.
    ///
    /// - Parameter time:    The wall time to update.
    /// - Parameter factor:  The scaling factor.
    public static func *= (time: inout Self,
                           factor: Number) {
        time = time * factor
    }
}
