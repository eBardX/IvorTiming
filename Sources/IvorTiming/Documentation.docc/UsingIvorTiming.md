# Using IvorTiming

Measure musical time in whole notes or in seconds, and convert between the two
with a tempo map.

## Overview

IvorTiming measures time in two ways. **Beat time** is metrical time: it
counts whole notes, so it stays the same whatever the tempo; **wall time**
counts seconds on the clock. Each has a type for a point in time and a type for
a length of time:

 Kind of time | Point in time    | Length of time     | Unit
:-----------  |:-------------    |:--------------     |:----
 Beat         | ``BeatTime``     | ``BeatDuration``   | Whole notes, as an exact rational number
 Wall         | ``WallTime``     | ``WallDuration``   | Whole microseconds

Beat time counts whole notes, not the beats of a meter: a quarter note is 1/4,
a dotted eighth note 3/16, and a triplet eighth note 1/12. A ``TempoMap`` says
how fast the music goes, a ``TimeConverter`` uses one to convert between the
two kinds of time, and a ``BeatQuantizer`` snaps beat times to a rhythmic grid.

## Times and durations

All four time and duration types are non-negative. Beat times and durations
hold an exact rational `Number` from
[XestiNumbers](https://github.com/eBardX/XestiNumbers), so a triplet eighth is
exactly 1/12 of a whole note. Wall times and durations hold a whole number of
microseconds; made from seconds, they round to the nearest microsecond.

Every one of them can be written as a literal, but the units differ: a beat
literal is a number of whole notes, while a wall literal is a number of
**microseconds**. To give a wall time in seconds, use
``WallTime/init(doubleValue:)`` or ``WallTime/init(numberValue:)``.

```swift
let downbeat: BeatTime = 4                      // four whole notes in
let triplet  = BeatDuration(numberValue: Number(numerator: 1, denominator: 12))!
let onset    = WallTime(doubleValue: 1.25)!     // 1,250,000 microseconds
```

The failable initializers — `init?(numberValue:)`, `init?(doubleValue:)`, and
`init?(plain:)` — return `nil` for a negative or non-finite value, or one too
large to represent.

Each type has a **plain** string form, which ``BeatTime/init(plain:)`` and its
counterparts parse back. Beat values print as mixed fractions, such as
`4 1/2`, and also parse from decimals; wall values print as seconds, without
trailing zeros. Each type also has a `FormatStyle`, and `formatted()` produces
an `AttributedString` for display.

``TimeProtocol`` and ``DurationProtocol`` are the shared interfaces of the time
and duration types, for code that works with either kind of time.
``TimeBasis`` names a kind of time — `beat` or `wall` — for a setting or a
file that must record which one it uses.

## Arithmetic

A time plus or minus a duration is a time, the difference between two times is
a duration, and a duration can be added to, subtracted from, or scaled by a
`Number`:

```swift
let later = downbeat + triplet          // 4 1/12
let gap   = later - downbeat            // 1/12
```

The operators require their results to stay non-negative: subtracting more
than there is, or scaling by a negative factor, stops execution. When that
could happen, use the checked forms instead — `adding(_:)`,
`subtracting(_:)`, `multiplied(by:)`, and `divided(by:)` on durations — which
return `nil`.

To move in either direction, pair a duration with a ``TimeDirection`` in a
``DirectedDuration``. ``BeatTime/duration(to:)`` returns the directed duration
from one time to another, and ``BeatTime/moved(by:)`` applies one:

```swift
let back = downbeat.duration(to: 2)!    // 2 whole notes, backward

downbeat.moved(by: back)                // 2
```

A zero duration must have the direction ``TimeDirection/same``, and a nonzero
one ``TimeDirection/forward`` or ``TimeDirection/backward``.

## Tempo maps

A ``Tempo`` is written the way a score states it: a rate per minute of a note
value, its *unit*. ♩. = 90 has a ``Tempo/rate`` of 90 and a ``Tempo/unit`` of
3/8 (a dotted quarter note, in whole notes). The rate is a positive, exact
rational number, so ♩. = 66⅔ is stored exactly. A tempo’s speed in whole notes
per minute, its ``Tempo/numberValue``, is the rate times the unit: 135/4 for
♩. = 90.

```swift
let dotted = Tempo(90, unit: .dottedQuarter)

dotted.numberValue                      // 135/4
dotted.plain                            // "3/8=90"
dotted.restated(in: .eighth)            // ♪ = 270
```

Tempos compare by how they’re written, not by how fast they are: ♩. = 90 and
♩ = 135 have the same speed, but they aren’t equal. Compare speeds with
``Tempo/numberValue``. ``Tempo/restated(in:)`` rewrites a tempo in another unit
at the same speed, and ``Tempo/scaled(unitBy:)`` multiplies its unit, and so
its speed, keeping its rate. A tempo’s `FormatStyle` formats only the rate,
rounded to a whole number; draw the unit in front of it as a note value.

A ``TempoMap`` is a list of entries, each a tempo that takes effect at a beat
time, sorted by beat time:

```swift
var tempoMap = TempoMap()                // ♩ = 60 until it has entries

tempoMap.insert(beatTime: 0, tempo: Tempo(120))
tempoMap.insert(beatTime: 2, tempo: Tempo(60))

tempoMap[1]                             // ♩ = 105
```

Subscripting a tempo map with a beat time gives the tempo in effect there.
Before the first entry, that is the first entry’s tempo, and after the last,
the last one’s. Between two entries the speed moves gradually from one to the
next, slowly at first and faster toward the second. It’s computed exactly, and
given in the unit of the entry the change starts from. An empty map gives its
``TempoMap/defaultTempo``.

Two entries at the same beat time with different tempos make an instant step.
An entry that exactly duplicates another — same beat time, tempo, and extras —
adds nothing, so inserting one is ignored.

Every entry has an ``TempoMap/EntryID`` that keeps naming it while the map
changes: ``TempoMap/insert(beatTime:tempo:extras:)`` returns it, and
``TempoMap/update(entryID:tempo:extras:)``, ``TempoMap/move(entryID:to:)``, and
``TempoMap/remove(entryID:)`` take it. An entry ID lasts only as long as the map
is in memory: it is not encoded, so a decoded map has fresh ones. A tempo map is
also a collection of its entries, but a position is valid only until the next
change; to keep addressing an entry, use its ID. An entry can carry `Extras`
(from [XestiTools](https://github.com/eBardX/XestiTools)) for data of your own.

## Transforming a tempo map

A tempo map can be transformed as a whole, or just the entries whose IDs you
pass:

- ``TempoMap/augment(by:anchor:entryIDs:)`` and
  ``TempoMap/diminish(by:anchor:entryIDs:)`` stretch or compress entry beat
  times by a factor of at least 1, relative to an anchor beat time that
  defaults to the start of the entries.
- ``TempoMap/move(by:entryIDs:)`` shifts entry beat times by a directed
  duration.
- ``TempoMap/reverse(within:entryIDs:)`` mirrors entry beat times within a
  range.
- ``TempoMap/quantize(using:entryIDs:)`` snaps entry beat times to a
  quantizer’s grid.

```swift
try tempoMap.augment(by: 2)             // entries now at whole notes 0 and 4
```

The first four throw a ``TempoMap/Error`` if their arguments are invalid or an
entry would land outside the valid range; quantizing never fails.

Augmenting the music slows it down. To keep its sound instead, follow the
augmentation with ``TempoMap/scaleUnits(by:from:)``, using the same factor and
anchor: each tempo keeps its rate while its unit grows, so ♪ = 240 becomes
♩ = 240. Nothing before the anchor changes speed.

## Converting between beat time and wall time

A ``TimeConverter`` takes a snapshot of a tempo map, so later changes to the
map do not affect it, and converts in either direction:

```swift
let converter = TimeConverter(tempoMap: tempoMap)

converter.wallTime(at: 1)               // when the music is one whole note in
converter.beatTime(at: WallTime(doubleValue: 2)!)  // how far in the music is after 2 seconds
```

At a steady tempo, a length of beat time lasts its length × 60 /
``Tempo/numberValue`` seconds. At ♩ = 60, a whole note lasts 4 seconds.

```swift
TimeConverter(tempoMap: TempoMap()).wallTime(at: 1)   // 4 seconds
```

## Quantizing

A ``BeatQuantizer`` snaps a beat time to the nearest point on a rhythmic grid.
Each of its factors `n` contributes a grid of `1/n`-whole-note subdivisions,
and the quantizer snaps to whichever point of any grid is nearest. Factors of
16 and 12 snap to sixteenth notes and eighth-note triplets alike:

```swift
let quantizer = try BeatQuantizer(factors: [16, 12])

quantizer.quantize(BeatTime(plain: "0.33")!)    // 1/3
quantizer.quantize(BeatTime(plain: "0.315")!)   // 5/16
quantizer.gridUnit                              // 1/48
```

## Error handling

Thrown errors conform to `EnhancedError` (from
[XestiTools](https://github.com/eBardX/XestiTools)): each has a `category` of
`"IvorTiming"` and a human-readable `message`.

 Type                      | Thrown by
:----                      |:---------
 ``BeatQuantizer/Error``   | `BeatQuantizer.init(factors:)`
 ``TempoMap/Error``        | `augment(by:anchor:entryIDs:)`, `diminish(by:anchor:entryIDs:)`, `move(by:entryIDs:)`, `reverse(within:entryIDs:)`
 ``ParseError``            | `TimeBasis.init(stringValue:)`

The failable initializers return `nil` rather than throwing, and the arithmetic
operators stop execution on a result that would be negative, as do
`Tempo.init(_:unit:)`, `Tempo.restated(in:)`, and
`TempoMap.scaleUnits(by:from:)` on an invalid argument; see
[Arithmetic](#Arithmetic).

## Concurrency

IvorTiming is built for Swift 6 strict concurrency. Every public type is a
`Sendable` value type, so instances can be freely shared across tasks and actor
boundaries.
