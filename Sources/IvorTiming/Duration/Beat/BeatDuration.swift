public import XestiNumbers

public struct BeatDuration: NumberRepresentable {

    // MARK: Public Type Properties

    public static let zero = Self(0)

    // MARK: Public Type Methods

    public static func isValid(_ numberValue: Number) -> Bool {
        numberValue.isRational && !numberValue.isNegative
    }

    // MARK: Public Initializers

    public init?(numberValue: Number) {
        guard Self.isValid(numberValue)
        else { return nil }

        self.numberValue = numberValue
    }

    // MARK: Public Instance Properties

    public let numberValue: Number
}

// MARK: - DurationProtocol

extension BeatDuration: DurationProtocol {

    // MARK: Public Instance Properties

    public var isZero: Bool {
        self == .zero
    }

    // MARK: Public Instance Methods

    public func adding(_ other: Self) -> Self? {
        Self(numberValue: numberValue + other.numberValue)
    }

    public func divided(by factor: Number) -> Self? {
        Self(numberValue: numberValue / factor)
    }

    public func multiplied(by factor: Number) -> Self? {
        Self(numberValue: numberValue * factor)
    }

    public func subtracting(_ other: Self) -> Self? {
        Self(numberValue: numberValue - other.numberValue)
    }
}
