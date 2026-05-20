// © 2025–2026 John Gary Pusey (see LICENSE.md)

public import XestiTools

/// A beat-time–indexed map of tempos.
public struct TempoMap {

    // MARK: Public Initializers

    /// Creates a new, empty tempo map with the given default tempo.
    ///
    /// - Parameter defaultTempo:   The tempo used when the tempo map is empty.
    ///                             Defaults to `.default` (60 BPM).
    public init(defaultTempo: Tempo = .default) {
        self.defaultTempo = defaultTempo
        self.entries = []
        self.hasExtras = false
    }

    // MARK: Public Instance Properties

    /// The tempo used when this tempo map contains no entries.
    public let defaultTempo: Tempo

    /// A Boolean value indicating whether any entry in this tempo map carries
    /// extra data.
    public private(set) var hasExtras: Bool

    // MARK: Internal Instance Properties

    internal var entries: [Entry]
}

// MARK: -

extension TempoMap {

    // MARK: Public Instance Properties

    /// A Boolean value indicating whether this tempo map contains no entries.
    public var isEmpty: Bool {
        entries.isEmpty
    }

    // MARK: Public Instance Subscripts

    /// Returns the interpolated tempo in effect at the given beat time.
    ///
    /// - Parameter beatTime:   The beat time at which to query the tempo.
    ///
    /// - Returns:  The ``Tempo`` value in effect at `beatTime`, or
    ///             ``defaultTempo`` if this tempo map is empty.
    public subscript(_ beatTime: BeatTime) -> Tempo {
        guard !entries.isEmpty
        else { return defaultTempo }

        guard let idx = entries.firstIndex(where: { beatTime < $0.beatTime })
        else { return entries[entries.endIndex - 1].tempo }

        guard idx > 0
        else { return entries[0].tempo }

        let startEntry = entries[idx - 1]
        let endEntry = entries[idx]

        let fraction = beatTime.fraction(from: startEntry.beatTime,
                                         through: endEntry.beatTime)

        let rawStart = Int(startEntry.tempo.uintValue)
        let rawEnd = Int(endEntry.tempo.uintValue)
        let offset = Int((Double(rawEnd - rawStart) * fraction * fraction).rounded())

        return Tempo(UInt(max(1, rawStart + offset)))
    }

    // MARK: Public Instance Methods

    /// Calls the given closure for each entry in this tempo map, in order.
    ///
    /// - Parameter body:   A closure that receives the beat time, tempo, and
    ///                     optional extras for each entry.
    public func forEach(_ body: (BeatTime, Tempo, Extras?) -> Void) {
        entries.forEach {
            body($0.beatTime,
                 $0.tempo,
                 $0.extras)
        }
    }

    /// Inserts a tempo entry into this tempo map at the given beat time.
    ///
    /// - Parameter beatTime:   The beat time at which the tempo takes effect.
    /// - Parameter tempo:      The tempo to insert.
    /// - Parameter extras:     Optional extra data attached to the entry.
    ///                         Defaults to `nil`.
    public mutating func insert(beatTime: BeatTime,
                                tempo: Tempo,
                                extras: Extras? = nil) {
        entries.insert(Entry(beatTime: beatTime,
                             tempo: tempo,
                             extras: extras),
                       at: insertionIndex(for: beatTime))

        if extras != nil {
            hasExtras = true
        }
    }

    /// Returns a copy of this tempo map with a tempo entry added at the given
    /// beat time.
    ///
    /// - Parameter beatTime:   The beat time at which the tempo takes effect.
    /// - Parameter tempo:      The tempo to insert.
    /// - Parameter extras:     Optional extra data attached to the entry.
    ///                         Defaults to `nil`.
    ///
    /// - Returns:  A new tempo map with the entry inserted.
    public func inserting(beatTime: BeatTime,
                          tempo: Tempo,
                          extras: Extras? = nil) -> Self {
        var new = self

        new.insert(beatTime: beatTime,
                   tempo: tempo,
                   extras: extras)

        return new
    }

    /// Merges the entries from another tempo map into this tempo map.
    ///
    /// - Parameter other:  The tempo map whose entries are merged into this
    ///                     tempo map.
    public mutating func merge(with other: Self) {
        guard !other.entries.isEmpty
        else { return }

        guard !entries.isEmpty
        else { self = other; return }

        entries.append(contentsOf: other.entries)
        entries.sort()

        hasExtras = hasExtras || other.hasExtras
    }

    /// Returns a copy of this tempo map merged with another tempo map.
    ///
    /// - Parameter other:  The tempo map to merge with.
    ///
    /// - Returns:  A new tempo map containing the entries from the two tempo
    ///             maps.
    public func merging(with other: Self) -> Self {
        var new = self

        new.merge(with: other)

        return new
    }

    /// Removes a matching tempo entry from this tempo map, if present.
    ///
    /// - Parameter beatTime:   The beat time of the entry to remove.
    /// - Parameter tempo:      The tempo of the entry to remove.
    /// - Parameter extras:     The optional extra data of the entry to remove.
    ///                         Defaults to `nil`.
    public mutating func remove(beatTime: BeatTime,
                                tempo: Tempo,
                                extras: Extras? = nil) {
        guard let index = firstIndex(beatTime: beatTime,
                                     tempo: tempo,
                                     extras: extras)
        else { return }

        entries.remove(at: index)

        if extras != nil {
            hasExtras = Self.hasExtras(in: entries)
        }
    }

    /// Returns a copy of this tempo map with a matching entry removed.
    ///
    /// - Parameter beatTime:   The beat time of the entry to remove.
    /// - Parameter tempo:      The tempo of the entry to remove.
    /// - Parameter extras:     The optional extra data of the entry to remove.
    ///                         Defaults to `nil`.
    ///
    /// - Returns:  A new tempo map with the matching entry removed.
    public func removing(beatTime: BeatTime,
                         tempo: Tempo,
                         extras: Extras? = nil) -> Self {
        var new = self

        new.remove(beatTime: beatTime,
                   tempo: tempo,
                   extras: extras)

        return new
    }
}

// MARK: - Codable

extension TempoMap: Codable {

    /// Creates a tempo map by decoding from the provided decoder.
    ///
    /// - Parameter decoder:    The decoder to read from.
    ///
    /// - Throws:   `DecodingError` if the encoded data is invalid or corrupted.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.defaultTempo = try container.decode(Tempo.self,
                                                 forKey: .defaultTempo)

        self.entries = try container.decode([Entry].self,
                                            forKey: .entries)

        self.hasExtras = Self.hasExtras(in: entries)
    }

    /// Encodes this tempo map into the provided encoder.
    ///
    /// - Parameter encoder:    The encoder to write to.
    ///
    /// - Throws:   `EncodingError` if the value cannot be encoded.
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        //
        // Maintain order:
        //
        try container.encode(entries,
                             forKey: .entries)

        try container.encode(defaultTempo,
                             forKey: .defaultTempo)
    }

    // MARK: Private Nested Types

    private enum CodingKeys: String, CodingKey {
        case defaultTempo
        case entries
    }
}

// MARK: - Sendable

extension TempoMap: Sendable {
}
