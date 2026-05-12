public import XestiNumbers

extension WallTime {
    public static func + (time: Self,
                          dur: WallDuration) -> Self {
        WallTime(time.numberValue + dur.numberValue)
    }

    public static func += (time: inout Self,
                           dur: WallDuration) {
        time = time + dur
    }

    public static func - (time: Self,
                          dur: WallDuration) -> Self {
        WallTime(time.numberValue - dur.numberValue)
    }

    public static func -= (time: inout Self,
                           dur: WallDuration) {
        time = time - dur
    }

    public static func - (time1: Self,
                          time2: Self) -> WallDuration {
        WallDuration(time1.numberValue - time2.numberValue)
    }

    public static func * (time: Self,
                          factor: Number) -> Self {
        WallTime(time.numberValue * factor)
    }

    public static func *= (time: inout Self,
                           factor: Number) {
        time = time * factor
    }
}
