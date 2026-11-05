/*
VOID STUDY 08 / Glass Ratios

LEARN
FM colour shaped into articulated notes.

COMPOSER'S NOTE
A fixed pitch changes character as the modulator ratio moves from simple to less settled relationships.

SCORE
88 BPM; global scale Minor; root 0 semitones above C.
32 beats of material + 4 beats of tail; about 24.5 seconds.
Form: Simple ratio (8 beats) / Bright integer (8 beats) / Uneven spectrum (8 beats) / Return (8 beats).
Hz parameters and MIDI-mode patterns keep their literal pitches.

PLAY
Evaluate the current VOID.scd first. Evaluate this entire parenthesized block.
Audio ON makes the patch audible. It adds its own selected nodes to the canvas.
Use Stop examples or ~void[\stopHelpExamples].value to stop early.
Undo removes the last build; saved patches retain nodes/patterns, while this file runs the written form.
This study sets the shared tempo/root/tuning and stops earlier help-built examples.
Recording and external MIDI output require your own device/button choices.

TRY
1. Keep Ratio at 2 and change only Index.
2. Use a longer envelope decay for a bell tail.
3. Compare integer and non-integer ratios at equal gain.
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
    make.value(\bell, \fm, (freq: 261.63, ratio: 2, index: 1.2, gain: 0.065));
    make.value(\beat, \clock, (division: 1));
    make.value(\drift, \random, (mode: 2, rate: 0.45, low: -1, high: 1));
    make.value(\shape, \envelope, (attack: 0.002, decay: 0.75));
    make.value(\echo, \delay, (sync: 1, division: 0.75, feedback: 0.25, mix: 0.24));
    make.value(\score, \note, ());
    nodes[\score][\text] = "08 / Glass Ratios\nFM colour shaped into articulated notes\nSimple ratio -> Bright integer -> Uneven spectrum -> Return\nStop examples / PANIC ends this score.";

    // ROUTING / audio and note cables use wire; knob modulation uses mod.
    wire.value(\bell, \shape, 0, 1);
    wire.value(\beat, \shape, 1, 1);
    wire.value(\shape, \echo, 0, 1);
    wire.value(\echo, \output, 0, 1);
    mod.value(\drift, \bell, \index, 0.025);

    context = v[\trackHelpExample].value(nodes,nodes[\bell],"08 / Glass Ratios");
    context[\lessonNumber] = 8; context[\scoreBeats] = 32; context[\tailBeats] = 4;
    alive = {v[\helpExampleAlive].value(context)};

    // FORM / every wait is measured in beats on VOID's shared note clock.
    performance = Routine({
        if(alive.value) {
            context[\section] = 0;
            v[\message].value("08 / Glass Ratios - Simple ratio");
            8.wait;
        };
        if(alive.value) {
            context[\section] = 1;
            v[\message].value("08 / Glass Ratios - Bright integer");
            v[\setParam].value(nodes[\bell], \ratio, 3);
            v[\setParam].value(nodes[\bell], \index, 2);
            8.wait;
        };
        if(alive.value) {
            context[\section] = 2;
            v[\message].value("08 / Glass Ratios - Uneven spectrum");
            v[\setParam].value(nodes[\bell], \ratio, 2.71);
            8.wait;
        };
        if(alive.value) {
            context[\section] = 3;
            v[\message].value("08 / Glass Ratios - Return");
            v[\setParam].value(nodes[\bell], \ratio, 2);
            v[\setParam].value(nodes[\bell], \index, 1.2);
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
        if(context[\finished]==true){v[\message].value("08 / Glass Ratios finished.")};
    }).play(v[\noteClock],quant:1);
    context[\routines].add(performance);

    v[\selection] = context[\owned].collect(_[\id]).asSet; v[\fit].value;
    v[\message].value("08 / Glass Ratios: Audio ON to listen; Stop examples / PANIC to stop.");
} {
    "Evaluate the current VOID.scd and wait for audio to be ready, then run this study.".postln;
};
)
