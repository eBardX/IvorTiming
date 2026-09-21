// © 2025–2026 John Gary Pusey (see LICENSE.md)

import Foundation
@testable import IvorTiming
import Testing
import XestiNumbers
import XestiTools

struct ExtraTempoMapTests {
}

// MARK: -

extension ExtraTempoMapTests {
    @Test
    func midiTempo() {
        #expect(Extra.midiTempo.name == "midiTempo")
        #expect(Extra.midiTempo.values.isEmpty)
    }

    @Test
    func rampDuration() {
        #expect(Extra.rampDuration.name == "rampDuration")
        #expect(Extra.rampDuration.values.isEmpty)
    }

    @Test
    func rampEndTempo() {
        #expect(Extra.rampEndTempo.name == "rampFinalTempo")
        #expect(Extra.rampEndTempo.values.isEmpty)
    }

    @Test
    func rampStartTempo() {
        #expect(Extra.rampStartTempo.name == "rampInitialTempo")
        #expect(Extra.rampStartTempo.values.isEmpty)
    }

    @Test
    func tempoText() {
        #expect(Extra.tempoText.name == "tempoText")
        #expect(Extra.tempoText.values.isEmpty)
    }

    @Test
    func tempoText_roundTripsThroughTempoMapEntry() {
        var tempoMap = TempoMap()

        tempoMap.insert(beatTime: 1,
                        tempo: 120,
                        extras: Extras(elements: [Extra(name: Extra.tempoText.name,
                                                        values: [.string("Allegro")])]))

        var found = false

        tempoMap.forEach { _, _, _, extras in
            if let mark = extras?.elements.first(where: { $0.name == Extra.tempoText.name }),
               case let .string(text)? = mark.values.first {
                found = true

                #expect(text == "Allegro")
            }
        }

        #expect(found)
    }
}
