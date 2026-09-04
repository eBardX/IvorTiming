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
    /// - Parameter body:   A closure that receives the identity, beat time,
    ///                     tempo, and optional extras for each entry.
    public func forEach(_ body: (EntryID, BeatTime, Tempo, Extras?) -> Void) {
        entries.forEach {
            body($0.entryID,
                 $0.beatTime,
                 $0.tempo,
                 $0.extras)
        }
    }

    /// Inserts a tempo entry into this tempo map at the given beat time.
    ///
    /// An entry that exactly duplicates one already present — same beat time,
    /// tempo, and extras — carries no information beyond the original and is
    /// silently ignored. Two entries at the same beat time with *different*
    /// tempos are a deliberate, meaningful step (interpolation jumps
    /// instantly at that beat time), and are unaffected by this check.
    ///
    /// - Parameter beatTime:   The beat time at which the tempo takes effect.
    /// - Parameter tempo:      The tempo to insert.
    /// - Parameter extras:     Optional extra data attached to the entry.
    ///                         Defaults to `nil`.
    ///
    /// - Returns:  A pair of the identity that now addresses this entry —
    ///             a freshly generated identity, unless the insertion
    ///             collapsed into a pre-existing exact duplicate (see
    ///             above), in which case the survivor's identity — and
    ///             `inserted`, `true` if a new entry was added and `false`
    ///             if the insertion collapsed into that pre-existing
    ///             duplicate instead.
    @discardableResult
    public mutating func insert(beatTime: BeatTime,
                                tempo: Tempo,
                                extras: Extras? = nil) -> (entryID: EntryID, inserted: Bool) {
        _insert(entryID: EntryID(),
                beatTime: beatTime,
                tempo: tempo,
                extras: extras)
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

    /// Moves the tempo entry with the given identity to a new beat time,
    /// keeping its tempo and extras, and re-sorts it into place.
    ///
    /// Unlike ``update(entryID:tempo:extras:)``, this is expected to reorder
    /// entries — that is the point of editing the beat time itself. Two
    /// entries legitimately ending up at the same beat time (see
    /// ``insert(beatTime:tempo:extras:)`` for the discontinuity use case) is
    /// not treated as a collision to reject; the moved entry simply takes
    /// its place among any others already there, exactly as a fresh
    /// insertion would.
    ///
    /// The one case where `entryID` stops identifying the moved entry afterward is
    /// when the move lands it exactly on top of another entry already
    /// present — same beat time, tempo, and extras — the same exact-duplicate
    /// case ``insert(beatTime:tempo:extras:)`` silently collapses. There, the
    /// moved entry merges into that pre-existing one instead of being kept
    /// separately, so `entryID` no longer names anything in the map; the returned
    /// identity is the survivor's instead, which a caller must switch to
    /// addressing from then on.
    ///
    /// - Parameter entryID:    The identity of the entry to move.
    /// - Parameter beatTime:   The new beat time for the entry.
    ///
    /// - Returns:  The identity that now addresses this entry's content — `entryID`
    ///             itself, unless the move merged it into a pre-existing exact
    ///             duplicate, in which case the survivor's identity. `nil` if
    ///             `entryID` did not identify any entry and nothing moved.
    @discardableResult
    public mutating func move(entryID: EntryID,
                              to beatTime: BeatTime) -> EntryID? {
        guard let position = firstIndex(entryID: entryID)
        else { return nil }

        let entry = entries.remove(at: position)

        let (newID, _) = _insert(entryID: entryID,
                                 beatTime: beatTime,
                                 tempo: entry.tempo,
                                 extras: entry.extras)

        hasExtras = Self.hasExtras(in: entries)

        return newID
    }

    /// Removes the tempo entry with the given identity, if present.
    ///
    /// - Parameter entryID:  The identity of the entry to remove. An identity
    ///                       naming no entry is ignored.
    ///
    /// - Returns:  `true` if `entryID` identified an entry and it was
    ///             removed, `false` if `entryID` named no entry and nothing
    ///             happened.
    @discardableResult
    public mutating func remove(entryID: EntryID) -> Bool {
        guard let position = firstIndex(entryID: entryID)
        else { return false }

        entries.remove(at: position)

        hasExtras = Self.hasExtras(in: entries)

        return true
    }

    /// Removes a matching tempo entry from this tempo map, if present.
    ///
    /// - Parameter beatTime:   The beat time of the entry to remove.
    /// - Parameter tempo:      The tempo of the entry to remove.
    /// - Parameter extras:     The optional extra data of the entry to remove.
    ///                         Defaults to `nil`.
    ///
    /// - Returns:  The identity of the entry that was removed, or `nil` if
    ///             no entry matched `beatTime`, `tempo`, and `extras`.
    @discardableResult
    public mutating func remove(beatTime: BeatTime,
                                tempo: Tempo,
                                extras: Extras? = nil) -> EntryID? {
        guard let index = firstIndex(beatTime: beatTime,
                                     tempo: tempo,
                                     extras: extras)
        else { return nil }

        let entryID = entries[index].entryID

        entries.remove(at: index)

        if extras != nil {
            hasExtras = Self.hasExtras(in: entries)
        }

        return entryID
    }

    /// Replaces the tempo entry with the given identity, in place.
    ///
    /// Unlike a ``remove(beatTime:tempo:extras:)`` followed by an
    /// ``insert(beatTime:tempo:extras:)``, this does not reorder entries.
    /// That distinction only matters when more than one entry shares a beat
    /// time: value-based removal cannot tell which of them was meant, and
    /// insertion always lands after every entry already at that beat time —
    /// so a remove-then-insert edit of one entry among ties silently changes
    /// the order of entries that were never touched. Updating in place at a
    /// known identity avoids both problems, and — unlike a position — that
    /// identity keeps addressing this same entry across any other entry's
    /// edit, so a caller never needs to re-resolve it first.
    ///
    /// The edit can turn this entry into an exact duplicate of another one
    /// already at the same beat time — same beat time, tempo, and extras —
    /// the same combination ``insert(beatTime:tempo:extras:)`` silently
    /// collapses. When that happens, `entryID` always keeps addressing the
    /// entry that was just updated; the *other*, pre-existing entry is the
    /// one silently removed instead. That is the only choice consistent
    /// with the guarantee above: a caller invoking this method already
    /// holds `entryID` and goes on using it afterward, so honoring "this
    /// identity keeps addressing this same entry" means the entry it
    /// wasn't referencing has to be the one that gives way, never the one
    /// it was.
    ///
    /// - Parameter entryID:    The identity of the entry to replace. An
    ///                         identity naming no entry is ignored.
    /// - Parameter tempo:      The new tempo for the entry.
    /// - Parameter extras:     The new optional extra data for the entry.
    ///                         Defaults to `nil`.
    ///
    /// - Returns:  A pair of `updated`, `true` if `entryID` identified an
    ///             entry and it was updated, `false` if `entryID` named no
    ///             entry and nothing happened — and `removedEntryID`, the
    ///             identity of the pre-existing entry dropped because the
    ///             edit collapsed into it (see above). `nil` if `updated`
    ///             is `false`, or if it is `true` but no such collision
    ///             occurred.
    @discardableResult
    public mutating func update(entryID: EntryID,
                                tempo: Tempo,
                                extras: Extras? = nil) -> (updated: Bool, removedEntryID: EntryID?) {
        guard let position = firstIndex(entryID: entryID)
        else { return (false, nil) }

        entries[position] = Entry(entryID: entryID,
                                  beatTime: entries[position].beatTime,
                                  tempo: tempo,
                                  extras: extras)

        //
        // The edit may have turned this entry into an exact duplicate of another
        // one already at the same beat time — see `insert(beatTime:tempo:extras:)`
        // for why that combination carries no information beyond a single entry.
        // Drop the other one rather than leave the duplicate in place. `Entry`'s
        // own `==` already excludes identity, so comparing whole entries is enough
        // to find one that only *differs* in which entry it is.
        //
        var removedEntryID: EntryID?

        if let duplicate = entries.indices.first(where: {
            entries[$0].entryID != entryID && entries[$0] == entries[position]
        }) {
            removedEntryID = entries[duplicate].entryID

            entries.remove(at: duplicate)
        }

        hasExtras = Self.hasExtras(in: entries)

        return (true, removedEntryID)
    }

    // MARK: Private Instance Methods

    @discardableResult
    private mutating func _insert(entryID: EntryID,
                                  beatTime: BeatTime,
                                  tempo: Tempo,
                                  extras: Extras?) -> (entryID: EntryID, inserted: Bool) {
        if let existing = firstIndex(beatTime: beatTime,
                                     tempo: tempo,
                                     extras: extras) {
            return (entries[existing].entryID, false)
        }

        entries.insert(Entry(entryID: entryID,
                             beatTime: beatTime,
                             tempo: tempo,
                             extras: extras),
                       at: insertionIndex(for: beatTime))

        if extras != nil {
            hasExtras = true
        }

        return (entryID, true)
    }
}

// MARK: - Codable

extension TempoMap: Codable {

    // MARK: Public Initializers

    /// Creates a tempo map by decoding from the provided decoder.
    ///
    /// Entries that exactly duplicate one another — same beat time, tempo, and
    /// extras — are collapsed, keeping the first occurrence, the same rule
    /// ``insert(beatTime:tempo:extras:)`` applies to a live tempo map. This is
    /// needed here, not just belt-and-braces: a document saved before that dedup
    /// rule existed can have duplicates already baked into its encoded form, and
    /// decoding is the only place left to catch those.
    ///
    /// - Parameter decoder:    The decoder to read from.
    ///
    /// - Throws:   `DecodingError` if the encoded data is invalid or corrupted.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.defaultTempo = try container.decode(Tempo.self,
                                                 forKey: .defaultTempo)

        let decodedEntries = try container.decode([Entry].self,
                                                  forKey: .entries)

        self.entries = Self.deduplicated(decodedEntries)
        self.hasExtras = Self.hasExtras(in: entries)
    }

    // MARK: Public Instance Methods

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

// MARK: - Equatable

extension TempoMap: Equatable {
}

// MARK: - Sendable

extension TempoMap: Sendable {
}
