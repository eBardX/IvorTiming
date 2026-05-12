@testable import IvorTiming
import Testing
import XestiNumbers

struct WallTimeTests {
}

// MARK: -

extension WallTimeTests {
    @Test
    func comparable() {
        #expect(WallTime(1) < WallTime(2))
        #expect(WallTime(1) == WallTime(1)) // swiftlint:disable:this identical_operands
    }

    @Test
    func duration_to_backward() {
        let result = WallTime(3).duration(to: WallTime(1))

        #expect(result?.duration == WallDuration(2))
        #expect(result?.direction == .backward)
    }

    @Test
    func duration_to_forward() {
        let result = WallTime(1).duration(to: WallTime(3))

        #expect(result?.duration == WallDuration(2))
        #expect(result?.direction == .forward)
    }

    @Test
    func duration_to_same() {
        let result = WallTime(2).duration(to: WallTime(2))

        #expect(result?.duration == .zero)
        #expect(result?.direction == .same)
    }

    @Test
    func init_invalid() {
        #expect(WallTime(numberValue: -1) == nil)
    }

    @Test
    func init_valid() {
        #expect(WallTime(numberValue: 0) != nil)
        #expect(WallTime(numberValue: 1) != nil)
    }

    @Test
    func moved_backward() {
        #expect(WallTime(3).moved(by: WallDuration(2), direction: .backward) == WallTime(1))
        #expect(WallTime(0).moved(by: WallDuration(1), direction: .backward) == nil)
    }

    @Test
    func moved_forward() {
        #expect(WallTime(1).moved(by: WallDuration(2), direction: .forward) == WallTime(3))
    }

    @Test
    func operators() {
        #expect(WallTime(1) + WallDuration(2) == WallTime(3))
        #expect(WallTime(3) - WallDuration(2) == WallTime(1))
        #expect(WallTime(3) - WallTime(1) == WallDuration(2))
    }

    @Test
    func zero() throws {
        let z = try #require(WallTime(numberValue: 0))

        #expect(z == .zero)
    }
}
