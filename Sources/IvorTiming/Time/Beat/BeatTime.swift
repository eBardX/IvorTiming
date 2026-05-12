public import XestiNumbers
public import XestiTools

public struct BeatTime: NumberRepresentable {

    // MARK: Public Type Properties

    public static let zero = Self(0)

    // MARK: Public Type Methods

    public static func isValid(_ numberValue: Number) -> Bool {
        numberValue.isRational && !numberValue.isNegative
    }

    // MARK: Public Initializers

    public init?(numberValue: Number) {
        guard Self.isValid(numberValue)
        else { return nil }

        self.numberValue = numberValue
    }

    // MARK: Public Instance Properties

    public let numberValue: Number
}

// MARK: - InterpolatableKey

extension BeatTime: InterpolatableKey {
    public func fraction(from startValue: Self,
                         through endValue: Self) -> Double {
        (doubleValue - startValue.doubleValue) / (endValue.doubleValue - startValue.doubleValue)
    }
}

// MARK: - TimeProtocol

extension BeatTime: TimeProtocol {

    // MARK: Public Instance Methods

    public func duration(to time: Self) -> (duration: BeatDuration,
                                            direction: DurationDirection)? {
        let val1 = numberValue
        let val2 = time.numberValue

        if val1 < val2 {
            return (BeatDuration(val2 - val1), .forward)
        }

        if val1 > val2 {
            return (BeatDuration(val1 - val2), .backward)
        }

        return (.zero, .same)
    }

    public func moved(by duration: BeatDuration,
                      direction: DurationDirection) -> Self? {
        switch direction {
        case .forward:
            return Self(numberValue: numberValue + duration.numberValue)

        case .backward:
            return Self(numberValue: numberValue - duration.numberValue)

        case .same:
            guard duration.isZero
            else { return nil }

            return self
        }
    }
}
