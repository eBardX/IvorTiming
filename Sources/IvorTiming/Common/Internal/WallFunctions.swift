// © 2026 John Gary Pusey (see LICENSE.md)

internal import Foundation

// MARK: Internal Functions

internal func formatWallSeconds(_ milliseconds: UInt) -> String {
    let secText = String(milliseconds / 1_000)
    let fracValue = milliseconds % 1_000

    guard fracValue != 0
    else { return secText }

    var fracText = String(format: "%03d", fracValue)

    while fracText.hasSuffix("0") {
        fracText.removeLast()
    }

    return secText + "." + fracText
}

internal func parseWallSeconds(_ text: String) -> UInt? {
    let parts = text.split(separator: ".",
                           maxSplits: 1,
                           omittingEmptySubsequences: false)

    guard (1...2).contains(parts.count),
          let secValue = UInt(parts[0])
    else { return nil }

    guard parts.count == 2
    else { return secValue * 1_000 }

    let fracText = parts[1]

    guard (1...3).contains(fracText.count),
          let fracValue = UInt(fracText)
    else { return nil }

    let scale: UInt = [100, 10, 1][fracText.count - 1]

    return (secValue * 1_000) + (fracValue * scale)
}
