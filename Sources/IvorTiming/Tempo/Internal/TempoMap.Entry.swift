// © 2025–2026 John Gary Pusey (see LICENSE.md)

internal import XestiTools

extension TempoMap {

    // MARK: Internal Nested Types

    internal enum Entry {
        case extended(BeatTime, Tempo, Extras)
        case simple(BeatTime, Tempo)
    }
}

// MARK: -

extension TempoMap.Entry {

    // MARK: Internal Initializers

    internal init(beatTime: BeatTime,
                  tempo: Tempo,
                  extras: Extras?) {
        if let extras, !extras.isEmpty {
            self = .extended(beatTime, tempo, extras)
        } else {
            self = .simple(beatTime, tempo)
        }
    }

    // MARK: Internal Instance Properties

    internal var beatTime: BeatTime {
        switch self {
        case let .extended(beatTime, _, _),
            let .simple(beatTime, _):
            beatTime
        }
    }

    internal var extras: Extras? {
        switch self {
        case let .extended(_, _, extras):
            extras

        default:
            nil
        }
    }

    internal var tempo: Tempo {
        switch self {
        case let .extended(_, tempo, _),
            let .simple(_, tempo):
            tempo
        }
    }
}

// MARK: - Codable

extension TempoMap.Entry: Codable {

    // MARK: Internal Initializers

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
}

// MARK: - Sendable

extension TempoMap.Entry: Sendable {
}
