// © 2025–2026 John Gary Pusey (see LICENSE.md)

public import XestiTools

extension Extra {

    // MARK: Public Type Properties

    /// The exact microseconds-per-quarter-note value of a MIDI tempo meta
    /// event, before it's rounded to an integer BPM for a ``TempoMap``
    /// entry's ``Tempo`` value. Payload: a single `.int`.
    public static let exactMicrosecondsPerQuarter = Self(name: "exactMicrosecondsPerQuarter")

    /// The starting tempo (BPM) of a JohnnySonic tempo ramp, attached to the
    /// ``TempoMap`` entry at the ramp's start beat. Payload: a single
    /// `.double`.
    public static let rampInitialTempo = Self(name: "rampInitialTempo")

    /// The ending tempo (BPM) of a JohnnySonic tempo ramp, attached to the
    /// ``TempoMap`` entry at the ramp's start beat. Payload: a single
    /// `.double`.
    public static let rampFinalTempo = Self(name: "rampFinalTempo")

    /// The duration (in beats) of a JohnnySonic tempo ramp, attached to the
    /// ``TempoMap`` entry at the ramp's start beat. Payload: a single
    /// `.double`.
    public static let rampDuration = Self(name: "rampDuration")

    /// The literal human-readable tempo text (e.g. `"Allegro"`) from an ABC
    /// `Q:` field or a Guido `\tempo` tag, attached to a ``TempoMap`` entry.
    /// Payload: a single `.string`.
    public static let tempoText = Self(name: "tempoText")
}
