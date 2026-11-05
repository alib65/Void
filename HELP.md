# VOID object help & musical examples

Click the VOID canvas, select an object and press **Cmd+D** (Ctrl+D on Windows/Linux). The shortcut also works in VOID's editor fields. **Cmd/Ctrl+Shift+D** duplicates objects.

Every object has three simple examples and a fourth complete musical piece. In the help window, use **Copy code**, **Copy description**, **Build example** and **Stop examples**. Examples add their own nodes; Undo removes the last build. Stop examples preserves the other nodes in your patch. Audio must be ON to hear playback.

To use the code below, evaluate the updated VOID.scd first. Copy an entire parenthesized block into the SuperCollider IDE, select the block and evaluate it. The helper functions used by the examples are included in VOID.scd. MIDI examples need a chosen device, MIC IN begins at gain zero, and RECORDER starts only when you press Record.

## Complete musical piece: Glass Garden

A four-section piece: Dawn, Motion, Mirror and Return, eight bars each, followed by two bars of tail. Three note sequencers play melody, chords and bass; a Euclidean pluck and a granular cloud add rhythm and texture. The arrangement changes the harmony, melody, orchestration and dynamics every eight beats. It uses your current global tempo, scale and root. The complete piece brings together melody, harmony, bass, percussion, a granular texture, shared effects and a four-section arrangement.

At 110 BPM the 32 bars and two-bar tail last about 74 seconds. The piece follows your current scale, root and tempo. Select a Persian/Arabic tuning or any 2–127 EDO before building it to use that pitch collection. In each object's help, example 4 includes that object in the arrangement.

