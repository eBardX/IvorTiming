// © 2025–2026 John Gary Pusey (see LICENSE.md)

import Foundation
@testable import IvorTiming
import Testing
import XestiNumbers

struct BeatDurationFormatStyleTests {
}

// MARK: -

extension BeatDurationFormatStyleTests {
    @Test
    func format() {
        let style = BeatDuration.FormatStyle(locale: Locale(identifier: "en_US"))
        let plain = style.format(BeatDuration(4)).characters.reduce(into: "") { $0.append($1) }

        #expect(plain == "4")
    }

    @Test
    func formatted() {
        #expect(!BeatDuration(4).formatted().characters.isEmpty)
    }

    @Test
    func locale() {
        let style = BeatDuration.FormatStyle(locale: Locale(identifier: "en_US"))

        #expect(style.locale.identifier == "en_US")
    }
}
