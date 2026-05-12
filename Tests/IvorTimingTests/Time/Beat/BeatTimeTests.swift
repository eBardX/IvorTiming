@testable import IvorTiming
import Testing
import XestiNumbers

struct BeatTimeTests {
}

// MARK: -

extension BeatTimeTests {
    @Test
    func comparable() {
        #expect(BeatTime(1) < BeatTime(2))
        #expect(BeatTime(1) == BeatTime(1)) // swiftlint:disable:this identical_operands
    }

    @Test
    func duration_to_backward() {
        let result = BeatTime(3).duration(to: BeatTime(1))

        #expect(result?.duration == BeatDuration(2))
        #expect(result?.direction == .backward)
    }

    @Test
    func duration_to_forward() {
        let result = BeatTime(1).duration(to: BeatTime(3))

        #expect(result?.duration == BeatDuration(2))
        #expect(result?.direction == .forward)
    }

    @Test
    func duration_to_same() {
        let result = BeatTime(2).duration(to: BeatTime(2))

        #expect(result?.duration == .zero)
        #expect(result?.direction == .same)
    }

    @Test
    func hashable() {
        let set: Set<BeatTime> = [BeatTime(1), BeatTime(1), BeatTime(2)]

        #expect(set.count == 2)
    }

    @Test
    func init_invalid() {
        #expect(BeatTime(numberValue: -1) == nil)
    }

    @Test
    func init_valid() {
        #expect(BeatTime(numberValue: 0) != nil)
        #expect(BeatTime(numberValue: 1) != nil)
    }

    @Test
    func moved_backward() {
        #expect(BeatTime(3).moved(by: BeatDuration(2), direction: .backward) == BeatTime(1))
        #expect(BeatTime(0).moved(by: BeatDuration(1), direction: .backward) == nil)
    }

    @Test
    func moved_forward() {
        #expect(BeatTime(1).moved(by: BeatDuration(2), direction: .forward) == BeatTime(3))
    }

    @Test
    func moved_same() {
        #expect(BeatTime(1).moved(by: .zero, direction: .same) == BeatTime(1))
        #expect(BeatTime(1).moved(by: BeatDuration(1), direction: .same) == nil)
    }

    @Test
    func operators() {
        #expect(BeatTime(1) + BeatDuration(2) == BeatTime(3))
        #expect(BeatTime(3) - BeatDuration(2) == BeatTime(1))
        #expect(BeatTime(3) - BeatTime(1) == BeatDuration(2))
    }

    @Test
    func zero() throws {
        let z = try #require(BeatTime(numberValue: 0))

        #expect(z == .zero)
    }
}
