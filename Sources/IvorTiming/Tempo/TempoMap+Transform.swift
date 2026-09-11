// © 2025–2026 John Gary Pusey (see LICENSE.md)

public import XestiNumbers

extension TempoMap {

    // MARK: Public Instance Methods

    /// Augments entry beat times by a rational factor.
    ///
    /// - Parameter factor:     A rational number ≥ 1 by which to stretch the selected entry beat
    ///                         times.
    /// - Parameter anchor:     The low beat-time bound to stretch beat times relative to. `nil`
    ///                         resolves to the map's own range, or — when `entryIDs` is non-`nil`
    ///                         — the selected entries' own range.
    /// - Parameter entryIDs:   The identities of the entries to augment, or `nil` to augment every
    ///                         entry in the map.
    ///
    /// - Throws:   ``TempoMap/Error/invalidAugmentationFactor(_:)`` if `factor` is not a rational
    ///             number ≥ 1; ``TempoMap/Error/invalidAnchor`` if `anchor` is later than the low
    ///             bound of the entries being augmented; otherwise,
    ///             ``TempoMap/Error/augmentFailure(_:)`` if an entry cannot be augmented.
    public mutating func augment(by factor: Number,
                                 anchor: BeatTime? = nil,
                                 entryIDs: Set<EntryID>? = nil) throws(Error) {
        guard factor.isRational,
              factor >= 1
        else { throw Error.invalidAugmentationFactor(factor) }

        guard !entries.isEmpty,
              factor > 1
        else { return }

        guard let selectedRange = _selectedBeatTimeRange(entryIDs: entryIDs)
        else { return }

        let loBeatTime = try _resolvedLowerBound(anchor, containing: selectedRange)

        for (idx, entry) in entries.enumerated() {
            guard entryIDs?.contains(entry.entryID) ?? true
            else { continue }

            guard let result = loBeatTime.duration(to: entry.beatTime),
                  let duration = result.duration.multiplied(by: factor),
                  let newBeatTime = loBeatTime.moved(by: DirectedDuration(duration: duration,
                                                                          direction: result.direction))
            else { throw Error.augmentFailure(entry.beatTime) }

            entries[idx] = Entry(entryID: entry.entryID,
                                 beatTime: newBeatTime,
                                 tempo: entry.tempo,
                                 extras: entry.extras)
        }

        entries.sort()
    }

    /// Diminishes entry beat times by a rational factor.
    ///
    /// - Parameter factor:     A rational number ≥ 1 by which to compress the selected entry beat
    ///                         times.
    /// - Parameter anchor:     The low beat-time bound to compress beat times relative to. `nil`
    ///                         resolves to the map's own range, or — when `entryIDs` is non-`nil`
    ///                         — the selected entries' own range.
    /// - Parameter entryIDs:   The identities of the entries to diminish, or `nil` to diminish
    ///                         every entry in the map.
    ///
    /// - Throws:   ``TempoMap/Error/invalidDiminutionFactor(_:)`` if `factor` is not a rational
    ///             number ≥ 1; ``TempoMap/Error/invalidAnchor`` if `anchor` is later than the low
    ///             bound of the entries being diminished; otherwise,
    ///             ``TempoMap/Error/diminishFailure(_:)`` if an entry cannot be diminished.
    public mutating func diminish(by factor: Number,
                                  anchor: BeatTime? = nil,
                                  entryIDs: Set<EntryID>? = nil) throws(Error) {
        guard factor.isRational,
              factor >= 1
        else { throw Error.invalidDiminutionFactor(factor) }

        guard !entries.isEmpty,
              factor > 1
        else { return }

        guard let selectedRange = _selectedBeatTimeRange(entryIDs: entryIDs)
        else { return }

        let loBeatTime = try _resolvedLowerBound(anchor, containing: selectedRange)

        for (idx, entry) in entries.enumerated() {
            guard entryIDs?.contains(entry.entryID) ?? true
            else { continue }

            guard let result = loBeatTime.duration(to: entry.beatTime),
                  let duration = result.duration.divided(by: factor),
                  let newBeatTime = loBeatTime.moved(by: DirectedDuration(duration: duration,
                                                                          direction: result.direction))
            else { throw Error.diminishFailure(entry.beatTime) }

            entries[idx] = Entry(entryID: entry.entryID,
                                 beatTime: newBeatTime,
                                 tempo: entry.tempo,
                                 extras: entry.extras)
        }

        entries.sort()
    }

