/*
VOID STUDY 18 / Pulse Subtraction

LEARN
Form made by removing attacks.

COMPOSER'S NOTE
The pitch and tempo stay fixed while each section removes two hits from the rhythmic circle.

SCORE
104 BPM; global scale Minor; root 0 semitones above C.
40 beats of material + 4 beats of tail; about 25.4 seconds.
Form: Eleven (8 beats) / Nine (8 beats) / Seven (8 beats) / Five (8 beats) / Three (8 beats).
Hz parameters and MIDI-mode patterns keep their literal pitches.

PLAY
Evaluate the current VOID.scd first. Evaluate this entire parenthesized block.
Audio ON makes the patch audible. It adds its own selected nodes to the canvas.
Use Stop examples or ~void[\stopHelpExamples].value to stop early.
Undo removes the last build; saved patches retain nodes/patterns, while this file runs the written form.
This study sets the shared tempo/root/tuning and stops earlier help-built examples.
Recording and external MIDI output require your own device/button choices.

TRY
1. Reverse the order of the hit counts.
2. Keep the hit count and change only Rotation.
3. Add a bass note only when a new section begins.
*/
(

var v, origin, nodes, context, make, wire, mod, phrase, alive, performance, scaleIndex;
v = ~void;
if(v.notNil and: {v[\ready]} and: {v[\trackHelpExample].notNil}) {
    scaleIndex = v[\scaleNames].indexOfEqual("Minor");
    if(scaleIndex.isNil) {Error("This VOID installation is missing the study tuning.").throw};
    v[\checkpoint].value;
    v[\stopHelpExamples].value;
    v[\bpm] = 104; v[\root] = 0; v[\scaleMode] = 0;
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
    make.value(\rhythm, \euclid, (steps: 16, pulses: 11, division: 4));
    make.value(\wood, \pluck, (freq: 196, auto: 0, decay: 0.18, gain: 0.16));
    make.value(\room, \reverb, (mix: 0.18, size: 0.8, shimmer: 0));
    make.value(\score, \note, ());
    nodes[\score][\text] = "18 / Pulse Subtraction\nForm made by removing attacks\nEleven -> Nine -> Seven -> Five -> Three\nStop examples / PANIC ends this score.";

    // ROUTING / audio and note cables use wire; knob modulation uses mod.
    wire.value(\rhythm, \wood, 0, 1);
    wire.value(\wood, \room, 0, 1);
    wire.value(\room, \output, 0, 1);

    context = v[\trackHelpExample].value(nodes,nodes[\rhythm],"18 / Pulse Subtraction");
    context[\lessonNumber] = 18; context[\scoreBeats] = 40; context[\tailBeats] = 4;
    alive = {v[\helpExampleAlive].value(context)};

    // FORM / every wait is measured in beats on VOID's shared note clock.
    performance = Routine({
        if(alive.value) {
            context[\section] = 0;
            v[\message].value("18 / Pulse Subtraction - Eleven");
            8.wait;
        };
        if(alive.value) {
            context[\section] = 1;
            v[\message].value("18 / Pulse Subtraction - Nine");
            v[\setParam].value(nodes[\rhythm], \pulses, 9);
            8.wait;
        };
        if(alive.value) {
            context[\section] = 2;
            v[\message].value("18 / Pulse Subtraction - Seven");
            v[\setParam].value(nodes[\rhythm], \pulses, 7);
            8.wait;
        };
        if(alive.value) {
            context[\section] = 3;
            v[\message].value("18 / Pulse Subtraction - Five");
            v[\setParam].value(nodes[\rhythm], \pulses, 5);
            8.wait;
        };
        if(alive.value) {
            context[\section] = 4;
            v[\message].value("18 / Pulse Subtraction - Three");
            v[\setParam].value(nodes[\rhythm], \pulses, 3);
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
        if(context[\finished]==true){v[\message].value("18 / Pulse Subtraction finished.")};
    }).play(v[\noteClock],quant:1);
    context[\routines].add(performance);

    v[\selection] = context[\owned].collect(_[\id]).asSet; v[\fit].value;
    v[\message].value("18 / Pulse Subtraction: Audio ON to listen; Stop examples / PANIC to stop.");
} {
    "Evaluate the current VOID.scd and wait for audio to be ready, then run this study.".postln;
};
)
