/*
VOID STUDY 49 / Open Stage

LEARN
Live MIDI alongside a written accompaniment.

COMPOSER'S NOTE
The accompaniment has its own form; a separate live instrument leaves space for a performer. Optional MIDI OUT can double the written line.

SCORE
88 BPM; global scale Minor; root 0 semitones above C.
64 beats of material + 4 beats of tail; about 46.4 seconds.
Form: Accompaniment (16 beats) / Space for a solo (24 beats) / Gather the ensemble (16 beats) / A final open chord (8 beats).
Hz parameters and MIDI-mode patterns keep their literal pitches.

PLAY
Evaluate the current VOID.scd first. Evaluate this entire parenthesized block.
Audio ON makes the patch audible. It adds its own selected nodes to the canvas.
Use Stop examples or ~void[\stopHelpExamples].value to stop early.
Undo removes the last build; saved patches retain nodes/patterns, while this file runs the written form.
This study sets the shared tempo/root/tuning and stops earlier help-built examples.
Recording and external MIDI output require your own device/button choices.

TRY
1. Choose a MIDI input and improvise during the open section.
2. Assign MIDI OUT to an MPE receiver and change the global tuning.
3. Raise MIC IN from zero only when you want to add a live audio source.
*/
(

var v, origin, nodes, context, make, wire, mod, phrase, alive, performance, scaleIndex;
v = ~void;
if(v.notNil and: {v[\ready]} and: {v[\trackHelpExample].notNil}) {
    scaleIndex = v[\scaleNames].indexOfEqual("Minor");
    if(scaleIndex.isNil) {Error("This VOID installation is missing the study tuning.").throw};
    v[\checkpoint].value;
    v[\stopHelpExamples].value;
    v[\bpm] = 88; v[\root] = 0; v[\scaleMode] = 0;
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
    make.value(\changes, \noteseq, (base: 48, division: 0.25, length: 4, gateLength: 0.9));
    make.value(\chords, \polysynth, (wave: 3, gain: 0.24, attack: 0.15, release: 1.3));
    make.value(\ground, \noteseq, (base: 36, division: 1, length: 8, gateLength: 0.7));
    make.value(\bass, \polysynth, (wave: 0, gain: 0.28, attack: 0.012, release: 0.25));
    make.value(\midi, \midiin, ());
    make.value(\live, \polysynth, (wave: 4, gain: 0.3, release: 0.65));
    make.value(\out, \midiout, ());
    make.value(\mic, \mic, (gain: 0));
    make.value(\mix, \mixer, (gain0: 0.65, gain1: 0.7, gain2: 0.7, gain3: 0.4, pan2: 0.25));
    make.value(\room, \reverb, (mix: 0.28, size: 0.8, shimmer: 0));
    make.value(\score, \note, ());
    nodes[\score][\text] = "49 / Open Stage\nLive MIDI alongside a written accompaniment\nAccompaniment -> Space for a solo -> Gather the ensemble -> A final open chord\nStop examples / PANIC ends this score.";

    // Device choices remain unassigned; configure them in the node inspector.
    v[\restoreMusic].value(nodes[\midi], (inputMapping: 2));
    v[\restoreMusic].value(nodes[\out], (mpe: true, bendRange: 48));

    // MUSICAL MATERIAL / [] is a rest; a nested array is a chord.
    phrase.value(\changes, (notes: [[0, 2, 4, 6], [3, 5, 7, 9], [5, 7, 9, 11], [4, 6, 8, 10]], degrees: true, velocity: [65, 58, 64, 55]));
    phrase.value(\ground, (notes: [[0], [], [0], [4], [3], [], [4], [-1]], degrees: true));

    // ROUTING / audio and note cables use wire; knob modulation uses mod.
    wire.value(\changes, \chords, 0, 1);
    wire.value(\ground, \bass, 0, 1);
    wire.value(\midi, \live, 0, 1);
    wire.value(\changes, \out, 0, 1);
    wire.value(\chords, \mix, 0, 1);
    wire.value(\bass, \mix, 1, 1);
    wire.value(\live, \mix, 2, 1);
    wire.value(\mic, \mix, 3, 1);
    wire.value(\mix, \room, 0, 1);
    wire.value(\room, \output, 0, 1);

    context = v[\trackHelpExample].value(nodes,nodes[\changes],"49 / Open Stage");
    context[\lessonNumber] = 49; context[\scoreBeats] = 64; context[\tailBeats] = 4;
    alive = {v[\helpExampleAlive].value(context)};

    // FORM / every wait is measured in beats on VOID's shared note clock.
    performance = Routine({
        if(alive.value) {
            context[\section] = 0;
            v[\message].value("49 / Open Stage - Accompaniment");
            16.wait;
        };
        if(alive.value) {
            context[\section] = 1;
            v[\message].value("49 / Open Stage - Space for a solo");
            v[\setParam].value(nodes[\chords], \gain, 0.17);
            v[\setParam].value(nodes[\bass], \gain, 0.23);
            24.wait;
        };
        if(alive.value) {
            context[\section] = 2;
            v[\message].value("49 / Open Stage - Gather the ensemble");
            v[\setParam].value(nodes[\chords], \gain, 0.24);
            v[\setParam].value(nodes[\bass], \gain, 0.28);
            16.wait;
        };
        if(alive.value) {
            context[\section] = 3;
            v[\message].value("49 / Open Stage - A final open chord");
            phrase.value(\changes, (notes: [[0, 2, 4, 6]], degrees: true));
            v[\setParam].value(nodes[\ground], \length, 1);
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
            4.wait; context[\finished] = true;
        };
        // This also handles deleting a study node while the score is running.
        v[\stopHelpExample].value(context);
        if(context[\finished]==true){v[\message].value("49 / Open Stage finished.")};
    }).play(v[\noteClock],quant:1);
    context[\routines].add(performance);

    // The conductor is queued first, then the note parts share the next beat.
    v[\startSequence].value(nodes[\changes]);
    v[\startSequence].value(nodes[\ground]);

    v[\selection] = context[\owned].collect(_[\id]).asSet; v[\fit].value;
    v[\message].value("49 / Open Stage: Audio ON to listen; Stop examples / PANIC to stop.");
} {
    "Evaluate the current VOID.scd and wait for audio to be ready, then run this study.".postln;
};
)
