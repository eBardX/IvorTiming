// © 2025–2026 John Gary Pusey (see LICENSE.md)

public import XestiNumbers
public import XestiTools

private import Foundation

/// A tempo in beats per minute, represented as a positive unsigned integer.
public struct Tempo {

    // MARK: Public Initializers

    /// Creates a tempo by parsing its plain string representation, returning `nil` if the string
    /// cannot be parsed or is out of range.
    ///
    /// - Parameter plain:  The plain string representation of the tempo (as produced by `plain`).
    public init?(plain: String) {
        guard let numberValue = try? Self.plainParseStrategy.parse(plain),
              numberValue.isExact,
              numberValue.isInteger,
              !numberValue.isNegative
        else { return nil }

        self.init(uintValue: numberValue.uintValue)
    }

    /// Creates a ``Tempo`` from an unsigned integer value.
    ///
    /// - Parameter uintValue:  The beats-per-minute value.
    ///
    /// - Returns:  A new ``Tempo``, or `nil` if `uintValue` is zero.
    public init?(uintValue: UInt) {
        guard Self.isValid(uintValue)
        else { return nil }

        self.uintValue = uintValue
    }

    // MARK: Public Instance Properties

    /// The tempo expressed as a beats-per-minute unsigned integer.
    public let uintValue: UInt
}

// MARK: -

extension Tempo {

    // MARK: Public Type Properties

    /// The default tempo of 60 beats per minute.
    public static let `default` = Self(60)

    // MARK: Public Type Methods

    /// Returns a Boolean value indicating whether the given unsigned integer is a valid tempo.
    ///
    /// - Parameter uintValue:  The unsigned integer to validate.
    ///
    /// - Returns:  `true` if `uintValue` is greater than zero; otherwise, `false`.
    public static func isValid(_ uintValue: UInt) -> Bool {
        uintValue > 0
    }

    // MARK: Public Instance Properties

    /// The tempo expressed as a `Double` beats-per-minute value.
    public var doubleValue: Double {
        Double(uintValue)
    }

    /// The tempo expressed as a `Number` beats-per-minute value.
    public var numberValue: Number {
        Number(uintValue)
    }

    /// The plain string representation of this tempo.
    public var plain: String {
        Self.plainFormatStyle.format(numberValue)
    }

    // MARK: Private Type Properties

    private static let plainFormatStyle = Number.FormatStyle(locale: plainLocale)
        .decimalPrecision(0)
        .fractionDisplay(strategy: .simple(alwaysShowDenominator: false))
        .grouping(false)

    private static let plainLocale = Locale(identifier: "en_US_POSIX")

    private static let plainParseStrategy = plainFormatStyle.parseStrategy
}

// MARK: - UIntRepresentable

extension Tempo: UIntRepresentable {
}
