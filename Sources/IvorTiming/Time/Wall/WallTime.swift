// © 2025–2026 John Gary Pusey (see LICENSE.md)

public import XestiTools

/// A point in wall-clock time, measured in milliseconds from a reference epoch.
public struct WallTime {

    // MARK: Public Initializers

    /// Creates a wall time by parsing its plain string representation, returning `nil` if the
    /// string cannot be parsed or is out of range.
    ///
    /// - Parameter plain:  The plain string representation of the wall time, in seconds (as
    ///                     produced by `plain`).
    public init?(plain: String) {
        guard let milliseconds = parseWallSeconds(plain)
        else { return nil }

        self.init(uintValue: milliseconds)
    }

    /// Creates a ``WallTime`` from a millisecond count.
    ///
    /// - Parameter uintValue:  The number of milliseconds since the reference epoch.
    public init?(uintValue: UInt) {
        self.uintValue = uintValue
    }

    // MARK: Public Instance Properties

    /// The number of milliseconds since the reference epoch representing this time.
    public let uintValue: UInt

    /// The number of seconds since the reference epoch representing this time.
    public var doubleValue: Double {
        Double(uintValue) / 1_000
    }

    /// The plain string representation of this wall time, in seconds, omitting trailing zero
    /// decimal digits.
    public var plain: String {
        formatWallSeconds(uintValue)
    }
}

// MARK: -

extension WallTime {

    // MARK: Public Type Properties

    /// The zero wall time.
    public static let zero = Self(0)

    // MARK: Internal Initializers

    // Rounds to the nearest millisecond.
    internal init(seconds: Double) {
        self.init(uintValue: UInt((max(seconds, 0) * 1_000).rounded()))!    // swiftlint:disable:this force_unwrapping
    }
}

// MARK: - CustomStringConvertible

extension WallTime {

    // MARK: Public Instance Properties

    public var description: String {
        plain
    }
}

// MARK: - InterpolatableKey

extension WallTime: InterpolatableKey {

    // MARK: Public Instance Methods

    /// Returns the fractional position of this time between two boundary times.
    ///
    /// - Parameter startValue:  The lower boundary time.
    /// - Parameter endValue:    The upper boundary time.
    ///
    /// - Returns:  The fraction in the unit interval `[0, 1]` representing this
    ///             time’s position between `startValue` and `endValue`.
    public func fraction(from startValue: Self,
                         through endValue: Self) -> Double {
        (doubleValue - startValue.doubleValue) / (endValue.doubleValue - startValue.doubleValue)
    }
}

// MARK: - TimeProtocol

extension WallTime: TimeProtocol {

    // MARK: Public Type Aliases

    /// The duration type for a wall time.
    public typealias DurationType = WallDuration

    // MARK: Public Instance Methods

    /// Returns the directed duration from this wall time to another.
    ///
    /// - Parameter time:   The destination wall time.
    ///
    /// - Returns:  A ``DirectedDuration`` representing the distance and
    ///             direction from this wall time to `time`, or `nil` if the
    ///             result cannot be computed.
    public func duration(to time: Self) -> DirectedDuration<DurationType>? {
        if uintValue < time.uintValue {
            return DirectedDuration(duration: WallDuration(time.uintValue - uintValue),
                                    direction: .forward)
        }

        if uintValue > time.uintValue {
            return DirectedDuration(duration: WallDuration(uintValue - time.uintValue),
                                    direction: .backward)
        }

        return DirectedDuration(duration: .zero,
                                direction: .same)
    }

    /// Returns the wall time obtained by moving this time by a directed
    /// duration.
    ///
    /// - Parameter directedDuration: The directed duration to move by.
    ///
    /// - Returns:  The resulting wall time, or `nil` if the result is invalid.
    public func moved(by directedDuration: DirectedDuration<DurationType>) -> Self? {
        switch directedDuration.direction {
        case .backward:
            guard uintValue >= directedDuration.duration.uintValue
            else { return nil }

            return Self(uintValue: uintValue - directedDuration.duration.uintValue)

        case .forward:
            return Self(uintValue: uintValue + directedDuration.duration.uintValue)

        case .same:
            return self
        }
    }
}

// MARK: - UIntRepresentable

extension WallTime: UIntRepresentable {
}
