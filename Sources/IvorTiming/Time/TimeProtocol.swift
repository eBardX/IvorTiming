public import Foundation
public import XestiTools

public protocol TimeProtocol<DurationType>: Codable,
                                            Comparable,
                                            Hashable,
                                            InterpolatableKey,
                                            Sendable {
    associatedtype DurationType: DurationProtocol

    static var zero: Self { get }

    func duration(to time: Self) -> (duration: DurationType,
                                     direction: DurationDirection)?

    func moved(by duration: DurationType,
               direction: DurationDirection) -> Self?
}

// MARK: -

extension TimeProtocol {
    public func formatted() -> AttributedString {
        switch self {
        case let value as BeatTime:
            value.formatted()

        case let value as WallTime:
            value.formatted()

        default:
            AttributedString("\(self)")
        }
    }
}
