// © 2025–2026 John Gary Pusey (see LICENSE.md)

public import XestiNumbers

private import Foundation

/// A tempo: a positive, exact rational rate per minute of a stated note value (the tempo’s
/// *unit*).
///
/// A tempo is stored the way a score states it. For example, ♩. = 90 is a rate of 90 with a unit
/// of 3/8 (a dotted quarter note, in whole notes). Its speed in whole notes per minute,
/// ``numberValue``, is the rate multiplied by the unit: here, 135/4.
///
/// Equality is *notational*: ♩. = 90 and ♩ = 135 have the same speed, but they’re written
/// differently, so they aren’t equal. Compare speeds with ``numberValue``.
public struct Tempo {

    // MARK: Public Initializers

    /// Creates a tempo from a whole-number rate and a unit.
    ///
    /// This initializer is meant for literals, such as `Tempo(120)` for ♩ = 120.
    ///
    /// - Parameter rate:   The number of units per minute.
    /// - Parameter unit:   The note value the rate counts, in whole notes. Defaults to a quarter
    ///                     note.
    ///
    /// - Precondition: `rate` is greater than zero, and `unit` is positive.
    public init(_ rate: UInt,
                unit: BeatDuration = .quarter) {
        precondition(Self._isValid(rate: Number(rate),
                                   unit: unit),
                     "Invalid tempo: \(rate) per \(unit.numberValue)")

        self.init(uncheckedRate: Number(rate),
                  unit: unit)
    }

    /// Creates a tempo by parsing its plain string representation, returning `nil` if the string
    /// cannot be parsed or is out of range.
    ///
    /// The string has the form `<unit>=<rate>`, as produced by ``plain``, such as `1/4=60` or
    /// `3/8=200/3`. A bare rate, such as `90`, means a quarter-note unit. Each number may be an
    /// integer, a fraction (`200/3`), a mixed number (`66 2/3`), or an exact decimal (`66.5`).
    ///
    /// - Parameter plain:  The plain string representation of the tempo.
    public init?(plain: String) {
        let parts = plain.split(separator: Self.plainSeparator,
                                omittingEmptySubsequences: false)

        let unit: BeatDuration
        let rateText: Substring

        switch parts.count {
        case 1:
            unit = .quarter
            rateText = parts[0]

        case 2:
            guard let unitValue = Self._parseExactNumber(parts[0]),
                  let parsedUnit = BeatDuration(numberValue: unitValue)
            else { return nil }

            unit = parsedUnit
            rateText = parts[1]

        default:
            return nil
        }

        guard let rate = Self._parseExactNumber(rateText)
        else { return nil }

        self.init(rate: rate,
                  unit: unit)
    }

    /// Creates a tempo from a rate and a unit, returning `nil` if either is out of range.
    ///
    /// - Parameter rate:   The number of units per minute. Must be a positive, exact rational
    ///                     number.
    /// - Parameter unit:   The note value the rate counts, in whole notes. Must be positive.
    ///                     Defaults to a quarter note.
    public init?(rate: Number,
                 unit: BeatDuration = .quarter) {
        guard Self._isValid(rate: rate,
                            unit: unit)
        else { return nil }

        self.init(uncheckedRate: rate,
                  unit: unit)
    }

    // MARK: Public Instance Properties

    /// The number of units per minute, as a positive, exact rational number. For example, 90 for
    /// ♩. = 90.
    public let rate: Number

    /// The note value the rate counts, in whole notes. For example, 3/8 for ♩. = 90.
    public let unit: BeatDuration

    // MARK: Internal Initializers

    internal init(uncheckedRate rate: Number,
                  unit: BeatDuration) {
        self.rate = rate
        self.unit = unit
    }
}

// MARK: -

extension Tempo {

    // MARK: Public Type Properties

    /// The default tempo, ♩ = 60.
    public static let `default` = Self(60)

    // MARK: Public Instance Properties

    /// The speed of this tempo in whole notes per minute, as a `Double`.
    public var doubleValue: Double {
        numberValue.doubleValue
    }

    /// The speed of this tempo in whole notes per minute: ``rate`` × ``unit``.
    ///
    /// For example, ♩. = 90 has a speed of 135/4, and ♩ = 60 has a speed of 15.
    public var numberValue: Number {
        rate * unit.numberValue
    }

    /// The plain string representation of this tempo, in the form `<unit>=<rate>`.
    ///
    /// For example, `1/4=60` for ♩ = 60, and `3/8=200/3` for ♩. = 66⅔.
    public var plain: String {
        Self.plainFormatStyle.format(unit.numberValue)
            + String(Self.plainSeparator)
            + Self.plainFormatStyle.format(rate)
    }

