// © 2026 John Gary Pusey (see LICENSE.md)

import Foundation
@testable import IvorTiming
import XestiNumbers
import XestiTools

// MARK: -

internal func beat(_ numerator: Int,
                   _ denominator: Int = 1) -> BeatTime {
    BeatTime(frac(numerator, denominator))
}

internal func dottedQuarter(_ rate: UInt) -> Tempo {
    Tempo(rate, unit: .dottedQuarter)
}

internal func dur(_ numerator: Int,
                  _ denominator: Int = 1) -> BeatDuration {
    BeatDuration(frac(numerator, denominator))
}

internal func extras() -> Extras {
    Extras(elements: [Extra(name: "tag")])
}

internal func formatRate(_ tempo: Tempo) -> String {
    let style = Tempo.FormatStyle(locale: Locale(identifier: "en_US"))

    return String(style.format(tempo).characters)
}

internal func frac(_ numerator: Int,
                   _ denominator: Int) -> Number {
    Number(numerator: numerator,
           denominator: denominator)
}
