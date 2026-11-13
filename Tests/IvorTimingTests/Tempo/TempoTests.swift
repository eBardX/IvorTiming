// © 2025–2026 John Gary Pusey (see LICENSE.md)

import Foundation
@testable import IvorTiming
import Testing
import XestiNumbers

struct TempoTests {
}

// MARK: -

extension TempoTests {
    @Test
    func codable() throws {
        let tempos = try [Tempo(120),
                          dottedQuarter(90),
                          #require(Tempo(rate: frac(200, 3), unit: dur(3, 8)))]

        for original in tempos {
            let data = try JSONEncoder().encode(original)
            let decoded = try JSONDecoder().decode(Tempo.self, from: data)

            #expect(decoded == original)
        }
    }

    @Test
    func codable_encodesPlainString() throws {
        let data = try JSONEncoder().encode([dottedQuarter(90)])

        #expect(String(bytes: data, encoding: .utf8) == #"["3\/8=90"]"#)
    }

    @Test
    func codable_invalid() {
        for json in [#"["0"]"#, #"["1/4=0"]"#, "[120]", #"["abc"]"#] {
            #expect(throws: DecodingError.self) {
                try JSONDecoder().decode([Tempo].self, from: Data(json.utf8))
            }
        }
    }

    @Test
    func `default`() {
        #expect(Tempo.default.rate == 60)
        #expect(Tempo.default.unit == .quarter)
        #expect(Tempo.default.numberValue == 15)
    }

    @Test
    func description() {
        #expect(dottedQuarter(90).description == "3/8=90")
    }

    @Test
    func doubleValue() {
        #expect(Tempo(120).doubleValue == 30.0)
        #expect(dottedQuarter(90).doubleValue == 33.75)
    }

    @Test
    func equality_isNotational() {
        let dotted = dottedQuarter(90)
        let plain = Tempo(135)

        #expect(dotted.numberValue == plain.numberValue)
        #expect(dotted != plain)
        #expect(Tempo(60) == .default)
    }

    @Test
    func hashable() {
        let set: Set<Tempo> = [Tempo(60), Tempo(60), Tempo(120), dottedQuarter(90), Tempo(135)]

        #expect(set.count == 4)
    }

    @Test
    func init_rate() throws {
        let tempo = try #require(Tempo(rate: frac(200, 3), unit: dur(3, 8)))

        #expect(tempo.rate == frac(200, 3))
        #expect(tempo.unit == dur(3, 8))
        #expect(tempo.numberValue == 25)
    }

    @Test
    func init_rate_defaultUnit() throws {
        let tempo = try #require(Tempo(rate: 120))

        #expect(tempo.unit == .quarter)
        #expect(tempo == Tempo(120))
    }

    @Test
    func init_rate_invalid() {
        #expect(Tempo(rate: 0) == nil)
        #expect(Tempo(rate: -1) == nil)
        #expect(Tempo(rate: Number(120.5)) == nil)
        #expect(Tempo(rate: 60, unit: .zero) == nil)
    }

    @Test
    func init_uint() {
        let tempo = Tempo(90, unit: dur(3, 8))

        #expect(tempo.rate == 90)
        #expect(tempo.unit == dur(3, 8))
        #expect(Tempo(120).unit == .quarter)
    }

    @Test
    func numberValue() {
        #expect(Tempo(60).numberValue == 15)
        #expect(Tempo(120).numberValue == 30)
        #expect(dottedQuarter(90).numberValue == frac(135, 4))
        #expect(dottedQuarter(67).numberValue == frac(201, 8))
        #expect(Tempo(40, unit: dur(5, 8)).numberValue == 25)
    }

    @Test
    func numberValue_meterTableVectors() {
        // METER_TABLE.md 1.10, Tempo table (the ramp row is in TempoMapTests).
        #expect(Tempo.default.numberValue == 15)
        #expect(Tempo(120).numberValue == 30)
        #expect(dottedQuarter(90).numberValue == frac(135, 4))
        #expect(dottedQuarter(90).restated(in: dur(1, 8)) == Tempo(270, unit: dur(1, 8)))
        #expect(dottedQuarter(67).numberValue == frac(201, 8))
        #expect(Tempo(rate: frac(200, 3), unit: dur(3, 8))?.numberValue == 25)
        #expect(Tempo(40, unit: dur(5, 8)).numberValue == 25)
    }