    // MARK: Public Instance Methods

    /// Returns this tempo restated in another unit, at the same speed.
    ///
    /// For example, ♩. = 90 restated in eighth notes is ♪ = 270.
    ///
    /// - Parameter unit:   The note value the restated tempo counts, in whole notes.
    ///
    /// - Returns:  A tempo with the given unit and the same ``numberValue`` as this tempo.
    ///
    /// - Precondition: `unit` is positive.
    public func restated(in unit: BeatDuration) -> Self {
        precondition(unit.numberValue.isPositive,
                     "Invalid tempo unit: \(unit.numberValue)")

        return Self(uncheckedRate: numberValue / unit.numberValue,
                    unit: unit)
    }

    /// Returns this tempo with its unit multiplied by a factor, at the same rate.
    ///
    /// The speed scales by the same factor. For example, ♪ = 240 with its unit scaled by 2 is
    /// ♩ = 240.
    ///
    /// - Parameter factor:   The factor to multiply the unit by. Must be a positive rational
    ///                       number.
    ///
    /// - Returns:  The scaled tempo, or `nil` if `factor` isn’t a positive rational number.
    public func scaled(unitBy factor: Number) -> Self? {
        guard factor.isRational,
              factor.isPositive,
              let newUnit = unit.multiplied(by: factor)
        else { return nil }

        return Self(rate: rate,
                    unit: newUnit)
    }

    // MARK: Private Type Properties

    private static let plainFormatStyle = Number.FormatStyle(locale: plainLocale)
        .decimalPrecision(0...3)
        .fractionDisplay(strategy: .simple(alwaysShowDenominator: false))
        .grouping(false)

    private static let plainLocale = Locale(identifier: "en_US_POSIX")

    //
    // The mixed strategy's parser accepts integers, simple fractions and mixed numbers alike.
    //
    private static let plainParseStrategy = Number.FormatStyle(locale: plainLocale)
        .fractionDisplay(strategy: .mixed(alwaysShowInteger: false))
        .grouping(false)
        .parseStrategy

    private static let plainSeparator: Character = "="

    // MARK: Private Type Methods

    private static func _isValid(rate: Number,
                                 unit: BeatDuration) -> Bool {
        rate.isExact
            && rate.isRational
            && rate.isPositive
            && unit.numberValue.isPositive
    }

    //
    // An exact decimal (“66.5”) is read digit by digit so that it stays exact. The parse strategy
    // would read it as a floating-point number.
    //
    private static func _parseExactDecimal(_ text: String) -> Number? {
        let parts = text.split(separator: ".",
                               omittingEmptySubsequences: false)

        guard parts.count == 2,
              !parts[0].isEmpty,
              !parts[1].isEmpty,
              parts.allSatisfy({ $0.allSatisfy { $0.isASCII && $0.isNumber } }),
              let digits = Number(parts[0] + parts[1])
        else { return nil }

        var scale = Number(1)

        for _ in parts[1] {
            scale *= 10
        }

        return digits / scale
    }

    private static func _parseExactNumber(_ text: Substring) -> Number? {
        let trimmed = text.trimmingCharacters(in: .whitespaces)

        if let value = _parseExactDecimal(trimmed) {
            return value
        }

        guard let value = try? plainParseStrategy.parse(trimmed),
              value.isExact
        else { return nil }

        return value
    }
}

// MARK: - Codable

extension Tempo: Codable {

    // MARK: Public Initializers

    /// Creates a tempo by decoding its plain string representation from the provided decoder.
    ///
    /// - Parameter decoder:    The decoder to read from.
    ///
    /// - Throws:   `DecodingError` if the encoded data isn’t a valid plain string representation
    ///             of a tempo.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let plain = try container.decode(String.self)

        guard let tempo = Self(plain: plain)
        else { throw DecodingError.dataCorruptedError(in: container,
                                                      debugDescription: "Invalid tempo: \(plain)") }

        self = tempo
    }

    // MARK: Public Instance Methods

    /// Encodes the plain string representation of this tempo into the provided encoder.
    ///
    /// - Parameter encoder:    The encoder to write to.
    ///
    /// - Throws:   `EncodingError` if the value can’t be encoded.
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()

        try container.encode(plain)
    }
}

// MARK: - CustomStringConvertible

extension Tempo: CustomStringConvertible {

    // MARK: Public Instance Properties

    /// A textual representation of this tempo: its plain string representation.
    public var description: String {
        plain
    }
}

// MARK: - Hashable

extension Tempo: Hashable {
}

// MARK: - Sendable

extension Tempo: Sendable {
}
