// © 2025–2026 John Gary Pusey (see LICENSE.md)

public import XestiNumbers
public import XestiTools

private import Foundation

/// A non-negative duration of wall-clock time, measured in microseconds.
public struct WallDuration {

    // MARK: Public Initializers

    /// Creates a ``WallDuration`` from a number of seconds, rounded to the nearest microsecond.
    ///
    /// A value exactly halfway between two microseconds rounds to the even one.
    ///
    /// - Parameter doubleValue:    The number of seconds.
    ///
    /// - Returns:  A new ``WallDuration``, or `nil` if `doubleValue` is negative, infinite, or NaN,
    ///             or is too large to represent.
    public init?(doubleValue: Double) {
        guard let uintValue = UInt(microsecondsFromSeconds: doubleValue)
        else { return nil }

        self.uintValue = uintValue
    }

    /// Creates a ``WallDuration`` from a rational number of seconds, rounded to the nearest
    /// microsecond.
    ///
    /// A value exactly halfway between two microseconds rounds to the even one.
    ///
    /// - Parameter numberValue:    The number of seconds.
    ///
    /// - Returns:  A new ``WallDuration``, or `nil` if `numberValue` is negative or not rational, or
    ///             is too large to represent.
    public init?(numberValue: Number) {
        guard let uintValue = UInt(microsecondsFromSeconds: numberValue)
        else { return nil }

        self.uintValue = uintValue
    }

    /// Creates a wall duration by parsing its plain string representation, returning `nil` if the
    /// string cannot be parsed or is out of range.
    ///
    /// - Parameter plain:  The plain string representation of the wall duration, in seconds (as
    ///                     produced by `plain`).
    public init?(plain: String) {
        guard let numberValue = try? Self.plainParseStrategy.parse(plain)
        else { return nil }

        self.init(numberValue: numberValue)
    }

    /// Creates a ``WallDuration`` from a microsecond count.
    ///
    /// - Parameter uintValue:  The number of microseconds.
    ///
    /// - Returns:  A new ``WallDuration``. This initializer never returns `nil`; it is
    ///             failable only to satisfy the `UIntRepresentable` requirement.
    public init?(uintValue: UInt) {
        self.uintValue = uintValue
    }

    // MARK: Public Instance Properties

    /// The number of microseconds representing this duration.
    public let uintValue: UInt

    // MARK: Internal Initializers

    //
    // For internal callers whose seconds are valid by construction. Rounds as
    // `init?(doubleValue:)` does, but traps rather than returning `nil`.
    //
    internal init(seconds: Double) {
        guard let value = Self(doubleValue: seconds)
        else { preconditionFailure("Invalid wall duration: \(seconds) seconds") }

        self = value
    }
}

// MARK: -

extension WallDuration {

    // MARK: Public Type Properties

    /// The zero wall duration.
    public static let zero = Self(0)

    // MARK: Public Instance Properties

    /// The number of seconds representing this duration.
    public var doubleValue: Double {
        Double(uintValue) / 1_000_000
    }

    /// The number of seconds representing this duration, as a `Number`.
    public var numberValue: Number {
        Number(uintValue) / 1_000_000
    }

    /// The plain string representation of this wall duration, in seconds, omitting trailing zero
    /// decimal digits.
    public var plain: String {
        Self.plainFormatStyle.format(numberValue)
    }

    // MARK: Private Type Properties

    private static let plainFormatStyle = Number.FormatStyle(locale: plainLocale)
        .decimalPrecision(0...6)
        .fractionDisplay(strategy: .decimal)
        .grouping(false)

    private static let plainLocale = Locale(identifier: "en_US_POSIX")

    private static let plainParseStrategy = plainFormatStyle.parseStrategy
}

// MARK: - CustomStringConvertible

extension WallDuration: CustomStringConvertible {

    // MARK: Public Instance Properties

    /// The plain string representation of this wall duration.
    public var description: String {
        plain
    }
}

// MARK: - DurationProtocol

extension WallDuration: DurationProtocol {

    // MARK: Public Instance Properties

    /// A Boolean value indicating whether this duration is zero.
    public var isZero: Bool {
        self == .zero
    }

    // MARK: Public Instance Methods

    /// Returns the sum of this wall duration and another.
    ///
    /// - Parameter other:  The wall duration to add.
    ///
    /// - Returns:  The sum, or `nil` if the result is not a valid wall
    ///             duration.
    public func adding(_ other: Self) -> Self? {
        let (result, overflow) = uintValue.addingReportingOverflow(other.uintValue)

        return overflow ? nil : Self(uintValue: result)
    }

    /// Returns this wall duration divided by a factor.
    ///
    /// - Parameter factor:  The divisor.
    ///
    /// - Returns:  The quotient, or `nil` if the result is not a valid wall
    ///             duration.
    public func divided(by factor: Number) -> Self? {
        guard !factor.isZero
        else { return nil }

        return Self(doubleValue: doubleValue / factor.doubleValue)
    }

    /// Returns this wall duration multiplied by a factor.
    ///
    /// - Parameter factor:  The multiplier.
    ///
    /// - Returns:  The product, or `nil` if the result is not a valid wall
    ///             duration.
    public func multiplied(by factor: Number) -> Self? {
        Self(doubleValue: doubleValue * factor.doubleValue)
    }

    /// Returns the result of subtracting another wall duration from this
    /// duration.
    ///
    /// - Parameter other:  The wall duration to subtract.
    ///
    /// - Returns:  The difference, or `nil` if the result is not a valid wall
    ///             duration.
    public func subtracting(_ other: Self) -> Self? {
        guard uintValue >= other.uintValue
        else { return nil }

        return Self(uintValue: uintValue - other.uintValue)
    }
}

// MARK: - UIntRepresentable

extension WallDuration: UIntRepresentable {
}
