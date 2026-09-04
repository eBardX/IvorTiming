// © 2025–2026 John Gary Pusey (see LICENSE.md)

/// The direction of movement between two points in time.
public enum TimeDirection {
    /// Movement toward an earlier point in time.
    case backward

    /// Movement toward a later point in time.
    case forward

    /// No movement in time.
    case same
}

// MARK: - Codable

extension TimeDirection: Codable {
}

// MARK: - Equatable

extension TimeDirection: Equatable {
}

// MARK: - Sendable

extension TimeDirection: Sendable {
}
