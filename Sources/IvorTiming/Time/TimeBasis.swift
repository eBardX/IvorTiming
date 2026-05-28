// © 2025–2026 John Gary Pusey (see LICENSE.md)

private import XestiTools

/// The basis used to measure time in a musical context.
public enum TimeBasis {
    /// Musical beat time, measured in beats.
    case beat

    /// Wall-clock time, measured in seconds.
    case wall
}

// MARK: -

extension TimeBasis {

    // MARK: Public Initializers

    /// Creates a ``TimeBasis`` from its string representation.
    ///
    /// - Parameter stringValue:    The string representation to parse.
    ///
    /// - Throws:   ``ParseError/invalidTimeBasis(_:)`` if `stringValue` is not a
    ///             recognized time basis.
    public init(stringValue: String) throws {
        guard let timeBasis = Self.timeBases[stringValue]
        else { throw ParseError.invalidTimeBasis(stringValue) }

        self = timeBasis
    }

    // MARK: Private Type Properties

    private static let stringValues: [Self: String] = [.beat: "beat",
                                                       .wall: "wall"]

    private static let timeBases: [String: Self] = ["beat": .beat,
                                                    "wall": .wall]
}

// MARK: - Codable

extension TimeBasis: Codable {

    // MARK: Public Initializers

    /// Creates a ``TimeBasis`` by decoding from the provided decoder.
    ///
    /// - Parameter decoder:    The decoder to read from.
    ///
    /// - Throws:   `DecodingError.dataCorruptedError` if the decoded string is
    ///             not a recognized time basis value.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)

        do {
            try self.init(stringValue: stringValue)
        } catch {
            throw DecodingError.dataCorruptedError(in: container,
                                                   debugDescription: "Invalid time basis value")
        }
    }

    // MARK: Public Instance Methods

    /// Encodes this value into the provided encoder.
    ///
    /// - Parameter encoder:    The encoder to write to.
    ///
    /// - Throws:   `EncodingError` if the value cannot be encoded.
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()

        try container.encode(description)
    }
}

// MARK: - Comparable

extension TimeBasis: Comparable {
}

// MARK: - CustomStringConvertible

 extension TimeBasis: CustomStringConvertible {
    /// The string representation of this time basis.
    public var description: String {
        Self.stringValues[self].require()
    }
 }

// MARK: - Equatable

extension TimeBasis: Equatable {
}

// MARK: - Hashable

extension TimeBasis: Hashable {
}

// MARK: - Sendable

extension TimeBasis: Sendable {
}
