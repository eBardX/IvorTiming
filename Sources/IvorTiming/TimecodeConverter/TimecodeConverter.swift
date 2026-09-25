// © 2026 John Gary Pusey (see LICENSE.md)

public import IvorSMPTE

private import XestiNumbers
private import XestiTools

/// A type that converts between SMPTE timecode and wall time.
///
/// Create a `TimecodeConverter` from the timecode at which wall time zero
/// occurs, and use it to convert times. Unlike ``TimeConverter``, a timecode
/// converter needs no tempo map: timecode is a way of labeling wall time, and
/// the mapping between the two is fixed by the frame rate and the start
/// timecode alone.
///
/// Combine a timecode converter with a ``TimeConverter`` to convert between
/// beat time and timecode by way of wall time.
public struct TimecodeConverter {

    // MARK: Public Initializers

    /// Creates a timecode converter for the given frame rate, with wall time
    /// zero occurring at midnight (00:00:00:00).
    ///
    /// - Parameter frameRate:  The SMPTE frame rate.
    public init(frameRate: SMPTEFrameRate) {
        self.init(startTimecode: SMPTETime(frameRate: frameRate,
                                           frameCount: 0,
                                           fraction: 0).require())
    }

    /// Creates a timecode converter with wall time zero occurring at the given
    /// timecode.
    ///
    /// The converter uses the frame rate of the start timecode.
    ///
    /// - Parameter startTimecode:  The timecode at wall time zero.
    public init(startTimecode: SMPTETime) {
        self.startTimecode = startTimecode
    }

    // MARK: Public Instance Properties

    /// The timecode at wall time zero.
    public let startTimecode: SMPTETime
}

// MARK: -

extension TimecodeConverter {

    // MARK: Public Instance Properties

    /// The SMPTE frame rate of the timecodes this converter produces.
    public var frameRate: SMPTEFrameRate {
        startTimecode.frameRate
    }

    // MARK: Public Instance Methods

    /// Returns the timecode corresponding to the given wall time.
    ///
    /// The result is rounded to the nearest hundredth of a frame, and wraps
    /// around to 00:00:00:00 after 24 hours of timecode.
    ///
    /// - Parameter wallTime:   The wall time to convert.
    ///
    /// - Returns:  The ``SMPTETime`` corresponding to `wallTime`.
    public func timecode(at wallTime: WallTime) -> SMPTETime {
        SMPTETime(frameRate: frameRate,
                  elapsedSeconds: startTimecode.elapsedSeconds + wallTime.numberValue).require()
    }

    /// Returns the wall time corresponding to the given timecode.
    ///
    /// Because timecode wraps around after 24 hours, a timecode earlier than
    /// the start timecode is treated as occurring on the following day. For
    /// example, if the start timecode is 23:59:00:00, then 00:01:00:00 occurs
    /// two minutes after wall time zero.
    ///
    /// The timecode need not have the same frame rate as this converter; it is
    /// converted by way of the exact number of seconds since midnight that it
    /// represents. The result is rounded to the nearest microsecond.
    ///
    /// - Parameter timecode:   The timecode to convert.
    ///
    /// - Returns:  The ``WallTime`` corresponding to `timecode`.
    public func wallTime(at timecode: SMPTETime) -> WallTime {
        let secondsPerDay = Number(frameRate.framesPerDay) / frameRate.numberValue
        let delta = timecode.elapsedSeconds - startTimecode.elapsedSeconds
        let seconds = delta - (secondsPerDay * floor(delta / secondsPerDay))

        return WallTime(round(seconds * 1_000_000).exact.uintValue)
    }
}

// MARK: - Equatable

extension TimecodeConverter: Equatable {
}

// MARK: - Hashable

extension TimecodeConverter: Hashable {
}

// MARK: - Sendable

extension TimecodeConverter: Sendable {
}
