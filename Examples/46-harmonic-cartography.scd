/*
VOID STUDY 46 / Harmonic Cartography

LEARN
Large-scale form through parallel modes.

COMPOSER'S NOTE
The same harmonic objects cross five different lights. The bass tonic remains a landmark while the upper intervals change.

SCORE
82 BPM; global scale Major; root 2 semitones above C.
80 beats of material + 8 beats of tail; about 64.4 seconds.
Form: Home (16 beats) / A darker river (16 beats) / An open fourth (16 beats) / The lowered seventh (16 beats) / Home reconsidered (16 beats).
Hz parameters and MIDI-mode patterns keep their literal pitches.

PLAY
Evaluate the current VOID.scd first. Evaluate this entire parenthesized block.
Audio ON makes the patch audible. It adds its own selected nodes to the canvas.
Use Stop examples or ~void[\stopHelpExamples].value to stop early.
Undo removes the last build; saved patches retain nodes/patterns, while this file runs the written form.
This study sets the shared tempo/root/tuning and stops earlier help-built examples.
Recording and external MIDI output require your own device/button choices.

TRY
1. Move Root only in the final section.
2. Keep the mode fixed and change the chord spacing instead.
3. Remove the pedal and hear how the harmony loses its landmark.
*/
(

var v, origin, nodes, context, make, wire, mod, phrase, alive, performance, scaleIndex;
v = ~void;
if(v.notNil and: {v[\ready]} and: {v[\trackHelpExample].notNil}) {
    scaleIndex = v[\scaleNames].indexOfEqual("Major");
    if(scaleIndex.isNil) {Error("This VOID installation is missing the study tuning.").throw};
    v[\checkpoint].value;
    v[\stopHelpExamples].value;
    v[\bpm] = 82; v[\root] = 2; v[\scaleMode] = 0;
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
    make.value(\chords, \polysynth, (wave: 3, gain: 0.25, attack: 0.2, release: 1.5));
    make.value(\line, \noteseq, (base: 72, division: 2, length: 16, gateLength: 0.7));
    make.value(\lead, \polysynth, (wave: 0, gain: 0.22, attack: 0.012, release: 0.55));
    make.value(\pedalLine, \noteseq, (base: 36, division: 0.25, length: 1, gateLength: 0.95));
    make.value(\pedal, \polysynth, (wave: 0, gain: 0.17, attack: 0.012, release: 1));
    make.value(\tone, \filter, (cutoff: 2500));
    make.value(\room, \reverb, (mix: 0.3, size: 0.8, shimmer: 0));
    make.value(\score, \note, ());
    nodes[\score][\text] = "46 / Harmonic Cartography\nLarge-scale form through parallel modes\nHome -> A darker river -> An open fourth -> The lowered seventh -> Home reconsidered\nStop examples / PANIC ends this score.";

    // MUSICAL MATERIAL / [] is a rest; a nested array is a chord.
    phrase.value(\changes, (notes: [[0, 2, 4, 6], [3, 5, 7, 9], [1, 3, 5, 7], [4, 6, 8, 10]], degrees: true));
    phrase.value(\line, (notes: [[0], [2], [3], [5], [4], [3], [2], [], [4], [5], [6], [4], [3], [2], [0], []], degrees: true));
    phrase.value(\pedalLine, (notes: [[0]], degrees: true));

    // ROUTING / audio and note cables use wire; knob modulation uses mod.
    wire.value(\changes, \chords, 0, 1);
    wire.value(\line, \lead, 0, 1);
    wire.value(\pedalLine, \pedal, 0, 1);
    wire.value(\chords, \tone, 0, 1);
    wire.value(\lead, \tone, 0, 1);
    wire.value(\pedal, \tone, 0, 1);
    wire.value(\tone, \room, 0, 1);
    wire.value(\room, \output, 0, 1);

    context = v[\trackHelpExample].value(nodes,nodes[\changes],"46 / Harmonic Cartography");
    context[\lessonNumber] = 46; context[\scoreBeats] = 80; context[\tailBeats] = 8;
    alive = {v[\helpExampleAlive].value(context)};

    // FORM / every wait is measured in beats on VOID's shared note clock.
    performance = Routine({
        if(alive.value) {
            context[\section] = 0;
            v[\message].value("46 / Harmonic Cartography - Home");
            v[\scaleMode] = 0; v[\sendGlobals].value;
            16.wait;
        };
        if(alive.value) {
            context[\section] = 1;
            v[\message].value("46 / Harmonic Cartography - A darker river");
            v[\scaleMode] = 1; v[\sendGlobals].value;
            v[\setParam].value(nodes[\tone], \cutoff, 1600);
            16.wait;
        };
        if(alive.value) {
            context[\section] = 2;
            v[\message].value("46 / Harmonic Cartography - An open fourth");
            v[\scaleMode] = 3; v[\sendGlobals].value;
            v[\setParam].value(nodes[\tone], \cutoff, 3700);
            16.wait;
        };
        if(alive.value) {
            context[\section] = 3;
            v[\message].value("46 / Harmonic Cartography - The lowered seventh");
            v[\scaleMode] = 4; v[\sendGlobals].value;
            16.wait;
        };
        if(alive.value) {
            context[\section] = 4;
            v[\message].value("46 / Harmonic Cartography - Home reconsidered");
            v[\scaleMode] = 0; v[\sendGlobals].value;
            v[\setParam].value(nodes[\lead], \gain, 0.17);
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
            8.wait; context[\finished] = true;
        };
        // This also handles deleting a study node while the score is running.
        v[\stopHelpExample].value(context);
        if(context[\finished]==true){v[\message].value("46 / Harmonic Cartography finished.")};
    }).play(v[\noteClock],quant:1);
    context[\routines].add(performance);

    // The conductor is queued first, then the note parts share the next beat.
    v[\startSequence].value(nodes[\changes]);
    v[\startSequence].value(nodes[\line]);
    v[\startSequence].value(nodes[\pedalLine]);

    v[\selection] = context[\owned].collect(_[\id]).asSet; v[\fit].value;
    v[\message].value("46 / Harmonic Cartography: Audio ON to listen; Stop examples / PANIC to stop.");
} {
    "Evaluate the current VOID.scd and wait for audio to be ready, then run this study.".postln;
};
)
