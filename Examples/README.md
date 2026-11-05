# Fifty studies for VOID

A graded collection of original musical studies. Start with a single phrase, then work through rhythmic construction, sound transformation, tuning, and complete forms. Every numbered file is independent; it uses the current VOID application and does not load a shared example library. The existing Glass-Garden.scd is retained as an additional piece.

## Play a study

1. Save your current patch, evaluate the current **VOID.scd**, and wait until it is ready.
2. Open one numbered file, select its entire parenthesized block, and evaluate it. Turn **Audio ON** to listen.
3. Read its **Learn**, **Composer's note**, **Score**, and **Try** sections. Every study has three practical variations.
4. Use **Stop examples** or `~void[\stopHelpExamples].value` to stop early. PANIC also stops the score.
5. The study nodes are selected together: copy them, inspect individual objects with **Cmd+D**, or use **Undo** to remove the last build before starting another study.

Each file sets the shared tempo, root and tuning and stops previous help-built examples. Other patch nodes are retained. Literal Hz settings and MIDI-mode notes keep their written pitches; degree-mode parts use the selected tuning. Every study has a finite ending and a release tail. Startup quantisation can add up to one beat to the listed duration.

The examples use core SuperCollider objects. Sample studies use the bundled `a11wlk01.wav`; replace it through PLAYER / GRANULAR CLOUD to explore your own sounds. MIDI OUT begins without a destination, MIC IN begins at gain zero, and recording begins only when you press Record. No external device or recording action is started automatically.

Persian and Arabic studies use the application's editable reference pitch collections. Their short compositions are pitch-collection exercises; adjust cents for your chosen intonation. EDO studies use actual degrees of the named division, including 72 and 127 EDO. The custom-scale and tritave studies explore different ways to define a pitch collection.

A saved VOID patch retains the graph, notes and current parameters. Re-evaluate the original study file to run its written arrangement again. Study 48 uses private snapshots and does not overwrite the toolbar's snapshot slots.

## 01-10 / Musical foundations

| File | What to learn | Tempo | Approx. length |
| --- | --- | --- | --- |
| [01 - A Line and Its Silence](01-a-line-and-its-silence.scd) | Phrase endings, rests and velocity | 84 BPM | 25.7 s |
| [02 - The Beating Pendulum](02-the-beating-pendulum.scd) | Unison tuning and slow spatial movement | 72 BPM | 36.7 s |
| [03 - Mirror Answer](03-mirror-answer.scd) | Antiphonal writing with two note sequencers | 92 BPM | 23.5 s |
| [04 - Chord Lanterns](04-chord-lanterns.scd) | Four-note chords and sustained harmonic rhythm | 76 BPM | 28.4 s |
| [05 - Open Windows](05-open-windows.scd) | Voice leading through literal MIDI voicings | 80 BPM | 27 s |
| [06 - Ground and Air](06-ground-and-air.scd) | Bass ostinato beneath a longer melody | 94 BPM | 23 s |
| [07 - Held Breath](07-held-breath.scd) | AD envelopes applied to a continuous source | 70 BPM | 30.9 s |
| [08 - Glass Ratios](08-glass-ratios.scd) | FM colour shaped into articulated notes | 88 BPM | 24.5 s |
| [09 - Three Distances](09-three-distances.scd) | Foreground, middle distance and background | 78 BPM | 27.7 s |
| [10 - A Small Ensemble](10-a-small-ensemble.scd) | Balance, panning and manual master recording | 96 BPM | 27.5 s |

## 11-20 / Rhythm and time

| File | What to learn | Tempo | Approx. length |
| --- | --- | --- | --- |
| [11 - Euclidean Footsteps](11-euclidean-footsteps.scd) | Interlocking trigger rhythms | 104 BPM | 20.8 s |
| [12 - Five Against Four](12-five-against-four.scd) | Independent sequencer cycle lengths | 108 BPM | 24.4 s |
| [13 - Sevenfold](13-sevenfold.scd) | A composed seven-eighth-note phrase | 112 BPM | 17.1 s |
| [14 - Clockwork Rain](14-clockwork-rain.scd) | Chance against a stable reference pulse | 100 BPM | 26.4 s |
| [15 - Accent Grammar](15-accent-grammar.scd) | Velocity accents beside a separate control sequence | 88 BPM | 24.5 s |
| [16 - Courtyard Hocket](16-courtyard-hocket.scd) | A melody distributed between two instruments | 84 BPM | 25.7 s |
| [17 - Phase Loom](17-phase-loom.scd) | Slow phase drift between almost equal rates | 112 BPM | 36.4 s |
| [18 - Pulse Subtraction](18-pulse-subtraction.scd) | Form made by removing attacks | 104 BPM | 25.4 s |
| [19 - Elastic Time](19-elastic-time.scd) | Per-step duration without changing the tempo | 86 BPM | 25.1 s |
| [20 - Lengths of Light](20-lengths-of-light.scd) | Note gate, release and articulation | 90 BPM | 24 s |

## 21-30 / Texture and processing

