// © 2025–2026 John Gary Pusey (see LICENSE.md)

import Foundation
@testable import IvorTiming
import Testing
import XestiNumbers

struct TempoTests {
}

// MARK: -

extension TempoTests {
    @Test
    func codable() throws {
        let original = try #require(Tempo(uintValue: 120))
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(Tempo.self, from: data)

        #expect(decoded == original)
    }

    @Test
    func comparable() throws {
        let t60 = try #require(Tempo(uintValue: 60))
        let t120 = try #require(Tempo(uintValue: 120))

        #expect(t60 < t120)
        #expect(t60 == .default)
    }

    @Test
    func `default`() {
        #expect(Tempo.default.uintValue == 60)
    }

    @Test
    func doubleValue() throws {
        let t120 = try #require(Tempo(uintValue: 120))

        #expect(t120.doubleValue == 120.0)
    }

    @Test
    func hashable() throws {
        let t60a = try #require(Tempo(uintValue: 60))
        let t60b = try #require(Tempo(uintValue: 60))
        let t120 = try #require(Tempo(uintValue: 120))
        let set: Set<Tempo> = [t60a, t60b, t120]

        #expect(set.count == 2)
    }

    @Test
    func init_invalid() {
        #expect(Tempo(uintValue: 0) == nil)
    }

    @Test
    func init_valid() {
        #expect(Tempo(uintValue: 1) != nil)
        #expect(Tempo(uintValue: 60) != nil)
        #expect(Tempo(uintValue: 240) != nil)
    }

    @Test
    func numberValue() throws {
        let t120 = try #require(Tempo(uintValue: 120))

        #expect(t120.numberValue == 120)
    }
}
