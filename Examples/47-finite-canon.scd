/*
VOID STUDY 47 / Finite Canon

LEARN
Staggered entries, transposition and contrary motion.

COMPOSER'S NOTE
Four voices enter two beats apart. The texture grows from a single subject, then leaves in the opposite order.

SCORE
94 BPM; global scale Minor; root 0 semitones above C.
40 beats of material + 4 beats of tail; about 28.1 seconds.
Form: First voice (2 beats) / Second voice (2 beats) / Contrary voice (2 beats) / Upper voice (18 beats) / Upper voice departs (4 beats) / Contrary voice departs (4 beats) / Second voice departs (4 beats) / One voice remains (4 beats).
Hz parameters and MIDI-mode patterns keep their literal pitches.

PLAY
Evaluate the current VOID.scd first. Evaluate this entire parenthesized block.
Audio ON makes the patch audible. It adds its own selected nodes to the canvas.
Use Stop examples or ~void[\stopHelpExamples].value to stop early.
Undo removes the last build; saved patches retain nodes/patterns, while this file runs the written form.
This study sets the shared tempo/root/tuning and stops earlier help-built examples.
Recording and external MIDI output require your own device/button choices.

TRY
1. Set every transposition to zero.
2. Replace the inverted line with an exact copy.
3. Change the entry distance from two to three beats.
*/
(

var v, origin, nodes, context, make, wire, mod, phrase, alive, performance, scaleIndex;
v = ~void;
if(v.notNil and: {v[\ready]} and: {v[\trackHelpExample].notNil}) {
    scaleIndex = v[\scaleNames].indexOfEqual("Minor");
    if(scaleIndex.isNil) {Error("This VOID installation is missing the study tuning.").throw};
    v[\checkpoint].value;
    v[\stopHelpExamples].value;
    v[\bpm] = 94; v[\root] = 0; v[\scaleMode] = 0;
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
    make.value(\a, \noteseq, (base: 60, division: 2, length: 8, gateLength: 0.7));
    make.value(\aVoice, \polysynth, (wave: 0, gain: 0.23, attack: 0.012, release: 0.3));
    make.value(\b, \noteseq, (base: 60, division: 2, length: 8, gateLength: 0.7));
    make.value(\bVoice, \polysynth, (wave: 3, gain: 0.2, attack: 0.012, release: 0.3));
    make.value(\c, \noteseq, (base: 60, division: 2, length: 8, gateLength: 0.7));
    make.value(\cVoice, \polysynth, (wave: 0, gain: 0.19, attack: 0.012, release: 0.3));
    make.value(\d, \noteseq, (base: 72, division: 2, length: 8, gateLength: 0.7));
    make.value(\dVoice, \polysynth, (wave: 3, gain: 0.16, attack: 0.012, release: 0.3));
    make.value(\left, \pan, (pan: -0.65));
    make.value(\right, \pan, (pan: 0.65));
    make.value(\room, \reverb, (mix: 0.24, size: 0.8, shimmer: 0));
    make.value(\score, \note, ());
    nodes[\score][\text] = "47 / Finite Canon\nStaggered entries, transposition and contrary motion\nFirst voice -> Second voice -> Contrary voice -> Upper voice -> Upper voice departs -> Contrary voice departs -> Second voice departs -> One voice remains\nStop examples / PANIC ends this score.";

    // MUSICAL MATERIAL / [] is a rest; a nested array is a chord.
    phrase.value(\a, (notes: [[0], [2], [4], [5], [4], [2], [1], [0]], degrees: true));
    phrase.value(\b, (notes: [[-2], [0], [2], [3], [2], [0], [-1], [-2]], degrees: true));
    phrase.value(\c, (notes: [[4], [2], [0], [-1], [0], [2], [3], [4]], degrees: true));
    phrase.value(\d, (notes: [[0], [2], [4], [5], [4], [2], [1], [0]], degrees: true));

    // ROUTING / audio and note cables use wire; knob modulation uses mod.
    wire.value(\a, \aVoice, 0, 1);
    wire.value(\b, \bVoice, 0, 1);
    wire.value(\c, \cVoice, 0, 1);
    wire.value(\d, \dVoice, 0, 1);
    wire.value(\aVoice, \left, 0, 1);
    wire.value(\cVoice, \left, 0, 1);
    wire.value(\bVoice, \right, 0, 1);
    wire.value(\dVoice, \right, 0, 1);
    wire.value(\left, \room, 0, 1);
    wire.value(\right, \room, 0, 1);
    wire.value(\room, \output, 0, 1);

    context = v[\trackHelpExample].value(nodes,nodes[\a],"47 / Finite Canon");
    context[\lessonNumber] = 47; context[\scoreBeats] = 40; context[\tailBeats] = 4;
    alive = {v[\helpExampleAlive].value(context)};

    // FORM / every wait is measured in beats on VOID's shared note clock.
    performance = Routine({
        if(alive.value) {
            context[\section] = 0;
            v[\message].value("47 / Finite Canon - First voice");
            v[\startSequence].value(nodes[\a]);
            2.wait;
        };
        if(alive.value) {
            context[\section] = 1;
            v[\message].value("47 / Finite Canon - Second voice");
            v[\startSequence].value(nodes[\b]);
            2.wait;
        };
        if(alive.value) {
            context[\section] = 2;
            v[\message].value("47 / Finite Canon - Contrary voice");
            v[\startSequence].value(nodes[\c]);
            2.wait;
        };
        if(alive.value) {
            context[\section] = 3;
            v[\message].value("47 / Finite Canon - Upper voice");
            v[\startSequence].value(nodes[\d]);
            18.wait;
        };
        if(alive.value) {
            context[\section] = 4;
            v[\message].value("47 / Finite Canon - Upper voice departs");
            v[\stopSequence].value(nodes[\d]);
            4.wait;
        };
        if(alive.value) {
            context[\section] = 5;
            v[\message].value("47 / Finite Canon - Contrary voice departs");
            v[\stopSequence].value(nodes[\c]);
            4.wait;
        };
        if(alive.value) {
            context[\section] = 6;
            v[\message].value("47 / Finite Canon - Second voice departs");
            v[\stopSequence].value(nodes[\b]);
            4.wait;
        };
        if(alive.value) {
            context[\section] = 7;
            v[\message].value("47 / Finite Canon - One voice remains");
            4.wait;
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
        if(context[\finished]==true){v[\message].value("47 / Finite Canon finished.")};
    }).play(v[\noteClock],quant:1);
    context[\routines].add(performance);

    v[\selection] = context[\owned].collect(_[\id]).asSet; v[\fit].value;
    v[\message].value("47 / Finite Canon: Audio ON to listen; Stop examples / PANIC to stop.");
} {
    "Evaluate the current VOID.scd and wait for audio to be ready, then run this study.".postln;
};
)