| File | What to learn | Tempo | Approx. length |
| --- | --- | --- | --- |
| [21 - Dust into Strings](21-dust-into-strings.scd) | Exciting a resonator with irregular impulses | 80 BPM | 39 s |
| [22 - Grain Atlas](22-grain-atlas.scd) | Scanning, freezing and dispersing a sample | 76 BPM | 41.1 s |
| [23 - Two Speeds of Memory](23-two-speeds-of-memory.scd) | Sample playback, reverse and crossfade | 84 BPM | 34.3 s |
| [24 - Spectral Lantern](24-spectral-lantern.scd) | Spectral capture as a formal event | 86 BPM | 30.7 s |
| [25 - Memory Room](25-memory-room.scd) | Captured audio, repetition and reversal | 92 BPM | 44.3 s |
| [26 - Parallel Weather](26-parallel-weather.scd) | A dry path and an independent effects send | 88 BPM | 27.3 s |
| [27 - Broken Glass](27-broken-glass.scd) | Digital resolution as a changing orchestration | 104 BPM | 20.8 s |
| [28 - Folded Bronze](28-folded-bronze.scd) | Parallel wavefolding and equal-power blending | 82 BPM | 26.3 s |
| [29 - Sideband Bells](29-sideband-bells.scd) | Ring modulation, fixed-Hz shifting and pitch ratios | 90 BPM | 24 s |
| [30 - Shimmer Canopy](30-shimmer-canopy.scd) | Long reverberation with restrained octave feedback | 68 BPM | 49.4 s |

## 31-42 / Modes, scales and microtonality

| File | What to learn | Tempo | Approx. length |
| --- | --- | --- | --- |
| [31 - Dorian River](31-dorian-river.scd) | Modal identity through a recurring sixth degree | 82 BPM | 26.3 s |
| [32 - Four Parallel Modes](32-four-parallel-modes.scd) | Rotating a scale while keeping the tonic fixed | 88 BPM | 35.5 s |
| [33 - Shur Nocturne](33-shur-nocturne.scd) | A melodic study in an editable Persian reference collection | 70 BPM | 36 s |
| [34 - Rast Courtyard](34-rast-courtyard.scd) | Composing with an Arabic quarter-tone reference table | 86 BPM | 25.1 s |
| [35 - Bayati at Dusk](35-bayati-at-dusk.scd) | Unequal phrase lengths and a tuned second degree | 74 BPM | 34.1 s |
| [36 - Nineteen Steps](36-nineteen-steps.scd) | Degree-based harmony in 19 EDO | 88 BPM | 24.5 s |
| [37 - Thirty One Lights](37-thirty-one-lights.scd) | Close voice leading in 31 EDO | 80 BPM | 27 s |
| [38 - Fifty Three Threads](38-fifty-three-threads.scd) | Fine pitch motion around a held interval | 66 BPM | 32.7 s |
| [39 - Iridescent Line](39-iridescent-line.scd) | Small ornaments in 72 EDO | 78 BPM | 27.7 s |
| [40 - Nearly Still](40-nearly-still.scd) | Nine-cent-scale detail in 127 EDO | 60 BPM | 52 s |
| [41 - Cent Mosaic](41-cent-mosaic.scd) | Authoring and hearing a custom cents collection | 82 BPM | 26.3 s |
| [42 - Tritave Orbits](42-tritave-orbits.scd) | A repeating period with frequency ratio 3 to 1 | 76 BPM | 28.4 s |

## 43-50 / Composed forms and performance

| File | What to learn | Tempo | Approx. length |
| --- | --- | --- | --- |
| [43 - Aperture](43-aperture.scd) | A return form with a changed orchestration | 90 BPM | 40 s |
| [44 - Night Transit](44-night-transit.scd) | Groove, interruption and a recognisable return | 116 BPM | 35.2 s |
| [45 - Glass Rain](45-glass-rain.scd) | A melodic miniature transformed by grains and a frozen spectrum | 78 BPM | 55.4 s |
| [46 - Harmonic Cartography](46-harmonic-cartography.scd) | Large-scale form through parallel modes | 82 BPM | 64.4 s |
| [47 - Finite Canon](47-finite-canon.scd) | Staggered entries, transposition and contrary motion | 94 BPM | 28.1 s |
| [48 - Rooms of Memory](48-rooms-of-memory.scd) | Private snapshots, locked parameters and a continuous morph | 90 BPM | 40 s |
| [49 - Open Stage](49-open-stage.scd) | Live MIDI alongside a written accompaniment | 88 BPM | 46.4 s |
| [50 - A Field of Returning Stars](50-a-field-of-returning-stars.scd) | A one-minute miniature with six composed moments | 88 BPM | 60 s |

## Suggested listening practice

Listen once without editing. On the second pass, change one musical decision: spacing, register, accent, silence, harmonic rhythm, or the order of sections. On the third pass, change one sound process. Keeping those decisions separate makes it easier to hear what each object contributes.

For longer pieces, mark the return of the initial material. A return can preserve a contour while changing its rhythm, register, density, or timbre. The last eight studies use these relationships as musical form.

## Validation

The library has a reproducible runtime check in `../tests/run-examples-validation.sh`. See `../VALIDATION.md` for the recorded environment, playback coverage and limits.
