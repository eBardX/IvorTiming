// © 2025–2026 John Gary Pusey (see LICENSE.md)

public import XestiNumbers

/// A non-negative duration measured in musical beats.
public struct BeatDuration: NumberRepresentable {

    // MARK: Public Type Properties

    /// The zero beat duration.
    public static let zero = Self(0)

    // MARK: Public Type Methods

    /// Returns a Boolean value indicating whether the given number is a valid
    /// beat duration.
    ///
    /// - Parameter numberValue:    The number to validate.
    ///
    /// - Returns:  `true` if `numberValue` is rational and non-negative;
    ///             otherwise, `false`.
    public static func isValid(_ numberValue: Number) -> Bool {
        numberValue.isRational && !numberValue.isNegative
    }

    // MARK: Public Initializers

    /// Creates a ``BeatDuration`` from a rational number value.
    ///
    /// - Parameter numberValue:    The rational number of beats.
    ///
    /// - Returns:  A new ``BeatDuration``, or `nil` if `numberValue` is not
    ///             a valid beat duration.
    public init?(numberValue: Number) {
        guard Self.isValid(numberValue)
        else { return nil }

        self.numberValue = numberValue
    }

    // MARK: Public Instance Properties

    /// The rational number of beats representing this duration.
    public let numberValue: Number
}

// MARK: - DurationProtocol

extension BeatDuration: DurationProtocol {

    // MARK: Public Instance Properties

    /// Returns a Boolean value indicating whether this duration is zero.
    public var isZero: Bool {
        self == .zero
    }

    // MARK: Public Instance Methods

    /// Returns the sum of this beat duration and another.
    ///
    /// - Parameter other:  The beat duration to add.
    ///
    /// - Returns:  The sum, or `nil` if the result is not a valid beat
    ///             duration.
    public func adding(_ other: Self) -> Self? {
        Self(numberValue: numberValue + other.numberValue)
    }

    /// Returns this beat duration divided by a factor.
    ///
    /// - Parameter factor:  The divisor.
    ///
    /// - Returns:  The quotient, or `nil` if the result is not a valid beat
    ///             duration.
    public func divided(by factor: Number) -> Self? {
        Self(numberValue: numberValue / factor)
    }

    /// Returns this beat duration multiplied by a factor.
    ///
    /// - Parameter factor:  The multiplier.
    ///
    /// - Returns:  The product, or `nil` if the result is not a valid beat
    ///             duration.
    public func multiplied(by factor: Number) -> Self? {
        Self(numberValue: numberValue * factor)
    }

    /// Returns the result of subtracting another beat duration from this
    /// duration.
    ///
    /// - Parameter other:  The beat duration to subtract.
    ///
    /// - Returns:  The difference, or `nil` if the result is not a valid beat
    ///             duration.
    public func subtracting(_ other: Self) -> Self? {
        Self(numberValue: numberValue - other.numberValue)
    }
}
