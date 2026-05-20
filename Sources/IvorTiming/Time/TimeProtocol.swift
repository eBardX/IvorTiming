// © 2025–2026 John Gary Pusey (see LICENSE.md)

public import Foundation
public import XestiTools

/// A protocol for types that represent a point in time.
public protocol TimeProtocol<DurationType>: Codable,
                                            Comparable,
                                            Hashable,
                                            InterpolatableKey,
                                            Sendable {
    /// The type of duration used to measure the distance between two time values.
    associatedtype DurationType: DurationProtocol

    /// The zero time value.
    static var zero: Self { get }

    /// Returns the directed duration from this time to another time.
    ///
    /// - Parameter time:   The destination time value.
    ///
    /// - Returns:  A ``DirectedDuration`` representing the distance and
    ///             direction from this time to `time`, or `nil` if the result
    ///             cannot be computed.
    func duration(to time: Self) -> DirectedDuration<DurationType>?

    /// Returns the time obtained by moving this time by a directed duration.
    ///
    /// - Parameter directedDuration:  The directed duration to move by.
    ///
    /// - Returns:  The resulting time value, or `nil` if the result is invalid.
    func moved(by directedDuration: DirectedDuration<DurationType>) -> Self?
}

// MARK: -

extension TimeProtocol {
    /// Returns an attributed string representation of this time using the
    /// default format style.
    public func formatted() -> AttributedString {
        switch self {
        case let value as BeatTime:
            value.formatted()

        case let value as WallTime:
            value.formatted()

        default:
            AttributedString("\(self)")
        }
    }
}
