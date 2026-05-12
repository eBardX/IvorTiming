public import XestiNumbers

extension BeatTime {
    public static func + (time: Self,
                          dur: BeatDuration) -> Self {
        BeatTime(time.numberValue + dur.numberValue)
    }

    public static func += (time: inout Self,
                           dur: BeatDuration) {
        time = time + dur
    }

    public static func - (time: Self,
                          dur: BeatDuration) -> Self {
        BeatTime(time.numberValue - dur.numberValue)
    }

    public static func -= (time: inout Self,
                           dur: BeatDuration) {
        time = time - dur
    }

    public static func - (time1: Self,
                          time2: Self) -> BeatDuration {
        BeatDuration(time1.numberValue - time2.numberValue)
    }

    public static func * (time: Self,
                          factor: Number) -> Self {
        BeatTime(time.numberValue * factor)
    }

    public static func *= (time: inout Self,
                           factor: Number) {
        time = time * factor
    }
}
