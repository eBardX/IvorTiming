// © 2026 John Gary Pusey (see LICENSE.md)

@testable import IvorTiming
import Testing

struct TempoMapIndexTests {
}

// MARK: -

extension TempoMapIndexTests {
    @Test
    func comparable() {
        #expect(TempoMap.Index(0) < TempoMap.Index(1))
        #expect(!(TempoMap.Index(1) < TempoMap.Index(0)))
        #expect(!(TempoMap.Index(1) < TempoMap.Index(1))) // swiftlint:disable:this identical_operands
    }

    @Test
    func equality() {
        #expect(TempoMap.Index(2) == TempoMap.Index(2)) // swiftlint:disable:this identical_operands
        #expect(TempoMap.Index(2) != TempoMap.Index(3))
    }

    @Test
    func hashable() {
        let set: Set<TempoMap.Index> = [TempoMap.Index(0), TempoMap.Index(0), TempoMap.Index(1)]

        #expect(set.count == 2)
    }

    @Test
    func init_offset() {
        #expect(TempoMap.Index(5).offset == 5)
    }
}
