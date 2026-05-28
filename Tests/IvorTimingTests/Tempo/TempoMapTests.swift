// © 2025–2026 John Gary Pusey (see LICENSE.md)

import Foundation
@testable import IvorTiming
import Testing
import XestiNumbers
import XestiTools

struct TempoMapTests {
}

// MARK: -

extension TempoMapTests {
    @Test
    func codable() throws {
        let t120 = try #require(Tempo(uintValue: 120))
        let original = TempoMap().inserting(beatTime: BeatTime(1),
                                            tempo: t120)
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(TempoMap.self, from: data)

        #expect(decoded[BeatTime(1)] == t120)
        #expect(decoded.defaultTempo == original.defaultTempo)
    }

    @Test
    func defaultTempo() {
        let tmap = TempoMap()

        #expect(tmap.defaultTempo == .default)
    }

    @Test
    func defaultTempo_override() throws {
        let t90  = try #require(Tempo(uintValue: 90))
        let tmap = TempoMap(defaultTempo: t90)

        #expect(tmap.defaultTempo == t90)
    }

    @Test
    func equality() throws {
        let t120 = try #require(Tempo(uintValue: 120))
        let t90  = try #require(Tempo(uintValue: 90))
        let tmap1 = TempoMap().inserting(beatTime: BeatTime(1), tempo: t120)
        let tmap2 = TempoMap().inserting(beatTime: BeatTime(1), tempo: t120)
        let tmap3 = TempoMap().inserting(beatTime: BeatTime(1), tempo: t90)
        let tmap4 = TempoMap(defaultTempo: t90).inserting(beatTime: BeatTime(1),
                                                          tempo: t120)

        #expect(tmap1 == tmap2)
        #expect(tmap1 != tmap3)
        #expect(tmap1 != tmap4)
    }

    @Test
    func forEach() throws {
        let t120 = try #require(Tempo(uintValue: 120))
        let t90  = try #require(Tempo(uintValue: 90))
        let tmap = TempoMap()
            .inserting(beatTime: BeatTime(1), tempo: t120)
            .inserting(beatTime: BeatTime(2), tempo: t90)
        var visited: [(BeatTime, Tempo)] = []

        tmap.forEach { beatTime, tempo, _ in
            visited.append((beatTime, tempo))
        }

        #expect(visited.count == 2)
        #expect(visited[0].0 == BeatTime(1))
        #expect(visited[0].1 == t120)
        #expect(visited[1].0 == BeatTime(2))
        #expect(visited[1].1 == t90)
    }

    @Test
    func hasExtras() throws {
        let t120   = try #require(Tempo(uintValue: 120))
        let extras = Extras(elements: [Extra(name: "tag")])
        let with   = TempoMap().inserting(beatTime: BeatTime(1),
                                          tempo: t120,
                                          extras: extras)
        let without = TempoMap().inserting(beatTime: BeatTime(1),
                                           tempo: t120)

        #expect(with.hasExtras)
        #expect(!without.hasExtras)
    }

    @Test
    func hasExtras_updatedOnRemove() throws {
        let t120   = try #require(Tempo(uintValue: 120))
        let extras = Extras(elements: [Extra(name: "tag")])
        var tmap   = TempoMap().inserting(beatTime: BeatTime(1),
                                          tempo: t120,
                                          extras: extras)

        tmap.remove(beatTime: BeatTime(1), tempo: t120, extras: extras)

        #expect(!tmap.hasExtras)
    }

    @Test
    func inserting() throws {
        let t120 = try #require(Tempo(uintValue: 120))
        let tmap = TempoMap().inserting(beatTime: BeatTime(1),
                                        tempo: t120)

        #expect(!tmap.isEmpty)
        #expect(tmap[BeatTime(1)] == t120)
    }

    @Test
    func isEmpty() {
        var tmap = TempoMap()

        #expect(tmap.isEmpty)

        tmap.insert(beatTime: .zero,
                    tempo: .default)

        #expect(!tmap.isEmpty)
    }

    @Test
    func merge() throws {
        let t120 = try #require(Tempo(uintValue: 120))
        let t90  = try #require(Tempo(uintValue: 90))
        var tmap = TempoMap().inserting(beatTime: BeatTime(1), tempo: t120)

        tmap.merge(with: TempoMap().inserting(beatTime: BeatTime(2), tempo: t90))

        #expect(tmap[BeatTime(1)] == t120)
        #expect(tmap[BeatTime(2)] == t90)
    }

    @Test
    func merging() throws {
        let t120 = try #require(Tempo(uintValue: 120))
        let t90  = try #require(Tempo(uintValue: 90))
        let tmap1 = TempoMap().inserting(beatTime: BeatTime(1),
                                         tempo: t120)
        let tmap2 = TempoMap().inserting(beatTime: BeatTime(2),
                                         tempo: t90)
        let merged = tmap1.merging(with: tmap2)

        #expect(merged[BeatTime(1)] == t120)
        #expect(merged[BeatTime(2)] == t90)
    }

    @Test
    func remove() throws {
        let t120 = try #require(Tempo(uintValue: 120))
        var tmap = TempoMap().inserting(beatTime: BeatTime(1), tempo: t120)

        tmap.remove(beatTime: BeatTime(1), tempo: t120)

        #expect(tmap.isEmpty)
    }

    @Test
    func removing() throws {
        let t120 = try #require(Tempo(uintValue: 120))
        let tmap = TempoMap()
            .inserting(beatTime: BeatTime(1),
                       tempo: t120)
            .removing(beatTime: BeatTime(1),
                      tempo: t120)

        #expect(tmap.isEmpty)
    }

    @Test
    func subscript_defaultWhenEmpty() {
        let tmap = TempoMap()

        #expect(tmap[BeatTime(5)] == .default)
    }

    @Test
    func subscript_interpolated() throws {
        let t60      = try #require(Tempo(uintValue: 60))
        let t120     = try #require(Tempo(uintValue: 120))
        let t75      = try #require(Tempo(uintValue: 75))
        let tmap = TempoMap()
            .inserting(beatTime: BeatTime(0),
                       tempo: t60)
            .inserting(beatTime: BeatTime(2),
                       tempo: t120)

        // Polynomial n=2: T(u) = T₀ + (T₁−T₀)·u²
        // At u=0.5: 60 + (120−60)·0.25 = 75
        #expect(tmap[BeatTime(1)] == t75)
    }
}
