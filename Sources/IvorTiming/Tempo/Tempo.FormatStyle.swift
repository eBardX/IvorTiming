// © 2025–2026 John Gary Pusey (see LICENSE.md)

public import Foundation

private import XestiNumbers

extension Tempo {

    // MARK: Public Nested Types

    /// A format style that produces an attributed string representation of a ``Tempo`` value.
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

    /// Returns an attributed string representation of the given tempo.
    ///
    /// - Parameter value:  The ``Tempo`` value to format.
    ///
    /// - Returns:  An `AttributedString` representation of the tempo’s numeric value.
    public func format(_ value: Tempo) -> AttributedString {
        baseStyle.format(value.numberValue)
    }
}

// MARK: -

extension Tempo {
    /// Returns an attributed string representation of this tempo using the default format style.
    ///
    /// - Returns:  An `AttributedString` representation of the tempo.
    public func formatted() -> AttributedString {
        FormatStyle().format(self)
    }
}
