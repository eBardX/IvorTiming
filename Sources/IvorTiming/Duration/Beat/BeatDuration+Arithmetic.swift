public import XestiNumbers

extension BeatDuration {
    public static func + (dur1: Self,
                          dur2: Self) -> Self {
        BeatDuration(dur1.numberValue + dur2.numberValue)
    }

    public static func += (dur1: inout Self,
                           dur2: Self) {
        dur1 = dur1 + dur2
    }

    public static func - (dur1: Self,
                          dur2: Self) -> Self {
        BeatDuration(dur1.numberValue - dur2.numberValue)
    }

    public static func -= (dur1: inout Self,
                           dur2: Self) {
        dur1 = dur1 - dur2
    }

    public static func * (dur: Self,
                          factor: Number) -> Self {
        BeatDuration(dur.numberValue * factor)
    }

    public static func -= (dur: inout Self,
                           factor: Number) {
        dur = dur * factor
    }
}
