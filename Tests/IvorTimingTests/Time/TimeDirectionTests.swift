// © 2025–2026 John Gary Pusey (see LICENSE.md)

import Foundation
@testable import IvorTiming
import Testing

struct TimeDirectionTests {
}

// MARK: -

extension TimeDirectionTests {
    @Test
    func codable() throws {
        for direction in [TimeDirection.backward, .same, .forward] {
            let data = try JSONEncoder().encode(direction)
            let decoded = try JSONDecoder().decode(TimeDirection.self, from: data)

            #expect(decoded == direction)
        }
    }
}
