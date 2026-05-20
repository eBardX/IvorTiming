// © 2026 John Gary Pusey (see LICENSE.md)

public import XestiTools

extension BeatQuantizer {
    /// An error that can occur while performing a beat quantizer operation.
    public enum Error {
        /// The subdivision factor array is empty.
        case emptyFactors

        /// A subdivision factor is invalid.
        case invalidFactor(Int)
    }
}

// MARK: - EnhancedError

extension BeatQuantizer.Error: EnhancedError {

    /// The error category identifying the source module.
    public var category: Category? {
        Category("IvorTiming")
    }

    /// A human-readable description of this error.
    public var message: String {
        switch self {
        case .emptyFactors:
            "The subdivision factors must not be empty"

        case let .invalidFactor(factor):
            "Invalid subdivision factor: \(factor)"
        }
    }
}

// MARK: - Sendable

extension BeatQuantizer.Error: Sendable {
}
