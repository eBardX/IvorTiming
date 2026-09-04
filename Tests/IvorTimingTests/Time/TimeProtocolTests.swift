// © 2025–2026 John Gary Pusey (see LICENSE.md)

import Foundation
@testable import IvorTiming
import Testing
import XestiNumbers

struct TimeProtocolTests {
}

// MARK: -

extension TimeProtocolTests {
    @Test
    func formatted_beatTime() {
        let time: any TimeProtocol = BeatTime(4)

        #expect(!time.formatted().characters.isEmpty)
    }

    @Test
    func formatted_wallTime() {
        let time: any TimeProtocol = WallTime(4)

        #expect(!time.formatted().characters.isEmpty)
    }
}
