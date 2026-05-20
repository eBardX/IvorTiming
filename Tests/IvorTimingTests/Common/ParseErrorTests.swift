// © 2026 John Gary Pusey (see LICENSE.md)

@testable import IvorTiming
import Testing
import XestiTools

struct ParseErrorTests {
}

// MARK: -

extension ParseErrorTests {
    @Test
    func category() {
        #expect(ParseError.invalidTimeBasis("x").category == Category("IvorTiming"))
    }

    @Test
    func message_invalidTimeBasis() {
        #expect(ParseError.invalidTimeBasis("foo").message == "Invalid time basis: \u{2018}foo\u{2019}")
    }
}
