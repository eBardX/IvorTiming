// © 2025–2026 John Gary Pusey (see LICENSE.md)

import Foundation
@testable import IvorTiming
import Testing
import XestiNumbers

struct TempoFormatStyleTests {
}

// MARK: -

extension TempoFormatStyleTests {
    @Test
    func format() throws {
        let tempo = try #require(Tempo(uintValue: 120))
        let style = Tempo.FormatStyle(locale: Locale(identifier: "en_US"))
        let plain = style.format(tempo).characters.reduce(into: "") { $0.append($1) }

        #expect(plain == "120")
    }

    @Test
    func formatted() throws {
        let tempo = try #require(Tempo(uintValue: 120))

        #expect(!tempo.formatted().characters.isEmpty)
    }

    @Test
    func locale() {
        let style = Tempo.FormatStyle(locale: Locale(identifier: "en_US"))

        #expect(style.locale.identifier == "en_US")
    }
}
