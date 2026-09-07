// © 2026 John Gary Pusey (see LICENSE.md)

@testable import IvorTiming
import Testing

struct WallFunctionsTests {
}

// MARK: -

extension WallFunctionsTests {
    @Test
    func formatWallSeconds_wholeSeconds() {
        #expect(formatWallSeconds(0) == "0")
        #expect(formatWallSeconds(1_000) == "1")
    }

    @Test
    func formatWallSeconds_withFraction() {
        #expect(formatWallSeconds(1_500) == "1.5")
        #expect(formatWallSeconds(1_050) == "1.05")
        #expect(formatWallSeconds(1_005) == "1.005")
    }

    @Test
    func parseWallSeconds_invalid() {
        #expect(parseWallSeconds("") == nil)
        #expect(parseWallSeconds("not a number") == nil)
        #expect(parseWallSeconds("1.") == nil)
        #expect(parseWallSeconds("1.2.3") == nil)
        #expect(parseWallSeconds("1.0001") == nil)
        #expect(parseWallSeconds("-1") == nil)
    }

    @Test
    func parseWallSeconds_wholeSeconds() {
        #expect(parseWallSeconds("0") == 0)
        #expect(parseWallSeconds("1") == 1_000)
    }

    @Test
    func parseWallSeconds_withFraction() {
        #expect(parseWallSeconds("1.5") == 1_500)
        #expect(parseWallSeconds("1.05") == 1_050)
        #expect(parseWallSeconds("1.005") == 1_005)
    }
}
