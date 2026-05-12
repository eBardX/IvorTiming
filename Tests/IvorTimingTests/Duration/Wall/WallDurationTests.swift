@testable import IvorTiming
import Testing
import XestiNumbers

struct WallDurationTests {
}

// MARK: -

extension WallDurationTests {
    @Test
    func adding() {
        #expect(WallDuration(1).adding(WallDuration(2)) == WallDuration(3))
        #expect(WallDuration.zero.adding(.zero) == .zero)
    }

    @Test
    func comparable() {
        #expect(WallDuration(1) < WallDuration(2))
        #expect(WallDuration(1) == WallDuration(1)) // swiftlint:disable:this identical_operands
    }

    @Test
    func divided() {
        #expect(WallDuration(4).divided(by: 2) == WallDuration(2))
    }

    @Test
    func hashable() {
        let set: Set<WallDuration> = [WallDuration(1), WallDuration(1), WallDuration(2)]

        #expect(set.count == 2)
    }

    @Test
    func init_invalid() {
        #expect(WallDuration(numberValue: -1) == nil)
    }

    @Test
    func init_valid() {
        #expect(WallDuration(numberValue: 0) != nil)
        #expect(WallDuration(numberValue: 1) != nil)
    }

    @Test
    func isZero() {
        #expect(WallDuration.zero.isZero)
        #expect(!WallDuration(1).isZero)
    }

    @Test
    func multiplied() {
        #expect(WallDuration(2).multiplied(by: 3) == WallDuration(6))
    }

    @Test
    func operators() {
        #expect(WallDuration(1) + WallDuration(2) == WallDuration(3))
        #expect(WallDuration(3) - WallDuration(1) == WallDuration(2))
    }

    @Test
    func subtracting() {
        #expect(WallDuration(3).subtracting(WallDuration(1)) == WallDuration(2))
        #expect(WallDuration(1).subtracting(WallDuration(3)) == nil)
    }

    @Test
    func zero() throws {
        let z = try #require(WallDuration(numberValue: 0))

        #expect(z == .zero)
        #expect(z.isZero)
    }
}
