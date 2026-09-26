// © 2025–2026 John Gary Pusey (see LICENSE.md)

public import XestiNumbers

extension BeatTime {

    // MARK: Public Type Methods

    /// Returns a beat time scaled by a factor.
    ///
    /// - Parameter time:    The beat time to scale.
    /// - Parameter factor:  The scaling factor.
    ///
    /// - Returns:  The product of `time` and `factor`.
    ///
    /// - Precondition: `factor` must be rational and non-negative.
    public static func * (time: Self,
                          factor: Number) -> Self {
        BeatTime(time.numberValue * factor)
    }

    /// Scales a beat time by a factor in place.
    ///
    /// - Parameter time:    The beat time to update.
    /// - Parameter factor:  The scaling factor.
    ///
    /// - Precondition: `factor` must be rational and non-negative.
    public static func *= (time: inout Self,
                           factor: Number) {
        time = time * factor
    }

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
    ///
    /// - Precondition: `dur` must not exceed `time`.
    public static func - (time: Self,
                          dur: BeatDuration) -> Self {
        BeatTime(time.numberValue - dur.numberValue)
    }

    /// Returns the duration between two beat times.
    ///
    /// - Parameter time1:  The first beat time.
    /// - Parameter time2:  The second beat time.
    ///
    /// - Returns:  The beat duration from `time2` to `time1`.
    ///
    /// - Precondition: `time2` must not be later than `time1`.
    public static func - (time1: Self,
                          time2: Self) -> BeatDuration {
        BeatDuration(time1.numberValue - time2.numberValue)
    }

    /// Retreats a beat time by a duration in place.
    ///
    /// - Parameter time:  The beat time to update.
    /// - Parameter dur:   The beat duration to subtract.
    ///
    /// - Precondition: `dur` must not exceed `time`.
    public static func -= (time: inout Self,
                           dur: BeatDuration) {
        time = time - dur
    }
}
