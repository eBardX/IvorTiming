private import XestiTools

public enum TimeBasis {
    case beat
    case wall
}

// MARK: -

extension TimeBasis {

    // MARK: Public Initializers

    public init?(stringValue: String) {
        guard let timeBasis = Self.timeBases[stringValue]
        else { return nil }

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

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)

        guard let timeBasis = Self.timeBases[stringValue]
        else { throw DecodingError.dataCorruptedError(in: container,
                                                      debugDescription: "Invalid time basis value") }

        self = timeBasis
    }

    // MARK: Public Instance Methods

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()

        try container.encode(description)
    }
}

// MARK: - CustomStringConvertible

 extension TimeBasis: CustomStringConvertible {
    public var description: String {
        Self.stringValues[self].require()
    }
 }

// MARK: - Sendable

extension TimeBasis: Sendable {
}
