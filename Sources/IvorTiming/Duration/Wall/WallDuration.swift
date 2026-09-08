// © 2025–2026 John Gary Pusey (see LICENSE.md)

public import XestiNumbers
public import XestiTools

private import Foundation

/// A non-negative duration of wall-clock time, measured in milliseconds.
public struct WallDuration {

    // MARK: Public Initializers

    /// Creates a wall duration by parsing its plain string representation, returning `nil` if the
    /// string cannot be parsed or is out of range.
    ///
    /// - Parameter plain:  The plain string representation of the wall duration, in seconds (as
    ///                     produced by `plain`).
    public init?(plain: String) {
        guard let numberValue = try? Self.plainParseStrategy.parse(plain)
        else { return nil }

        self.init(seconds: numberValue.doubleValue)
    }

    /// Creates a ``WallDuration`` from a millisecond count.
    ///
    /// - Parameter uintValue:  The number of milliseconds.
    public init?(uintValue: UInt) {
        self.uintValue = uintValue
    }

    // MARK: Public Instance Properties

    /// The number of milliseconds representing this duration.
    public let uintValue: UInt
}

// MARK: -

extension WallDuration {

    // MARK: Public Type Properties

    /// The zero wall duration.
    public static let zero = Self(0)

    // MARK: Public Instance Properties

    /// The number of seconds representing this duration.
    public var doubleValue: Double {
        Double(uintValue) / 1_000
    }

    public var numberValue: Number {
        Number(Double(uintValue) / 1_000)
    }

    /// The plain string representation of this wall duration, in seconds, omitting trailing zero
    /// decimal digits.
    public var plain: String {
        Self.plainFormatStyle.format(numberValue)
    }

    // MARK: Internal Initializers

    // Rounds to the nearest millisecond.
    internal init(seconds: Double) {
        self.init(uintValue: UInt((max(seconds, 0) * 1_000).rounded()))!    // swiftlint:disable:this force_unwrapping
    }

    // MARK: Private Type Properties

    private static let plainFormatStyle = Number.FormatStyle(locale: plainLocale)
        .decimalPrecision(0...3)
        .fractionDisplay(strategy: .simple(alwaysShowDenominator: false))
        .grouping(false)

    private static let plainLocale = Locale(identifier: "en_US_POSIX")

    private static let plainParseStrategy = plainFormatStyle.parseStrategy
}

// MARK: - CustomStringConvertible

extension WallDuration {

    // MARK: Public Instance Properties

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

        return Self(seconds: doubleValue / factor.doubleValue)
    }

    /// Returns this wall duration multiplied by a factor.
    ///
    /// - Parameter factor:  The multiplier.
    ///
    /// - Returns:  The product, or `nil` if the result is not a valid wall
    ///             duration.
    public func multiplied(by factor: Number) -> Self? {
        Self(seconds: doubleValue * factor.doubleValue)
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
