// © 2025–2026 John Gary Pusey (see LICENSE.md)

public import XestiNumbers

extension TempoMap {

    // MARK: Public Instance Methods

    /// Augments entry beat times by a rational factor.
    ///
    /// - Parameter factor:     A rational number ≥ 1 by which to stretch the selected entry beat
    ///                         times.
    /// - Parameter anchor:     The low beat-time bound to stretch beat times relative to. `nil`
    ///                         resolves to the map’s own range, or — when `entryIDs` is non-`nil`
    ///                         — the selected entries’ own range.
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

            entries[idx] = StoredEntry(entryID: entry.entryID,
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
    ///                         resolves to the map’s own range, or — when `entryIDs` is non-`nil`
    ///                         — the selected entries’ own range.
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

            entries[idx] = StoredEntry(entryID: entry.entryID,
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

            entries[idx] = StoredEntry(entryID: entry.entryID,
                                       beatTime: newBeatTime,
                                       tempo: entry.tempo,
                                       extras: entry.extras)
        }

        entries.sort()
    }

    /// Quantizes entry beat times to the nearest grid point defined by `quantizer`.
    ///
    /// Unlike `augment`/`diminish`/`move`/`reverse`, this never throws — an already-built
    /// ``BeatQuantizer`` has already had its factors validated, so there is nothing left for
    /// this call to fail on, and snapping an entry to a grid point can never overflow the way a
    /// relative move can.
    ///
    /// - Parameter quantizer:   The quantizer whose grid to snap entry beat times to.
    /// - Parameter entryIDs:    The identities of the entries to quantize, or `nil` to quantize
    ///                          every entry in the map.
    public mutating func quantize(using quantizer: BeatQuantizer,
                                  entryIDs: Set<EntryID>? = nil) {
        guard !entries.isEmpty
        else { return }

        for (idx, entry) in entries.enumerated() {
            guard entryIDs?.contains(entry.entryID) ?? true
            else { continue }

            entries[idx] = StoredEntry(entryID: entry.entryID,
                                       beatTime: quantizer.quantize(entry.beatTime),
                                       tempo: entry.tempo,
                                       extras: entry.extras)
        }

        entries.sort()
    }

    /// Reverses the order of entries within a beat-time range.
    ///
    /// Each entry’s beat time is mirrored within the range, and entries that share a beat time
    /// swap order, so a step keeps its flat segments on either side.
    ///
    /// A ramp is reversed by its endpoints only. Its curve isn’t flipped: the reversed ramp is
    /// interpolated just as a ramp written in that direction would be. That’s how a performer
    /// reads a score played backwards. An accelerando from 60 to 120 becomes a ritardando from
    /// 120 to 60, played as any ritardando from 120 to 60 is played, not as the accelerando run
    /// backwards in time.
    ///
    /// - Parameter beatTimeRange:   The beat-time range to mirror entry beat times around. `nil`
    ///                              resolves to the map’s own beat-time range, or — when
    ///                              `entryIDs` is non-`nil` — the selected entries’ own range.
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

            entries[idx] = StoredEntry(entryID: entry.entryID,
                                       beatTime: newBeatTime,
                                       tempo: entry.tempo,
                                       extras: entry.extras)
        }

        //
        // Mirroring reverses the selected entries' order in beat time, so reverse their order in the
        // array too. Entries that share a beat time (a step: the old value, then the new) must swap
        // as well, or the step comes out backwards. The stable sort then merges them back in
        // among any unselected entries.
        //
        let selectedIndices = entries.indices.filter { entryIDs?.contains(entries[$0].entryID) ?? true }
        let reversedEntries = selectedIndices.reversed().map { entries[$0] }

        for (idx, entry) in zip(selectedIndices, reversedEntries) {
            entries[idx] = entry
        }

        entries.sort()
    }

    /// Multiplies the unit of every tempo from a beat time onward by a factor, keeping each rate.
    ///
    /// Use this after augmenting or diminishing the music from `anchor` by `factor`, to keep its
    /// sound: each tempo keeps its rate, and its speed in whole notes per minute scales with the
    /// music. For example, ♪ = 240 becomes ♩ = 240 when the music is augmented by 2.
    ///
    /// Nothing before `anchor` changes speed. Unless `anchor` is zero, an unscaled entry is first
    /// inserted at `anchor`, holding the tempo the music reaches there (the end of any ramp that
    /// runs into it). It comes before any entry already at `anchor`, so the speed steps there.
    /// Then every other entry at or after `anchor` has its unit scaled. If no entry was at
    /// `anchor`, a scaled entry holding the tempo in effect there is inserted as well. That
    /// includes ``defaultTempo``, when this tempo map is empty.
    ///
    /// Inserting an entry inside a ramp splits it. The first part keeps its exact shape; the
    /// second becomes a fresh ease-in from the speed at `anchor` to the ramp’s end, which is
    /// close to the original but not identical.
    ///
    /// - Parameter factor:   The factor to multiply each unit by.
    /// - Parameter anchor:   The beat time from which units are scaled.
    ///
    /// - Precondition: `factor` is a positive rational number.
    public mutating func scaleUnits(by factor: Number,
                                    from anchor: BeatTime) {
        precondition(factor.isRational && factor.isPositive,
                     "Invalid unit scaling factor: \(factor)")

        guard factor != 1
        else { return }

        let firstIndex = entries.firstIndex { $0.beatTime >= anchor } ?? entries.endIndex
        let hasEntryAtAnchor = firstIndex < entries.endIndex && entries[firstIndex].beatTime == anchor
        let arrivingTempo = hasEntryAtAnchor ? entries[firstIndex].tempo : self[anchor]

        var scaledEntries = Array(entries[..<firstIndex])

        if anchor != .zero {
            scaledEntries.append(StoredEntry(beatTime: anchor,
                                             tempo: arrivingTempo,
                                             extras: nil))
        }

        if !hasEntryAtAnchor {
            scaledEntries.append(StoredEntry(beatTime: anchor,
                                             tempo: _scaled(arrivingTempo, by: factor),
                                             extras: nil))
        }

        for entry in entries[firstIndex...] {
            scaledEntries.append(StoredEntry(entryID: entry.entryID,
                                             beatTime: entry.beatTime,
                                             tempo: _scaled(entry.tempo, by: factor),
                                             extras: entry.extras))
        }

        entries = scaledEntries
    }

    // MARK: Private Instance Methods

    //
    // `nil` resolves to `containing` (the selected entries’ own range) — safe by construction,
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

    private func _scaled(_ tempo: Tempo,
                         by factor: Number) -> Tempo {
        guard let scaled = tempo.scaled(unitBy: factor)
        else { preconditionFailure("Unable to scale tempo unit: \(tempo) by \(factor)") }

        return scaled
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
