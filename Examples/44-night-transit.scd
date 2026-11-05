/*
VOID STUDY 44 / Night Transit

LEARN
Groove, interruption and a recognisable return.

COMPOSER'S NOTE
A syncopated bass and clipped upper notes establish a moving scene. The break retains only the harmonic light.

SCORE
116 BPM; global scale Minor; root 0 semitones above C.
64 beats of material + 4 beats of tail; about 35.2 seconds.
Form: Departure (16 beats) / City in motion (16 beats) / Lights through the window (16 beats) / Arrival (16 beats).
Hz parameters and MIDI-mode patterns keep their literal pitches.

PLAY
Evaluate the current VOID.scd first. Evaluate this entire parenthesized block.
Audio ON makes the patch audible. It adds its own selected nodes to the canvas.
Use Stop examples or ~void[\stopHelpExamples].value to stop early.
Undo removes the last build; saved patches retain nodes/patterns, while this file runs the written form.
This study sets the shared tempo/root/tuning and stops earlier help-built examples.
Recording and external MIDI output require your own device/button choices.

TRY
1. Leave one percussion voice through the break.
2. Restore the bass one phrase before the melody.
3. Change the return by octave placement instead of adding notes.
*/
(

var v, origin, nodes, context, make, wire, mod, phrase, alive, performance, scaleIndex;
v = ~void;
if(v.notNil and: {v[\ready]} and: {v[\trackHelpExample].notNil}) {
    scaleIndex = v[\scaleNames].indexOfEqual("Minor");
    if(scaleIndex.isNil) {Error("This VOID installation is missing the study tuning.").throw};
    v[\checkpoint].value;
    v[\stopHelpExamples].value;
    v[\bpm] = 116; v[\root] = 0; v[\scaleMode] = 0;
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
    make.value(\ground, \noteseq, (base: 36, division: 4, length: 16, gateLength: 0.4));
    make.value(\bass, \polysynth, (wave: 0, gain: 0.3, attack: 0.012, release: 0.14));
    make.value(\line, \noteseq, (base: 72, division: 2, length: 16, gateLength: 0.7));
    make.value(\lead, \polysynth, (wave: 4, gain: 0.22, attack: 0.012, release: 0.2));
    make.value(\chords, \noteseq, (base: 48, division: 0.25, length: 4, gateLength: 0.9));
    make.value(\pad, \polysynth, (wave: 3, gain: 0.18, attack: 0.2, release: 1.4));
    make.value(\beat, \euclid, (steps: 16, pulses: 5, division: 4));
    make.value(\wood, \pluck, (freq: 98, auto: 0, decay: 0.12, gain: 0.14));
    make.value(\mix, \mixer, (gain0: 0.7, gain1: 0.65, gain2: 0.65, gain3: 0.55));
    make.value(\tone, \filter, (cutoff: 2400));
    make.value(\echo, \delay, (sync: 1, division: 0.75, feedback: 0.33, mix: 0.22));
    make.value(\room, \reverb, (mix: 0.2, size: 0.8, shimmer: 0));
    make.value(\score, \note, ());
    nodes[\score][\text] = "44 / Night Transit\nGroove, interruption and a recognisable return\nDeparture -> City in motion -> Lights through the window -> Arrival\nStop examples / PANIC ends this score.";

    // MUSICAL MATERIAL / [] is a rest; a nested array is a chord.
    phrase.value(\ground, (notes: [[0], [], [0], [4], [], [0], [3], [], [0], [], [4], [], [3], [2], [], [4]], degrees: true, velocity: [100, 50, 61, 75, 50, 80, 65, 50, 91, 50, 73, 50, 81, 60, 50, 66]));
    phrase.value(\line, (notes: [[4], [], [7], [6], [], [4], [2], [], [5], [], [4], [2], [], [1], [0], []], degrees: true));
    phrase.value(\chords, (notes: [[0, 2, 4], [3, 5, 7], [5, 7, 9], [4, 6, 8]], degrees: true));

    // ROUTING / audio and note cables use wire; knob modulation uses mod.
    wire.value(\ground, \bass, 0, 1);
    wire.value(\line, \lead, 0, 1);
    wire.value(\chords, \pad, 0, 1);
    wire.value(\beat, \wood, 0, 1);
    wire.value(\bass, \mix, 0, 1);
    wire.value(\lead, \mix, 1, 1);
    wire.value(\pad, \mix, 2, 1);
    wire.value(\wood, \mix, 3, 1);
    wire.value(\mix, \tone, 0, 1);
    wire.value(\tone, \echo, 0, 1);
    wire.value(\echo, \room, 0, 1);
    wire.value(\room, \output, 0, 1);

    context = v[\trackHelpExample].value(nodes,nodes[\ground],"44 / Night Transit");
    context[\lessonNumber] = 44; context[\scoreBeats] = 64; context[\tailBeats] = 4;
    alive = {v[\helpExampleAlive].value(context)};

    // FORM / every wait is measured in beats on VOID's shared note clock.
    performance = Routine({
        if(alive.value) {
            context[\section] = 0;
            v[\message].value("44 / Night Transit - Departure");
            16.wait;
        };
        if(alive.value) {
            context[\section] = 1;
            v[\message].value("44 / Night Transit - City in motion");
            v[\setParam].value(nodes[\tone], \cutoff, 4200);
            v[\setParam].value(nodes[\beat], \pulses, 9);
            16.wait;
        };
        if(alive.value) {
            context[\section] = 2;
            v[\message].value("44 / Night Transit - Lights through the window");
            v[\setParam].value(nodes[\bass], \gain, 0);
            v[\setParam].value(nodes[\lead], \gain, 0);
            v[\setParam].value(nodes[\wood], \gain, 0);
            v[\setParam].value(nodes[\tone], \cutoff, 1300);
            16.wait;
        };
        if(alive.value) {
            context[\section] = 3;
            v[\message].value("44 / Night Transit - Arrival");
            v[\setParam].value(nodes[\bass], \gain, 0.3);
            v[\setParam].value(nodes[\lead], \gain, 0.2);
            v[\setParam].value(nodes[\wood], \gain, 0.12);
            v[\setParam].value(nodes[\beat], \pulses, 5);
            v[\setParam].value(nodes[\tone], \cutoff, 2600);
            16.wait;
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
            4.wait; context[\finished] = true;
        };
        // This also handles deleting a study node while the score is running.
        v[\stopHelpExample].value(context);
        if(context[\finished]==true){v[\message].value("44 / Night Transit finished.")};
    }).play(v[\noteClock],quant:1);
    context[\routines].add(performance);

    // The conductor is queued first, then the note parts share the next beat.
    v[\startSequence].value(nodes[\ground]);
    v[\startSequence].value(nodes[\line]);
    v[\startSequence].value(nodes[\chords]);

    v[\selection] = context[\owned].collect(_[\id]).asSet; v[\fit].value;
    v[\message].value("44 / Night Transit: Audio ON to listen; Stop examples / PANIC to stop.");
} {
    "Evaluate the current VOID.scd and wait for audio to be ready, then run this study.".postln;
};
)
