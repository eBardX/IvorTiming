// © 2026 John Gary Pusey (see LICENSE.md)

import Foundation
@testable import IvorTiming
import Testing
import XestiNumbers

struct DirectedDurationTests {
}

// MARK: -

extension DirectedDurationTests {
    @Test
    func codable() throws {
        let original = DirectedDuration(duration: BeatDuration(2), direction: .forward)
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(DirectedDuration<BeatDuration>.self, from: data)

        #expect(decoded == original)
    }

    @Test
    func equality() {
        let d1 = DirectedDuration(duration: BeatDuration(2), direction: .forward)
        let d2 = DirectedDuration(duration: BeatDuration(2), direction: .forward)

        #expect(d1 == d2)
    }

    @Test
    func inequality() {
        let d1 = DirectedDuration(duration: BeatDuration(1), direction: .forward)
        let d2 = DirectedDuration(duration: BeatDuration(2), direction: .forward)
        let d3 = DirectedDuration(duration: BeatDuration(1), direction: .backward)

        #expect(d1 != d2)
        #expect(d1 != d3)
    }

    @Test
    func init_backward() {
        let d = DirectedDuration(duration: BeatDuration(3), direction: .backward)

        #expect(d.direction == .backward)
        #expect(d.duration == BeatDuration(3))
    }

    @Test
    func init_forward() {
        let d = DirectedDuration(duration: BeatDuration(1), direction: .forward)

        #expect(d.direction == .forward)
        #expect(d.duration == BeatDuration(1))
    }

    @Test
    func init_zero() {
        let d = DirectedDuration(duration: BeatDuration.zero, direction: .same)

        #expect(d.direction == .same)
        #expect(d.duration == .zero)
    }
}
