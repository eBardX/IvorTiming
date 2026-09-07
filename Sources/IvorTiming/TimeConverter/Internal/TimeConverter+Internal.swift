// © 2026 John Gary Pusey (see LICENSE.md)

private import XestiNumbers
private import XestiTools

extension TimeConverter {

    // MARK: Internal Instance Methods

    internal func floorIndex(for beatTime: BeatTime) -> Int {
        guard let idx = entries.firstIndex(where: { beatTime < $0.beatTime })
        else { return entries.count - 1 }

        return idx - 1
    }

    internal func floorIndex(for wallTime: WallTime) -> Int {
        guard let idx = entries.firstIndex(where: { wallTime < $0.wallTime })
        else { return entries.count - 1 }

        return idx - 1
    }

    internal mutating func updateDerivedProperties() {
        guard !entries.isEmpty
        else { return }

        let referenceTempoValue = Tempo.default.numberValue

        for index in entries.indices {
            let startTempo = entries[index].tempo.numberValue

            let beatDuration: BeatDuration
            let tempoChange: Number

            if index < entries.count - 1 {
                beatDuration = entries[index + 1].beatTime - entries[index].beatTime
                tempoChange = entries[index + 1].tempo.numberValue - startTempo
            } else {
                beatDuration = 1
                tempoChange = 0
            }

            let beatLength = beatDuration.numberValue
            let wallDuration: WallDuration

            if tempoChange < 0 {
                let scale = sqrt(-tempoChange / startTempo)

                wallDuration = WallDuration(seconds: (beatLength * referenceTempoValue / sqrt(startTempo * -tempoChange) * atanh(scale)).doubleValue)
            } else if tempoChange > 0 {
                let scale = sqrt(tempoChange / startTempo)

                wallDuration = WallDuration(seconds: (beatLength * referenceTempoValue / sqrt(startTempo * tempoChange) * atan(scale)).doubleValue)
            } else {
                wallDuration = WallDuration(seconds: (beatLength * referenceTempoValue / startTempo).doubleValue)
            }

            let wallTime: WallTime = if index == 0 {
                WallTime(seconds: (entries[0].beatTime.numberValue * referenceTempoValue / startTempo).doubleValue)
            } else {
                entries[index - 1].wallTime + entries[index - 1].wallDuration
            }

            entries[index].beatDuration = beatDuration
            entries[index].tempoChange = tempoChange
            entries[index].wallDuration = wallDuration
            entries[index].wallTime = wallTime
        }
    }
}
