// © 2025–2026 John Gary Pusey (see LICENSE.md)

@testable import IvorTiming
import Testing
import XestiNumbers
import XestiTools

struct TempoMapInternalTests {
}

// MARK: -

extension TempoMapInternalTests {
    @Test
    func firstIndex_found() throws {
        let t120 = try #require(Tempo(uintValue: 120))
        var tmap = TempoMap()

        tmap.insert(beatTime: BeatTime(1), tempo: t120)

        #expect(tmap.firstIndex(beatTime: BeatTime(1), tempo: t120, extras: nil) == 0)
    }

    @Test
    func firstIndex_notFound() throws {
        let t120 = try #require(Tempo(uintValue: 120))
        var tmap = TempoMap()

        tmap.insert(beatTime: BeatTime(1), tempo: t120)

        let index = tmap.firstIndex(beatTime: BeatTime(2), tempo: t120, extras: nil)

        #expect(index == nil)
    }

    @Test
    func deduplicated_keepsFirstOccurrence() throws {
        let t120 = try #require(Tempo(uintValue: 120))
        let t90  = try #require(Tempo(uintValue: 90))
        let first = TempoMap.Entry(beatTime: BeatTime(1), tempo: t120, extras: nil)
        let duplicate = TempoMap.Entry(beatTime: BeatTime(1), tempo: t120, extras: nil)
        let distinct = TempoMap.Entry(beatTime: BeatTime(2), tempo: t90, extras: nil)
        let result = TempoMap.deduplicated([first, duplicate, distinct])

        #expect(result.count == 2)
        #expect(result[0].entryID == first.entryID)
        #expect(result[1].entryID == distinct.entryID)
    }

    @Test
    func deduplicated_empty() {
        #expect(TempoMap.deduplicated([]).isEmpty)
    }

    @Test
    func firstIndex_entryID_found() throws {
        let t120 = try #require(Tempo(uintValue: 120))
        var tmap = TempoMap()

        tmap.insert(beatTime: BeatTime(1), tempo: t120)

        var foundEntryID: TempoMap.EntryID?

        tmap.forEach { entryID, _, _, _ in foundEntryID = entryID }

        #expect(try tmap.firstIndex(entryID: #require(foundEntryID)) == 0)
    }

    @Test
    func firstIndex_entryID_notFound() {
        let tmap = TempoMap()
        let position = tmap.firstIndex(entryID: TempoMap.EntryID())

        #expect(position == nil)
    }

    @Test
    func hasExtras_empty() {
        #expect(!TempoMap.hasExtras(in: []))
    }

    @Test
    func hasExtras_withExtras() throws {
        let t120 = try #require(Tempo(uintValue: 120))
        let entry = TempoMap.Entry(beatTime: BeatTime(1),
                                   tempo: t120,
                                   extras: Extras(elements: [Extra(name: "tag")]))

        #expect(TempoMap.hasExtras(in: [entry]))
    }

    @Test
    func hasExtras_withoutExtras() throws {
        let t120 = try #require(Tempo(uintValue: 120))
        let entry = TempoMap.Entry(beatTime: BeatTime(1), tempo: t120, extras: nil)

        #expect(!TempoMap.hasExtras(in: [entry]))
    }

    @Test
    func insertionIndex_empty() {
        let tmap = TempoMap()

        #expect(tmap.insertionIndex(for: BeatTime(1)) == 0)
    }

    @Test
    func insertionIndex_middle() throws {
        let t120 = try #require(Tempo(uintValue: 120))
        var tmap = TempoMap()

        tmap.insert(beatTime: BeatTime(1), tempo: t120)
        tmap.insert(beatTime: BeatTime(3), tempo: t120)

        #expect(tmap.insertionIndex(for: BeatTime(2)) == 1)
    }
}
