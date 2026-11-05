/*
VOID STUDY 42 / Tritave Orbits

LEARN
A repeating period with frequency ratio 3 to 1.

COMPOSER'S NOTE
Thirteen degrees complete the period. The upper line crosses that boundary while the lower part keeps an unchanging reference.

SCORE
76 BPM; global scale Bohlen-Pierce (bp); root 0 semitones above C.
32 beats of material + 4 beats of tail; about 28.4 seconds.
Form: Study (32 beats).
Hz parameters and MIDI-mode patterns keep their literal pitches.

PLAY
Evaluate the current VOID.scd first. Evaluate this entire parenthesized block.
Audio ON makes the patch audible. It adds its own selected nodes to the canvas.
Use Stop examples or ~void[\stopHelpExamples].value to stop early.
Undo removes the last build; saved patches retain nodes/patterns, while this file runs the written form.
This study sets the shared tempo/root/tuning and stops earlier help-built examples.
Recording and external MIDI output require your own device/button choices.

TRY
1. Compare degrees 0 and 13 in the same register.
2. Replace the chord with single notes before adding intervals.
3. Write a phrase that closes at degree 13.
*/
(

var v, origin, nodes, context, make, wire, mod, phrase, alive, performance, scaleIndex;
v = ~void;
if(v.notNil and: {v[\ready]} and: {v[\trackHelpExample].notNil}) {
    scaleIndex = v[\scaleNames].indexOfEqual("Bohlen-Pierce (bp)");
    if(scaleIndex.isNil) {Error("This VOID installation is missing the study tuning.").throw};
    v[\checkpoint].value;
    v[\stopHelpExamples].value;
    v[\bpm] = 76; v[\root] = 0; v[\scaleMode] = 0;
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
    make.value(\line, \noteseq, (base: 45, division: 2, length: 16, gateLength: 0.7));
    make.value(\lead, \polysynth, (wave: 0, gain: 0.24, attack: 0.012, release: 0.5));
    make.value(\changes, \noteseq, (base: 33, division: 0.25, length: 4, gateLength: 0.9));
    make.value(\chords, \polysynth, (wave: 0, gain: 0.19, attack: 0.15, release: 1.3));
    make.value(\room, \reverb, (mix: 0.27, size: 0.8, shimmer: 0));
    make.value(\score, \note, ());
    nodes[\score][\text] = "42 / Tritave Orbits\nA repeating period with frequency ratio 3 to 1\nStudy\nStop examples / PANIC ends this score.";

    // MUSICAL MATERIAL / [] is a rest; a nested array is a chord.
    phrase.value(\line, (notes: [[0], [2], [4], [7], [9], [7], [4], [2], [0], [4], [7], [9], [11], [13], [9], [0]], degrees: true));
    phrase.value(\changes, (notes: [[0, 4, 7], [2, 6, 9], [4, 7, 11], [0, 4, 7]], degrees: true));

    // ROUTING / audio and note cables use wire; knob modulation uses mod.
    wire.value(\line, \lead, 0, 1);
    wire.value(\changes, \chords, 0, 1);
    wire.value(\lead, \room, 0, 1);
    wire.value(\chords, \room, 0, 1);
    wire.value(\room, \output, 0, 1);

    context = v[\trackHelpExample].value(nodes,nodes[\line],"42 / Tritave Orbits");
    context[\lessonNumber] = 42; context[\scoreBeats] = 32; context[\tailBeats] = 4;
    alive = {v[\helpExampleAlive].value(context)};

    // FORM / every wait is measured in beats on VOID's shared note clock.
    performance = Routine({
        if(alive.value) {
            context[\section] = 0;
            v[\message].value("42 / Tritave Orbits - Study");
            32.wait;
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
        if(context[\finished]==true){v[\message].value("42 / Tritave Orbits finished.")};
    }).play(v[\noteClock],quant:1);
    context[\routines].add(performance);

    // The conductor is queued first, then the note parts share the next beat.
    v[\startSequence].value(nodes[\line]);
    v[\startSequence].value(nodes[\changes]);

    v[\selection] = context[\owned].collect(_[\id]).asSet; v[\fit].value;
    v[\message].value("42 / Tritave Orbits: Audio ON to listen; Stop examples / PANIC to stop.");
} {
    "Evaluate the current VOID.scd and wait for audio to be ready, then run this study.".postln;
};
)
