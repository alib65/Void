/*
VOID STUDY 29 / Sideband Bells

LEARN
Ring modulation, fixed-Hz shifting and pitch ratios.

COMPOSER'S NOTE
The same notes pass from tremolo to metallic sidebands and finally to displaced overtones.

SCORE
90 BPM; global scale Minor; root 0 semitones above C.
32 beats of material + 4 beats of tail; about 24 seconds.
Form: Trembling (8 beats) / Metal (8 beats) / Fixed-Hz shift (8 beats) / A pitch-ratio fifth (8 beats).
Hz parameters and MIDI-mode patterns keep their literal pitches.

PLAY
Evaluate the current VOID.scd first. Evaluate this entire parenthesized block.
Audio ON makes the patch audible. It adds its own selected nodes to the canvas.
Use Stop examples or ~void[\stopHelpExamples].value to stop early.
Undo removes the last build; saved patches retain nodes/patterns, while this file runs the written form.
This study sets the shared tempo/root/tuning and stops earlier help-built examples.
Recording and external MIDI output require your own device/button choices.

TRY
1. Compare the fixed-Hz shift with the final pitch-ratio section.
2. Use a negative shift in the third section.
3. Reduce Mix until the changed overtones become a shadow.
*/
(

var v, origin, nodes, context, make, wire, mod, phrase, alive, performance, scaleIndex;
v = ~void;
if(v.notNil and: {v[\ready]} and: {v[\trackHelpExample].notNil}) {
    scaleIndex = v[\scaleNames].indexOfEqual("Minor");
    if(scaleIndex.isNil) {Error("This VOID installation is missing the study tuning.").throw};
    v[\checkpoint].value;
    v[\stopHelpExamples].value;
    v[\bpm] = 90; v[\root] = 0; v[\scaleMode] = 0;
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
    make.value(\lead, \polysynth, (wave: 3, gain: 0.29, attack: 0.012, release: 0.35));
    make.value(\colour, \ring, (frequency: 8, mode: 0, mix: 0.55));
    make.value(\ratio, \pitchshift, (ratio: 1.5, mix: 1, pitchDisp: 0, timeDisp: 0.01));
    make.value(\compare, \xfade, (mix: 0));
    make.value(\room, \reverb, (mix: 0.25, size: 0.8, shimmer: 0));
    make.value(\score, \note, ());
    nodes[\score][\text] = "29 / Sideband Bells\nRing modulation, fixed-Hz shifting and pitch ratios\nTrembling -> Metal -> Fixed-Hz shift -> A pitch-ratio fifth\nStop examples / PANIC ends this score.";

    // MUSICAL MATERIAL / [] is a rest; a nested array is a chord.
    phrase.value(\line, (notes: [[0], [], [4], [2], [], [6], [5], [4], [0], [], [3], [2], [], [1], [0], []], degrees: true));

    // ROUTING / audio and note cables use wire; knob modulation uses mod.
    wire.value(\line, \lead, 0, 1);
    wire.value(\lead, \colour, 0, 1);
    wire.value(\room, \output, 0, 1);
    wire.value(\colour, \compare, 0, 1);
    wire.value(\lead, \ratio, 0, 1);
    wire.value(\ratio, \compare, 1, 1);
    wire.value(\compare, \room, 0, 1);

    context = v[\trackHelpExample].value(nodes,nodes[\line],"29 / Sideband Bells");
    context[\lessonNumber] = 29; context[\scoreBeats] = 32; context[\tailBeats] = 4;
    alive = {v[\helpExampleAlive].value(context)};

    // FORM / every wait is measured in beats on VOID's shared note clock.
    performance = Routine({
        if(alive.value) {
            context[\section] = 0;
            v[\message].value("29 / Sideband Bells - Trembling");
            8.wait;
        };
        if(alive.value) {
            context[\section] = 1;
            v[\message].value("29 / Sideband Bells - Metal");
            v[\setParam].value(nodes[\colour], \frequency, 70);
            8.wait;
        };
        if(alive.value) {
            context[\section] = 2;
            v[\message].value("29 / Sideband Bells - Fixed-Hz shift");
            v[\setParam].value(nodes[\colour], \mode, 1);
            v[\setParam].value(nodes[\colour], \frequency, 120);
            8.wait;
        };
        if(alive.value) {
            context[\section] = 3;
            v[\message].value("29 / Sideband Bells - A pitch-ratio fifth");
            v[\setParam].value(nodes[\compare], \mix, 1);
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
        if(context[\finished]==true){v[\message].value("29 / Sideband Bells finished.")};
    }).play(v[\noteClock],quant:1);
    context[\routines].add(performance);

    // The conductor is queued first, then the note parts share the next beat.
    v[\startSequence].value(nodes[\line]);

    v[\selection] = context[\owned].collect(_[\id]).asSet; v[\fit].value;
    v[\message].value("29 / Sideband Bells: Audio ON to listen; Stop examples / PANIC to stop.");
} {
    "Evaluate the current VOID.scd and wait for audio to be ready, then run this study.".postln;
};
)
