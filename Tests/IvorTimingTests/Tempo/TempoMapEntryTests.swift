// © 2026 John Gary Pusey (see LICENSE.md)

@testable import IvorTiming
import Testing
import XestiTools

struct TempoMapEntryTests {
}

// MARK: -

extension TempoMapEntryTests {
    @Test
    func equality() {
        let stored = TempoMap.StoredEntry(beatTime: beat(1),
                                          tempo: Tempo(120),
                                          extras: nil)

        #expect(TempoMap.Entry(stored) == TempoMap.Entry(stored)) // swiftlint:disable:this identical_operands
    }

    @Test
    func equality_distinctEntryIDs() {
        let stored1 = TempoMap.StoredEntry(beatTime: beat(1),
                                           tempo: Tempo(120),
                                           extras: nil)
        let stored2 = TempoMap.StoredEntry(beatTime: beat(1),
                                           tempo: Tempo(120),
                                           extras: nil)

        #expect(TempoMap.Entry(stored1) != TempoMap.Entry(stored2))
    }

    @Test
    func init_extended() {
        let entryID = TempoMap.EntryID()
        let entry = TempoMap.Entry(TempoMap.StoredEntry(entryID: entryID,
                                                        beatTime: beat(3, 4),
                                                        tempo: dottedQuarter(90),
                                                        extras: extras()))

        #expect(entry.beatTime == beat(3, 4))
        #expect(entry.entryID == entryID)
        #expect(entry.extras == extras())
        #expect(entry.tempo == dottedQuarter(90))
    }

    @Test
    func init_simple() {
        let entryID = TempoMap.EntryID()
        let entry = TempoMap.Entry(TempoMap.StoredEntry(entryID: entryID,
                                                        beatTime: beat(2),
                                                        tempo: Tempo(60),
                                                        extras: nil))

        #expect(entry.beatTime == beat(2))
        #expect(entry.entryID == entryID)
        #expect(entry.extras == nil)
        #expect(entry.tempo == Tempo(60))
    }
}
