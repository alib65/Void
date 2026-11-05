/*
VOID STUDY 40 / Nearly Still

LEARN
Nine-cent-scale detail in 127 EDO.

COMPOSER'S NOTE
Degrees 42 and 43 are close enough to become a change of surface against the sustained chord.

SCORE
60 BPM; global scale 127 EDO; root 0 semitones above C.
48 beats of material + 4 beats of tail; about 52 seconds.
Form: Fine surfaces (32 beats) / A quieter return (16 beats).
Hz parameters and MIDI-mode patterns keep their literal pitches.

PLAY
Evaluate the current VOID.scd first. Evaluate this entire parenthesized block.
Audio ON makes the patch audible. It adds its own selected nodes to the canvas.
Use Stop examples or ~void[\stopHelpExamples].value to stop early.
Undo removes the last build; saved patches retain nodes/patterns, while this file runs the written form.
This study sets the shared tempo/root/tuning and stops earlier help-built examples.
Recording and external MIDI output require your own device/button choices.

TRY
1. Compare 42 with 44 against the held pitch.
2. Lengthen the quiet approach to degree 74.
3. Use scale-degree keyboard mapping for a live response.
*/
(

var v, origin, nodes, context, make, wire, mod, phrase, alive, performance, scaleIndex;
v = ~void;
if(v.notNil and: {v[\ready]} and: {v[\trackHelpExample].notNil}) {
    scaleIndex = v[\scaleNames].indexOfEqual("127 EDO");
    if(scaleIndex.isNil) {Error("This VOID installation is missing the study tuning.").throw};
    v[\checkpoint].value;
    v[\stopHelpExamples].value;
    v[\bpm] = 60; v[\root] = 0; v[\scaleMode] = 0;
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
    make.value(\lead, \polysynth, (wave: 0, gain: 0.2, attack: 0.012, release: 0.8));
    make.value(\changes, \noteseq, (base: 60, division: 0.25, length: 1, gateLength: 0.95));
    make.value(\chords, \polysynth, (wave: 0, gain: 0.17, attack: 0.3, release: 2));
    make.value(\room, \reverb, (mix: 0.15, size: 0.8, shimmer: 0));
    make.value(\score, \note, ());
    nodes[\score][\text] = "40 / Nearly Still\nNine-cent-scale detail in 127 EDO\nFine surfaces -> A quieter return\nStop examples / PANIC ends this score.";

    // MUSICAL MATERIAL / [] is a rest; a nested array is a chord.
    phrase.value(\line, (notes: [[42], [43], [42], [41], [42], [], [74], [73], [74], [75], [74], [], [21], [42], [0], []], degrees: true, velocity: [77, 48, 63, 47, 60, 50, 70, 46, 61, 48, 59, 50, 55, 61, 65, 50]));
    phrase.value(\changes, (notes: [[0, 42, 74]], degrees: true, duration: [2]));

    // ROUTING / audio and note cables use wire; knob modulation uses mod.
    wire.value(\line, \lead, 0, 1);
    wire.value(\changes, \chords, 0, 1);
    wire.value(\lead, \room, 0, 1);
    wire.value(\chords, \room, 0, 1);
    wire.value(\room, \output, 0, 1);

    context = v[\trackHelpExample].value(nodes,nodes[\line],"40 / Nearly Still");
    context[\lessonNumber] = 40; context[\scoreBeats] = 48; context[\tailBeats] = 4;
    alive = {v[\helpExampleAlive].value(context)};

    // FORM / every wait is measured in beats on VOID's shared note clock.
    performance = Routine({
        if(alive.value) {
            context[\section] = 0;
            v[\message].value("40 / Nearly Still - Fine surfaces");
            32.wait;
        };
        if(alive.value) {
            context[\section] = 1;
            v[\message].value("40 / Nearly Still - A quieter return");
            v[\setParam].value(nodes[\lead], \gain, 0.14);
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
        if(context[\finished]==true){v[\message].value("40 / Nearly Still finished.")};
    }).play(v[\noteClock],quant:1);
    context[\routines].add(performance);

    // The conductor is queued first, then the note parts share the next beat.
    v[\startSequence].value(nodes[\line]);
    v[\startSequence].value(nodes[\changes]);

    v[\selection] = context[\owned].collect(_[\id]).asSet; v[\fit].value;
    v[\message].value("40 / Nearly Still: Audio ON to listen; Stop examples / PANIC to stop.");
} {
    "Evaluate the current VOID.scd and wait for audio to be ready, then run this study.".postln;
};
)
