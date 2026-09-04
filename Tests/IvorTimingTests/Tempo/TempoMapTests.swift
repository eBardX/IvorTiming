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
        var original = TempoMap()

        original.insert(beatTime: BeatTime(1), tempo: t120)

        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(TempoMap.self, from: data)

        #expect(decoded[BeatTime(1)] == t120)
        #expect(decoded.defaultTempo == original.defaultTempo)
    }

    @Test
    func codable_decodeDeduplicatesLegacyDuplicates() throws {
        let t120 = try #require(Tempo(uintValue: 120))
        var tmap = TempoMap()

        // Simulates a document saved before `insert`'s dedup rule existed: nothing
        // about `Codable` itself enforces uniqueness, so two exact-duplicate entries
        // can land in `entries` directly, bypassing `insert`'s own guard.
        tmap.entries = [TempoMap.Entry(beatTime: BeatTime(1), tempo: t120, extras: nil),
                        TempoMap.Entry(beatTime: BeatTime(1), tempo: t120, extras: nil)]

        let data = try JSONEncoder().encode(tmap)
        let decoded = try JSONDecoder().decode(TempoMap.self, from: data)
        var count = 0

        decoded.forEach { _, _, _, _ in count += 1 }

        #expect(count == 1)
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
        var tmap1 = TempoMap()
        var tmap2 = TempoMap()
        var tmap3 = TempoMap()
        var tmap4 = TempoMap(defaultTempo: t90)

        tmap1.insert(beatTime: BeatTime(1), tempo: t120)
        tmap2.insert(beatTime: BeatTime(1), tempo: t120)
        tmap3.insert(beatTime: BeatTime(1), tempo: t90)
        tmap4.insert(beatTime: BeatTime(1), tempo: t120)

        #expect(tmap1 == tmap2)
        #expect(tmap1 != tmap3)
        #expect(tmap1 != tmap4)
    }

    @Test
    func forEach() throws {
        let t120 = try #require(Tempo(uintValue: 120))
        let t90  = try #require(Tempo(uintValue: 90))
        var tmap = TempoMap()

        tmap.insert(beatTime: BeatTime(1), tempo: t120)
        tmap.insert(beatTime: BeatTime(2), tempo: t90)

        var visited: [(BeatTime, Tempo)] = []
        var ids: [TempoMap.EntryID] = []

        tmap.forEach { entryID, beatTime, tempo, _ in
            ids.append(entryID)
            visited.append((beatTime, tempo))
        }

        #expect(visited.count == 2)
        #expect(visited[0].0 == BeatTime(1))
        #expect(visited[0].1 == t120)
        #expect(visited[1].0 == BeatTime(2))
        #expect(visited[1].1 == t90)
        #expect(Set(ids).count == 2)
    }

    @Test
    func insert_duplicate() throws {
        let t120 = try #require(Tempo(uintValue: 120))
        var tmap = TempoMap()

        let first = tmap.insert(beatTime: BeatTime(1), tempo: t120)
        let second = tmap.insert(beatTime: BeatTime(1), tempo: t120)

        #expect(first.inserted)
        #expect(!second.inserted)
        #expect(second.entryID == first.entryID)
    }

    @Test
    func insert_new() throws {
        let t120 = try #require(Tempo(uintValue: 120))
        let t90  = try #require(Tempo(uintValue: 90))
        var tmap = TempoMap()

        let first = tmap.insert(beatTime: BeatTime(1), tempo: t120)
        let second = tmap.insert(beatTime: BeatTime(2), tempo: t90)

        #expect(first.inserted)
        #expect(second.inserted)
        #expect(second.entryID != first.entryID)
    }

    @Test
    func hasExtras() throws {
        let t120   = try #require(Tempo(uintValue: 120))
        let extras = Extras(elements: [Extra(name: "tag")])
        var with = TempoMap()
        var without = TempoMap()

        with.insert(beatTime: BeatTime(1), tempo: t120, extras: extras)
        without.insert(beatTime: BeatTime(1), tempo: t120)

        #expect(with.hasExtras)
        #expect(!without.hasExtras)
    }

    @Test
    func hasExtras_updatedOnRemove() throws {
        let t120   = try #require(Tempo(uintValue: 120))
        let extras = Extras(elements: [Extra(name: "tag")])
        var tmap = TempoMap()

        tmap.insert(beatTime: BeatTime(1), tempo: t120, extras: extras)
        tmap.remove(beatTime: BeatTime(1), tempo: t120, extras: extras)

        #expect(!tmap.hasExtras)
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
        var tmap = TempoMap()
        var other = TempoMap()

        tmap.insert(beatTime: BeatTime(1), tempo: t120)
        other.insert(beatTime: BeatTime(2), tempo: t90)

        tmap.merge(with: other)

        #expect(tmap[BeatTime(1)] == t120)
        #expect(tmap[BeatTime(2)] == t90)
    }

    @Test
    func move_found() throws {
        let t120 = try #require(Tempo(uintValue: 120))
        var tmap = TempoMap()
        var movedID: TempoMap.EntryID?

        tmap.insert(beatTime: BeatTime(1), tempo: t120)

        tmap.forEach { entryID, beatTime, _, _ in
            if beatTime == BeatTime(1) {
                movedID = entryID
            }
        }

        let entryID = try #require(movedID)
        let newID = tmap.move(entryID: entryID, to: BeatTime(5))
        var beatTimes: [BeatTime] = []

        tmap.forEach { _, beatTime, _, _ in beatTimes.append(beatTime) }

        #expect(newID == entryID)
        #expect(beatTimes == [BeatTime(5)])
        #expect(tmap[BeatTime(5)] == t120)
    }

    @Test
    func move_mergesIntoExistingDuplicate() throws {
        let t120 = try #require(Tempo(uintValue: 120))
        var tmap = TempoMap()

        tmap.insert(beatTime: BeatTime(1), tempo: t120)
        tmap.insert(beatTime: BeatTime(5), tempo: t120)

        var movingID: TempoMap.EntryID?
        var survivorID: TempoMap.EntryID?

        tmap.forEach { entryID, beatTime, _, _ in
            if beatTime == BeatTime(1) {
                movingID = entryID
            } else {
                survivorID = entryID
            }
        }

        let entryID = try #require(movingID)
        let expectedSurvivor = try #require(survivorID)
        let newID = tmap.move(entryID: entryID, to: BeatTime(5))

        #expect(newID == expectedSurvivor)
        #expect(newID != entryID)

        var count = 0

        tmap.forEach { _, _, _, _ in count += 1 }

        #expect(count == 1)
    }

    @Test
    func move_notFound() {
        var tmap = TempoMap()

        #expect(tmap.move(entryID: TempoMap.EntryID(), to: BeatTime(1)) == nil)
    }

    @Test
    func remove_found() throws {
        let t120 = try #require(Tempo(uintValue: 120))
        var tmap = TempoMap()

        let inserted = tmap.insert(beatTime: BeatTime(1), tempo: t120)
        let removedID = tmap.remove(beatTime: BeatTime(1), tempo: t120)

        #expect(removedID == inserted.entryID)
        #expect(tmap.isEmpty)
    }

    @Test
    func remove_notFound() throws {
        let t120 = try #require(Tempo(uintValue: 120))
        let t90  = try #require(Tempo(uintValue: 90))
        var tmap = TempoMap()

        tmap.insert(beatTime: BeatTime(1), tempo: t120)

        let removedID = tmap.remove(beatTime: BeatTime(1), tempo: t90)

        #expect(removedID == nil)
        #expect(!tmap.isEmpty)
    }

    @Test
    func remove_entryID_found() throws {
        let t120 = try #require(Tempo(uintValue: 120))
        var tmap = TempoMap()
        var removedID: TempoMap.EntryID?

        tmap.insert(beatTime: BeatTime(1), tempo: t120)

        tmap.forEach { entryID, _, _, _ in
            removedID = entryID
        }

        let entryID = try #require(removedID)
        let removed = tmap.remove(entryID: entryID)

        #expect(removed)
        #expect(tmap.isEmpty)
    }

    @Test
    func remove_entryID_notFound() throws {
        let t120 = try #require(Tempo(uintValue: 120))
        var tmap = TempoMap()

        tmap.insert(beatTime: BeatTime(1), tempo: t120)

        let removed = tmap.remove(entryID: TempoMap.EntryID())

        #expect(!removed)
        #expect(!tmap.isEmpty)
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
        var tmap = TempoMap()

        tmap.insert(beatTime: BeatTime(0), tempo: t60)
        tmap.insert(beatTime: BeatTime(2), tempo: t120)

        // Polynomial n=2: T(u) = T₀ + (T₁−T₀)·u²
        // At u=0.5: 60 + (120−60)·0.25 = 75
        #expect(tmap[BeatTime(1)] == t75)
    }

    @Test
    func update_collapsesIntoDuplicate() throws {
        let t120 = try #require(Tempo(uintValue: 120))
        let t90  = try #require(Tempo(uintValue: 90))
        var tmap = TempoMap()
        var ids: [TempoMap.EntryID] = []

        tmap.insert(beatTime: BeatTime(1), tempo: t120)
        tmap.insert(beatTime: BeatTime(1), tempo: t90)

        tmap.forEach { entryID, _, _, _ in ids.append(entryID) }

        // Editing the second entry back to `t120` makes it an exact duplicate
        // of the first, so it should be dropped rather than left in place.
        let result = try tmap.update(entryID: #require(ids.last), tempo: t120)

        #expect(result.updated)
        #expect(result.removedEntryID == ids.first)

        var remaining: [TempoMap.EntryID] = []

        tmap.forEach { entryID, _, _, _ in remaining.append(entryID) }

        #expect(remaining == [ids.last])
    }

    @Test
    func update_found() throws {
        let t120 = try #require(Tempo(uintValue: 120))
        let t90  = try #require(Tempo(uintValue: 90))
        var tmap = TempoMap()
        var foundEntryID: TempoMap.EntryID?

        tmap.insert(beatTime: BeatTime(1), tempo: t120)

        tmap.forEach { entryID, _, _, _ in foundEntryID = entryID }

        let result = try tmap.update(entryID: #require(foundEntryID), tempo: t90)

        #expect(result.updated)
        #expect(result.removedEntryID == nil)
        #expect(tmap[BeatTime(1)] == t90)
    }

    @Test
    func update_notFound() throws {
        let t120 = try #require(Tempo(uintValue: 120))
        var tmap = TempoMap()

        let result = tmap.update(entryID: TempoMap.EntryID(), tempo: t120)

        #expect(!result.updated)
        #expect(result.removedEntryID == nil)
        #expect(tmap.isEmpty)
    }
}
