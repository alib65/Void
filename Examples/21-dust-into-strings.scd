/*
VOID STUDY 21 / Dust into Strings

LEARN
Exciting a resonator with irregular impulses.

COMPOSER'S NOTE
Tiny noise events acquire a tuned ringing body; the apparent instrument comes from the resonator.

SCORE
80 BPM; global scale Minor; root 0 semitones above C.
48 beats of material + 4 beats of tail; about 39 seconds.
Form: A few strings (16 beats) / Brighter body (16 beats) / The low room (16 beats).
Hz parameters and MIDI-mode patterns keep their literal pitches.

PLAY
Evaluate the current VOID.scd first. Evaluate this entire parenthesized block.
Audio ON makes the patch audible. It adds its own selected nodes to the canvas.
Use Stop examples or ~void[\stopHelpExamples].value to stop early.
Undo removes the last build; saved patches retain nodes/patterns, while this file runs the written form.
This study sets the shared tempo/root/tuning and stops earlier help-built examples.
Recording and external MIDI output require your own device/button choices.

TRY
1. Listen to the dust without the resonator.
2. Lengthen Decay while reducing Density.
3. Change the chord bank and keep the excitation unchanged.
*/
(

var v, origin, nodes, context, make, wire, mod, phrase, alive, performance, scaleIndex;
v = ~void;
if(v.notNil and: {v[\ready]} and: {v[\trackHelpExample].notNil}) {
    scaleIndex = v[\scaleNames].indexOfEqual("Minor");
    if(scaleIndex.isNil) {Error("This VOID installation is missing the study tuning.").throw};
    v[\checkpoint].value;
    v[\stopHelpExamples].value;
    v[\bpm] = 80; v[\root] = 0; v[\scaleMode] = 0;
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
    make.value(\dust, \noise, (kind: 4, density: 15, colour: 10000, gain: 0.16));
    make.value(\body, \resonator, (rootNote: 48, chord: 1, decay: 2.8, mix: 0.85));
    make.value(\room, \reverb, (mix: 0.24, size: 0.86, shimmer: 0));
    make.value(\score, \note, ());
    nodes[\score][\text] = "21 / Dust into Strings\nExciting a resonator with irregular impulses\nA few strings -> Brighter body -> The low room\nStop examples / PANIC ends this score.";

    // ROUTING / audio and note cables use wire; knob modulation uses mod.
    wire.value(\dust, \body, 0, 1);
    wire.value(\body, \room, 0, 1);
    wire.value(\room, \output, 0, 1);

    context = v[\trackHelpExample].value(nodes,nodes[\dust],"21 / Dust into Strings");
    context[\lessonNumber] = 21; context[\scoreBeats] = 48; context[\tailBeats] = 4;
    alive = {v[\helpExampleAlive].value(context)};

    // FORM / every wait is measured in beats on VOID's shared note clock.
    performance = Routine({
        if(alive.value) {
            context[\section] = 0;
            v[\message].value("21 / Dust into Strings - A few strings");
            16.wait;
        };
        if(alive.value) {
            context[\section] = 1;
            v[\message].value("21 / Dust into Strings - Brighter body");
            v[\setParam].value(nodes[\body], \rootNote, 55);
            v[\setParam].value(nodes[\dust], \density, 24);
            16.wait;
        };
        if(alive.value) {
            context[\section] = 2;
            v[\message].value("21 / Dust into Strings - The low room");
            v[\setParam].value(nodes[\body], \rootNote, 43);
            v[\setParam].value(nodes[\dust], \density, 8);
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
        if(context[\finished]==true){v[\message].value("21 / Dust into Strings finished.")};
    }).play(v[\noteClock],quant:1);
    context[\routines].add(performance);

    v[\selection] = context[\owned].collect(_[\id]).asSet; v[\fit].value;
    v[\message].value("21 / Dust into Strings: Audio ON to listen; Stop examples / PANIC to stop.");
} {
    "Evaluate the current VOID.scd and wait for audio to be ready, then run this study.".postln;
};
)
