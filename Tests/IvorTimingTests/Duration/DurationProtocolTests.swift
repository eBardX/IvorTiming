// © 2025–2026 John Gary Pusey (see LICENSE.md)

import Foundation
@testable import IvorTiming
import Testing
import XestiNumbers

struct DurationProtocolTests {
}

// MARK: -

extension DurationProtocolTests {
    @Test
    func formatted_beatDuration() {
        let duration: any DurationProtocol = BeatDuration(4)

        #expect(!duration.formatted().characters.isEmpty)
    }

    @Test
    func formatted_wallDuration() {
        let duration: any DurationProtocol = WallDuration(4)

        #expect(!duration.formatted().characters.isEmpty)
    }
}
