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
    func init_invalid() {
        #expect(TimeBasis(stringValue: "invalid") == nil)
        #expect(TimeBasis(stringValue: "") == nil)
    }

    @Test
    func init_valid() {
        #expect(TimeBasis(stringValue: "beat") == .beat)
        #expect(TimeBasis(stringValue: "wall") == .wall)
    }
}
