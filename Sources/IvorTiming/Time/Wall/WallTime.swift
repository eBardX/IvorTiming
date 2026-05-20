// © 2025–2026 John Gary Pusey (see LICENSE.md)

public import XestiNumbers
public import XestiTools

/// A point in wall-clock time, measured in seconds from a reference epoch.
public struct WallTime: NumberRepresentable {

    // MARK: Public Type Properties

    /// The zero wall time.
    public static let zero = Self(0)

    // MARK: Public Type Methods

    /// Returns a Boolean value indicating whether the given number is a valid
    /// wall time.
    ///
    /// - Parameter numberValue:    The number to validate.
    ///
    /// - Returns:  `true` if `numberValue` is rational and non-negative;
    ///             otherwise, `false`.
    public static func isValid(_ numberValue: Number) -> Bool {
        numberValue.isRational && !numberValue.isNegative
    }

    // MARK: Public Initializers

    /// Creates a ``WallTime`` from a rational number value.
    ///
    /// - Parameter numberValue:    The rational number of seconds.
    ///
    /// - Returns:  A new ``WallTime``, or `nil` if `numberValue` is not a valid
    ///             wall time.
    public init?(numberValue: Number) {
        guard Self.isValid(numberValue)
        else { return nil }

        self.numberValue = numberValue
    }

    // MARK: Public Instance Properties

    /// The rational number of seconds representing this time.
    public let numberValue: Number
}

// MARK: - InterpolatableKey

extension WallTime: InterpolatableKey {
    /// Returns the fractional position of this time between two boundary times.
    ///
    /// - Parameter startValue:  The lower boundary time.
    /// - Parameter endValue:    The upper boundary time.
    ///
    /// - Returns:  The fraction in the unit interval `[0, 1]` representing this
    ///             time’s position between `startValue` and `endValue`.
    public func fraction(from startValue: Self,
                         through endValue: Self) -> Double {
        (doubleValue - startValue.doubleValue) / (endValue.doubleValue - startValue.doubleValue)
    }
}

// MARK: - TimeProtocol

extension WallTime: TimeProtocol {

    // MARK: Public Type Aliases

    /// The duration type for a wall time.
    public typealias DurationType = WallDuration

    // MARK: Public Instance Methods

    /// Returns the directed duration from this wall time to another.
    ///
    /// - Parameter time:   The destination wall time.
    ///
    /// - Returns:  A ``DirectedDuration`` representing the distance and
    ///             direction from this wall time to `time`.
    public func duration(to time: Self) -> DirectedDuration<DurationType>? {
        let val1 = numberValue
        let val2 = time.numberValue

        if val1 < val2 {
            return DirectedDuration(duration: WallDuration(val2 - val1),
                                    direction: .forward)
        }

        if val1 > val2 {
            return DirectedDuration(duration: WallDuration(val1 - val2),
                                    direction: .backward)
        }

        return DirectedDuration(duration: .zero,
                                direction: .same)
    }

    /// Returns the wall time obtained by moving this time by a directed
    /// duration.
    ///
    /// - Parameter directedDuration: The directed duration to move by.
    ///
    /// - Returns:  The resulting wall time, or `nil` if the result is invalid.
    public func moved(by directedDuration: DirectedDuration<DurationType>) -> Self? {
        switch directedDuration.direction {
        case .forward:
            Self(numberValue: numberValue + directedDuration.duration.numberValue)

        case .backward:
            Self(numberValue: numberValue - directedDuration.duration.numberValue)

        case .same:
            self
        }
    }
}
