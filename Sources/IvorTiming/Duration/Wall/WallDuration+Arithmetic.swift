public import XestiNumbers

extension WallDuration {
    public static func + (dur1: Self,
                          dur2: Self) -> Self {
        WallDuration(dur1.numberValue + dur2.numberValue)
    }

    public static func += (dur1: inout Self,
                           dur2: Self) {
        dur1 = dur1 + dur2
    }

    public static func - (dur1: Self,
                          dur2: Self) -> Self {
        WallDuration(dur1.numberValue - dur2.numberValue)
    }

    public static func -= (dur1: inout Self,
                           dur2: Self) {
        dur1 = dur1 - dur2
    }

    public static func * (dur: Self,
                          factor: Number) -> Self {
        WallDuration(dur.numberValue * factor)
    }

    public static func -= (dur: inout Self,
                           factor: Number) {
        dur = dur * factor
    }
}
