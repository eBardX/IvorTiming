// © 2025–2026 John Gary Pusey (see LICENSE.md)

public import XestiTools

extension Extra {

    // MARK: Public Type Properties

    /// The exact microseconds-per-quarter-note value of a MIDI tempo meta
    /// event, before it’s rounded to an integer BPM for a ``TempoMap``
    /// entry’s ``Tempo`` value. Payload: a single `.int`.
    public static let midiTempo = Self(name: "midiTempo")

    /// The SMPTE time division of a Standard MIDI File whose event times are
    /// measured in frames rather than beats, attached to the ``TempoMap`` entry
    /// at beat zero. Payload: a `.string` holding the frame rate (a
    /// `SMPTEFrameRate` description, such as `"25"` or `"29.97DF"`), then an
    /// `.int` holding the number of ticks per frame.
    public static let midiTimeCode = Self(name: "midiTimeCode")

    /// The duration (in beats) of a JohnnySonic tempo ramp, attached to the
    /// ``TempoMap`` entry at the ramp’s start beat. Payload: a single
    /// `.double`.
    public static let rampDuration = Self(name: "rampDuration")

    /// The ending tempo (BPM) of a JohnnySonic tempo ramp, attached to the
    /// ``TempoMap`` entry at the ramp’s start beat. Payload: a single
    /// `.double`.
    ///
    /// The serialized name stays `rampFinalTempo` for compatibility with
    /// previously saved projects.
    public static let rampEndTempo = Self(name: "rampFinalTempo")

    /// The starting tempo (BPM) of a JohnnySonic tempo ramp, attached to the
    /// ``TempoMap`` entry at the ramp’s start beat. Payload: a single
    /// `.double`.
    ///
    /// The serialized name stays `rampInitialTempo` for compatibility with
    /// previously saved projects.
    public static let rampStartTempo = Self(name: "rampInitialTempo")

    /// The SMPTE timecode at which a work starts (at beat zero), attached to
    /// the ``TempoMap`` entry at beat zero. Use it as the start timecode of a
    /// ``TimecodeConverter``. Payload: a `.string` holding the frame rate (a
    /// `SMPTEFrameRate` description, such as `"25"` or `"29.97DF"`), then a
    /// `.string` holding the timecode (an `SMPTETime` description, such as
    /// `"01:00:00:00"`).
    public static let smpteOffset = Self(name: "smpteOffset")

    /// The literal human-readable tempo text (e.g. `"Allegro"`) from an ABC
    /// `Q:` field or a Guido `\tempo` tag, attached to a ``TempoMap`` entry.
    /// Payload: a single `.string`.
    public static let tempoText = Self(name: "tempoText")
}
