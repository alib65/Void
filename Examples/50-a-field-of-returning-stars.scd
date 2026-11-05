/*
VOID STUDY 50 / A Field of Returning Stars

LEARN
A one-minute miniature with six composed moments.

COMPOSER'S NOTE
A small intervallic seed becomes a melody, crosses an independent seven-step answer, dissolves into a held spectrum, and returns in a shorter coda.

SCORE
88 BPM; global scale Dorian; root 7 semitones above C.
80 beats of material + 8 beats of tail; about 60 seconds.
Form: Seed (8 beats) / Constellation (16 beats) / Cross-currents (16 beats) / Stillpoint (16 beats) / Return (16 beats) / Coda (8 beats).
Hz parameters and MIDI-mode patterns keep their literal pitches.

PLAY
Evaluate the current VOID.scd first. Evaluate this entire parenthesized block.
Audio ON makes the patch audible. It adds its own selected nodes to the canvas.
Use Stop examples or ~void[\stopHelpExamples].value to stop early.
Undo removes the last build; saved patches retain nodes/patterns, while this file runs the written form.
This study sets the shared tempo/root/tuning and stops earlier help-built examples.
Recording and external MIDI output require your own device/button choices.

TRY
1. Replace the seed and derive the answer from your new contour.
2. Make Stillpoint completely silent except for the cloud.
3. Record a full take, then compare its proportions with the written form.
*/
(

var v, origin, nodes, context, make, wire, mod, phrase, alive, performance, scaleIndex;
v = ~void;
if(v.notNil and: {v[\ready]} and: {v[\trackHelpExample].notNil}) {
    scaleIndex = v[\scaleNames].indexOfEqual("Dorian");
    if(scaleIndex.isNil) {Error("This VOID installation is missing the study tuning.").throw};
    v[\checkpoint].value;
    v[\stopHelpExamples].value;
    v[\bpm] = 88; v[\root] = 7; v[\scaleMode] = 0;
    v[\customScale] = nil; v[\scaleIndex] = scaleIndex;
    v[\sendGlobals].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);

    // Small local helpers keep the patch and musical data readable.
    make = { |name, type, parameters|
        var node, index;
        index = nodes.size-1;
        node = v[\add].value(type, origin+((index%3*295)@((index/3).floor*305)), false);
        nodes[name] = node;
        parameters.keysValuesDo { |key,value|v[\setParam].value(node,key,value)};
        node
    };
    wire = { |source,destination,inlet=0,amount=1|
        v[\connect].value(nodes[source],0,nodes[destination],inlet,nil,amount,false)
    };
    mod = { |source,destination,key,depth|
        var index;
        index = v[\registry][nodes[destination][\type]][\params].detectIndex { |spec|spec[\key]==key };
        v[\connect].value(nodes[source],0,nodes[destination],0,index,depth,false)
    };
    phrase = { |name,data|v[\helpPattern].value(nodes[name],data)};

    // INSTRUMENTS / each name below identifies one canvas object.
    make.value(\line, \noteseq, (base: 60, division: 2, length: 16, gateLength: 0.7));
    make.value(\lead, \polysynth, (wave: 3, gain: 0.2, attack: 0.012, release: 0.45));
    make.value(\answerLine, \noteseq, (base: 72, division: 2, length: 7, gateLength: 0.7));
    make.value(\answer, \polysynth, (wave: 0, gain: 0, attack: 0.012, release: 0.35));
    make.value(\chords, \noteseq, (base: 48, division: 0.25, length: 4, gateLength: 0.9));
    make.value(\pad, \polysynth, (wave: 3, gain: 0.15, attack: 0.25, release: 1.7));
    make.value(\ground, \noteseq, (base: 36, division: 1, length: 8, gateLength: 0.7));
    make.value(\bass, \polysynth, (wave: 0, gain: 0, attack: 0.012, release: 0.24));
    make.value(\rhythm, \euclid, (steps: 16, pulses: 5, division: 4));
    make.value(\wood, \pluck, (freq: 98, auto: 0, decay: 0.15, gain: 0));
    make.value(\cloud, \granular, (density: 18, size: 0.1, scan: 0.018, pitchScatter: 0, gain: 0.025));
    make.value(\spectral, \spectral, (smear: 6, mix: 0.6));
    make.value(\mix, \mixer, (gain0: 0.65, gain1: 0.6, gain2: 0.65, gain3: 0.45, pan0: -0.25, pan1: 0.2));
    make.value(\tone, \filter, (cutoff: 1400, resonance: 0.24));
    make.value(\echo, \delay, (sync: 1, division: 0.75, feedback: 0.4, mix: 0.24));
    make.value(\room, \reverb, (mix: 0.3, size: 0.92, shimmer: 0));
    make.value(\display, \scope, (mode: 1));
    make.value(\recorder, \recorder, ());
    make.value(\score, \note, ());
    nodes[\score][\text] = "50 / A Field of Returning Stars\nA one-minute miniature with six composed moments\nSeed -> Constellation -> Cross-currents -> Stillpoint -> Return -> Coda\nStop examples / PANIC ends this score.";

    // The bundled voice recording makes this study portable without a download.
    v[\loadSound].value(nodes[\cloud], Platform.resourceDir +/+ "sounds/a11wlk01.wav", false);

    // MUSICAL MATERIAL / [] is a rest; a nested array is a chord.
    phrase.value(\line, (notes: [[0], [2], [4], [], [5], [4], [2], [1], [0], [], [3], [2], [1], [0], [], []], degrees: true, velocity: [92, 60, 77, 55, 83, 65, 69, 56, 80, 50, 73, 61, 55, 65, 50, 50]));
    phrase.value(\answerLine, (notes: [[4], [6], [7], [5], [4], [2], [1]], degrees: true, velocity: [78, 54, 68, 57, 72, 53, 61]));
    phrase.value(\chords, (notes: [[0, 2, 4, 6], [3, 5, 7, 9], [5, 7, 9, 11], [4, 6, 8, 10]], degrees: true, velocity: [62, 55, 60, 53]));
    phrase.value(\ground, (notes: [[0], [], [4], [0], [3], [], [4], [-1]], degrees: true));

    // ROUTING / audio and note cables use wire; knob modulation uses mod.
    wire.value(\line, \lead, 0, 1);
    wire.value(\answerLine, \answer, 0, 1);
    wire.value(\chords, \pad, 0, 1);
    wire.value(\ground, \bass, 0, 1);
    wire.value(\rhythm, \wood, 0, 1);
    wire.value(\cloud, \spectral, 0, 1);
    wire.value(\lead, \mix, 0, 1);
    wire.value(\answer, \mix, 0, 1);
    wire.value(\pad, \mix, 1, 1);
    wire.value(\bass, \mix, 2, 1);
    wire.value(\wood, \mix, 3, 1);
    wire.value(\spectral, \mix, 3, 1);
    wire.value(\mix, \tone, 0, 1);
    wire.value(\tone, \echo, 0, 1);
    wire.value(\echo, \room, 0, 1);
    wire.value(\room, \display, 0, 1);
    wire.value(\display, \output, 0, 1);

    context = v[\trackHelpExample].value(nodes,nodes[\line],"50 / A Field of Returning Stars");
    context[\lessonNumber] = 50; context[\scoreBeats] = 80; context[\tailBeats] = 8;
    alive = {v[\helpExampleAlive].value(context)};

    // FORM / every wait is measured in beats on VOID's shared note clock.
    performance = Routine({
        if(alive.value) {
            context[\section] = 0;
            v[\message].value("50 / A Field of Returning Stars - Seed");
            8.wait;
        };
        if(alive.value) {
            context[\section] = 1;
            v[\message].value("50 / A Field of Returning Stars - Constellation");
            v[\setParam].value(nodes[\lead], \gain, 0.26);
            v[\setParam].value(nodes[\bass], \gain, 0.25);
            v[\setParam].value(nodes[\wood], \gain, 0.13);
            v[\setParam].value(nodes[\tone], \cutoff, 2800);
            16.wait;
        };
        if(alive.value) {
            context[\section] = 2;
            v[\message].value("50 / A Field of Returning Stars - Cross-currents");
            v[\setParam].value(nodes[\answer], \gain, 0.2);
            v[\setParam].value(nodes[\rhythm], \pulses, 7);
            v[\setParam].value(nodes[\tone], \cutoff, 3800);
            16.wait;
        };
        if(alive.value) {
            context[\section] = 3;
            v[\message].value("50 / A Field of Returning Stars - Stillpoint");
            v[\setParam].value(nodes[\lead], \gain, 0);
            v[\setParam].value(nodes[\answer], \gain, 0);
            v[\setParam].value(nodes[\bass], \gain, 0);
            v[\setParam].value(nodes[\wood], \gain, 0);
            v[\setParam].value(nodes[\cloud], \gain, 0.075);
            v[\setParam].value(nodes[\spectral], \freeze, 1);
            v[\setParam].value(nodes[\pad], \gain, 0.12);
            16.wait;
        };
        if(alive.value) {
            context[\section] = 4;
            v[\message].value("50 / A Field of Returning Stars - Return");
            v[\setParam].value(nodes[\lead], \gain, 0.23);
            v[\setParam].value(nodes[\answer], \gain, 0.09);
            v[\setParam].value(nodes[\bass], \gain, 0.22);
            v[\setParam].value(nodes[\wood], \gain, 0.1);
            v[\setParam].value(nodes[\cloud], \gain, 0.025);
            v[\setParam].value(nodes[\spectral], \freeze, 0);
            v[\setParam].value(nodes[\rhythm], \pulses, 5);
            v[\setParam].value(nodes[\tone], \cutoff, 2200);
            16.wait;
        };
        if(alive.value) {
            context[\section] = 5;
            v[\message].value("50 / A Field of Returning Stars - Coda");
            phrase.value(\line, (notes: [[0], [], [2], [], [4], [], [2], [], [0], [], [], [], [], [], [], []], degrees: true));
            v[\setParam].value(nodes[\answer], \gain, 0);
            v[\setParam].value(nodes[\bass], \gain, 0.12);
            v[\setParam].value(nodes[\wood], \gain, 0);
            v[\setParam].value(nodes[\cloud], \gain, 0.012);
            v[\setParam].value(nodes[\lead], \gain, 0.17);
            8.wait;
        };
        if(alive.value) {
            // Release notes first. Stop new excitations while the effects ring.
            context[\owned].do { |node|
                if(node[\type]==\noteseq){v[\stopSequence].value(node)};
                if(node[\type]==\midiin){v[\stopMusicNode].value(node); node[\active]=false};
                if([\clock,\euclid,\sequencer].includes(node[\type])) {
                    node[\active]=false; if(node[\synth].notNil){node[\synth].set(\active,0)};
                };
                if([\osc,\fm,\noise,\drone,\player,\granular,\mic].includes(node[\type])){v[\setParam].value(node,\gain,0)};
                if(node[\type]==\pluck){v[\setParam].value(node,\auto,0)};
            };
            8.wait; context[\finished] = true;
        };
        // This also handles deleting a study node while the score is running.
        v[\stopHelpExample].value(context);
        if(context[\finished]==true){v[\message].value("50 / A Field of Returning Stars finished.")};
    }).play(v[\noteClock],quant:1);
    context[\routines].add(performance);

    // The conductor is queued first, then the note parts share the next beat.
    v[\startSequence].value(nodes[\line]);
    v[\startSequence].value(nodes[\answerLine]);
    v[\startSequence].value(nodes[\chords]);
    v[\startSequence].value(nodes[\ground]);

    v[\selection] = context[\owned].collect(_[\id]).asSet; v[\fit].value;
    v[\message].value("50 / A Field of Returning Stars: Audio ON to listen; Stop examples / PANIC to stop.");
} {
    "Evaluate the current VOID.scd and wait for audio to be ready, then run this study.".postln;
};
)
