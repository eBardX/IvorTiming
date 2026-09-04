// © 2025–2026 John Gary Pusey (see LICENSE.md)

public import XestiTools

private import Foundation

extension TempoMap {

    // MARK: Public Nested Types

    /// A stable identity for a single entry in a ``TempoMap``, represented as a
    /// validated string.
    ///
    /// An entry's beat time, tempo, and extras can all change — via
    /// ``TempoMap/update(entryID:tempo:extras:)`` or ``TempoMap/move(entryID:to:)`` — without
    /// affecting its identity, so a caller can keep addressing the same entry across
    /// an edit that reorders it, rather than recomputing which ordinal position it
    /// landed on.
    ///
    /// Not persisted: `TempoMap.Entry`'s `Codable` conformance never encodes an
    /// entry's identity, and assigns every decoded entry a fresh one, the same as a
    /// newly inserted entry. An entry's identity is therefore stable only within one
    /// in-memory tempo map's lifetime — never across an encode/decode round trip, and
    /// so never across a save and reopen.
    public struct EntryID: StringRepresentable {

        // MARK: Public Initializers

        /// Creates a new, unique entry identity.
        public init() {
            self.init(Self.validPrefix + UUID().base62String)
        }

        /// Creates an entry identity from a string value, returning `nil` if the
        /// string is invalid.
        ///
        /// - Parameter stringValue:    The string identifying the entry.
        public init?(stringValue: String) {
            guard Self.isValid(stringValue)
            else { return nil }

            self.stringValue = stringValue
        }

        // MARK: Public Instance Properties

        /// The string value of this entry identity.
        public let stringValue: String
    }
}

// MARK: -

extension TempoMap.EntryID {

    // MARK: Public Type Methods

    /// Returns a Boolean value indicating whether the given string is a valid entry
    /// identity.
    ///
    /// - Parameter stringValue:    The string to validate.
    ///
    /// - Returns:  `true` if `stringValue` is valid; otherwise, `false`.
    public static func isValid(_ stringValue: String) -> Bool {
        stringValue.wholeMatch(of: validPattern) != nil
    }

    // MARK: Private Type Properties

    private nonisolated(unsafe) static let validPattern = /E\$[0-9A-Za-z]{22}/

    private static let validPrefix = "E$"
}
