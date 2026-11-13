// © 2025–2026 John Gary Pusey (see LICENSE.md)

public import Foundation

private import XestiNumbers

extension Tempo {

    // MARK: Public Nested Types

    /// A format style that produces an attributed string representation of a ``Tempo`` value’s
    /// rate.
    ///
    /// Only the rate is formatted, rounded to the nearest whole number, with halves rounding up:
    /// ♩. = 66⅔ formats as `67`, and ♩ = 67½ as `68`. The unit isn’t included; draw it as a note
    /// value in front of the rate.
    public struct FormatStyle {

        // MARK: Public Initializers

        /// Creates a format style with the given locale.
        ///
        /// - Parameter locale:     The locale to use for formatting. Defaults to `.autoupdatingCurrent`.
        public init(locale: Locale = .autoupdatingCurrent) {
            self.baseStyle = Number.FormatStyle(locale: locale)
                .decimalPrecision(0)
                .fractionDisplay(strategy: .simple(alwaysShowDenominator: false))
                .attributed
            self.locale = locale
        }

        // MARK: Public Instance Properties

        /// The locale used for formatting.
        public let locale: Locale

        // MARK: Private Instance Properties

        private let baseStyle: Number.FormatStyle.Attributed
    }
}

// MARK: - FormatStyle

extension Tempo.FormatStyle: FormatStyle {

    // MARK: Public Instance Methods

    /// Returns an attributed string representation of the given tempo’s rate, rounded to the
    /// nearest whole number (halves round up).
    ///
    /// - Parameter value:  The ``Tempo`` value to format.
    ///
    /// - Returns:  An attributed string representation of the rounded rate of `value`.
    public func format(_ value: Tempo) -> AttributedString {
        baseStyle.format(floor(value.rate + Number(numerator: 1, denominator: 2)))
    }
}

// MARK: -

extension Tempo {

    // MARK: Public Instance Methods

    /// Returns an attributed string representation of this tempo’s rate using the default format
    /// style.
    public func formatted() -> AttributedString {
        FormatStyle().format(self)
    }
}