    /// Moves entry beat times by a directed duration.
    ///
    /// - Parameter directedDuration:   The directed duration by which to move the selected entry
    ///                                 beat times.
    /// - Parameter entryIDs:           The identities of the entries to move, or `nil` to move
    ///                                 every entry in the map.
    ///
    /// - Throws:   ``TempoMap/Error/moveFailure(_:)`` if an entry cannot be moved.
    public mutating func move(by directedDuration: DirectedDuration<BeatDuration>,
                              entryIDs: Set<EntryID>? = nil) throws(Error) {
        guard !entries.isEmpty,
              !directedDuration.duration.isZero
        else { return }

        for (idx, entry) in entries.enumerated() {
            guard entryIDs?.contains(entry.entryID) ?? true
            else { continue }

            guard let newBeatTime = entry.beatTime.moved(by: directedDuration)
            else { throw Error.moveFailure(entry.beatTime) }

            entries[idx] = Entry(entryID: entry.entryID,
                                 beatTime: newBeatTime,
                                 tempo: entry.tempo,
                                 extras: entry.extras)
        }

        entries.sort()
    }

    /// Reverses the order of entries within a beat-time range.
    ///
    /// - Parameter beatTimeRange:   The beat-time range to mirror entry beat times around. `nil`
    ///                              resolves to the map's own beat-time range, or — when
    ///                              `entryIDs` is non-`nil` — the selected entries' own range.
    /// - Parameter entryIDs:        The identities of the entries to reverse, or `nil` to reverse
    ///                              every entry in the map.
    ///
    /// - Throws:   ``TempoMap/Error/invalidAnchor`` if `beatTimeRange` does not contain the
    ///             beat-time range of the entries being reversed; otherwise,
    ///             ``TempoMap/Error/reverseFailure(_:)`` if an entry cannot be reversed.
    public mutating func reverse(within beatTimeRange: ClosedRange<BeatTime>? = nil,
                                 entryIDs: Set<EntryID>? = nil) throws(Error) {
        guard !entries.isEmpty
        else { return }

        guard let selectedRange = _selectedBeatTimeRange(entryIDs: entryIDs)
        else { return }

        let anchorRange = try _resolvedRange(beatTimeRange, containing: selectedRange)
        let hiBeatTime = anchorRange.upperBound
        let loBeatTime = anchorRange.lowerBound

        for (idx, entry) in entries.enumerated() {
            guard entryIDs?.contains(entry.entryID) ?? true
            else { continue }

            guard let dirDur = entry.beatTime.duration(to: hiBeatTime),
                  let newBeatTime = loBeatTime.moved(by: dirDur)
            else { throw Error.reverseFailure(entry.beatTime) }

            entries[idx] = Entry(entryID: entry.entryID,
                                 beatTime: newBeatTime,
                                 tempo: entry.tempo,
                                 extras: entry.extras)
        }

        entries.sort()
    }

    // MARK: Private Instance Methods

    //
    // `nil` resolves to `containing` (the selected entries' own range) — safe by construction,
    // since it's derived from the very entries being operated on. A caller-supplied anchor must be
    // no later than that range's low bound, or the stretch it pivots would be applied against
    // entries it doesn't actually bound.
    //
    private func _resolvedLowerBound(_ anchor: BeatTime?,
                                     containing selectedRange: ClosedRange<BeatTime>) throws(Error) -> BeatTime {
        guard let anchor
        else { return selectedRange.lowerBound }

        guard anchor <= selectedRange.lowerBound
        else { throw Error.invalidAnchor }

        return anchor
    }

    //
    // `nil` resolves to `selectedRange` — safe by construction, since it's derived from the very
    // entries being operated on. A caller-supplied range must fully contain `selectedRange`, or
    // the mirror it pivots around would reflect entries it doesn't actually bound.
    //
    private func _resolvedRange(_ anchorRange: ClosedRange<BeatTime>?,
                                containing selectedRange: ClosedRange<BeatTime>) throws(Error) -> ClosedRange<BeatTime> {
        guard let anchorRange
        else { return selectedRange }

        guard anchorRange.lowerBound <= selectedRange.lowerBound,
              anchorRange.upperBound >= selectedRange.upperBound
        else { throw Error.invalidAnchor }

        return anchorRange
    }

    //
    // `entries` is always kept sorted by beat time, so the first and last elements of any
    // (order-preserving) subsequence of it bound that subsequence's beat-time range.
    //
    private func _selectedBeatTimeRange(entryIDs: Set<EntryID>?) -> ClosedRange<BeatTime>? {
        let selected = entryIDs.map { ids in entries.filter { ids.contains($0.entryID) } } ?? entries

        guard let first = selected.first,
              let last = selected.last
        else { return nil }

        return first.beatTime...last.beatTime
    }
}
