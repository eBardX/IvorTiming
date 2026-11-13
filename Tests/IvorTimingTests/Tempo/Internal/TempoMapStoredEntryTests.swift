// © 2025–2026 John Gary Pusey (see LICENSE.md)

import Foundation
@testable import IvorTiming
import Testing
import XestiNumbers
import XestiTools

struct TempoMapStoredEntryTests {
}

// MARK: -

extension TempoMapStoredEntryTests {
    @Test
    func beatTime() {
        let t120 = Tempo(120)
        let simple = TempoMap.StoredEntry(beatTime: BeatTime(1), tempo: t120, extras: nil)
        let extended = TempoMap.StoredEntry(beatTime: BeatTime(2),
                                            tempo: t120,
                                            extras: Extras(elements: [Extra(name: "tag")]))

        #expect(simple.beatTime == BeatTime(1))
        #expect(extended.beatTime == BeatTime(2))
    }

    @Test
    func codable() throws {
        let t120 = Tempo(120)
        let simple = TempoMap.StoredEntry(beatTime: BeatTime(1), tempo: t120, extras: nil)
        let extended = TempoMap.StoredEntry(beatTime: BeatTime(2),
                                            tempo: t120,
                                            extras: Extras(elements: [Extra(name: "tag")]))

        for original in [simple, extended] {
            let data = try JSONEncoder().encode(original)
            let decoded = try JSONDecoder().decode(TempoMap.StoredEntry.self, from: data)

            #expect(decoded == original)
        }
    }

    @Test
    func comparable() {
        let t120 = Tempo(120)
        let earlier = TempoMap.StoredEntry(beatTime: BeatTime(1), tempo: t120, extras: nil)
        let later = TempoMap.StoredEntry(beatTime: BeatTime(2), tempo: t120, extras: nil)

        #expect(earlier < later)
        #expect(!(later < earlier))
    }

    @Test
    func entryID_defaultsToFreshIdentity() {
        let t120 = Tempo(120)
        let e1 = TempoMap.StoredEntry(beatTime: BeatTime(1), tempo: t120, extras: nil)
        let e2 = TempoMap.StoredEntry(beatTime: BeatTime(1), tempo: t120, extras: nil)

        #expect(e1.entryID != e2.entryID)
    }

    @Test
    func entryID_explicit() {
        let t120 = Tempo(120)
        let entryID = TempoMap.EntryID()
        let entry = TempoMap.StoredEntry(entryID: entryID, beatTime: BeatTime(1), tempo: t120, extras: nil)

        #expect(entry.entryID == entryID)
    }

    @Test
    func equality() {
        let t120 = Tempo(120)
        let e1 = TempoMap.StoredEntry(beatTime: BeatTime(1), tempo: t120, extras: nil)
        let e2 = TempoMap.StoredEntry(beatTime: BeatTime(1), tempo: t120, extras: nil)

        #expect(e1 == e2)
    }

    @Test
    func equality_ignoresIdentity() {
        let t120 = Tempo(120)
        let e1 = TempoMap.StoredEntry(beatTime: BeatTime(1), tempo: t120, extras: nil)
        let e2 = TempoMap.StoredEntry(beatTime: BeatTime(1), tempo: t120, extras: nil)

        #expect(e1.entryID != e2.entryID)
        #expect(e1 == e2)
    }

    @Test
    func extras() {
        let t120 = Tempo(120)
        let extrasValue = Extras(elements: [Extra(name: "tag")])
        let simple = TempoMap.StoredEntry(beatTime: BeatTime(1), tempo: t120, extras: nil)
        let extended = TempoMap.StoredEntry(beatTime: BeatTime(1), tempo: t120, extras: extrasValue)

        #expect(simple.extras == nil)
        #expect(extended.extras == extrasValue)
    }

    @Test
    func inequality() {
        let t120 = Tempo(120)
        let t90 = Tempo(90)
        let e1 = TempoMap.StoredEntry(beatTime: BeatTime(1), tempo: t120, extras: nil)
        let e2 = TempoMap.StoredEntry(beatTime: BeatTime(2), tempo: t120, extras: nil)
        let e3 = TempoMap.StoredEntry(beatTime: BeatTime(1), tempo: t90, extras: nil)

        #expect(e1 != e2)
        #expect(e1 != e3)
    }

    @Test
    func init_emptyExtras() {
        let t120 = Tempo(120)
        let entry = TempoMap.StoredEntry(beatTime: BeatTime(1), tempo: t120, extras: Extras())

        #expect(entry.extras == nil)
    }

    @Test
    func init_noExtras() {
        let t120 = Tempo(120)
        let entry = TempoMap.StoredEntry(beatTime: BeatTime(1), tempo: t120, extras: nil)

        #expect(entry.extras == nil)
    }

    @Test
    func init_withExtras() {
        let t120 = Tempo(120)
        let extrasValue = Extras(elements: [Extra(name: "tag")])
        let entry = TempoMap.StoredEntry(beatTime: BeatTime(1), tempo: t120, extras: extrasValue)

        #expect(entry.extras == extrasValue)
    }

    @Test
    func tempo() {
        let t120 = Tempo(120)
        let t90 = Tempo(90)
        let simple = TempoMap.StoredEntry(beatTime: BeatTime(1), tempo: t120, extras: nil)
        let extended = TempoMap.StoredEntry(beatTime: BeatTime(1),
                                            tempo: t90,
                                            extras: Extras(elements: [Extra(name: "tag")]))

        #expect(simple.tempo == t120)
        #expect(extended.tempo == t90)
    }
}
