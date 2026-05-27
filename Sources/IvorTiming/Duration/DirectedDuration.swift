// © 2026 John Gary Pusey (see LICENSE.md)

/// A duration paired with a direction of movement.
///
/// The direction must be consistent with the duration: a zero duration
/// requires ``TimeDirection/same``, and a non-zero duration requires
/// ``TimeDirection/forward`` or ``TimeDirection/backward``.
public struct DirectedDuration<DurationType: DurationProtocol> {

    // MARK: Public Initializers

    /// Creates a ``DirectedDuration`` from a duration and a direction.
    ///
    /// - Parameter duration:   The magnitude of the movement.
    /// - Parameter direction:  The direction of the movement.
    ///
    /// - Precondition: `duration.isZero` if and only if `direction == .same`.
    public init(duration: DurationType,
                direction: TimeDirection) {
        precondition(duration.isZero
                     ? direction == .same
                     : direction != .same)

        self.direction = direction
        self.duration = duration
    }

    // MARK: Public Instance Properties

    /// The direction of movement.
    public let direction: TimeDirection

    /// The magnitude of the movement.
    public let duration: DurationType
}

// MARK: - Codable

extension DirectedDuration: Codable {
}

// MARK: - Equatable

extension DirectedDuration: Equatable {
}

// MARK: - Sendable

extension DirectedDuration: Sendable {
}
