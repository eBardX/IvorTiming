// © 2026 John Gary Pusey (see LICENSE.md)

private import XestiNumbers

/// A type that quantizes beat times to the nearest subdivision.
///
/// Create a `BeatQuantizer` with an array of subdivision factors and use it
/// to snap beat times to the closest rhythmic grid point.
///
/// Each factor `n` defines a grid of `1/n`-beat subdivisions. The quantizer
/// snaps to whichever grid point across all factors is nearest to the input
/// time. An empty factor array quantizes to the nearest integer beat.
public struct BeatQuantizer {

    // MARK: Public Initializers

    /// Creates a beat quantizer with the given subdivision factors.
    ///
    /// - Parameter factors:    An array of positive integer subdivision factors.
    ///
    /// - Throws:   ``BeatQuantizer/Error/emptyFactors`` if `factors` is empty,
    ///             or ``BeatQuantizer/Error/invalidFactor(_:)`` if any factor is
    ///             not positive.
    public init(factors: [Int]) throws {
        self.lcmFactor = try Self._computeLCMFactor(factors)
    }

    // MARK: Public Instance Methods

    /// Returns the beat time nearest to `beatTime` on the quantization grid.
    ///
    /// - Parameter beatTime:   The beat time to quantize.
    ///
    /// - Returns:  The quantized ``BeatTime``.
    public func quantize(_ beatTime: BeatTime) -> BeatTime {
        let value = beatTime.numberValue
        let numer = round(value * lcmFactor).exact.intValue

        return BeatTime(Number(numer) / lcmFactor)
    }

    // MARK: Private Type Methods

    private static func _computeLCMFactor(_ factors: [Int]) throws -> Number {
        guard !factors.isEmpty
        else { throw Error.emptyFactors }

        for factor in factors {
            guard factor > 0
            else { throw Error.invalidFactor(factor) }
        }

        return factors.reduce(Number(1)) { lcm($0, Number($1)) }
    }

    // MARK: Private Instance Properties

    private let lcmFactor: Number
}

// MARK: - Sendable

extension BeatQuantizer: Sendable {
}
