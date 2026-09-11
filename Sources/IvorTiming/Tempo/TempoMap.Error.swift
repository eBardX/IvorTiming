// © 2025–2026 John Gary Pusey (see LICENSE.md)

public import XestiNumbers
public import XestiTools

extension TempoMap {

    // MARK: Public Nested Types

    /// An error thrown by ``TempoMap`` operations.
    public enum Error {
        /// A failure that occurred while augmenting an entry.
        case augmentFailure(BeatTime)

        /// A failure that occurred while diminishing an entry.
        case diminishFailure(BeatTime)

        /// An anchor that does not contain the range of the entries it is being applied to.
        case invalidAnchor

        /// An augmentation factor that is not a positive rational number ≥ 1.
        case invalidAugmentationFactor(Number)

        /// A diminution factor that is not a positive rational number ≥ 1.
        case invalidDiminutionFactor(Number)

        /// A failure that occurred while moving an entry.
        case moveFailure(BeatTime)

        /// A failure that occurred while reversing an entry.
        case reverseFailure(BeatTime)
    }
}

// MARK: - EnhancedError

extension TempoMap.Error: EnhancedError {
    /// The error category identifying the source module.
    public var category: Category? {
        Category("IvorTiming")
    }

    /// A human-readable description of this error.
    public var message: String {
        switch self {
        case let .augmentFailure(beatTime):
            "Unable to augment tempo map entry, beat time: \(beatTime)"

        case let .diminishFailure(beatTime):
            "Unable to diminish tempo map entry, beat time: \(beatTime)"

        case .invalidAnchor:
            "Invalid anchor: does not contain the range of entries it is being applied to"

        case let .invalidAugmentationFactor(factor):
            "Invalid augmentation factor: \(factor)"

        case let .invalidDiminutionFactor(factor):
            "Invalid diminution factor: \(factor)"

        case let .moveFailure(beatTime):
            "Unable to move tempo map entry, beat time: \(beatTime)"

        case let .reverseFailure(beatTime):
            "Unable to reverse tempo map entry, beat time: \(beatTime)"
        }
    }
}

// MARK: - Equatable

extension TempoMap.Error: Equatable {
}

// MARK: - Sendable

extension TempoMap.Error: Sendable {
}
