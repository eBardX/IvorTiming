// © 2025–2026 John Gary Pusey (see LICENSE.md)

@testable import IvorTiming
import Testing
import XestiNumbers
import XestiTools

struct TempoMapErrorTests {
}

// MARK: -

extension TempoMapErrorTests {
    @Test
    func category() {
        #expect(TempoMap.Error.invalidAugmentationFactor(2).category == Category("IvorTiming"))
    }

    @Test
    func message_augmentFailure() {
        let msg = TempoMap.Error.augmentFailure(BeatTime(0)).message

        #expect(msg.contains("augment"))
    }

    @Test
    func message_diminishFailure() {
        let msg = TempoMap.Error.diminishFailure(BeatTime(0)).message

        #expect(msg.contains("diminish"))
    }

    @Test
    func message_invalidAnchor() {
        let msg = TempoMap.Error.invalidAnchor.message

        #expect(msg.contains("anchor"))
    }

    @Test
    func message_invalidAugmentationFactor() {
        let msg = TempoMap.Error.invalidAugmentationFactor(Number(0)).message

        #expect(msg.contains("augmentation"))
    }

    @Test
    func message_invalidDiminutionFactor() {
        let msg = TempoMap.Error.invalidDiminutionFactor(Number(0)).message

        #expect(msg.contains("diminution"))
    }

    @Test
    func message_moveFailure() {
        let msg = TempoMap.Error.moveFailure(BeatTime(0)).message

        #expect(msg.contains("move"))
    }

    @Test
    func message_reverseFailure() {
        let msg = TempoMap.Error.reverseFailure(BeatTime(0)).message

        #expect(msg.contains("reverse"))
    }
}
