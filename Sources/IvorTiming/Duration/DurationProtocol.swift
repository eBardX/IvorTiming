public import Foundation
public import XestiNumbers

public protocol DurationProtocol: Codable,
                                  Comparable,
                                  Hashable,
                                  Sendable {
    var isZero: Bool { get }

    func adding(_ other: Self) -> Self?

    func divided(by factor: Number) -> Self?

    func multiplied(by factor: Number) -> Self?

    func subtracting(_ other: Self) -> Self?
}

// MARK: -

extension DurationProtocol {
    public func formatted() -> AttributedString {
        switch self {
        case let value as BeatDuration:
            value.formatted()

        case let value as WallDuration:
            value.formatted()

        default:
            AttributedString("\(self)")
        }
    }
}
