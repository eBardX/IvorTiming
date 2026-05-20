// © 2026 John Gary Pusey (see LICENSE.md)

public import XestiTools

/// An error that can occur while parsing a string value.
public enum ParseError {

    /// The time basis is unrecognized.
    case invalidTimeBasis(String)
}

// MARK: - EnhancedError

extension ParseError: EnhancedError {

    /// The error category identifying the source module.
    public var category: Category? {
        Category("IvorTiming")
    }

    /// A human-readable description of this error.
    public var message: String {
        switch self {
        case let .invalidTimeBasis(value):
            "Invalid time basis: ‘\(value)’"
        }
    }
}

// MARK: - Sendable

extension ParseError: Sendable {
}
