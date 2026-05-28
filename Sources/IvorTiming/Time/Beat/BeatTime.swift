// © 2025–2026 John Gary Pusey (see LICENSE.md)

public import XestiNumbers
public import XestiTools

/// A point in musical beat time, measured in beats from a reference position.
public struct BeatTime: NumberRepresentable {

    // MARK: Public Type Properties

    /// The zero beat time.
    public static let zero = Self(0)

    // MARK: Public Type Methods

    /// Returns a Boolean value indicating whether the given number is a valid
    /// beat time.
    ///
    /// - Parameter numberValue:    The number to validate.
    ///
    /// - Returns:  `true` if `numberValue` is rational and non-negative;
    ///             otherwise, `false`.
    public static func isValid(_ numberValue: Number) -> Bool {
        numberValue.isRational && !numberValue.isNegative
    }

    // MARK: Public Initializers

    /// Creates a ``BeatTime`` from a rational number value.
    ///
    /// - Parameter numberValue:    The rational number of beats.
    ///
    /// - Returns:  A new ``BeatTime``, or `nil` if `numberValue` is not a valid
    ///             beat time.
    public init?(numberValue: Number) {
        guard Self.isValid(numberValue)
        else { return nil }

        self.numberValue = numberValue
    }

    // MARK: Public Instance Properties

    /// The rational number of beats representing this time.
    public let numberValue: Number
}

// MARK: - InterpolatableKey

extension BeatTime: InterpolatableKey {
    /// Returns the fractional position of this beat time between two boundary
    /// times.
    ///
    /// - Parameter startValue:  The lower boundary beat time.
    /// - Parameter endValue:    The upper boundary beat time.
    ///
    /// - Returns:  The fraction in the unit interval `[0, 1]` representing
    ///             this time’s position between `startValue` and `endValue`.
    public func fraction(from startValue: Self,
                         through endValue: Self) -> Double {
        (doubleValue - startValue.doubleValue) / (endValue.doubleValue - startValue.doubleValue)
    }
}

// MARK: - TimeProtocol

extension BeatTime: TimeProtocol {

    // MARK: Public Type Aliases

    /// The duration type for a beat time.
    public typealias DurationType = BeatDuration

    // MARK: Public Instance Methods

    /// Returns the directed duration from this beat time to another.
    ///
    /// - Parameter time:   The destination beat time.
    ///
    /// - Returns:  A ``DirectedDuration`` representing the distance and
    ///             direction from this beat time to `time`, or `nil` if the
    ///             result cannot be computed.
    public func duration(to time: Self) -> DirectedDuration<DurationType>? {
        let val1 = numberValue
        let val2 = time.numberValue

        if val1 < val2 {
            return DirectedDuration(duration: BeatDuration(val2 - val1),
                                    direction: .forward)
        }

        if val1 > val2 {
            return DirectedDuration(duration: BeatDuration(val1 - val2),
                                    direction: .backward)
        }

        return DirectedDuration(duration: .zero,
                                direction: .same)
    }

    /// Returns the beat time obtained by moving this time by a directed
    /// duration.
    ///
    /// - Parameter directedDuration: The directed duration to move by.
    ///
    /// - Returns:  The resulting beat time, or `nil` if the result is invalid.
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
