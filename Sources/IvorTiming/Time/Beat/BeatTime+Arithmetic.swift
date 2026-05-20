// © 2025–2026 John Gary Pusey (see LICENSE.md)

public import XestiNumbers

extension BeatTime {
    /// Returns a beat time advanced by a duration.
    ///
    /// - Parameter time:  The beat time to advance.
    /// - Parameter dur:   The beat duration to add.
    ///
    /// - Returns:  The beat time `dur` beats after `time`.
    public static func + (time: Self,
                          dur: BeatDuration) -> Self {
        BeatTime(time.numberValue + dur.numberValue)
    }

    /// Advances a beat time by a duration in place.
    ///
    /// - Parameter time:  The beat time to update.
    /// - Parameter dur:   The beat duration to add.
    public static func += (time: inout Self,
                           dur: BeatDuration) {
        time = time + dur
    }

    /// Returns a beat time retreated by a duration.
    ///
    /// - Parameter time:  The beat time to retreat.
    /// - Parameter dur:   The beat duration to subtract.
    ///
    /// - Returns:  The beat time `dur` beats before `time`.
    public static func - (time: Self,
                          dur: BeatDuration) -> Self {
        BeatTime(time.numberValue - dur.numberValue)
    }

    /// Retreats a beat time by a duration in place.
    ///
    /// - Parameter time:  The beat time to update.
    /// - Parameter dur:   The beat duration to subtract.
    public static func -= (time: inout Self,
                           dur: BeatDuration) {
        time = time - dur
    }

    /// Returns the duration between two beat times.
    ///
    /// - Parameter time1:  The first beat time.
    /// - Parameter time2:  The second beat time.
    ///
    /// - Returns:  The beat duration from `time2` to `time1`.
    public static func - (time1: Self,
                          time2: Self) -> BeatDuration {
        BeatDuration(time1.numberValue - time2.numberValue)
    }

    /// Returns a beat time scaled by a factor.
    ///
    /// - Parameter time:    The beat time to scale.
    /// - Parameter factor:  The scaling factor.
    ///
    /// - Returns:  The product of `time` and `factor`.
    public static func * (time: Self,
                          factor: Number) -> Self {
        BeatTime(time.numberValue * factor)
    }

    /// Scales a beat time by a factor in place.
    ///
    /// - Parameter time:    The beat time to update.
    /// - Parameter factor:  The scaling factor.
    public static func *= (time: inout Self,
                           factor: Number) {
        time = time * factor
    }
}
