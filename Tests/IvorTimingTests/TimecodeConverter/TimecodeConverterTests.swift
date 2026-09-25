// © 2026 John Gary Pusey (see LICENSE.md)

import IvorSMPTE
@testable import IvorTiming
import Testing
import XestiNumbers
import XestiTools

struct TimecodeConverterTests {
}

// MARK: -

extension TimecodeConverterTests {
    @Test
    func beatTimeToTimecode_viaWallTime() throws {
        let t120 = try #require(Tempo(uintValue: 120))
        var tmap = TempoMap()

        tmap.insert(beatTime: .zero, tempo: t120)

        let start = try #require(SMPTETime(string: "01:00:00:00", frameRate: .fps25))
        let tconv = TimeConverter(tempoMap: tmap)
        let tcconv = TimecodeConverter(startTimecode: start)

        // Beat 3 at 120 BPM is 1.5 seconds in.
        #expect(tcconv.timecode(at: tconv.wallTime(at: BeatTime(3))).description == "01:00:01:12.50")
        #expect(try tconv.beatTime(at: tcconv.wallTime(at: #require(SMPTETime(string: "01:00:02:00", frameRate: .fps25)))) == BeatTime(4))
    }

    @Test
    func equality() throws {
        let start = try #require(SMPTETime(string: "01:00:00:00", frameRate: .fps25))

        let tcconv1 = TimecodeConverter(startTimecode: start)
        let tcconv2 = TimecodeConverter(startTimecode: start)

        #expect(tcconv1 == tcconv2)
        #expect(tcconv1 != TimecodeConverter(frameRate: .fps25))
    }

    @Test
    func frameRate() throws {
        let start = try #require(SMPTETime(string: "01:00:00;00", frameRate: .fps2997))

        #expect(TimecodeConverter(startTimecode: start).frameRate == .fps2997)
        #expect(TimecodeConverter(frameRate: .fps50).frameRate == .fps50)
    }

    @Test
    func init_frameRate_startsAtMidnight() {
        let tcconv = TimecodeConverter(frameRate: .fps24)

        #expect(tcconv.startTimecode.frameCount == 0)
        #expect(tcconv.startTimecode.fraction == 0)
        #expect(tcconv.timecode(at: .zero).description == "00:00:00:00")
    }

    @Test
    func timecode_dropFrame() {
        let tcconv = TimecodeConverter(frameRate: .fps2997)

        // 60 seconds of real time is only 1,798.2 frames, so the timecode lags behind.
        #expect(tcconv.timecode(at: WallTime(60_000_000)).description == "00:00:59;28.20")

        // Ten minutes of drop-frame timecode is exactly 17,982 frames.
        let tenMinutes = Number(17_982 * 1_001) / 30_000

        #expect(tcconv.timecode(at: WallTime(round(tenMinutes * 1_000_000).exact.uintValue)).description == "00:10:00;00")
    }

    @Test
    func timecode_withStartOffset() throws {
        let start = try #require(SMPTETime(string: "00:59:58:00", frameRate: .fps25))
        let tcconv = TimecodeConverter(startTimecode: start)

        #expect(tcconv.timecode(at: .zero) == start)
        #expect(tcconv.timecode(at: WallTime(2_000_000)).description == "01:00:00:00")
        #expect(tcconv.timecode(at: WallTime(2_020_000)).description == "01:00:00:00.50")
    }

    @Test
    func timecode_wrapsAfter24Hours() throws {
        let start = try #require(SMPTETime(string: "23:59:59:00", frameRate: .fps25))
        let tcconv = TimecodeConverter(startTimecode: start)

        #expect(tcconv.timecode(at: WallTime(2_000_000)).description == "00:00:01:00")
    }

    @Test
    func wallTime() throws {
        let start = try #require(SMPTETime(string: "01:00:00:00", frameRate: .fps25))
        let tcconv = TimecodeConverter(startTimecode: start)

        #expect(tcconv.wallTime(at: start) == .zero)
        #expect(try tcconv.wallTime(at: #require(SMPTETime(string: "01:00:01:12.50", frameRate: .fps25))) == WallTime(1_500_000))
    }

    @Test
    func wallTime_beforeStartWraps() throws {
        let start = try #require(SMPTETime(string: "00:59:58:00", frameRate: .fps25))
        let tcconv = TimecodeConverter(startTimecode: start)
        let earlier = try #require(SMPTETime(string: "00:59:57:00", frameRate: .fps25))

        #expect(tcconv.wallTime(at: earlier) == WallTime((86_400 - 1) * 1_000_000))
    }

    @Test
    func wallTime_crossesMidnight() throws {
        let start = try #require(SMPTETime(string: "23:59:00:00", frameRate: .fps30))
        let tcconv = TimecodeConverter(startTimecode: start)
        let later = try #require(SMPTETime(string: "00:01:00:00", frameRate: .fps30))

        #expect(tcconv.wallTime(at: later) == WallTime(120_000_000))
    }

    @Test
    func wallTime_differentFrameRate() throws {
        let tcconv = TimecodeConverter(frameRate: .fps25)
        let time = try #require(SMPTETime(string: "00:00:01:15", frameRate: .fps30))

        #expect(tcconv.wallTime(at: time) == WallTime(1_500_000))
    }

    @Test
    func wallTime_dropFrame() throws {
        let tcconv = TimecodeConverter(frameRate: .fps2997)
        let time = try #require(SMPTETime(string: "00:00:00;01", frameRate: .fps2997))

        // 1001/30000 seconds, rounded to the nearest microsecond.
        #expect(tcconv.wallTime(at: time) == WallTime(33_367))
    }

    @Test(arguments: SMPTEFrameRate.allCases)
    func wallTime_roundTrip(frameRate: SMPTEFrameRate) throws {
        let start = try #require(SMPTETime(frameRate: frameRate, frameCount: frameRate.framesPerDay / 3, fraction: 0))
        let tcconv = TimecodeConverter(startTimecode: start)

        for frameCount in stride(from: 0, to: frameRate.framesPerDay, by: 4_999) {
            let time = try #require(SMPTETime(frameRate: frameRate, frameCount: frameCount, fraction: frameCount % 100))

            #expect(tcconv.timecode(at: tcconv.wallTime(at: time)) == time)
        }
    }
}
