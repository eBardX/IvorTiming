// © 2026 John Gary Pusey (see LICENSE.md)

@testable import IvorTiming
import Testing
import XestiNumbers

struct BeatQuantizerTests {
}

// MARK: -

extension BeatQuantizerTests {
    @Test
    func init_emptyFactors() {
        #expect(throws: BeatQuantizer.Error.self) { try BeatQuantizer(factors: []) }
    }

    @Test
    func init_invalidFactor() {
        #expect(throws: BeatQuantizer.Error.self) { try BeatQuantizer(factors: [0]) }
        #expect(throws: BeatQuantizer.Error.self) { try BeatQuantizer(factors: [-1]) }
        #expect(throws: BeatQuantizer.Error.self) { try BeatQuantizer(factors: [4, 0, 2]) }
    }

    @Test
    func init_validFactors() throws {
        _ = try BeatQuantizer(factors: [1])
        _ = try BeatQuantizer(factors: [2, 3, 4])
    }

    @Test
    func quantize_equivalentFactors() throws {
        let q4  = try BeatQuantizer(factors: [4])
        let q8  = try BeatQuantizer(factors: [8])
        let q48 = try BeatQuantizer(factors: [4, 8])

        let bt = BeatTime(3.141592)

        #expect(q48.quantize(bt) == q8.quantize(bt))
        #expect(q48.quantize(bt) != q4.quantize(bt))
    }

    @Test
    func quantize_alreadyOnGrid() throws {
        let q = try BeatQuantizer(factors: [4])

        #expect(q.quantize("1/4") == "1/4")
        #expect(q.quantize("3/4") == "3/4")
        #expect(q.quantize(BeatTime(2)) == BeatTime(2))
    }

    @Test
    func quantize_inexact() throws {
        let q4 = try BeatQuantizer(factors: [4])
        let q8 = try BeatQuantizer(factors: [8])

        #expect(q4.quantize(BeatTime(0.123456)) == BeatTime(0))
        #expect(q4.quantize(BeatTime(1.888888)) == BeatTime(2))
        #expect(q4.quantize(BeatTime(2.376543)) == BeatTime(2.5))
        #expect(q4.quantize(BeatTime(3.141592)) == BeatTime(3.25))
        #expect(q8.quantize(BeatTime(3.141592)) == BeatTime(3.125))
    }

    @Test
    func quantize_inexact_producesRational() throws {
        let q = try BeatQuantizer(factors: [4])

        #expect(q.quantize(BeatTime(0.123456)).numberValue.isExact)
        #expect(q.quantize(BeatTime(3.141592)).numberValue.isExact)
        #expect(q.quantize(BeatTime(2.376543)).numberValue.isExact)
    }

    @Test
    func quantize_multipleFactors() throws {
        let q = try BeatQuantizer(factors: [2, 3])

        #expect(q.quantize("1/4") == "1/3")
        #expect(q.quantize("5/8") == "2/3")
    }

    @Test
    func quantize_subdivision() throws {
        let q = try BeatQuantizer(factors: [2])

        #expect(q.quantize("3/8") == "1/2")
        #expect(q.quantize("5/8") == "1/2")
        #expect(q.quantize("11/8") == "3/2")
    }
}
