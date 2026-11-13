// © 2026 John Gary Pusey (see LICENSE.md)

private import XestiNumbers

extension BeatDuration {

    // MARK: Public Type Properties

    /// The duration of a dotted eighth note: 3/16 of a whole note.
    public static let dottedEighth = Self(Number(numerator: 3,
                                                 denominator: 16))

    /// The duration of a dotted half note: 3/4 of a whole note.
    public static let dottedHalf = Self(Number(numerator: 3,
                                               denominator: 4))

    /// The duration of a dotted quarter note: 3/8 of a whole note.
    public static let dottedQuarter = Self(Number(numerator: 3,
                                                  denominator: 8))

    /// The duration of an eighth note: 1/8 of a whole note.
    public static let eighth = Self(Number(numerator: 1,
                                           denominator: 8))

    /// The duration of a half note: 1/2 of a whole note.
    public static let half = Self(Number(numerator: 1,
                                         denominator: 2))

    /// The duration of a quarter note: 1/4 of a whole note.
    public static let quarter = Self(Number(numerator: 1,
                                            denominator: 4))

    /// The duration of a sixteenth note: 1/16 of a whole note.
    public static let sixteenth = Self(Number(numerator: 1,
                                              denominator: 16))

    /// The duration of a whole note.
    public static let whole = Self(1)
}
