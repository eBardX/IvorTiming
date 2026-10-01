// © 2026 John Gary Pusey (see LICENSE.md)

public import XestiTools

extension TempoMap {

    // MARK: Public Nested Types

    /// A snapshot of an entry in a ``TempoMap``.
    ///
    /// There is deliberately no public initializer. Values of this type come only from a
    /// ``TempoMap``, so the ``entryID`` of one identifies an entry in that map — until that entry
    /// is removed — and can be passed back to methods such as ``TempoMap/remove(entryID:)``.
    public struct Entry {

        // MARK: Public Instance Properties

        /// The beat time at which the tempo takes effect.
        public let beatTime: BeatTime

        /// The stable identity of the entry.
        public let entryID: EntryID

        /// The extra data attached to the entry, if any.
        public let extras: Extras?

        /// The tempo of the entry.
        public let tempo: Tempo

        // MARK: Internal Initializers

        internal init(_ entry: StoredEntry) {
            self.beatTime = entry.beatTime
            self.entryID = entry.entryID
            self.extras = entry.extras
            self.tempo = entry.tempo
        }
    }
}

// MARK: - Equatable

extension TempoMap.Entry: Equatable {
}

// MARK: - Sendable

extension TempoMap.Entry: Sendable {
}
