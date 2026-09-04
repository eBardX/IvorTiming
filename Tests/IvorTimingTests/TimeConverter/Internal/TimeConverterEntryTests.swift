// © 2026 John Gary Pusey (see LICENSE.md)

@testable import IvorTiming
import Testing
import XestiNumbers

struct TimeConverterEntryTests {
}

// MARK: -

extension TimeConverterEntryTests {
    @Test
    func init_validValues() throws {
        let t120 = try #require(Tempo(uintValue: 120))
        let entry = TimeConverter.Entry(beatTime: BeatTime(1), tempo: t120)

        #expect(entry.beatTime == BeatTime(1))
        #expect(entry.tempo == t120)
        #expect(entry.beatDuration == .zero)
        #expect(entry.tempoChange == 0)
        #expect(entry.wallDuration == .zero)
        #expect(entry.wallTime == .zero)
    }
}
