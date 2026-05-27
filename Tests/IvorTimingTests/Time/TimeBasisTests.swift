// © 2025–2026 John Gary Pusey (see LICENSE.md)

import Foundation
@testable import IvorTiming
import Testing

struct TimeBasisTests {
}

// MARK: -

extension TimeBasisTests {
    @Test
    func codable() throws {
        let beatData = try JSONEncoder().encode(TimeBasis.beat)
        let wallData = try JSONEncoder().encode(TimeBasis.wall)

        #expect(try JSONDecoder().decode(TimeBasis.self, from: beatData) == .beat)
        #expect(try JSONDecoder().decode(TimeBasis.self, from: wallData) == .wall)
    }

    @Test
    func description() {
        #expect(TimeBasis.beat.description == "beat")
        #expect(TimeBasis.wall.description == "wall")
    }

    @Test
    func equality() {
        #expect(TimeBasis.beat == .beat)
        #expect(TimeBasis.wall == .wall)
        #expect(TimeBasis.beat != .wall)
    }

    @Test
    func init_invalid() {
        #expect(throws: ParseError.self) { try TimeBasis(stringValue: "invalid") }
        #expect(throws: ParseError.self) { try TimeBasis(stringValue: "") }
    }

    @Test
    func init_valid() throws {
        #expect(try TimeBasis(stringValue: "beat") == .beat)
        #expect(try TimeBasis(stringValue: "wall") == .wall)
    }
}
