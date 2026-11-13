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
    func format() {
        #expect(formatRate(Tempo(120)) == "120")
    }

    @Test
    func format_omitsUnit() {
        #expect(formatRate(dottedQuarter(90)) == "90")
    }

    @Test
    func format_roundsHalvesUp() throws {
        #expect(try formatRate(#require(Tempo(rate: frac(200, 3), unit: dur(3, 8)))) == "67")
        #expect(try formatRate(#require(Tempo(rate: frac(135, 2)))) == "68")
        #expect(try formatRate(#require(Tempo(rate: frac(133, 2)))) == "67")
        #expect(try formatRate(#require(Tempo(rate: frac(661, 10)))) == "66")
        #expect(formatRate(dottedQuarter(67)) == "67")
    }

    @Test
    func formatted() {
        #expect(!Tempo(120).formatted().characters.isEmpty)
    }

    @Test
    func locale() {
        let style = Tempo.FormatStyle(locale: Locale(identifier: "en_US"))

        #expect(style.locale.identifier == "en_US")
    }
}