```supercollider
(
// Glass Garden · a complete 32-bar piece
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['leadSeq'] = v[\add].value('noteseq', origin + (0 @ 0), false);
    v[\setParam].value(nodes['leadSeq'], 'base', 60);
    v[\setParam].value(nodes['leadSeq'], 'division', 2);
    v[\setParam].value(nodes['leadSeq'], 'gateLength', 0.7);
    v[\setParam].value(nodes['leadSeq'], 'length', 16);
    nodes['lead'] = v[\add].value('polysynth', origin + (295 @ 0), false);
    v[\setParam].value(nodes['lead'], 'attack', 0.012);
    v[\setParam].value(nodes['lead'], 'gain', 0.28);
    v[\setParam].value(nodes['lead'], 'release', 0.45);
    v[\setParam].value(nodes['lead'], 'wave', 0);
    nodes['padSeq'] = v[\add].value('noteseq', origin + (590 @ 0), false);
    v[\setParam].value(nodes['padSeq'], 'base', 48);
    v[\setParam].value(nodes['padSeq'], 'division', 0.25);
    v[\setParam].value(nodes['padSeq'], 'gateLength', 0.9);
    v[\setParam].value(nodes['padSeq'], 'length', 1);
    nodes['pad'] = v[\add].value('polysynth', origin + (0 @ 305), false);
    v[\setParam].value(nodes['pad'], 'attack', 0.35);
    v[\setParam].value(nodes['pad'], 'cutoff', 3400);
    v[\setParam].value(nodes['pad'], 'gain', 0.2);
    v[\setParam].value(nodes['pad'], 'release', 2);
    v[\setParam].value(nodes['pad'], 'wave', 3);
    nodes['bassSeq'] = v[\add].value('noteseq', origin + (295 @ 305), false);
    v[\setParam].value(nodes['bassSeq'], 'base', 36);
    v[\setParam].value(nodes['bassSeq'], 'division', 1);
    v[\setParam].value(nodes['bassSeq'], 'gateLength', 0.6);
    v[\setParam].value(nodes['bassSeq'], 'length', 8);
    nodes['bass'] = v[\add].value('polysynth', origin + (590 @ 305), false);
    v[\setParam].value(nodes['bass'], 'attack', 0.015);
    v[\setParam].value(nodes['bass'], 'cutoff', 1200);
    v[\setParam].value(nodes['bass'], 'gain', 0);
    v[\setParam].value(nodes['bass'], 'release', 0.24);
    v[\setParam].value(nodes['bass'], 'wave', 0);
    nodes['rhythm'] = v[\add].value('euclid', origin + (0 @ 610), false);
    v[\setParam].value(nodes['rhythm'], 'division', 4);
    v[\setParam].value(nodes['rhythm'], 'pulses', 5);
    v[\setParam].value(nodes['rhythm'], 'steps', 16);
    nodes['drum'] = v[\add].value('pluck', origin + (295 @ 610), false);
    v[\setParam].value(nodes['drum'], 'auto', 0);
    v[\setParam].value(nodes['drum'], 'coef', 0.65);
    v[\setParam].value(nodes['drum'], 'decay', 0.16);
    v[\setParam].value(nodes['drum'], 'freq', 70);
    v[\setParam].value(nodes['drum'], 'gain', 0);
    nodes['cloud'] = v[\add].value('granular', origin + (590 @ 610), false);
    v[\setParam].value(nodes['cloud'], 'density', 16);
    v[\setParam].value(nodes['cloud'], 'gain', 0.04);
    v[\setParam].value(nodes['cloud'], 'pitchScatter', 0);
    v[\setParam].value(nodes['cloud'], 'scan', 0.018);
    v[\setParam].value(nodes['cloud'], 'size', 0.09);
    nodes['mix'] = v[\add].value('mixer', origin + (0 @ 915), false);
    v[\setParam].value(nodes['mix'], 'gain0', 0.7);
    v[\setParam].value(nodes['mix'], 'gain1', 0.6);
    v[\setParam].value(nodes['mix'], 'gain2', 0.7);
    v[\setParam].value(nodes['mix'], 'gain3', 0.5);
    v[\setParam].value(nodes['mix'], 'pan0', 0.15);
    v[\setParam].value(nodes['mix'], 'pan1', -0.25);
    nodes['tone'] = v[\add].value('filter', origin + (295 @ 915), false);
    v[\setParam].value(nodes['tone'], 'cutoff', 700);
    v[\setParam].value(nodes['tone'], 'resonance', 0.24);
    nodes['echo'] = v[\add].value('delay', origin + (590 @ 915), false);
    v[\setParam].value(nodes['echo'], 'division', 0.75);
    v[\setParam].value(nodes['echo'], 'feedback', 0.38);
    v[\setParam].value(nodes['echo'], 'mix', 0.25);
    v[\setParam].value(nodes['echo'], 'sync', 1);
    nodes['space'] = v[\add].value('reverb', origin + (0 @ 1220), false);
    v[\setParam].value(nodes['space'], 'mix', 0.3);
    v[\setParam].value(nodes['space'], 'shimmer', 0.08);
    v[\setParam].value(nodes['space'], 'size', 0.9);
    nodes['stereo'] = v[\add].value('pan', origin + (295 @ 1220), false);
    v[\setParam].value(nodes['stereo'], 'auto', 0.15);
    v[\setParam].value(nodes['stereo'], 'rate', 0.07);
    nodes['display'] = v[\add].value('scope', origin + (590 @ 1220), false);
    v[\setParam].value(nodes['display'], 'mode', 1);
    nodes['score'] = v[\add].value('note', origin + (0 @ 1525), false);
    v[\helpPattern].value(nodes['leadSeq'], ('node': 'leadSeq', 'notes': [[0], [2], [4], [], [7], [4], [2], [1], [0], [], [2], [4], [6], [4], [2], []], 'degrees': true));
    v[\helpPattern].value(nodes['padSeq'], ('node': 'padSeq', 'velocity': [62], 'notes': [[0, 2, 4, 6]], 'degrees': true, 
  'duration': [2]));
    v[\helpPattern].value(nodes['bassSeq'], ('notes': [[0], [0], [4], [0], [7], [4], [2], [4]], 'velocity': [86, 58, 72, 56, 80, 60, 70, 52], 'node': 'bassSeq', 'degrees': true));
    nodes['score'][\text] = "GLASS GARDEN
Dawn / Motion / Mirror / Return
8 bars each + 2 bars of tail
Uses the current tempo, root and scale.
Stop examples or PANIC ends the performance.";
    v[\loadSound].value(nodes['cloud'], Platform.resourceDir +/+ "sounds/a11wlk01.wav", false);
    v[\connect].value(nodes['leadSeq'], 0, nodes['lead'], 0, nil, 1, false);
    v[\connect].value(nodes['padSeq'], 0, nodes['pad'], 0, nil, 1, false);
    v[\connect].value(nodes['bassSeq'], 0, nodes['bass'], 0, nil, 1, false);
    v[\connect].value(nodes['rhythm'], 0, nodes['drum'], 0, nil, 1, false);
    v[\connect].value(nodes['lead'], 0, nodes['mix'], 0, nil, 1, false);
    v[\connect].value(nodes['pad'], 0, nodes['mix'], 1, nil, 1, false);
    v[\connect].value(nodes['bass'], 0, nodes['mix'], 2, nil, 1, false);
    v[\connect].value(nodes['drum'], 0, nodes['mix'], 3, nil, 1, false);
    v[\connect].value(nodes['cloud'], 0, nodes['mix'], 3, nil, 1, false);
    v[\connect].value(nodes['mix'], 0, nodes['tone'], 0, nil, 1, false);
    v[\connect].value(nodes['tone'], 0, nodes['echo'], 0, nil, 1, false);
    v[\connect].value(nodes['echo'], 0, nodes['space'], 0, nil, 1, false);
    v[\connect].value(nodes['space'], 0, nodes['stereo'], 0, nil, 1, false);
    v[\connect].value(nodes['stereo'], 0, nodes['display'], 0, nil, 1, false);
    v[\connect].value(nodes['display'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['leadSeq'], "Glass Garden · a complete 32-bar piece");
    // Complete score and arrangement: four eight-bar sections, then a two-bar tail.
    ({ |context|
    var app,nodes,routine;
    app = ~void; nodes = context[\nodes];
    routine = Routine({
        var sections,melodies,roots,section,phrase,root,settings,lead,bass,pad;
        sections = [
            (name:"Dawn",lead:0.23,pad:0.2,bass:0,drum:0,cloud:0.04,cutoff:700,wave:0,pulses:3),
            (name:"Motion",lead:0.29,pad:0.18,bass:0.24,drum:0.2,cloud:0.055,cutoff:2200,wave:3,pulses:5),
            (name:"Mirror",lead:0.27,pad:0.17,bass:0.26,drum:0.22,cloud:0.045,cutoff:3700,wave:4,pulses:7),
            (name:"Return",lead:0.2,pad:0.2,bass:0.15,drum:0.09,cloud:0.02,cutoff:950,wave:0,pulses:3)
        ];
        melodies = [
            [[0],[2],[4],[],[7],[4],[2],[1],[0],[],[2],[4],[6],[4],[2],[]],
            [[0],[4],[2],[6],[4],[7],[6],[2],[0],[2],[4],[7],[9],[7],[4],[2]],
            [[7],[6],[4],[2],[0],[],[2],[4],[6],[4],[2],[1],[0],[2],[4],[]],
            [[0],[],[2],[],[4],[],[2],[],[0],[],[],[1],[0],[],[],[]]
        ];
        roots = [0,3,5,4]; section = 0;
        while {section<4 and: {app[\helpExampleAlive].value(context)}} {
            settings = sections[section]; context[\section] = section;
            app[\setParam].value(nodes[\lead],\gain,settings[\lead]);
            app[\setParam].value(nodes[\lead],\wave,settings[\wave]);
            app[\setParam].value(nodes[\pad],\gain,settings[\pad]);
            app[\setParam].value(nodes[\bass],\gain,settings[\bass]);
            app[\setParam].value(nodes[\drum],\gain,settings[\drum]);
            app[\setParam].value(nodes[\cloud],\gain,settings[\cloud]);
            app[\setParam].value(nodes[\tone],\cutoff,settings[\cutoff]);
            app[\setParam].value(nodes[\rhythm],\pulses,settings[\pulses]);
            app[\setParam].value(nodes[\rhythm],\rotation,section);
            if(context[\focus][\type]==\stutter){app[\setParam].value(context[\focus],\repeat,if(section==2){1}{0})};
            app[\message].value("Glass Garden · "++settings[\name]++" · section "++(section+1)++" / 4");
            phrase = 0;
            while {phrase<4 and: {app[\helpExampleAlive].value(context)}} {
                root = roots[phrase];
                lead = nodes[\leadSeq]; bass = nodes[\bassSeq]; pad = nodes[\padSeq];
                16.do { |i|
                    lead[\noteSteps][i] = (notes:melodies[section][i]+root,enabled:true,
                        velocity:[91,59,76,55,84,62,72,58].wrapAt(i),probability:1,duration:1);
                    bass[\noteSteps][i] = (notes:[0,0,4,0,7,4,2,4].wrapAt(i).asArray+root,
                        enabled:true,velocity:[86,58,72,56,80,60,70,52].wrapAt(i),probability:1,duration:1);
                    pad[\noteSteps][i] = (notes:[0,2,4,6]+root,enabled:true,velocity:62,probability:1,duration:2);
                };
                if(context[\focus][\type]==\drone){app[\setParam].value(context[\focus],\rootNote,app[\degreeNote].value(root,36))};
                if([\osc,\fm].includes(context[\focus][\type])){app[\setParam].value(context[\focus],\freq,app[\degreeNote].value(root,36).midicps)};
                context[\phrase] = phrase; context[\rootDegree] = root;
                // One phrase is two 4/4 bars. Four phrases make each eight-bar section.
                8.wait; phrase = phrase+1;
            };
            section = section+1;
        };
        if(app[\helpExampleAlive].value(context)) {
            [\leadSeq,\padSeq,\bassSeq].do { |key|app[\stopSequence].value(nodes[key])};
            app[\setParam].value(nodes[\drum],\gain,0); app[\setParam].value(nodes[\cloud],\gain,0);
            // Let the instrument releases, echoes and room ring for two more bars.
            8.wait; context[\finished] = true; app[\stopHelpExample].value(context);
            app[\message].value("Glass Garden finished: 32 bars and a two-bar tail.");
        };
    }).play(app[\noteClock],quant:1);
    context[\routines].add(routine);
}).value(context);
    v[\startSequence].value(nodes['leadSeq']);
    v[\startSequence].value(nodes['padSeq']);
    v[\startSequence].value(nodes['bassSeq']);
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

## PLAYER

PLAYER plays an audio file while keeping its left and right channels separate. Rate changes speed and pitch together; a negative rate plays backwards. Start and End choose a region of the file. Loop repeats it. The examples load SuperCollider's bundled voice recording; you can replace it with your own sound.

### 1. A repeating recording

Hear the original recording loop. Use Load or Add sound to choose your own file.

```supercollider
(
// A repeating recording
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['focus'] = v[\add].value('player', origin + (0 @ 0), false);
    v[\setParam].value(nodes['focus'], 'gain', 0.14);
    v[\setParam].value(nodes['focus'], 'loop', 1);
    v[\setParam].value(nodes['focus'], 'rate', 1);
    v[\loadSound].value(nodes['focus'], Platform.resourceDir +/+ "sounds/a11wlk01.wav", false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "A repeating recording");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 2. A slower recording

Half speed lowers the recording by one octave and doubles its duration.

```supercollider
(
// A slower recording
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['focus'] = v[\add].value('player', origin + (0 @ 0), false);
    v[\setParam].value(nodes['focus'], 'gain', 0.14);
    v[\setParam].value(nodes['focus'], 'loop', 1);
    v[\setParam].value(nodes['focus'], 'rate', 0.5);
    v[\loadSound].value(nodes['focus'], Platform.resourceDir +/+ "sounds/a11wlk01.wav", false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "A slower recording");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 3. A backwards recording

Negative Rate plays the selected region backwards.

```supercollider
(
// A backwards recording
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['focus'] = v[\add].value('player', origin + (0 @ 0), false);
    v[\setParam].value(nodes['focus'], 'gain', 0.14);
    v[\setParam].value(nodes['focus'], 'loop', 1);
    v[\setParam].value(nodes['focus'], 'rate', -1);
    v[\loadSound].value(nodes['focus'], Platform.resourceDir +/+ "sounds/a11wlk01.wav", false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "A backwards recording");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 4. Musical piece

A looping fragment of the bundled voice recording adds a quiet background layer.

Choose example 4 in this object's help, or build it directly:

```supercollider
~void[\buildHelpExample].value('player', 3);
```

## GRANULAR CLOUD

GRANULAR CLOUD plays many tiny pieces of an audio file at once. Grain size changes the length of each piece, Density changes how many start each second, and Position chooses where they come from. Scan moves that position over time. Pitch and Scatter can turn a familiar recording into a new texture.

### 1. A gentle cloud

Small grains move slowly through the voice recording.

```supercollider
(
// A gentle cloud
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['focus'] = v[\add].value('granular', origin + (0 @ 0), false);
    v[\setParam].value(nodes['focus'], 'density', 18);
    v[\setParam].value(nodes['focus'], 'gain', 0.16);
    v[\setParam].value(nodes['focus'], 'pitchScatter', 0);
    v[\setParam].value(nodes['focus'], 'scan', 0.025);
    v[\setParam].value(nodes['focus'], 'size', 0.12);
    v[\loadSound].value(nodes['focus'], Platform.resourceDir +/+ "sounds/a11wlk01.wav", false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "A gentle cloud");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 2. A frozen place

Freeze stops scanning, so grains keep reading around one chosen position.

```supercollider
(
// A frozen place
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['focus'] = v[\add].value('granular', origin + (0 @ 0), false);
    v[\setParam].value(nodes['focus'], 'density', 35);
    v[\setParam].value(nodes['focus'], 'freeze', 1);
    v[\setParam].value(nodes['focus'], 'gain', 0.13);
    v[\setParam].value(nodes['focus'], 'position', 0.45);
    v[\setParam].value(nodes['focus'], 'scan', 0.1);
    v[\setParam].value(nodes['focus'], 'size', 0.07);
    v[\loadSound].value(nodes['focus'], Platform.resourceDir +/+ "sounds/a11wlk01.wav", false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "A frozen place");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 3. A scattered cloud

Pitch scatter, random grain positions and a wide stereo spread make a changing texture.

```supercollider
(
// A scattered cloud
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['focus'] = v[\add].value('granular', origin + (0 @ 0), false);
    v[\setParam].value(nodes['focus'], 'density', 45);
    v[\setParam].value(nodes['focus'], 'gain', 0.12);
    v[\setParam].value(nodes['focus'], 'pitchScatter', 7);
    v[\setParam].value(nodes['focus'], 'positionScatter', 0.2);
    v[\setParam].value(nodes['focus'], 'size', 0.045);
    v[\setParam].value(nodes['focus'], 'spread', 1);
    v[\loadSound].value(nodes['focus'], Platform.resourceDir +/+ "sounds/a11wlk01.wav", false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "A scattered cloud");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 4. Musical piece

A slowly scanning cloud made from the bundled voice recording surrounds the melody.

Choose example 4 in this object's help, or build it directly:

```supercollider
~void[\buildHelpExample].value('granular', 3);
```

## OSC

OSC makes a steady musical tone by repeating a wave. Frequency chooses the pitch, Wave chooses its colour, and Gain sets its loudness. Connect its round audio outlet to OUTPUT. It is a continuous sound source; use POLY SYNTH for notes with individual starts and endings.

### 1. A quiet sine tone

Listen to a soft A at 220 Hz. Change Frequency slowly, then try the other Wave positions.

```supercollider
(
// A quiet sine tone
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['focus'] = v[\add].value('osc', origin + (0 @ 0), false);
    v[\setParam].value(nodes['focus'], 'freq', 220);
    v[\setParam].value(nodes['focus'], 'gain', 0.075);
    v[\setParam].value(nodes['focus'], 'voices', 1);
    v[\setParam].value(nodes['focus'], 'wave', 0);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "A quiet sine tone");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 2. A wide saw sound

Three slightly detuned saw waves make a broad, warm tone. Unison voices and Detune control the thickness.

```supercollider
(
// A wide saw sound
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['focus'] = v[\add].value('osc', origin + (0 @ 0), false);
    v[\setParam].value(nodes['focus'], 'detune', 12);
    v[\setParam].value(nodes['focus'], 'freq', 110);
    v[\setParam].value(nodes['focus'], 'gain', 0.05);
    v[\setParam].value(nodes['focus'], 'spread', 0.8);
    v[\setParam].value(nodes['focus'], 'voices', 3);
    v[\setParam].value(nodes['focus'], 'wave', 1);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "A wide saw sound");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 3. A hollow pulse tone

The narrow pulse has a bright, hollow colour. Move Pulse width between 0.1 and 0.8 to hear the change.

```supercollider
(
// A hollow pulse tone
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['focus'] = v[\add].value('osc', origin + (0 @ 0), false);
    v[\setParam].value(nodes['focus'], 'freq', 165);
    v[\setParam].value(nodes['focus'], 'gain', 0.055);
    v[\setParam].value(nodes['focus'], 'voices', 1);
    v[\setParam].value(nodes['focus'], 'wave', 4);
    v[\setParam].value(nodes['focus'], 'width', 0.2);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "A hollow pulse tone");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 4. Musical piece

A quiet extra sustained tone supports the bass and changes pitch with the harmony.

Choose example 4 in this object's help, or build it directly:

```supercollider
~void[\buildHelpExample].value('osc', 3);
```

## FM

FM makes a tone by using one oscillator to move the pitch of another very quickly. Carrier sets the main pitch. Ratio sets the relationship between the two oscillators. Index changes the amount of movement: low values are gentle; high values become bright or metallic.

### 1. A soft electric tone

A simple 2:1 ratio and a low Index make a rounded electric tone.

```supercollider
(
// A soft electric tone
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['focus'] = v[\add].value('fm', origin + (0 @ 0), false);
    v[\setParam].value(nodes['focus'], 'freq', 220);
    v[\setParam].value(nodes['focus'], 'gain', 0.065);
    v[\setParam].value(nodes['focus'], 'index', 0.8);
    v[\setParam].value(nodes['focus'], 'ratio', 2);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "A soft electric tone");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 2. A glassy bell colour

The non-integer ratio adds bell-like overtones. This example sustains; put ENVELOPE after it for a struck bell.

```supercollider
(
// A glassy bell colour
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['focus'] = v[\add].value('fm', origin + (0 @ 0), false);
    v[\setParam].value(nodes['focus'], 'freq', 330);
    v[\setParam].value(nodes['focus'], 'gain', 0.045);
    v[\setParam].value(nodes['focus'], 'index', 3);
    v[\setParam].value(nodes['focus'], 'ratio', 3.5);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "A glassy bell colour");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 3. A rough bass colour

A low carrier and a higher Index make a strong bass colour. Reduce Index for a softer version.

```supercollider
(
// A rough bass colour
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['focus'] = v[\add].value('fm', origin + (0 @ 0), false);
    v[\setParam].value(nodes['focus'], 'feedback', 0.2);
    v[\setParam].value(nodes['focus'], 'freq', 55);
    v[\setParam].value(nodes['focus'], 'gain', 0.04);
    v[\setParam].value(nodes['focus'], 'index', 5);
    v[\setParam].value(nodes['focus'], 'ratio', 1);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "A rough bass colour");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 4. Musical piece

An extra FM tone adds a small bright layer above the bass.

Choose example 4 in this object's help, or build it directly:

```supercollider
~void[\buildHelpExample].value('fm', 3);
```

## NOISE

NOISE makes sound without a single clear note. White is bright, pink is darker, and brown is deeper. Colour removes high frequencies. Dust makes separate tiny clicks instead of a steady hiss. Noise is useful for wind, breath and percussion.

### 1. Soft pink wind

A low Colour setting turns pink noise into a gentle wind sound.

```supercollider
(
// Soft pink wind
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['focus'] = v[\add].value('noise', origin + (0 @ 0), false);
    v[\setParam].value(nodes['focus'], 'colour', 1200);
    v[\setParam].value(nodes['focus'], 'gain', 0.055);
    v[\setParam].value(nodes['focus'], 'kind', 1);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Soft pink wind");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 2. Deep brown rumble

Brown noise with a low cutoff makes a quiet low rumble.

```supercollider
(
// Deep brown rumble
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['focus'] = v[\add].value('noise', origin + (0 @ 0), false);
    v[\setParam].value(nodes['focus'], 'colour', 350);
    v[\setParam].value(nodes['focus'], 'gain', 0.045);
    v[\setParam].value(nodes['focus'], 'kind', 2);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Deep brown rumble");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 3. Scattered dust clicks

Dust creates small, irregular clicks. Density controls how often they happen.

```supercollider
(
// Scattered dust clicks
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['focus'] = v[\add].value('noise', origin + (0 @ 0), false);
    v[\setParam].value(nodes['focus'], 'colour', 7000);
    v[\setParam].value(nodes['focus'], 'density', 12);
    v[\setParam].value(nodes['focus'], 'gain', 0.065);
    v[\setParam].value(nodes['focus'], 'kind', 4);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Scattered dust clicks");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 4. Musical piece

A low-level noise layer provides air around the notes.

Choose example 4 in this object's help, or build it directly:

```supercollider
~void[\buildHelpExample].value('noise', 3);
```

## PLUCK

PLUCK makes a short ringing sound, like a string being picked. Frequency sets its note, Decay controls how long it rings, and Damping changes the brightness. Auto clock picks it once per beat. Turn Auto clock off when a CLOCK or EUCLID object supplies the triggers.

### 1. One picked note per beat

A 220 Hz string is picked on every beat. Decay 1.2 leaves a clear space between notes.

```supercollider
(
// One picked note per beat
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['focus'] = v[\add].value('pluck', origin + (0 @ 0), false);
    v[\setParam].value(nodes['focus'], 'auto', 1);
    v[\setParam].value(nodes['focus'], 'decay', 1.2);
    v[\setParam].value(nodes['focus'], 'freq', 220);
    v[\setParam].value(nodes['focus'], 'gain', 0.2);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "One picked note per beat");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 2. A deep damped string

A lower note and stronger damping give a soft bass pluck.

```supercollider
(
// A deep damped string
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['focus'] = v[\add].value('pluck', origin + (0 @ 0), false);
    v[\setParam].value(nodes['focus'], 'auto', 1);
    v[\setParam].value(nodes['focus'], 'coef', 0.7);
    v[\setParam].value(nodes['focus'], 'decay', 0.65);
    v[\setParam].value(nodes['focus'], 'freq', 82.41);
    v[\setParam].value(nodes['focus'], 'gain', 0.2);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "A deep damped string");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 3. Long ringing strings

A brighter note with a long Decay lets successive plucks overlap.

```supercollider
(
// Long ringing strings
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['focus'] = v[\add].value('pluck', origin + (0 @ 0), false);
    v[\setParam].value(nodes['focus'], 'auto', 1);
    v[\setParam].value(nodes['focus'], 'coef', 0.2);
    v[\setParam].value(nodes['focus'], 'decay', 5);
    v[\setParam].value(nodes['focus'], 'freq', 329.63);
    v[\setParam].value(nodes['focus'], 'gain', 0.14);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Long ringing strings");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 4. Musical piece

A short low pluck plays the Euclidean percussion pattern.

Choose example 4 in this object's help, or build it directly:

```supercollider
~void[\buildHelpExample].value('pluck', 3);
```

## DRONE

DRONE holds several related notes at once. Root MIDI sets the bottom note and Chord type chooses their relationship. Slightly different tunings make the notes slowly beat against each other. Spread and Slow beating control this movement.

### 1. A still minor chord

A low minor chord rings continuously with only a little tuning spread.

```supercollider
(
// A still minor chord
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['focus'] = v[\add].value('drone', origin + (0 @ 0), false);
    v[\setParam].value(nodes['focus'], 'beating', 0.08);
    v[\setParam].value(nodes['focus'], 'chord', 1);
    v[\setParam].value(nodes['focus'], 'gain', 0.12);
    v[\setParam].value(nodes['focus'], 'rootNote', 45);
    v[\setParam].value(nodes['focus'], 'spread', 4);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "A still minor chord");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 2. A wide major seventh

A major-seventh stack, wider stereo spread and stronger beating make a luminous pad.

```supercollider
(
// A wide major seventh
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['focus'] = v[\add].value('drone', origin + (0 @ 0), false);
    v[\setParam].value(nodes['focus'], 'beating', 0.18);
    v[\setParam].value(nodes['focus'], 'chord', 3);
    v[\setParam].value(nodes['focus'], 'gain', 0.1);
    v[\setParam].value(nodes['focus'], 'rootNote', 48);
    v[\setParam].value(nodes['focus'], 'spread', 14);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "A wide major seventh");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 3. A suspended atmosphere

A suspended chord avoids a major or minor third. Slow beating makes the sustained sound breathe.

```supercollider
(
// A suspended atmosphere
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['focus'] = v[\add].value('drone', origin + (0 @ 0), false);
    v[\setParam].value(nodes['focus'], 'beating', 0.045);
    v[\setParam].value(nodes['focus'], 'chord', 2);
    v[\setParam].value(nodes['focus'], 'gain', 0.1);
    v[\setParam].value(nodes['focus'], 'rootNote', 43);
    v[\setParam].value(nodes['focus'], 'spread', 22);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "A suspended atmosphere");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 4. Musical piece

A quiet held chord thickens each section. Its root follows the progression.

Choose example 4 in this object's help, or build it directly:

```supercollider
~void[\buildHelpExample].value('drone', 3);
```

## MIC IN

MIC IN brings the first two input channels of the SuperCollider audio device into the patch. Input gain controls their level. Noise gate closes the input when the signal is quiet. These examples start with Input gain at zero; raise it gradually when your input is ready.

### 1. Hear the input

MIC IN connects directly to OUTPUT. Raise Input gain to hear the chosen audio-device inputs.

```supercollider
(
// Hear the input
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['focus'] = v[\add].value('mic', origin + (0 @ 0), false);
    v[\setParam].value(nodes['focus'], 'gain', 0);
    v[\setParam].value(nodes['focus'], 'gate', 0.01);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Hear the input");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 2. Put the input in a room

Raise Input gain, then compare the dry input with the reverb sound.

```supercollider
(
// Put the input in a room
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['focus'] = v[\add].value('mic', origin + (0 @ 0), false);
    v[\setParam].value(nodes['focus'], 'gain', 0);
    nodes['space'] = v[\add].value('reverb', origin + (295 @ 0), false);
    v[\setParam].value(nodes['space'], 'mix', 0.3);
    v[\connect].value(nodes['focus'], 0, nodes['space'], 0, nil, 1, false);
    v[\connect].value(nodes['space'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Put the input in a room");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 3. Echo the input

Raise Input gain and speak or play short sounds. Each sound leaves tempo-synchronised repeats.

```supercollider
(
// Echo the input
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['focus'] = v[\add].value('mic', origin + (0 @ 0), false);
    v[\setParam].value(nodes['focus'], 'gain', 0);
    nodes['echo'] = v[\add].value('delay', origin + (295 @ 0), false);
    v[\setParam].value(nodes['echo'], 'division', 0.5);
    v[\setParam].value(nodes['echo'], 'feedback', 0.35);
    v[\setParam].value(nodes['echo'], 'mix', 0.3);
    v[\setParam].value(nodes['echo'], 'sync', 1);
    v[\connect].value(nodes['focus'], 0, nodes['echo'], 0, nil, 1, false);
    v[\connect].value(nodes['echo'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Echo the input");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 4. Musical piece

An optional live input enters the fourth mixer channel. It starts at gain zero.

Choose example 4 in this object's help, or build it directly:

```supercollider
~void[\buildHelpExample].value('mic', 3);
```

## LFO

LFO is a slow repeating movement rather than an audible sound. Connect its hollow outlet to a knob to make that knob rise and fall. Rate sets the speed and Shape sets the movement. Minimum and Maximum limit the values it sends.

### 1. A slow filter breath

A sine movement gently opens and closes the filter.

```supercollider
(
// A slow filter breath
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('osc', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'freq', 110);
    v[\setParam].value(nodes['source'], 'gain', 0.055);
    v[\setParam].value(nodes['source'], 'wave', 1);
    nodes['tone'] = v[\add].value('filter', origin + (295 @ 0), false);
    v[\setParam].value(nodes['tone'], 'cutoff', 1300);
    v[\setParam].value(nodes['tone'], 'resonance', 0.4);
    nodes['focus'] = v[\add].value('lfo', origin + (590 @ 0), false);
    v[\setParam].value(nodes['focus'], 'high', 1);
    v[\setParam].value(nodes['focus'], 'low', -1);
    v[\setParam].value(nodes['focus'], 'rate', 0.15);
    v[\setParam].value(nodes['focus'], 'shape', 0);
    v[\connect].value(nodes['source'], 0, nodes['tone'], 0, nil, 1, false);
    v[\connect].value(nodes['tone'], 0, nodes['output'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['tone'], 0, 0, 0.12, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "A slow filter breath");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 2. Side-to-side movement

A triangle movement sends the sound gradually from left to right.

```supercollider
(
// Side-to-side movement
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('osc', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'freq', 110);
    v[\setParam].value(nodes['source'], 'gain', 0.055);
    v[\setParam].value(nodes['source'], 'wave', 1);
    nodes['tone'] = v[\add].value('pan', origin + (295 @ 0), false);
    nodes['focus'] = v[\add].value('lfo', origin + (590 @ 0), false);
    v[\setParam].value(nodes['focus'], 'high', 1);
    v[\setParam].value(nodes['focus'], 'low', -1);
    v[\setParam].value(nodes['focus'], 'rate', 0.2);
    v[\setParam].value(nodes['focus'], 'shape', 1);
    v[\connect].value(nodes['source'], 0, nodes['tone'], 0, nil, 1, false);
    v[\connect].value(nodes['tone'], 0, nodes['output'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['tone'], 0, 0, 0.35, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Side-to-side movement");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 3. A soft pulse

A sine movement changes loudness without changing the note.

```supercollider
(
// A soft pulse
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('osc', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'freq', 110);
    v[\setParam].value(nodes['source'], 'gain', 0.055);
    v[\setParam].value(nodes['source'], 'wave', 1);
    nodes['tone'] = v[\add].value('vca', origin + (295 @ 0), false);
    v[\setParam].value(nodes['tone'], 'gain', 0.3);
    nodes['focus'] = v[\add].value('lfo', origin + (590 @ 0), false);
    v[\setParam].value(nodes['focus'], 'high', 1);
    v[\setParam].value(nodes['focus'], 'low', 0);
    v[\setParam].value(nodes['focus'], 'rate', 1);
    v[\setParam].value(nodes['focus'], 'shape', 0);
    v[\connect].value(nodes['source'], 0, nodes['tone'], 0, nil, 1, false);
    v[\connect].value(nodes['tone'], 0, nodes['output'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['tone'], 0, 0, 0.18, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "A soft pulse");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 4. Musical piece

Its hollow outlet makes a small, continuous change to the main filter brightness.

Choose example 4 in this object's help, or build it directly:

```supercollider
~void[\buildHelpExample].value('lfo', 3);
```

## RANDOM

RANDOM moves a knob in an unpredictable way. Smooth glides between values, Step jumps to new values, and Walk takes small steps from the last value. Rate controls how often it moves. Use a small cable depth for gentle variation.

### 1. A wandering filter

Smooth random movement changes the brightness of a steady saw sound.

```supercollider
(
// A wandering filter
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('osc', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'freq', 110);
    v[\setParam].value(nodes['source'], 'gain', 0.055);
    v[\setParam].value(nodes['source'], 'wave', 1);
    nodes['tone'] = v[\add].value('filter', origin + (295 @ 0), false);
    v[\setParam].value(nodes['tone'], 'cutoff', 1300);
    v[\setParam].value(nodes['tone'], 'resonance', 0.4);
    nodes['focus'] = v[\add].value('random', origin + (590 @ 0), false);
    v[\setParam].value(nodes['focus'], 'high', 1);
    v[\setParam].value(nodes['focus'], 'low', -1);
    v[\setParam].value(nodes['focus'], 'mode', 0);
    v[\setParam].value(nodes['focus'], 'rate', 0.6);
    v[\connect].value(nodes['source'], 0, nodes['tone'], 0, nil, 1, false);
    v[\connect].value(nodes['tone'], 0, nodes['output'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['tone'], 0, 0, 0.13, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "A wandering filter");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 2. Random stereo places

Stepped random values move the sound to a new stereo position.

```supercollider
(
// Random stereo places
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('osc', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'freq', 110);
    v[\setParam].value(nodes['source'], 'gain', 0.055);
    v[\setParam].value(nodes['source'], 'wave', 1);
    nodes['tone'] = v[\add].value('pan', origin + (295 @ 0), false);
    nodes['focus'] = v[\add].value('random', origin + (590 @ 0), false);
    v[\setParam].value(nodes['focus'], 'high', 1);
    v[\setParam].value(nodes['focus'], 'low', -1);
    v[\setParam].value(nodes['focus'], 'mode', 1);
    v[\setParam].value(nodes['focus'], 'rate', 2);
    v[\connect].value(nodes['source'], 0, nodes['tone'], 0, nil, 1, false);
    v[\connect].value(nodes['tone'], 0, nodes['output'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['tone'], 0, 0, 0.35, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Random stereo places");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 3. A walking filter

Walk makes a series of small changes rather than unrelated jumps.

```supercollider
(
// A walking filter
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('osc', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'freq', 110);
    v[\setParam].value(nodes['source'], 'gain', 0.055);
    v[\setParam].value(nodes['source'], 'wave', 1);
    nodes['tone'] = v[\add].value('filter', origin + (295 @ 0), false);
    v[\setParam].value(nodes['tone'], 'cutoff', 1300);
    v[\setParam].value(nodes['tone'], 'resonance', 0.4);
    nodes['focus'] = v[\add].value('random', origin + (590 @ 0), false);
    v[\setParam].value(nodes['focus'], 'high', 1);
    v[\setParam].value(nodes['focus'], 'low', -1);
    v[\setParam].value(nodes['focus'], 'mode', 2);
    v[\setParam].value(nodes['focus'], 'rate', 3);
    v[\connect].value(nodes['source'], 0, nodes['tone'], 0, nil, 1, false);
    v[\connect].value(nodes['tone'], 0, nodes['output'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['tone'], 0, 0, 0.16, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "A walking filter");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 4. Musical piece

Its hollow outlet makes a small, continuous change to the main filter brightness.

Choose example 4 in this object's help, or build it directly:

```supercollider
~void[\buildHelpExample].value('random', 3);
```

## CHAOS

CHAOS creates movement from a small mathematical system that never settles into a simple repeating loop. It sends control values, so connect its hollow outlet to a knob. Kind chooses a different behaviour. Rate sets how fast the system changes, and Output amount limits its strength.

### 1. A Lorenz filter

Lorenz movement makes an irregular brightness pattern.

```supercollider
(
// A Lorenz filter
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('osc', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'freq', 110);
    v[\setParam].value(nodes['source'], 'gain', 0.055);
    v[\setParam].value(nodes['source'], 'wave', 1);
    nodes['tone'] = v[\add].value('filter', origin + (295 @ 0), false);
    v[\setParam].value(nodes['tone'], 'cutoff', 1300);
    v[\setParam].value(nodes['tone'], 'resonance', 0.4);
    nodes['focus'] = v[\add].value('chaotic', origin + (590 @ 0), false);
    v[\setParam].value(nodes['focus'], 'amount', 0.5);
    v[\setParam].value(nodes['focus'], 'kind', 0);
    v[\setParam].value(nodes['focus'], 'rate', 12);
    v[\connect].value(nodes['source'], 0, nodes['tone'], 0, nil, 1, false);
    v[\connect].value(nodes['tone'], 0, nodes['output'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['tone'], 0, 0, 0.12, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "A Lorenz filter");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 2. Henon stereo motion

Henon sends more angular movement into the stereo position.

```supercollider
(
// Henon stereo motion
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('osc', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'freq', 110);
    v[\setParam].value(nodes['source'], 'gain', 0.055);
    v[\setParam].value(nodes['source'], 'wave', 1);
    nodes['tone'] = v[\add].value('pan', origin + (295 @ 0), false);
    nodes['focus'] = v[\add].value('chaotic', origin + (590 @ 0), false);
    v[\setParam].value(nodes['focus'], 'amount', 0.4);
    v[\setParam].value(nodes['focus'], 'kind', 1);
    v[\setParam].value(nodes['focus'], 'rate', 8);
    v[\connect].value(nodes['source'], 0, nodes['tone'], 0, nil, 1, false);
    v[\connect].value(nodes['tone'], 0, nodes['output'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['tone'], 0, 0, 0.25, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Henon stereo motion");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 3. A restless filter

Latoocarfian movement gives the filter a different kind of uneven rhythm.

```supercollider
(
// A restless filter
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('osc', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'freq', 110);
    v[\setParam].value(nodes['source'], 'gain', 0.055);
    v[\setParam].value(nodes['source'], 'wave', 1);
    nodes['tone'] = v[\add].value('filter', origin + (295 @ 0), false);
    v[\setParam].value(nodes['tone'], 'cutoff', 1300);
    v[\setParam].value(nodes['tone'], 'resonance', 0.4);
    nodes['focus'] = v[\add].value('chaotic', origin + (590 @ 0), false);
    v[\setParam].value(nodes['focus'], 'amount', 0.4);
    v[\setParam].value(nodes['focus'], 'kind', 2);
    v[\setParam].value(nodes['focus'], 'rate', 18);
    v[\connect].value(nodes['source'], 0, nodes['tone'], 0, nil, 1, false);
    v[\connect].value(nodes['tone'], 0, nodes['output'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['tone'], 0, 0, 0.1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "A restless filter");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 4. Musical piece

Its hollow outlet makes a small, continuous change to the main filter brightness.

Choose example 4 in this object's help, or build it directly:

```supercollider
~void[\buildHelpExample].value('chaotic', 3);
```

## CLOCK

CLOCK sends regular trigger pulses. It makes no sound on its own: connect it to a Trigger inlet. Tempo multiplier chooses how many pulses happen per beat. Probability can leave some pulses out.

### 1. Pick a string on the beat

CLOCK triggers PLUCK once per beat. PLUCK's own Auto clock is turned off.

```supercollider
(
// Pick a string on the beat
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['focus'] = v[\add].value('clock', origin + (0 @ 0), false);
    v[\setParam].value(nodes['focus'], 'division', 1);
    nodes['sound'] = v[\add].value('pluck', origin + (295 @ 0), false);
    v[\setParam].value(nodes['sound'], 'auto', 0);
    v[\setParam].value(nodes['sound'], 'freq', 220);
    v[\setParam].value(nodes['sound'], 'gain', 0.18);
    v[\connect].value(nodes['focus'], 0, nodes['sound'], 0, nil, 1, false);
    v[\connect].value(nodes['sound'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Pick a string on the beat");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 2. Four picks per beat

A multiplier of four makes a quick picked rhythm.

```supercollider
(
// Four picks per beat
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['focus'] = v[\add].value('clock', origin + (0 @ 0), false);
    v[\setParam].value(nodes['focus'], 'division', 4);
    nodes['sound'] = v[\add].value('pluck', origin + (295 @ 0), false);
    v[\setParam].value(nodes['sound'], 'auto', 0);
    v[\setParam].value(nodes['sound'], 'decay', 0.3);
    v[\setParam].value(nodes['sound'], 'freq', 330);
    v[\setParam].value(nodes['sound'], 'gain', 0.12);
    v[\connect].value(nodes['focus'], 0, nodes['sound'], 0, nil, 1, false);
    v[\connect].value(nodes['sound'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Four picks per beat");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 3. An incomplete rhythm

Probability 0.55 leaves out some of the two pulses per beat.

```supercollider
(
// An incomplete rhythm
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['focus'] = v[\add].value('clock', origin + (0 @ 0), false);
    v[\setParam].value(nodes['focus'], 'division', 2);
    v[\setParam].value(nodes['focus'], 'probability', 0.55);
    nodes['sound'] = v[\add].value('pluck', origin + (295 @ 0), false);
    v[\setParam].value(nodes['sound'], 'auto', 0);
    v[\setParam].value(nodes['sound'], 'decay', 0.7);
    v[\setParam].value(nodes['sound'], 'freq', 165);
    v[\setParam].value(nodes['sound'], 'gain', 0.18);
    v[\connect].value(nodes['focus'], 0, nodes['sound'], 0, nil, 1, false);
    v[\connect].value(nodes['sound'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "An incomplete rhythm");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 4. Musical piece

Extra clock pulses add occasional picked accents to the percussion.

Choose example 4 in this object's help, or build it directly:

```supercollider
~void[\buildHelpExample].value('clock', 3);
```

## EUCLID

EUCLID spreads a chosen number of hits as evenly as possible over a repeating number of steps. Steps is the length of the circle, Pulses is the number of hits, and Rotation moves the pattern around. Connect its hollow outlet to a Trigger inlet.

### 1. Five hits in sixteen steps

A familiar uneven rhythm drives a short plucked note.

```supercollider
(
// Five hits in sixteen steps
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['focus'] = v[\add].value('euclid', origin + (0 @ 0), false);
    v[\setParam].value(nodes['focus'], 'division', 4);
    v[\setParam].value(nodes['focus'], 'pulses', 5);
    v[\setParam].value(nodes['focus'], 'steps', 16);
    nodes['sound'] = v[\add].value('pluck', origin + (295 @ 0), false);
    v[\setParam].value(nodes['sound'], 'auto', 0);
    v[\setParam].value(nodes['sound'], 'decay', 0.3);
    v[\setParam].value(nodes['sound'], 'freq', 110);
    v[\setParam].value(nodes['sound'], 'gain', 0.18);
    v[\connect].value(nodes['focus'], 0, nodes['sound'], 0, nil, 1, false);
    v[\connect].value(nodes['sound'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Five hits in sixteen steps");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 2. Three hits in eight steps

A shorter cycle gives a different rhythmic shape.

```supercollider
(
// Three hits in eight steps
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['focus'] = v[\add].value('euclid', origin + (0 @ 0), false);
    v[\setParam].value(nodes['focus'], 'division', 2);
    v[\setParam].value(nodes['focus'], 'pulses', 3);
    v[\setParam].value(nodes['focus'], 'steps', 8);
    nodes['sound'] = v[\add].value('pluck', origin + (295 @ 0), false);
    v[\setParam].value(nodes['sound'], 'auto', 0);
    v[\setParam].value(nodes['sound'], 'decay', 0.6);
    v[\setParam].value(nodes['sound'], 'freq', 220);
    v[\setParam].value(nodes['sound'], 'gain', 0.18);
    v[\connect].value(nodes['focus'], 0, nodes['sound'], 0, nil, 1, false);
    v[\connect].value(nodes['sound'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Three hits in eight steps");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 3. Rotate a seven-step rhythm

Two hits move around a seven-step cycle. Change Rotation to hear a new starting point.

```supercollider
(
// Rotate a seven-step rhythm
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['focus'] = v[\add].value('euclid', origin + (0 @ 0), false);
    v[\setParam].value(nodes['focus'], 'division', 3);
    v[\setParam].value(nodes['focus'], 'pulses', 2);
    v[\setParam].value(nodes['focus'], 'rotation', 3);
    v[\setParam].value(nodes['focus'], 'steps', 7);
    nodes['sound'] = v[\add].value('pluck', origin + (295 @ 0), false);
    v[\setParam].value(nodes['sound'], 'auto', 0);
    v[\setParam].value(nodes['sound'], 'decay', 0.4);
    v[\setParam].value(nodes['sound'], 'freq', 330);
    v[\setParam].value(nodes['sound'], 'gain', 0.16);
    v[\connect].value(nodes['focus'], 0, nodes['sound'], 0, nil, 1, false);
    v[\connect].value(nodes['sound'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Rotate a seven-step rhythm");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 4. Musical piece

Five hits in sixteen steps make the piece's main percussion pattern. Later sections use more hits.

Choose example 4 in this object's help, or build it directly:

```supercollider
~void[\buildHelpExample].value('euclid', 3);
```

## STEP SEQ

STEP SEQ repeats a row of control values. It can move a knob in steps or send trigger pulses. Draw the bars to change values, use the small squares to turn steps on and off, and use probability to leave some steps out. For named notes and chords, open NOTE SEQ.

### 1. Draw a brightness pattern

The bars change FILTER Cutoff. Draw higher bars for brighter steps.

```supercollider
(
// Draw a brightness pattern
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('osc', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'freq', 110);
    v[\setParam].value(nodes['source'], 'gain', 0.06);
    v[\setParam].value(nodes['source'], 'wave', 1);
    nodes['tone'] = v[\add].value('filter', origin + (295 @ 0), false);
    v[\setParam].value(nodes['tone'], 'cutoff', 500);
    nodes['focus'] = v[\add].value('sequencer', origin + (590 @ 0), false);
    v[\setParam].value(nodes['focus'], 'division', 2);
    v[\setParam].value(nodes['focus'], 'length', 8);
    v[\connect].value(nodes['source'], 0, nodes['tone'], 0, nil, 1, false);
    v[\connect].value(nodes['tone'], 0, nodes['output'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['tone'], 0, 0, 0.28, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Draw a brightness pattern");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 2. Draw a loudness pattern

The bars change VCA Gain. Low bars make quiet steps and high bars make louder steps.

```supercollider
(
// Draw a loudness pattern
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('osc', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'freq', 220);
    v[\setParam].value(nodes['source'], 'gain', 0.08);
    nodes['level'] = v[\add].value('vca', origin + (295 @ 0), false);
    v[\setParam].value(nodes['level'], 'gain', 0.05);
    nodes['focus'] = v[\add].value('sequencer', origin + (590 @ 0), false);
    v[\setParam].value(nodes['focus'], 'division', 4);
    v[\setParam].value(nodes['focus'], 'length', 16);
    v[\connect].value(nodes['source'], 0, nodes['level'], 0, nil, 1, false);
    v[\connect].value(nodes['level'], 0, nodes['output'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['level'], 0, 0, 0.3, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Draw a loudness pattern");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 3. Turn step gates into picks

Output gates sends trigger pulses. Turn individual gate squares off to create rests.

```supercollider
(
// Turn step gates into picks
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['focus'] = v[\add].value('sequencer', origin + (0 @ 0), false);
    v[\setParam].value(nodes['focus'], 'division', 4);
    v[\setParam].value(nodes['focus'], 'length', 8);
    v[\setParam].value(nodes['focus'], 'triggerOut', 1);
    nodes['sound'] = v[\add].value('pluck', origin + (295 @ 0), false);
    v[\setParam].value(nodes['sound'], 'auto', 0);
    v[\setParam].value(nodes['sound'], 'decay', 0.4);
    v[\setParam].value(nodes['sound'], 'freq', 165);
    v[\setParam].value(nodes['sound'], 'gain', 0.17);
    v[\connect].value(nodes['focus'], 0, nodes['sound'], 0, nil, 1, false);
    v[\connect].value(nodes['sound'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Turn step gates into picks");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 4. Musical piece

Its control pattern adds a small repeating brightness figure to the main filter.

Choose example 4 in this object's help, or build it directly:

```supercollider
~void[\buildHelpExample].value('sequencer', 3);
```

## ENVELOPE

ENVELOPE gives a sound a beginning and an ending. Attack is the time it takes to rise and Decay is the time it takes to fall. ADSR mode also has a held level and a release. Feed audio into its filled inlet and trigger pulses into its hollow inlet. The hollow outlet can also shape another knob.

### 1. Short soft notes

A clock opens and closes a steady oscillator. The envelope turns it into separate notes.

```supercollider
(
// Short soft notes
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('osc', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'freq', 220);
    v[\setParam].value(nodes['source'], 'gain', 0.08);
    nodes['beat'] = v[\add].value('clock', origin + (295 @ 0), false);
    v[\setParam].value(nodes['beat'], 'division', 2);
    nodes['focus'] = v[\add].value('envelope', origin + (590 @ 0), false);
    v[\setParam].value(nodes['focus'], 'attack', 0.01);
    v[\setParam].value(nodes['focus'], 'decay', 0.25);
    v[\setParam].value(nodes['focus'], 'mode', 0);
    v[\connect].value(nodes['source'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['beat'], 0, nodes['focus'], 1, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Short soft notes");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 2. Slow swells

A slow clock triggers an envelope with a long rise and fall.

```supercollider
(
// Slow swells
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('osc', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'freq', 165);
    v[\setParam].value(nodes['source'], 'gain', 0.05);
    v[\setParam].value(nodes['source'], 'wave', 2);
    nodes['beat'] = v[\add].value('clock', origin + (295 @ 0), false);
    v[\setParam].value(nodes['beat'], 'division', 0.25);
    nodes['focus'] = v[\add].value('envelope', origin + (590 @ 0), false);
    v[\setParam].value(nodes['focus'], 'attack', 1.1);
    v[\setParam].value(nodes['focus'], 'decay', 1.8);
    v[\setParam].value(nodes['focus'], 'mode', 0);
    v[\connect].value(nodes['source'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['beat'], 0, nodes['focus'], 1, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Slow swells");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 3. Held notes with release

ADSR mode holds the sound briefly before releasing it.

```supercollider
(
// Held notes with release
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('fm', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'freq', 220);
    v[\setParam].value(nodes['source'], 'gain', 0.06);
    v[\setParam].value(nodes['source'], 'index', 1);
    nodes['beat'] = v[\add].value('clock', origin + (295 @ 0), false);
    v[\setParam].value(nodes['beat'], 'division', 1);
    nodes['focus'] = v[\add].value('envelope', origin + (590 @ 0), false);
    v[\setParam].value(nodes['focus'], 'attack', 0.03);
    v[\setParam].value(nodes['focus'], 'decay', 0.15);
    v[\setParam].value(nodes['focus'], 'hold', 0.25);
    v[\setParam].value(nodes['focus'], 'mode', 1);
    v[\setParam].value(nodes['focus'], 'release', 0.4);
    v[\setParam].value(nodes['focus'], 'sustain', 0.5);
    v[\connect].value(nodes['source'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['beat'], 0, nodes['focus'], 1, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Held notes with release");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 4. Musical piece

The lead passes through an extra rhythmic volume shape, triggered by the percussion pattern.

Choose example 4 in this object's help, or build it directly:

```supercollider
~void[\buildHelpExample].value('envelope', 3);
```

## FILTER

FILTER removes parts of a sound to change its brightness and colour. Low-pass keeps the low frequencies, high-pass keeps the high ones, and band-pass keeps a narrow area. Cutoff chooses the dividing point. Resonance makes the area around that point stand out.

### 1. A warm low-pass

Only the lower part of each pluck passes through.

```supercollider
(
// A warm low-pass
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('pluck', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'decay', 1.2);
    v[\setParam].value(nodes['source'], 'freq', 220);
    v[\setParam].value(nodes['source'], 'gain', 0.18);
    nodes['focus'] = v[\add].value('filter', origin + (295 @ 0), false);
    v[\setParam].value(nodes['focus'], 'cutoff', 900);
    v[\setParam].value(nodes['focus'], 'kind', 0);
    v[\setParam].value(nodes['focus'], 'resonance', 0.25);
    v[\connect].value(nodes['source'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "A warm low-pass");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 2. A thin high-pass

Removing the low frequencies makes a small, bright sound.

```supercollider
(
// A thin high-pass
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('pluck', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'decay', 1.2);
    v[\setParam].value(nodes['source'], 'freq', 220);
    v[\setParam].value(nodes['source'], 'gain', 0.18);
    nodes['focus'] = v[\add].value('filter', origin + (295 @ 0), false);
    v[\setParam].value(nodes['focus'], 'cutoff', 1200);
    v[\setParam].value(nodes['focus'], 'kind', 1);
    v[\setParam].value(nodes['focus'], 'resonance', 0.2);
    v[\connect].value(nodes['source'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "A thin high-pass");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 3. A ringing band

A narrow band gives each pluck a resonant vowel-like colour.

```supercollider
(
// A ringing band
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('pluck', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'decay', 1.2);
    v[\setParam].value(nodes['source'], 'freq', 220);
    v[\setParam].value(nodes['source'], 'gain', 0.18);
    nodes['focus'] = v[\add].value('filter', origin + (295 @ 0), false);
    v[\setParam].value(nodes['focus'], 'cutoff', 1800);
    v[\setParam].value(nodes['focus'], 'kind', 2);
    v[\setParam].value(nodes['focus'], 'resonance', 0.75);
    v[\connect].value(nodes['source'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "A ringing band");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 4. Musical piece

This is the main brightness control. It opens in the middle sections and closes at the end.

Choose example 4 in this object's help, or build it directly:

```supercollider
~void[\buildHelpExample].value('filter', 3);
```

## DELAY

DELAY repeats a sound after a short time. Time is the gap before each repeat. Feedback decides how many repeats remain, and Mix blends them with the original sound. Tempo sync measures the gap in beats instead of seconds.

### 1. A single short echo

A quiet repeat follows every pluck.

```supercollider
(
// A single short echo
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('pluck', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'decay', 1.2);
    v[\setParam].value(nodes['source'], 'freq', 220);
    v[\setParam].value(nodes['source'], 'gain', 0.18);
    nodes['focus'] = v[\add].value('delay', origin + (295 @ 0), false);
    v[\setParam].value(nodes['focus'], 'feedback', 0.2);
    v[\setParam].value(nodes['focus'], 'mix', 0.3);
    v[\setParam].value(nodes['focus'], 'time', 0.22);
    v[\connect].value(nodes['source'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "A single short echo");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 2. Echoes on the beat

Tempo sync and a half-beat length place repeats between the picked notes.

```supercollider
(
// Echoes on the beat
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('pluck', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'decay', 1.2);
    v[\setParam].value(nodes['source'], 'freq', 220);
    v[\setParam].value(nodes['source'], 'gain', 0.18);
    nodes['focus'] = v[\add].value('delay', origin + (295 @ 0), false);
    v[\setParam].value(nodes['focus'], 'division', 0.5);
    v[\setParam].value(nodes['focus'], 'feedback', 0.48);
    v[\setParam].value(nodes['focus'], 'mix', 0.35);
    v[\setParam].value(nodes['focus'], 'sync', 1);
    v[\connect].value(nodes['source'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Echoes on the beat");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 3. A dark echo trail

A low Loop filter removes brightness from successive repeats.

```supercollider
(
// A dark echo trail
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('pluck', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'decay', 1.2);
    v[\setParam].value(nodes['source'], 'freq', 220);
    v[\setParam].value(nodes['source'], 'gain', 0.18);
    nodes['focus'] = v[\add].value('delay', origin + (295 @ 0), false);
    v[\setParam].value(nodes['focus'], 'feedback', 0.67);
    v[\setParam].value(nodes['focus'], 'mix', 0.4);
    v[\setParam].value(nodes['focus'], 'time', 0.6);
    v[\setParam].value(nodes['focus'], 'tone', 1200);
    v[\connect].value(nodes['source'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "A dark echo trail");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 4. Musical piece

Beat-synchronised echoes join the notes into longer rhythmic phrases.

Choose example 4 in this object's help, or build it directly:

```supercollider
~void[\buildHelpExample].value('delay', 3);
```

## REVERB

REVERB adds the many small reflections you hear in a room. Room size controls how spacious it sounds. Damping makes the reflections darker. Mix blends the room with the original sound. Shimmer sends a little octave-shifted sound back into the reverb.

### 1. A small room

Short, dark reflections put a pluck in a small space.

```supercollider
(
// A small room
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('pluck', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'decay', 1.2);
    v[\setParam].value(nodes['source'], 'freq', 220);
    v[\setParam].value(nodes['source'], 'gain', 0.18);
    nodes['focus'] = v[\add].value('reverb', origin + (295 @ 0), false);
    v[\setParam].value(nodes['focus'], 'damping', 0.65);
    v[\setParam].value(nodes['focus'], 'mix', 0.25);
    v[\setParam].value(nodes['focus'], 'shimmer', 0);
    v[\setParam].value(nodes['focus'], 'size', 0.3);
    v[\connect].value(nodes['source'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "A small room");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 2. A large hall

A larger room leaves a longer, more open trail.

```supercollider
(
// A large hall
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('pluck', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'decay', 1.2);
    v[\setParam].value(nodes['source'], 'freq', 220);
    v[\setParam].value(nodes['source'], 'gain', 0.18);
    nodes['focus'] = v[\add].value('reverb', origin + (295 @ 0), false);
    v[\setParam].value(nodes['focus'], 'damping', 0.3);
    v[\setParam].value(nodes['focus'], 'mix', 0.4);
    v[\setParam].value(nodes['focus'], 'shimmer', 0);
    v[\setParam].value(nodes['focus'], 'size', 0.9);
    v[\connect].value(nodes['source'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "A large hall");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 3. An octave shimmer

A little shimmer adds a higher halo to the long reflections.

```supercollider
(
// An octave shimmer
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('pluck', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'decay', 1.2);
    v[\setParam].value(nodes['source'], 'freq', 220);
    v[\setParam].value(nodes['source'], 'gain', 0.18);
    nodes['focus'] = v[\add].value('reverb', origin + (295 @ 0), false);
    v[\setParam].value(nodes['focus'], 'damping', 0.4);
    v[\setParam].value(nodes['focus'], 'mix', 0.45);
    v[\setParam].value(nodes['focus'], 'shimmer', 0.28);
    v[\setParam].value(nodes['focus'], 'size', 0.94);
    v[\connect].value(nodes['source'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "An octave shimmer");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 4. Musical piece

A large room connects all the layers and leaves a tail at the end.

Choose example 4 in this object's help, or build it directly:

```supercollider
~void[\buildHelpExample].value('reverb', 3);
```

## SPECTRAL

SPECTRAL splits sound into many frequency pieces, changes them, then joins them again. Smear spreads those pieces into a blur. Scramble moves some of them around. Freeze holds a captured spectrum, turning a changing sound into a sustained texture.

### 1. Blur a plucked note

Magnitude smear spreads each ringing note into a softer texture.

```supercollider
(
// Blur a plucked note
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('pluck', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'decay', 1.2);
    v[\setParam].value(nodes['source'], 'freq', 220);
    v[\setParam].value(nodes['source'], 'gain', 0.18);
    nodes['focus'] = v[\add].value('spectral', origin + (295 @ 0), false);
    v[\setParam].value(nodes['focus'], 'mix', 0.8);
    v[\setParam].value(nodes['focus'], 'smear', 14);
    v[\connect].value(nodes['source'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Blur a plucked note");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 2. Rearrange the colour

Bin scramble moves some of the frequency pieces to unexpected places.

```supercollider
(
// Rearrange the colour
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('pluck', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'decay', 1.2);
    v[\setParam].value(nodes['source'], 'freq', 220);
    v[\setParam].value(nodes['source'], 'gain', 0.18);
    nodes['focus'] = v[\add].value('spectral', origin + (295 @ 0), false);
    v[\setParam].value(nodes['focus'], 'mix', 0.7);
    v[\setParam].value(nodes['focus'], 'scramble', 0.35);
    v[\setParam].value(nodes['focus'], 'width', 0.22);
    v[\connect].value(nodes['source'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Rearrange the colour");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 3. Capture a spectrum

After four beats, FFT freeze holds the material heard at that moment. Set Freeze back to zero to listen again.

```supercollider
(
// Capture a spectrum
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('pluck', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'decay', 1.2);
    v[\setParam].value(nodes['source'], 'freq', 220);
    v[\setParam].value(nodes['source'], 'gain', 0.18);
    nodes['focus'] = v[\add].value('spectral', origin + (295 @ 0), false);
    v[\setParam].value(nodes['focus'], 'mix', 0.8);
    v[\setParam].value(nodes['focus'], 'smear', 5);
    v[\connect].value(nodes['source'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Capture a spectrum");
    v[\runHelpActions].value(context, [('after': 4, 'value': 1, 'node': 'focus', 'param': 'freeze')]);
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 4. Musical piece

The lead melody passes through this processor before entering the main mix.

Choose example 4 in this object's help, or build it directly:

```supercollider
~void[\buildHelpExample].value('spectral', 3);
```

## PITCH SHIFT

PITCH SHIFT changes the pitch of incoming audio while keeping its general speed. Ratio 2 raises it one octave and 0.5 lowers it one octave. Pitch dispersion spreads the pitches apart, and Time dispersion makes the grains less regular.

### 1. An octave above

Ratio 2 adds a higher version of the picked note.

```supercollider
(
// An octave above
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('pluck', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'decay', 1.2);
    v[\setParam].value(nodes['source'], 'freq', 220);
    v[\setParam].value(nodes['source'], 'gain', 0.18);
    nodes['focus'] = v[\add].value('pitchshift', origin + (295 @ 0), false);
    v[\setParam].value(nodes['focus'], 'mix', 0.65);
    v[\setParam].value(nodes['focus'], 'pitchDisp', 0);
    v[\setParam].value(nodes['focus'], 'ratio', 2);
    v[\setParam].value(nodes['focus'], 'timeDisp', 0.01);
    v[\connect].value(nodes['source'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "An octave above");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 2. An octave below

Ratio 0.5 puts the sound in a lower register.

```supercollider
(
// An octave below
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('pluck', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'decay', 1.2);
    v[\setParam].value(nodes['source'], 'freq', 220);
    v[\setParam].value(nodes['source'], 'gain', 0.18);
    nodes['focus'] = v[\add].value('pitchshift', origin + (295 @ 0), false);
    v[\setParam].value(nodes['focus'], 'mix', 0.75);
    v[\setParam].value(nodes['focus'], 'pitchDisp', 0);
    v[\setParam].value(nodes['focus'], 'ratio', 0.5);
    v[\connect].value(nodes['source'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "An octave below");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 3. A scattered fifth

Ratio 1.5 adds a fifth while dispersion makes the result less steady.

```supercollider
(
// A scattered fifth
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('pluck', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'decay', 1.2);
    v[\setParam].value(nodes['source'], 'freq', 220);
    v[\setParam].value(nodes['source'], 'gain', 0.18);
    nodes['focus'] = v[\add].value('pitchshift', origin + (295 @ 0), false);
    v[\setParam].value(nodes['focus'], 'mix', 0.5);
    v[\setParam].value(nodes['focus'], 'pitchDisp', 0.08);
    v[\setParam].value(nodes['focus'], 'ratio', 1.5);
    v[\setParam].value(nodes['focus'], 'timeDisp', 0.04);
    v[\connect].value(nodes['source'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "A scattered fifth");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 4. Musical piece

The lead melody passes through this processor before entering the main mix.

Choose example 4 in this object's help, or build it directly:

```supercollider
~void[\buildHelpExample].value('pitchshift', 3);
```

## CRUSH

CRUSH makes digital sound coarser. Lower Sample rate removes fast detail, and lower Bit depth makes the wave use fewer loudness levels. Mix lets the rough version sit beside the clean sound.

### 1. A little digital grain

Twelve bits and a moderate sample rate add a small amount of roughness.

```supercollider
(
// A little digital grain
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('pluck', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'decay', 1.2);
    v[\setParam].value(nodes['source'], 'freq', 220);
    v[\setParam].value(nodes['source'], 'gain', 0.18);
    nodes['focus'] = v[\add].value('crush', origin + (295 @ 0), false);
    v[\setParam].value(nodes['focus'], 'bits', 12);
    v[\setParam].value(nodes['focus'], 'mix', 0.6);
    v[\setParam].value(nodes['focus'], 'sampleRate', 12000);
    v[\connect].value(nodes['source'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "A little digital grain");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 2. An old small sampler

Six bits make the quiet parts of each note much more coarse.

```supercollider
(
// An old small sampler
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('pluck', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'decay', 1.2);
    v[\setParam].value(nodes['source'], 'freq', 220);
    v[\setParam].value(nodes['source'], 'gain', 0.18);
    nodes['focus'] = v[\add].value('crush', origin + (295 @ 0), false);
    v[\setParam].value(nodes['focus'], 'bits', 6);
    v[\setParam].value(nodes['focus'], 'mix', 0.65);
    v[\setParam].value(nodes['focus'], 'sampleRate', 6000);
    v[\connect].value(nodes['source'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "An old small sampler");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 3. A broken radio

A very low sample rate and four bits turn the pluck into a rough buzzing object.

```supercollider
(
// A broken radio
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('pluck', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'decay', 1.2);
    v[\setParam].value(nodes['source'], 'freq', 220);
    v[\setParam].value(nodes['source'], 'gain', 0.18);
    nodes['focus'] = v[\add].value('crush', origin + (295 @ 0), false);
    v[\setParam].value(nodes['focus'], 'bits', 4);
    v[\setParam].value(nodes['focus'], 'mix', 0.5);
    v[\setParam].value(nodes['focus'], 'sampleRate', 1500);
    v[\connect].value(nodes['source'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "A broken radio");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 4. Musical piece

The lead melody passes through this processor before entering the main mix.

Choose example 4 in this object's help, or build it directly:

```supercollider
~void[\buildHelpExample].value('crush', 3);
```

## DISTORT

DISTORT changes the shape of a wave to add new overtones. Drive pushes the sound harder. Tanh rounds its edges, Fold bends the wave back on itself, and Clip cuts the edges off. Tone removes excess high frequencies.

### 1. A warm edge

A little rounded distortion thickens each pluck.

```supercollider
(
// A warm edge
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('pluck', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'decay', 1.2);
    v[\setParam].value(nodes['source'], 'freq', 220);
    v[\setParam].value(nodes['source'], 'gain', 0.18);
    nodes['focus'] = v[\add].value('distort', origin + (295 @ 0), false);
    v[\setParam].value(nodes['focus'], 'drive', 3);
    v[\setParam].value(nodes['focus'], 'mix', 0.45);
    v[\setParam].value(nodes['focus'], 'mode', 0);
    v[\setParam].value(nodes['focus'], 'tone', 5000);
    v[\connect].value(nodes['source'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "A warm edge");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 2. Fold the wave

Folding adds changing high overtones as the note decays.

```supercollider
(
// Fold the wave
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('pluck', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'decay', 1.2);
    v[\setParam].value(nodes['source'], 'freq', 220);
    v[\setParam].value(nodes['source'], 'gain', 0.18);
    nodes['focus'] = v[\add].value('distort', origin + (295 @ 0), false);
    v[\setParam].value(nodes['focus'], 'drive', 8);
    v[\setParam].value(nodes['focus'], 'mix', 0.45);
    v[\setParam].value(nodes['focus'], 'mode', 1);
    v[\setParam].value(nodes['focus'], 'tone', 4500);
    v[\connect].value(nodes['source'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Fold the wave");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 3. A clipped attack

Clipping gives a more abrupt edge to the start of the note.

```supercollider
(
// A clipped attack
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('pluck', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'decay', 1.2);
    v[\setParam].value(nodes['source'], 'freq', 220);
    v[\setParam].value(nodes['source'], 'gain', 0.18);
    nodes['focus'] = v[\add].value('distort', origin + (295 @ 0), false);
    v[\setParam].value(nodes['focus'], 'drive', 10);
    v[\setParam].value(nodes['focus'], 'mix', 0.4);
    v[\setParam].value(nodes['focus'], 'mode', 2);
    v[\setParam].value(nodes['focus'], 'tone', 2800);
    v[\connect].value(nodes['source'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "A clipped attack");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 4. Musical piece

The lead melody passes through this processor before entering the main mix.

Choose example 4 in this object's help, or build it directly:

```supercollider
~void[\buildHelpExample].value('distort', 3);
```

## RING / FREQ SHIFT

RING / FREQ SHIFT makes new tones from the incoming sound. Ring mode multiplies it by another wave, often creating a bell-like or trembling colour. Frequency shift moves all frequencies by the same number of hertz, so the overtones stop lining up in the usual way.

### 1. A slow tremble

Ring mode at 5 Hz makes a fast change in loudness.

```supercollider
(
// A slow tremble
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('pluck', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'decay', 1.2);
    v[\setParam].value(nodes['source'], 'freq', 220);
    v[\setParam].value(nodes['source'], 'gain', 0.18);
    nodes['focus'] = v[\add].value('ring', origin + (295 @ 0), false);
    v[\setParam].value(nodes['focus'], 'frequency', 5);
    v[\setParam].value(nodes['focus'], 'mix', 0.8);
    v[\setParam].value(nodes['focus'], 'mode', 0);
    v[\connect].value(nodes['source'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "A slow tremble");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 2. A metallic colour

A faster ring frequency makes new pitches around the plucked note.

```supercollider
(
// A metallic colour
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('pluck', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'decay', 1.2);
    v[\setParam].value(nodes['source'], 'freq', 220);
    v[\setParam].value(nodes['source'], 'gain', 0.18);
    nodes['focus'] = v[\add].value('ring', origin + (295 @ 0), false);
    v[\setParam].value(nodes['focus'], 'frequency', 80);
    v[\setParam].value(nodes['focus'], 'mix', 0.6);
    v[\setParam].value(nodes['focus'], 'mode', 0);
    v[\connect].value(nodes['source'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "A metallic colour");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 3. Slide the overtones

Frequency shift moves every frequency up by 120 Hz.

```supercollider
(
// Slide the overtones
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('pluck', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'decay', 1.2);
    v[\setParam].value(nodes['source'], 'freq', 220);
    v[\setParam].value(nodes['source'], 'gain', 0.18);
    nodes['focus'] = v[\add].value('ring', origin + (295 @ 0), false);
    v[\setParam].value(nodes['focus'], 'frequency', 120);
    v[\setParam].value(nodes['focus'], 'mix', 0.6);
    v[\setParam].value(nodes['focus'], 'mode', 1);
    v[\connect].value(nodes['source'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Slide the overtones");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 4. Musical piece

The lead melody passes through this processor before entering the main mix.

Choose example 4 in this object's help, or build it directly:

```supercollider
~void[\buildHelpExample].value('ring', 3);
```

## STUTTER

STUTTER remembers a short piece of recent audio and repeats it. Slice seconds is the length of that piece. Rate changes its playback speed and can reverse it. Capture / repeat holds the slice; a trigger can also cause a temporary repeat.

### 1. Repeat a small slice

The object listens for four beats, then starts repeating its latest slice. Turn Capture / repeat off to hear the live sound.

```supercollider
(
// Repeat a small slice
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('pluck', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'decay', 1.2);
    v[\setParam].value(nodes['source'], 'freq', 220);
    v[\setParam].value(nodes['source'], 'gain', 0.18);
    nodes['focus'] = v[\add].value('stutter', origin + (295 @ 0), false);
    v[\setParam].value(nodes['focus'], 'mix', 0.75);
    v[\setParam].value(nodes['focus'], 'size', 0.15);
    v[\connect].value(nodes['source'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Repeat a small slice");
    v[\runHelpActions].value(context, [('after': 4, 'value': 1, 'node': 'focus', 'param': 'repeat')]);
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 2. A reverse memory

After four beats, the captured slice plays backwards.

```supercollider
(
// A reverse memory
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('pluck', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'decay', 1.2);
    v[\setParam].value(nodes['source'], 'freq', 220);
    v[\setParam].value(nodes['source'], 'gain', 0.18);
    nodes['focus'] = v[\add].value('stutter', origin + (295 @ 0), false);
    v[\setParam].value(nodes['focus'], 'mix', 0.7);
    v[\setParam].value(nodes['focus'], 'rate', -1);
    v[\setParam].value(nodes['focus'], 'size', 0.3);
    v[\connect].value(nodes['source'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "A reverse memory");
    v[\runHelpActions].value(context, [('after': 4, 'value': 1, 'node': 'focus', 'param': 'repeat')]);
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 3. A slower fragment

A longer captured piece plays at half speed after four beats.

```supercollider
(
// A slower fragment
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('pluck', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'decay', 1.2);
    v[\setParam].value(nodes['source'], 'freq', 220);
    v[\setParam].value(nodes['source'], 'gain', 0.18);
    nodes['focus'] = v[\add].value('stutter', origin + (295 @ 0), false);
    v[\setParam].value(nodes['focus'], 'mix', 0.65);
    v[\setParam].value(nodes['focus'], 'rate', 0.5);
    v[\setParam].value(nodes['focus'], 'size', 0.5);
    v[\connect].value(nodes['source'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "A slower fragment");
    v[\runHelpActions].value(context, [('after': 4, 'value': 1, 'node': 'focus', 'param': 'repeat')]);
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 4. Musical piece

The lead melody passes through this processor before entering the main mix.

Choose example 4 in this object's help, or build it directly:

```supercollider
~void[\buildHelpExample].value('stutter', 3);
```

## RESONATOR

RESONATOR makes incoming sound ring at a group of chosen pitches, like exciting several strings or metal bars. Root MIDI and Chord type tune the ringing notes. Decay sets how long they last. Even a small click can become a chord.

### 1. A ringing minor chord

Each picked sound excites a low minor-chord bank.

```supercollider
(
// A ringing minor chord
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('pluck', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'decay', 1.2);
    v[\setParam].value(nodes['source'], 'freq', 220);
    v[\setParam].value(nodes['source'], 'gain', 0.18);
    nodes['focus'] = v[\add].value('resonator', origin + (295 @ 0), false);
    v[\setParam].value(nodes['focus'], 'chord', 1);
    v[\setParam].value(nodes['focus'], 'decay', 2);
    v[\setParam].value(nodes['focus'], 'mix', 0.65);
    v[\setParam].value(nodes['focus'], 'rootNote', 48);
    v[\connect].value(nodes['source'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "A ringing minor chord");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 2. A bright major seventh

A higher major-seventh bank gives a brighter set of ringing pitches.

```supercollider
(
// A bright major seventh
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('pluck', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'decay', 1.2);
    v[\setParam].value(nodes['source'], 'freq', 220);
    v[\setParam].value(nodes['source'], 'gain', 0.18);
    nodes['focus'] = v[\add].value('resonator', origin + (295 @ 0), false);
    v[\setParam].value(nodes['focus'], 'chord', 3);
    v[\setParam].value(nodes['focus'], 'decay', 3);
    v[\setParam].value(nodes['focus'], 'mix', 0.6);
    v[\setParam].value(nodes['focus'], 'rootNote', 60);
    v[\connect].value(nodes['source'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "A bright major seventh");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 3. Long suspended strings

A suspended chord and longer decay make overlapping resonances.

```supercollider
(
// Long suspended strings
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('pluck', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'decay', 1.2);
    v[\setParam].value(nodes['source'], 'freq', 220);
    v[\setParam].value(nodes['source'], 'gain', 0.18);
    nodes['focus'] = v[\add].value('resonator', origin + (295 @ 0), false);
    v[\setParam].value(nodes['focus'], 'chord', 2);
    v[\setParam].value(nodes['focus'], 'decay', 6);
    v[\setParam].value(nodes['focus'], 'mix', 0.6);
    v[\setParam].value(nodes['focus'], 'rootNote', 43);
    v[\connect].value(nodes['source'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Long suspended strings");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 4. Musical piece

The lead melody passes through this processor before entering the main mix.

Choose example 4 in this object's help, or build it directly:

```supercollider
~void[\buildHelpExample].value('resonator', 3);
```

## COMPRESSOR

COMPRESSOR reduces the difference between louder and quieter parts of a sound. Threshold is the level where it starts working. Ratio controls how strongly it reduces peaks. Attack and Release control its response speed. Makeup gain adjusts the level after compression.

### 1. Gentle peak control

A moderate ratio softens the loudest part of the pluck.

```supercollider
(
// Gentle peak control
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('pluck', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'decay', 1.2);
    v[\setParam].value(nodes['source'], 'freq', 220);
    v[\setParam].value(nodes['source'], 'gain', 0.18);
    nodes['focus'] = v[\add].value('compressor', origin + (295 @ 0), false);
    v[\setParam].value(nodes['focus'], 'attack', 0.01);
    v[\setParam].value(nodes['focus'], 'makeup', 1);
    v[\setParam].value(nodes['focus'], 'ratio', 2);
    v[\setParam].value(nodes['focus'], 'release', 0.2);
    v[\setParam].value(nodes['focus'], 'threshold', 0.08);
    v[\connect].value(nodes['source'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Gentle peak control");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 2. Tighter attacks

A faster attack catches more of the picked peak.

```supercollider
(
// Tighter attacks
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('pluck', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'decay', 1.2);
    v[\setParam].value(nodes['source'], 'freq', 220);
    v[\setParam].value(nodes['source'], 'gain', 0.18);
    nodes['focus'] = v[\add].value('compressor', origin + (295 @ 0), false);
    v[\setParam].value(nodes['focus'], 'attack', 0.002);
    v[\setParam].value(nodes['focus'], 'makeup', 1.2);
    v[\setParam].value(nodes['focus'], 'ratio', 6);
    v[\setParam].value(nodes['focus'], 'release', 0.12);
    v[\setParam].value(nodes['focus'], 'threshold', 0.035);
    v[\connect].value(nodes['source'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Tighter attacks");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 3. Slow recovery

A longer release keeps the sound controlled for more of the space between notes.

```supercollider
(
// Slow recovery
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('pluck', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'decay', 1.2);
    v[\setParam].value(nodes['source'], 'freq', 220);
    v[\setParam].value(nodes['source'], 'gain', 0.18);
    nodes['focus'] = v[\add].value('compressor', origin + (295 @ 0), false);
    v[\setParam].value(nodes['focus'], 'attack', 0.008);
    v[\setParam].value(nodes['focus'], 'makeup', 1.3);
    v[\setParam].value(nodes['focus'], 'ratio', 8);
    v[\setParam].value(nodes['focus'], 'release', 0.65);
    v[\setParam].value(nodes['focus'], 'threshold', 0.025);
    v[\connect].value(nodes['source'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Slow recovery");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 4. Musical piece

The lead melody passes through this processor before entering the main mix.

Choose example 4 in this object's help, or build it directly:

```supercollider
~void[\buildHelpExample].value('compressor', 3);
```

## MIXER

MIXER brings up to four stereo sounds together. Each input has its own gain, stereo position and mute switch. This lets you balance several musical parts before sending them through shared effects.

### 1. Balance two tones

A low sine and a higher triangle enter separate mixer channels. Move Input 1 and Input 2 gain to compare them.

```supercollider
(
// Balance two tones
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['low'] = v[\add].value('osc', origin + (0 @ 0), false);
    v[\setParam].value(nodes['low'], 'freq', 110);
    v[\setParam].value(nodes['low'], 'gain', 0.05);
    nodes['high'] = v[\add].value('osc', origin + (295 @ 0), false);
    v[\setParam].value(nodes['high'], 'freq', 220);
    v[\setParam].value(nodes['high'], 'gain', 0.05);
    v[\setParam].value(nodes['high'], 'wave', 3);
    nodes['focus'] = v[\add].value('mixer', origin + (590 @ 0), false);
    v[\setParam].value(nodes['focus'], 'gain0', 0.7);
    v[\setParam].value(nodes['focus'], 'gain1', 0.4);
    v[\connect].value(nodes['low'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['high'], 0, nodes['focus'], 1, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Balance two tones");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 2. Put two parts apart

The first sound is left and the second is right. Both remain in the same stereo mix.

```supercollider
(
// Put two parts apart
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['low'] = v[\add].value('pluck', origin + (0 @ 0), false);
    v[\setParam].value(nodes['low'], 'decay', 0.7);
    v[\setParam].value(nodes['low'], 'freq', 165);
    v[\setParam].value(nodes['low'], 'gain', 0.16);
    nodes['high'] = v[\add].value('drone', origin + (295 @ 0), false);
    v[\setParam].value(nodes['high'], 'gain', 0.08);
    v[\setParam].value(nodes['high'], 'rootNote', 57);
    nodes['focus'] = v[\add].value('mixer', origin + (590 @ 0), false);
    v[\setParam].value(nodes['focus'], 'gain0', 0.65);
    v[\setParam].value(nodes['focus'], 'gain1', 0.65);
    v[\setParam].value(nodes['focus'], 'pan0', -0.65);
    v[\setParam].value(nodes['focus'], 'pan1', 0.65);
    v[\connect].value(nodes['low'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['high'], 0, nodes['focus'], 1, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Put two parts apart");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 3. Leave one channel silent

Input 2 starts muted. Click its mute value in the inspector to bring the drone into the mix.

```supercollider
(
// Leave one channel silent
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['low'] = v[\add].value('pluck', origin + (0 @ 0), false);
    v[\setParam].value(nodes['low'], 'freq', 220);
    v[\setParam].value(nodes['low'], 'gain', 0.15);
    nodes['high'] = v[\add].value('drone', origin + (295 @ 0), false);
    v[\setParam].value(nodes['high'], 'gain', 0.1);
    v[\setParam].value(nodes['high'], 'rootNote', 45);
    nodes['focus'] = v[\add].value('mixer', origin + (590 @ 0), false);
    v[\setParam].value(nodes['focus'], 'mute1', 1);
    v[\connect].value(nodes['low'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['high'], 0, nodes['focus'], 1, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Leave one channel silent");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 4. Musical piece

Four channels balance lead, chords, bass and percussion/cloud before the shared effects.

Choose example 4 in this object's help, or build it directly:

```supercollider
~void[\buildHelpExample].value('mixer', 3);
```

## PAN

PAN places stereo audio between the left and right speakers. Pan sets a fixed place. Auto-pan depth moves around that place, and Auto-pan Hz sets the speed. It changes position rather than pitch.

### 1. A place on the left

The ringing note sits left of centre.

```supercollider
(
// A place on the left
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('pluck', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'freq', 220);
    v[\setParam].value(nodes['source'], 'gain', 0.16);
    nodes['focus'] = v[\add].value('pan', origin + (295 @ 0), false);
    v[\setParam].value(nodes['focus'], 'pan', -0.7);
    v[\connect].value(nodes['source'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "A place on the left");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 2. A place on the right

The same note sits right of centre.

```supercollider
(
// A place on the right
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('pluck', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'freq', 220);
    v[\setParam].value(nodes['source'], 'gain', 0.16);
    nodes['focus'] = v[\add].value('pan', origin + (295 @ 0), false);
    v[\setParam].value(nodes['focus'], 'pan', 0.7);
    v[\connect].value(nodes['source'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "A place on the right");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 3. A moving sound

Auto-pan moves the note smoothly between the speakers.

```supercollider
(
// A moving sound
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('pluck', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'freq', 220);
    v[\setParam].value(nodes['source'], 'gain', 0.16);
    nodes['focus'] = v[\add].value('pan', origin + (295 @ 0), false);
    v[\setParam].value(nodes['focus'], 'auto', 0.8);
    v[\setParam].value(nodes['focus'], 'pan', 0);
    v[\setParam].value(nodes['focus'], 'rate', 0.18);
    v[\connect].value(nodes['source'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "A moving sound");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 4. Musical piece

A small automatic pan gives the completed mix a slow stereo movement.

Choose example 4 in this object's help, or build it directly:

```supercollider
~void[\buildHelpExample].value('pan', 3);
```

## VCA / GAIN

VCA / GAIN changes how loud a sound is. Gain 1 keeps its level, Gain 0 is silent, and larger values raise the level. Connect a control outlet to Gain to make a pulse, swell or rhythm.

### 1. Turn a sound down

A VCA at 0.3 makes the original oscillator quieter.

```supercollider
(
// Turn a sound down
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('osc', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'freq', 220);
    v[\setParam].value(nodes['source'], 'gain', 0.1);
    nodes['focus'] = v[\add].value('vca', origin + (295 @ 0), false);
    v[\setParam].value(nodes['focus'], 'gain', 0.3);
    v[\connect].value(nodes['source'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Turn a sound down");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 2. Make a gentle swell

An LFO changes the VCA gain to create a repeating swell.

```supercollider
(
// Make a gentle swell
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('osc', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'freq', 165);
    v[\setParam].value(nodes['source'], 'gain', 0.08);
    v[\setParam].value(nodes['source'], 'wave', 3);
    nodes['motion'] = v[\add].value('lfo', origin + (295 @ 0), false);
    v[\setParam].value(nodes['motion'], 'high', 1);
    v[\setParam].value(nodes['motion'], 'low', 0);
    v[\setParam].value(nodes['motion'], 'rate', 0.25);
    nodes['focus'] = v[\add].value('vca', origin + (590 @ 0), false);
    v[\setParam].value(nodes['focus'], 'gain', 0.1);
    v[\connect].value(nodes['source'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['motion'], 0, nodes['focus'], 0, 0, 0.25, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Make a gentle swell");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 3. Draw a volume rhythm

STEP SEQ bars decide how loud each step is.

```supercollider
(
// Draw a volume rhythm
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('fm', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'freq', 110);
    v[\setParam].value(nodes['source'], 'gain', 0.06);
    v[\setParam].value(nodes['source'], 'index', 1);
    nodes['motion'] = v[\add].value('sequencer', origin + (295 @ 0), false);
    v[\setParam].value(nodes['motion'], 'division', 4);
    v[\setParam].value(nodes['motion'], 'length', 8);
    nodes['focus'] = v[\add].value('vca', origin + (590 @ 0), false);
    v[\setParam].value(nodes['focus'], 'gain', 0.05);
    v[\connect].value(nodes['source'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['motion'], 0, nodes['focus'], 0, 0, 0.25, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Draw a volume rhythm");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 4. Musical piece

A gain stage sits after the mixer and before the tone and space effects.

Choose example 4 in this object's help, or build it directly:

```supercollider
~void[\buildHelpExample].value('vca', 3);
```

## XFADE

XFADE blends between two stereo inputs. At 0 you hear A, at 1 you hear B, and the middle shares both. It adjusts the blend to keep the transition fairly even in loudness. Connect a slow control to Mix for an automatic change of colour.

### 1. Only the first sound

At Mix 0, you hear the low sine on input A.

```supercollider
(
// Only the first sound
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['a'] = v[\add].value('osc', origin + (0 @ 0), false);
    v[\setParam].value(nodes['a'], 'freq', 110);
    v[\setParam].value(nodes['a'], 'gain', 0.055);
    nodes['b'] = v[\add].value('osc', origin + (295 @ 0), false);
    v[\setParam].value(nodes['b'], 'freq', 165);
    v[\setParam].value(nodes['b'], 'gain', 0.055);
    v[\setParam].value(nodes['b'], 'wave', 3);
    nodes['focus'] = v[\add].value('xfade', origin + (590 @ 0), false);
    v[\setParam].value(nodes['focus'], 'mix', 0);
    v[\connect].value(nodes['a'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['b'], 0, nodes['focus'], 1, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Only the first sound");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 2. Only the second sound

At Mix 1, you hear the higher triangle on input B.

```supercollider
(
// Only the second sound
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['a'] = v[\add].value('osc', origin + (0 @ 0), false);
    v[\setParam].value(nodes['a'], 'freq', 110);
    v[\setParam].value(nodes['a'], 'gain', 0.055);
    nodes['b'] = v[\add].value('osc', origin + (295 @ 0), false);
    v[\setParam].value(nodes['b'], 'freq', 165);
    v[\setParam].value(nodes['b'], 'gain', 0.055);
    v[\setParam].value(nodes['b'], 'wave', 3);
    nodes['focus'] = v[\add].value('xfade', origin + (590 @ 0), false);
    v[\setParam].value(nodes['focus'], 'mix', 1);
    v[\connect].value(nodes['a'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['b'], 0, nodes['focus'], 1, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Only the second sound");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 3. Blend two colours

At Mix 0.5, the two different tones share the sound.

```supercollider
(
// Blend two colours
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['a'] = v[\add].value('osc', origin + (0 @ 0), false);
    v[\setParam].value(nodes['a'], 'freq', 110);
    v[\setParam].value(nodes['a'], 'gain', 0.055);
    nodes['b'] = v[\add].value('osc', origin + (295 @ 0), false);
    v[\setParam].value(nodes['b'], 'freq', 165);
    v[\setParam].value(nodes['b'], 'gain', 0.055);
    v[\setParam].value(nodes['b'], 'wave', 3);
    nodes['focus'] = v[\add].value('xfade', origin + (590 @ 0), false);
    v[\setParam].value(nodes['focus'], 'mix', 0.5);
    v[\connect].value(nodes['a'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['b'], 0, nodes['focus'], 1, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Blend two colours");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 4. Musical piece

The lead and pad become the two sides of a blend before the lead mixer channel.

Choose example 4 in this object's help, or build it directly:

```supercollider
~void[\buildHelpExample].value('xfade', 3);
```

## SCOPE

SCOPE shows a sound while passing it onwards. Waveform draws its fast changes in level. Spectrum shows which frequency areas are strongest. Display & audio gain changes both the picture and the level of the sound leaving the object.

### 1. See a sine wave

The smooth repeating curve comes from a sine oscillator.

```supercollider
(
// See a sine wave
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('osc', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'freq', 110);
    v[\setParam].value(nodes['source'], 'gain', 0.06);
    v[\setParam].value(nodes['source'], 'wave', 0);
    nodes['focus'] = v[\add].value('scope', origin + (295 @ 0), false);
    v[\setParam].value(nodes['focus'], 'mode', 0);
    v[\connect].value(nodes['source'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "See a sine wave");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 2. See a square wave

A square wave has abrupt edges. Compare the shape with the sine example.

```supercollider
(
// See a square wave
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('osc', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'freq', 110);
    v[\setParam].value(nodes['source'], 'gain', 0.06);
    v[\setParam].value(nodes['source'], 'wave', 2);
    nodes['focus'] = v[\add].value('scope', origin + (295 @ 0), false);
    v[\setParam].value(nodes['focus'], 'mode', 0);
    v[\connect].value(nodes['source'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "See a square wave");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 3. See the overtones

Spectrum mode shows the many frequency bands in a saw wave.

```supercollider
(
// See the overtones
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('osc', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'freq', 110);
    v[\setParam].value(nodes['source'], 'gain', 0.06);
    v[\setParam].value(nodes['source'], 'wave', 1);
    nodes['focus'] = v[\add].value('scope', origin + (295 @ 0), false);
    v[\setParam].value(nodes['focus'], 'mode', 1);
    v[\connect].value(nodes['source'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "See the overtones");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 4. Musical piece

It displays the final mix after the shared effects and before OUTPUT.

Choose example 4 in this object's help, or build it directly:

```supercollider
~void[\buildHelpExample].value('scope', 3);
```

## OUTPUT

OUTPUT is the permanent stereo destination of the patch. Sounds reach the audio device after passing through its master volume and protection. You can connect several audio cables to it; they are added together. Audio OFF mutes the hardware, while recording can still capture the master.

### 1. Send one tone to the speakers

A quiet oscillator goes straight to the existing OUTPUT. Turn Audio ON if the toolbar is muted.

```supercollider
(
// Send one tone to the speakers
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('osc', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'freq', 220);
    v[\setParam].value(nodes['source'], 'gain', 0.07);
    v[\connect].value(nodes['source'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['output'], "Send one tone to the speakers");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 2. Add two sounds

Two quiet tones share OUTPUT and are added together.

```supercollider
(
// Add two sounds
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['one'] = v[\add].value('osc', origin + (0 @ 0), false);
    v[\setParam].value(nodes['one'], 'freq', 220);
    v[\setParam].value(nodes['one'], 'gain', 0.04);
    nodes['two'] = v[\add].value('osc', origin + (295 @ 0), false);
    v[\setParam].value(nodes['two'], 'freq', 330);
    v[\setParam].value(nodes['two'], 'gain', 0.04);
    v[\connect].value(nodes['one'], 0, nodes['output'], 0, nil, 1, false);
    v[\connect].value(nodes['two'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['output'], "Add two sounds");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 3. Send a small instrument

A note sequencer plays a chord through POLY SYNTH into the permanent master.

```supercollider
(
// Send a small instrument
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['seq'] = v[\add].value('noteseq', origin + (0 @ 0), false);
    v[\setParam].value(nodes['seq'], 'division', 1);
    v[\setParam].value(nodes['seq'], 'length', 4);
    nodes['sound'] = v[\add].value('polysynth', origin + (295 @ 0), false);
    v[\setParam].value(nodes['sound'], 'gain', 0.35);
    v[\helpPattern].value(nodes['seq'], ('node': 'seq', 'notes': [[0, 2, 4], [3, 5, 7], [4, 6, 8], [0, 2, 4]], 'degrees': true));
    v[\connect].value(nodes['seq'], 0, nodes['sound'], 0, nil, 1, false);
    v[\connect].value(nodes['sound'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['output'], "Send a small instrument");
    v[\startSequence].value(nodes['seq']);
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 4. Musical piece

All musical layers reach this protected stereo master. The piece does not replace it.

Choose example 4 in this object's help, or build it directly:

```supercollider
~void[\buildHelpExample].value('output', 3);
```

## RECORDER

RECORDER records the protected master to a stereo WAV file. It follows the master automatically, so it does not need an audio cable to hear the finished mix. Click Record to begin and click again to finish the file. The saved path appears in the status line.

### 1. Record one sound

A picked note is ready to record. Click RECORDER's Record master button, then click it again to finish.

```supercollider
(
// Record one sound
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('pluck', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'freq', 220);
    v[\setParam].value(nodes['source'], 'gain', 0.16);
    nodes['focus'] = v[\add].value('recorder', origin + (295 @ 0), false);
    v[\connect].value(nodes['source'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Record one sound");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 2. Record an effect trail

The recorder captures the full sound including reverb. Start and stop recording manually.

```supercollider
(
// Record an effect trail
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['source'] = v[\add].value('pluck', origin + (0 @ 0), false);
    v[\setParam].value(nodes['source'], 'freq', 330);
    v[\setParam].value(nodes['source'], 'gain', 0.14);
    nodes['space'] = v[\add].value('reverb', origin + (295 @ 0), false);
    v[\setParam].value(nodes['space'], 'mix', 0.4);
    nodes['focus'] = v[\add].value('recorder', origin + (590 @ 0), false);
    v[\connect].value(nodes['source'], 0, nodes['space'], 0, nil, 1, false);
    v[\connect].value(nodes['space'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Record an effect trail");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 3. Record a chord pattern

Apply and play this short pattern, then start recording when ready.

```supercollider
(
// Record a chord pattern
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['seq'] = v[\add].value('noteseq', origin + (0 @ 0), false);
    v[\setParam].value(nodes['seq'], 'division', 1);
    v[\setParam].value(nodes['seq'], 'length', 4);
    nodes['sound'] = v[\add].value('polysynth', origin + (295 @ 0), false);
    v[\setParam].value(nodes['sound'], 'gain', 0.35);
    nodes['focus'] = v[\add].value('recorder', origin + (590 @ 0), false);
    v[\helpPattern].value(nodes['seq'], ('node': 'seq', 'notes': [[0, 2, 4], [3, 5, 7], [4, 6, 8], [0, 2, 4]], 'degrees': true));
    v[\connect].value(nodes['seq'], 0, nodes['sound'], 0, nil, 1, false);
    v[\connect].value(nodes['sound'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Record a chord pattern");
    v[\startSequence].value(nodes['seq']);
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 4. Musical piece

A RECORDER is included for capturing the whole performance. Press Record yourself; building the piece does not create a recording.

Choose example 4 in this object's help, or build it directly:

```supercollider
~void[\buildHelpExample].value('recorder', 3);
```

## NOTE

NOTE is a written reminder on the canvas. It makes no sound and needs no cables. Double-click its body to edit the words. Use it for playing instructions, a score, a patch title or the meaning of a group of controls.

### 1. Label a sound

The NOTE names a quiet oscillator patch. Double-click the note body to change the title.

```supercollider
(
// Label a sound
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['focus'] = v[\add].value('note', origin + (0 @ 0), false);
    nodes['sound'] = v[\add].value('osc', origin + (295 @ 0), false);
    v[\setParam].value(nodes['sound'], 'freq', 220);
    v[\setParam].value(nodes['sound'], 'gain', 0.06);
    nodes['focus'][\text] = "A quiet A
OSC -> OUTPUT
Frequency: 220 Hz";
    v[\connect].value(nodes['sound'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Label a sound");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 2. Write playing instructions

The note tells the performer how to change the sound over time.

```supercollider
(
// Write playing instructions
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['focus'] = v[\add].value('note', origin + (0 @ 0), false);
    nodes['sound'] = v[\add].value('drone', origin + (295 @ 0), false);
    v[\setParam].value(nodes['sound'], 'gain', 0.09);
    nodes['focus'][\text] = "For 8 slow breaths:
Raise Spread a little.
Then return to stillness.";
    v[\connect].value(nodes['sound'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Write playing instructions");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 3. Write a short score

A written score sits beside a four-chord pattern.

```supercollider
(
// Write a short score
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['focus'] = v[\add].value('note', origin + (0 @ 0), false);
    nodes['seq'] = v[\add].value('noteseq', origin + (295 @ 0), false);
    v[\setParam].value(nodes['seq'], 'division', 0.5);
    v[\setParam].value(nodes['seq'], 'length', 4);
    nodes['sound'] = v[\add].value('polysynth', origin + (590 @ 0), false);
    v[\setParam].value(nodes['sound'], 'gain', 0.3);
    v[\helpPattern].value(nodes['seq'], ('node': 'seq', 'notes': [[0, 2, 4], [3, 5, 7], [4, 6, 8], [0, 2, 4]], 'degrees': true));
    nodes['focus'][\text] = "Four chords
Repeat quietly.
Open the filter on the last chord.
Stop and let the release finish.";
    v[\connect].value(nodes['seq'], 0, nodes['sound'], 0, nil, 1, false);
    v[\connect].value(nodes['sound'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Write a short score");
    v[\startSequence].value(nodes['seq']);
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 4. Musical piece

The canvas note is a score with the four section names, their lengths, and the performance instructions.

Choose example 4 in this object's help, or build it directly:

```supercollider
~void[\buildHelpExample].value('note', 3);
```

## POLY SYNTH

POLY SYNTH turns note events into sound. It can play up to 32 notes at once, so chords work as well as single notes. Wave changes the colour. Attack and Release shape the start and end of each note. Connect a MIDI IN or NOTE SEQ diamond outlet to its diamond inlet, then send its round audio outlet to OUTPUT.

### 1. Four separate notes

A short scale-degree pattern plays a soft sine instrument.

```supercollider
(
// Four separate notes
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['seq'] = v[\add].value('noteseq', origin + (0 @ 0), false);
    v[\setParam].value(nodes['seq'], 'division', 2);
    v[\setParam].value(nodes['seq'], 'length', 4);
    nodes['focus'] = v[\add].value('polysynth', origin + (295 @ 0), false);
    v[\setParam].value(nodes['focus'], 'gain', 0.35);
    v[\setParam].value(nodes['focus'], 'release', 0.2);
    v[\setParam].value(nodes['focus'], 'wave', 0);
    v[\helpPattern].value(nodes['seq'], ('node': 'seq', 'notes': [[0], [1], [2], [4]], 'degrees': true));
    v[\connect].value(nodes['seq'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Four separate notes");
    v[\startSequence].value(nodes['seq']);
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 2. Play chords

Four-note chords show polyphony. A longer release lets them overlap slightly.

```supercollider
(
// Play chords
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['seq'] = v[\add].value('noteseq', origin + (0 @ 0), false);
    v[\setParam].value(nodes['seq'], 'division', 0.5);
    v[\setParam].value(nodes['seq'], 'length', 4);
    nodes['focus'] = v[\add].value('polysynth', origin + (295 @ 0), false);
    v[\setParam].value(nodes['focus'], 'attack', 0.08);
    v[\setParam].value(nodes['focus'], 'gain', 0.3);
    v[\setParam].value(nodes['focus'], 'release', 1.2);
    v[\setParam].value(nodes['focus'], 'wave', 3);
    v[\helpPattern].value(nodes['seq'], ('node': 'seq', 'notes': [[0, 2, 4, 6], [3, 5, 7, 9], [4, 6, 8, 10], [0, 2, 4, 6]], 'degrees': true));
    v[\connect].value(nodes['seq'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Play chords");
    v[\startSequence].value(nodes['seq']);
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 3. A bell-like melody

The FM waveform and a short attack make a clear, ringing melody.

```supercollider
(
// A bell-like melody
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['seq'] = v[\add].value('noteseq', origin + (0 @ 0), false);
    v[\setParam].value(nodes['seq'], 'division', 3);
    v[\setParam].value(nodes['seq'], 'length', 8);
    nodes['focus'] = v[\add].value('polysynth', origin + (295 @ 0), false);
    v[\setParam].value(nodes['focus'], 'gain', 0.3);
    v[\setParam].value(nodes['focus'], 'release', 0.45);
    v[\setParam].value(nodes['focus'], 'wave', 4);
    v[\helpPattern].value(nodes['seq'], ('notes': [[0], [4], [2], [6], [4], [7], [6], [2]], 'velocity': [92, 64, 78, 60, 90, 64, 76, 55], 'node': 'seq', 'degrees': true));
    v[\connect].value(nodes['seq'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['focus'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "A bell-like melody");
    v[\startSequence].value(nodes['seq']);
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 4. Musical piece

It is the lead instrument. Two more POLY SYNTH objects play chords and bass.

Choose example 4 in this object's help, or build it directly:

```supercollider
~void[\buildHelpExample].value('polysynth', 3);
```

## MIDI IN

MIDI IN receives notes from a keyboard, controller or another application. It makes no audio itself. Choose the device and channel in MIDI settings, then connect its diamond outlet to POLY SYNTH or MIDI OUT. Velocity, sustain pedal and pitch bend are supported.

### 1. Play the synth by hand

Choose your input in MIDI settings, then play the controller. All channels are accepted.

```supercollider
(
// Play the synth by hand
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['focus'] = v[\add].value('midiin', origin + (0 @ 0), false);
    nodes['sound'] = v[\add].value('polysynth', origin + (295 @ 0), false);
    v[\setParam].value(nodes['sound'], 'gain', 0.4);
    v[\connect].value(nodes['focus'], 0, nodes['sound'], 0, nil, 1, false);
    v[\connect].value(nodes['sound'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Play the synth by hand");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 2. Listen to channel two

Only MIDI channel 2 plays this instrument. Set your keyboard to channel 2.

```supercollider
(
// Listen to channel two
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['focus'] = v[\add].value('midiin', origin + (0 @ 0), false);
    nodes['sound'] = v[\add].value('polysynth', origin + (295 @ 0), false);
    v[\setParam].value(nodes['sound'], 'gain', 0.35);
    v[\setParam].value(nodes['sound'], 'wave', 3);
    v[\restoreMusic].value(nodes['focus'], ('midiChannel': 1));
    v[\connect].value(nodes['focus'], 0, nodes['sound'], 0, nil, 1, false);
    v[\connect].value(nodes['sound'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Listen to channel two");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 3. Walk through a microtonal scale

Degree mapping makes neighbouring keys play neighbouring degrees of the global scale. Choose an EDO or Persian/Arabic preset in Scales.

```supercollider
(
// Walk through a microtonal scale
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['focus'] = v[\add].value('midiin', origin + (0 @ 0), false);
    nodes['sound'] = v[\add].value('polysynth', origin + (295 @ 0), false);
    v[\setParam].value(nodes['sound'], 'gain', 0.35);
    v[\setParam].value(nodes['sound'], 'wave', 0);
    v[\restoreMusic].value(nodes['focus'], ('inputMapping': 2));
    v[\connect].value(nodes['focus'], 0, nodes['sound'], 0, nil, 1, false);
    v[\connect].value(nodes['sound'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Walk through a microtonal scale");
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 4. Musical piece

An optional MIDI IN lets you improvise over the piece using the lead instrument. Choose a controller in its settings.

Choose example 4 in this object's help, or build it directly:

```supercollider
~void[\buildHelpExample].value('midiin', 3);
```

## NOTE SEQ

NOTE SEQ repeats a pattern of musical notes and chords. Each step can have several notes, a rest, a velocity, a probability and a duration. Degree mode follows the global scale and root; MIDI mode plays exact note numbers or note names. Its diamond outlet carries notes rather than audio.

### 1. A small scale melody

Degrees 0, 1, 2 and 4 make a four-note phrase in the selected global scale.

```supercollider
(
// A small scale melody
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['focus'] = v[\add].value('noteseq', origin + (0 @ 0), false);
    v[\setParam].value(nodes['focus'], 'division', 2);
    v[\setParam].value(nodes['focus'], 'length', 4);
    nodes['sound'] = v[\add].value('polysynth', origin + (295 @ 0), false);
    v[\setParam].value(nodes['sound'], 'gain', 0.35);
    v[\helpPattern].value(nodes['focus'], ('node': 'focus', 'notes': [[0], [1], [2], [4]], 'degrees': true));
    v[\connect].value(nodes['focus'], 0, nodes['sound'], 0, nil, 1, false);
    v[\connect].value(nodes['sound'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "A small scale melody");
    v[\startSequence].value(nodes['focus']);
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 2. Chords with space

A chord, a rest, another chord and a rest make a simple call and response.

```supercollider
(
// Chords with space
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['focus'] = v[\add].value('noteseq', origin + (0 @ 0), false);
    v[\setParam].value(nodes['focus'], 'division', 1);
    v[\setParam].value(nodes['focus'], 'gateLength', 0.65);
    v[\setParam].value(nodes['focus'], 'length', 4);
    nodes['sound'] = v[\add].value('polysynth', origin + (295 @ 0), false);
    v[\setParam].value(nodes['sound'], 'gain', 0.3);
    v[\setParam].value(nodes['sound'], 'release', 0.7);
    v[\setParam].value(nodes['sound'], 'wave', 3);
    v[\helpPattern].value(nodes['focus'], ('node': 'focus', 'notes': [[0, 2, 4], [], [3, 5, 7], []], 'degrees': true));
    v[\connect].value(nodes['focus'], 0, nodes['sound'], 0, nil, 1, false);
    v[\connect].value(nodes['sound'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Chords with space");
    v[\startSequence].value(nodes['focus']);
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 3. Exact notes and microtones

MIDI numbers 60, 64.5 and 67 form a chord with a quarter-tone middle note. Literal pitches stay fixed when the global scale changes.

```supercollider
(
// Exact notes and microtones
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['focus'] = v[\add].value('noteseq', origin + (0 @ 0), false);
    v[\setParam].value(nodes['focus'], 'division', 1);
    v[\setParam].value(nodes['focus'], 'length', 4);
    nodes['sound'] = v[\add].value('polysynth', origin + (295 @ 0), false);
    v[\setParam].value(nodes['sound'], 'gain', 0.3);
    v[\helpPattern].value(nodes['focus'], ('node': 'focus', 'notes': [[60, 64.5, 67], [], [62, 65.25, 69], []], 'degrees': false));
    v[\connect].value(nodes['focus'], 0, nodes['sound'], 0, nil, 1, false);
    v[\connect].value(nodes['sound'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Exact notes and microtones");
    v[\startSequence].value(nodes['focus']);
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 4. Musical piece

Three independent note sequencers play melody, four-note chords and bass. This object is the lead sequencer.

Choose example 4 in this object's help, or build it directly:

```supercollider
~void[\buildHelpExample].value('noteseq', 3);
```

## MIDI OUT

MIDI OUT sends note events to another instrument or application. Choose the destination in MIDI settings. Standard mode uses one channel and rounds fractional pitches. MPE mode gives notes separate channels so microtonal chords keep their individual tuning. A POLY SYNTH is included in these examples so you can also hear the notes internally.

### 1. Send a simple melody

Choose an output destination. Standard mode sends the four-note melody on MIDI channel 1.

```supercollider
(
// Send a simple melody
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['seq'] = v[\add].value('noteseq', origin + (0 @ 0), false);
    v[\setParam].value(nodes['seq'], 'division', 2);
    v[\setParam].value(nodes['seq'], 'length', 4);
    nodes['focus'] = v[\add].value('midiout', origin + (295 @ 0), false);
    nodes['sound'] = v[\add].value('polysynth', origin + (590 @ 0), false);
    v[\setParam].value(nodes['sound'], 'gain', 0.3);
    v[\restoreMusic].value(nodes['focus'], ('bendRange': 2, 'mpe': false, 'outChannel': 0));
    v[\helpPattern].value(nodes['seq'], ('node': 'seq', 'notes': [[60], [62], [64], [67]], 'degrees': false));
    v[\connect].value(nodes['seq'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['seq'], 0, nodes['sound'], 0, nil, 1, false);
    v[\connect].value(nodes['sound'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Send a simple melody");
    v[\startSequence].value(nodes['seq']);
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 2. Send a microtonal chord

Choose an MPE-capable destination with matching pitch-bend range. The internal monitor also plays the fractional chord.

```supercollider
(
// Send a microtonal chord
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['seq'] = v[\add].value('noteseq', origin + (0 @ 0), false);
    v[\setParam].value(nodes['seq'], 'division', 1);
    v[\setParam].value(nodes['seq'], 'length', 4);
    nodes['focus'] = v[\add].value('midiout', origin + (295 @ 0), false);
    nodes['sound'] = v[\add].value('polysynth', origin + (590 @ 0), false);
    v[\setParam].value(nodes['sound'], 'gain', 0.3);
    v[\helpPattern].value(nodes['seq'], ('node': 'seq', 'notes': [[60, 64.5, 67.25], [], [62, 65.5, 69.25], []], 'degrees': false));
    v[\connect].value(nodes['seq'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['seq'], 0, nodes['sound'], 0, nil, 1, false);
    v[\connect].value(nodes['sound'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Send a microtonal chord");
    v[\startSequence].value(nodes['seq']);
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 3. Send the chosen scale

Choose a destination and use MPE for fractional degrees. Change the global scale to hear and transmit another tuning.

```supercollider
(
// Send the chosen scale
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['seq'] = v[\add].value('noteseq', origin + (0 @ 0), false);
    v[\setParam].value(nodes['seq'], 'division', 2);
    v[\setParam].value(nodes['seq'], 'length', 8);
    nodes['focus'] = v[\add].value('midiout', origin + (295 @ 0), false);
    nodes['sound'] = v[\add].value('polysynth', origin + (590 @ 0), false);
    v[\setParam].value(nodes['sound'], 'gain', 0.3);
    v[\helpPattern].value(nodes['seq'], ('node': 'seq', 'notes': [[0], [1], [2], [3], [4], [5], [6], [7]], 'degrees': true));
    v[\connect].value(nodes['seq'], 0, nodes['focus'], 0, nil, 1, false);
    v[\connect].value(nodes['seq'], 0, nodes['sound'], 0, nil, 1, false);
    v[\connect].value(nodes['sound'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['focus'], "Send the chosen scale");
    v[\startSequence].value(nodes['seq']);
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)
```

### 4. Musical piece

The lead note pattern also reaches MIDI OUT. Choose a destination to double the lead on an external instrument.

Choose example 4 in this object's help, or build it directly:

```supercollider
~void[\buildHelpExample].value('midiout', 3);
```
