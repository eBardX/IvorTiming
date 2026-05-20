// © 2026 John Gary Pusey (see LICENSE.md)

@testable import IvorTiming
import Testing
import XestiTools

struct BeatQuantizerErrorTests {
}

// MARK: -

extension BeatQuantizerErrorTests {
    @Test
    func category() {
        #expect(BeatQuantizer.Error.invalidFactor(0).category == Category("IvorTiming"))
    }

    @Test
    func message_emptyFactors() {
        #expect(BeatQuantizer.Error.emptyFactors.message == "The subdivision factors must not be empty")
    }

    @Test
    func message_invalidFactor() {
        #expect(BeatQuantizer.Error.invalidFactor(-3).message == "Invalid subdivision factor: -3")
    }
}
