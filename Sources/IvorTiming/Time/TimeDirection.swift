// © 2025–2026 John Gary Pusey (see LICENSE.md)

/// The direction of movement between two points in time.
public enum TimeDirection {
    /// Movement toward an earlier point in time.
    case backward

    /// No movement in time.
    case same

    /// Movement toward a later point in time.
    case forward
}

// MARK: - Codable

extension TimeDirection: Codable {
}

// MARK: - Sendable

extension TimeDirection: Sendable {
}
