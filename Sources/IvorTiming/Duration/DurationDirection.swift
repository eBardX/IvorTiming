public enum DurationDirection {
    case backward
    case same
    case forward
}

// MARK: - Codable

extension DurationDirection: Codable {
}

// MARK: - Sendable

extension DurationDirection: Sendable {
}
