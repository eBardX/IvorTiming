// © 2025–2026 John Gary Pusey (see LICENSE.md)

import Foundation
@testable import IvorTiming
import Testing
import XestiNumbers

struct WallTimeFormatStyleTests {
}

// MARK: -

extension WallTimeFormatStyleTests {
    @Test
    func format() {
        let style = WallTime.FormatStyle(locale: Locale(identifier: "en_US"))
        let plain = style.format(WallTime(4)).characters.reduce(into: "") { $0.append($1) }

        #expect(plain == "4")
    }

    @Test
    func formatted() {
        #expect(!WallTime(4).formatted().characters.isEmpty)
    }

    @Test
    func locale() {
        let style = WallTime.FormatStyle(locale: Locale(identifier: "en_US"))

        #expect(style.locale.identifier == "en_US")
    }
}
