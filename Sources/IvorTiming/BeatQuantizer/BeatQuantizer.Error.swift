// © 2026 John Gary Pusey (see LICENSE.md)

public import XestiTools

extension BeatQuantizer {

    /// An error thrown by ``BeatQuantizer`` operations.
    public enum Error {

        /// An empty subdivision factor array.
        case emptyFactors

        /// A subdivision factor that is not a positive integer.
        case invalidFactor(Int)
    }
}

// MARK: - EnhancedError

extension BeatQuantizer.Error: EnhancedError {

    /// The error category for this error.
    public var category: Category? {
        Category("IvorTiming")
    }

    /// The human-readable message for this error.
    public var message: String {
        switch self {
        case .emptyFactors:
            "Quantization factors must not be empty"

        case let .invalidFactor(factor):
            "Invalid quantization factor: \(factor)"
        }
    }
}

// MARK: - Sendable

extension BeatQuantizer.Error: Sendable {
}
