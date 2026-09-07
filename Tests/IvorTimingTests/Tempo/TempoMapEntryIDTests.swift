// © 2025–2026 John Gary Pusey (see LICENSE.md)

import Foundation
@testable import IvorTiming
import Testing
import XestiTools

struct TempoMapEntryIDTests {
}

// MARK: -

extension TempoMapEntryIDTests {
    @Test
    func codable() throws {
        let original = TempoMap.EntryID()
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(TempoMap.EntryID.self, from: data)

        #expect(decoded == original)
    }

    @Test
    func equality() {
        let entryID = TempoMap.EntryID()
        let otherEntryID = TempoMap.EntryID()

        #expect(entryID == entryID) // swiftlint:disable:this identical_operands
        #expect(entryID != otherEntryID)
    }

    @Test
    func hashable() {
        let entryID = TempoMap.EntryID()
        let set: Set<TempoMap.EntryID> = [entryID, entryID, TempoMap.EntryID()]

        #expect(set.count == 2)
    }

    @Test
    func init_stringValue_invalid() {
        #expect(TempoMap.EntryID(stringValue: "") == nil)
        #expect(TempoMap.EntryID(stringValue: "not an entry id") == nil)
        #expect(TempoMap.EntryID(stringValue: "E$tooShort") == nil)
    }

    @Test
    func init_stringValue_valid() throws {
        let original = TempoMap.EntryID()
        let roundTripped = try #require(TempoMap.EntryID(stringValue: original.stringValue))

        #expect(roundTripped == original)
    }

    @Test
    func isValid() {
        let entryID = TempoMap.EntryID()

        #expect(TempoMap.EntryID.isValid(entryID.stringValue))
        #expect(!TempoMap.EntryID.isValid("not an entry id"))
    }

    @Test
    func uniqueness() {
        let firstEntryID = TempoMap.EntryID()
        let secondEntryID = TempoMap.EntryID()

        #expect(firstEntryID != secondEntryID)
    }
}
