// © 2025–2026 John Gary Pusey (see LICENSE.md)

public import Foundation
public import XestiNumbers

/// A protocol for types that represent a non-negative duration of time.
public protocol DurationProtocol: Codable,
                                  Comparable,
                                  Hashable,
                                  Sendable {
    /// A Boolean value indicating whether this duration is zero.
    var isZero: Bool { get }

    /// Returns the sum of this duration and another, or `nil` if the result
    /// is invalid.
    ///
    /// - Parameter other:  The duration to add.
    ///
    /// - Returns:  The sum of the two durations, or `nil` if the result is
    ///             invalid.
    func adding(_ other: Self) -> Self?

    /// Returns this duration divided by a factor, or `nil` if the result is
    /// invalid.
    ///
    /// - Parameter factor:  The divisor.
    ///
    /// - Returns:  This duration divided by `factor`, or `nil` if the result
    ///             is invalid.
    func divided(by factor: Number) -> Self?

    /// Returns this duration multiplied by a factor, or `nil` if the result
    /// is invalid.
    ///
    /// - Parameter factor:  The multiplier.
    ///
    /// - Returns:  This duration multiplied by `factor`, or `nil` if the
    ///             result is invalid.
    func multiplied(by factor: Number) -> Self?

    /// Returns the result of subtracting another duration from this duration,
    /// or `nil` if the result is invalid.
    ///
    /// - Parameter other:  The duration to subtract.
    ///
    /// - Returns:  The difference of the two durations, or `nil` if the
    ///             result is invalid.
    func subtracting(_ other: Self) -> Self?
}

// MARK: -

extension DurationProtocol {
    /// Returns an attributed string representation of this duration using the
    /// default format style.
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
