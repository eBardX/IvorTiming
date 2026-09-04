// © 2025–2026 John Gary Pusey (see LICENSE.md)

internal import XestiTools

extension TempoMap {

    // MARK: Internal Nested Types

    internal enum Entry {
        case extended(EntryID, BeatTime, Tempo, Extras)
        case simple(EntryID, BeatTime, Tempo)

        // MARK: Internal Initializers

        //
        // `entryID` defaults to a fresh identity — the common case, a newly inserted or
        // decoded entry. Passing one explicitly is for the one caller that needs to
        // keep an existing identity across a content change: `update(entryID:tempo:extras:)`.
        //
        internal init(entryID: EntryID = EntryID(),
                      beatTime: BeatTime,
                      tempo: Tempo,
                      extras: Extras?) {
            if let extras, !extras.isEmpty {
                self = .extended(entryID, beatTime, tempo, extras)
            } else {
                self = .simple(entryID, beatTime, tempo)
            }
        }
    }
}

// MARK: -

extension TempoMap.Entry {

    // MARK: Internal Instance Properties

    internal var beatTime: BeatTime {
        switch self {
        case let .extended(_, beatTime, _, _),
            let .simple(_, beatTime, _):
            beatTime
        }
    }

    internal var extras: Extras? {
        switch self {
        case let .extended(_, _, _, extras):
            extras

        default:
            nil
        }
    }

    internal var entryID: TempoMap.EntryID {
        switch self {
        case let .extended(entryID, _, _, _),
            let .simple(entryID, _, _):
            entryID
        }
    }

    internal var tempo: Tempo {
        switch self {
        case let .extended(_, _, tempo, _),
            let .simple(_, _, tempo):
            tempo
        }
    }
}

// MARK: - Codable

extension TempoMap.Entry: Codable {

    // MARK: Internal Initializers

    //
    // Identity is never encoded (see `EntryID`’s doc comment), so decoding always
    // assigns a fresh one via the default parameter — indistinguishable from a
    // freshly inserted entry.
    //
    internal init(from decoder: any Decoder) throws {
        var container = try decoder.unkeyedContainer()

        let beatTime = try container.decode(BeatTime.self)
        let tempo = try container.decode(Tempo.self)
        let extras = try container.decodeIfPresent(Extras.self)

        self.init(beatTime: beatTime,
                  tempo: tempo,
                  extras: extras)
    }

    // MARK: Internal Instance Methods

    internal func encode(to encoder: any Encoder) throws {
        var container = encoder.unkeyedContainer()

        try container.encode(beatTime)
        try container.encode(tempo)

        if let extras {
            try container.encode(extras)
        }
    }
}

// MARK: - Comparable

extension TempoMap.Entry: Comparable {

    // MARK: Internal Type Methods

    internal static func < (lhs: Self,
                            rhs: Self) -> Bool {
        lhs.beatTime < rhs.beatTime
    }
}

// MARK: - Equatable

extension TempoMap.Entry: Equatable {

    // MARK: Internal Type Methods

    //
    // Identity is deliberately excluded: two entries are equal here exactly when
    // they carry the same beat time, tempo, and extras, regardless of which
    // `EntryID` each holds. This is what lets `insert`'s exact-duplicate check, and
    // the `codable`/`equality` tests that construct content-identical entries
    // independently, keep working — a synthesized `==` that compared identity too
    // would make every such pair unequal, since each got a fresh, distinct entryID.
    //
    internal static func == (lhs: Self,
                             rhs: Self) -> Bool {
        (lhs.beatTime, lhs.tempo, lhs.extras) == (rhs.beatTime, rhs.tempo, rhs.extras)
    }
}

// MARK: - Sendable

extension TempoMap.Entry: Sendable {
}