    @Test
    func plain() throws {
        #expect(Tempo(60).plain == "1/4=60")
        #expect(dottedQuarter(90).plain == "3/8=90")
        #expect(try #require(Tempo(rate: frac(200, 3), unit: dur(3, 8))).plain == "3/8=200/3")
        #expect(Tempo(60, unit: dur(3, 2)).plain == "3/2=60")
        #expect(Tempo(60, unit: dur(1)).plain == "1=60")
    }

    @Test
    func plain_parse() throws {
        #expect(Tempo(plain: "1/4=60") == Tempo(60))
        #expect(Tempo(plain: "3/8=200/3") == Tempo(rate: frac(200, 3), unit: dur(3, 8)))
        #expect(Tempo(plain: "90") == Tempo(90))
        #expect(Tempo(plain: "66 2/3") == Tempo(rate: frac(200, 3)))
        #expect(Tempo(plain: "3/8=66 2/3") == Tempo(rate: frac(200, 3), unit: dur(3, 8)))
        #expect(Tempo(plain: "66.5") == Tempo(rate: frac(133, 2)))
        #expect(Tempo(plain: "1/4=66.1") == Tempo(rate: frac(661, 10)))
        #expect(Tempo(plain: "1 1/2=60") == Tempo(60, unit: dur(3, 2)))
        #expect(Tempo(plain: "3/8 = 90") == dottedQuarter(90))

        let decimal = try #require(Tempo(plain: "66.1"))

        #expect(decimal.rate.isExact)
    }

    @Test
    func plain_parse_invalid() {
        #expect(Tempo(plain: "0") == nil)
        #expect(Tempo(plain: "-1") == nil)
        #expect(Tempo(plain: "1/4=0") == nil)
        #expect(Tempo(plain: "0=60") == nil)
        #expect(Tempo(plain: "-1/4=60") == nil)
        #expect(Tempo(plain: "1/4=60=1") == nil)
        #expect(Tempo(plain: "=60") == nil)
        #expect(Tempo(plain: "1/4=") == nil)
        #expect(Tempo(plain: "") == nil)
        #expect(Tempo(plain: "not a number") == nil)
        #expect(Tempo(plain: "1/0") == nil)
        #expect(Tempo(plain: ".5") == nil)
    }

    @Test
    func plain_roundTrip() throws {
        let tempos = try [Tempo(60),
                          dottedQuarter(90),
                          #require(Tempo(rate: frac(200, 3), unit: dur(3, 8))),
                          Tempo(40, unit: dur(5, 8)),
                          Tempo(60, unit: dur(3, 2))]

        for tempo in tempos {
            #expect(Tempo(plain: tempo.plain) == tempo)
        }
    }

    @Test
    func restated() {
        let restated = dottedQuarter(90).restated(in: dur(1, 8))

        #expect(restated == Tempo(270, unit: dur(1, 8)))
        #expect(restated.numberValue == dottedQuarter(90).numberValue)
    }

    @Test
    func restated_fractionalRate() {
        let restated = Tempo(100).restated(in: dur(3, 8))

        #expect(restated.rate == frac(200, 3))
        #expect(restated.numberValue == Tempo(100).numberValue)
    }

    @Test
    func scaled() {
        #expect(Tempo(240, unit: dur(1, 8)).scaled(unitBy: 2) == Tempo(240))
        #expect(dottedQuarter(90).scaled(unitBy: frac(1, 3)) == Tempo(90, unit: dur(1, 8)))
        #expect(Tempo(60).scaled(unitBy: 2)?.numberValue == 30)
    }

    @Test
    func scaled_invalid() {
        #expect(Tempo(60).scaled(unitBy: 0) == nil)
        #expect(Tempo(60).scaled(unitBy: -2) == nil)
    }
}
