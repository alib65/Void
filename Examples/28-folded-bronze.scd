/*
VOID STUDY 28 / Folded Bronze

LEARN
Parallel wavefolding and equal-power blending.

COMPOSER'S NOTE
A picked string and its folded shadow are two sides of one sound; the listener can follow the transition.

SCORE
82 BPM; global scale Minor; root 0 semitones above C.
32 beats of material + 4 beats of tail; about 26.3 seconds.
Form: The string (8 beats) / Bronze edge (8 beats) / Folded body (8 beats) / A trace of the edge (8 beats).
Hz parameters and MIDI-mode patterns keep their literal pitches.

PLAY
Evaluate the current VOID.scd first. Evaluate this entire parenthesized block.
Audio ON makes the patch audible. It adds its own selected nodes to the canvas.
Use Stop examples or ~void[\stopHelpExamples].value to stop early.
Undo removes the last build; saved patches retain nodes/patterns, while this file runs the written form.
This study sets the shared tempo/root/tuning and stops earlier help-built examples.
Recording and external MIDI output require your own device/button choices.

TRY
1. Reduce Drive and increase the folded return instead.
2. Change Fold to Tanh while preserving the same phrase.
3. Add a slow movement to the blend.
*/
(

var v, origin, nodes, context, make, wire, mod, phrase, alive, performance, scaleIndex;
v = ~void;
if(v.notNil and: {v[\ready]} and: {v[\trackHelpExample].notNil}) {
    scaleIndex = v[\scaleNames].indexOfEqual("Minor");
    if(scaleIndex.isNil) {Error("This VOID installation is missing the study tuning.").throw};
    v[\checkpoint].value;
    v[\stopHelpExamples].value;
    v[\bpm] = 82; v[\root] = 0; v[\scaleMode] = 0;
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
    make.value(\string, \pluck, (freq: 146.83, decay: 0.75, gain: 0.13));
    make.value(\fold, \distort, (drive: 8, mode: 1, tone: 3600, mix: 1));
    make.value(\blend, \xfade, (mix: 0));
    make.value(\room, \reverb, (mix: 0.2, size: 0.8, shimmer: 0));
    make.value(\score, \note, ());
    nodes[\score][\text] = "28 / Folded Bronze\nParallel wavefolding and equal-power blending\nThe string -> Bronze edge -> Folded body -> A trace of the edge\nStop examples / PANIC ends this score.";

    // ROUTING / audio and note cables use wire; knob modulation uses mod.
    wire.value(\string, \blend, 0, 1);
    wire.value(\string, \fold, 0, 1);
    wire.value(\fold, \blend, 1, 1);
    wire.value(\blend, \room, 0, 1);
    wire.value(\room, \output, 0, 1);

    context = v[\trackHelpExample].value(nodes,nodes[\string],"28 / Folded Bronze");
    context[\lessonNumber] = 28; context[\scoreBeats] = 32; context[\tailBeats] = 4;
    alive = {v[\helpExampleAlive].value(context)};

    // FORM / every wait is measured in beats on VOID's shared note clock.
    performance = Routine({
        if(alive.value) {
            context[\section] = 0;
            v[\message].value("28 / Folded Bronze - The string");
            8.wait;
        };
        if(alive.value) {
            context[\section] = 1;
            v[\message].value("28 / Folded Bronze - Bronze edge");
            v[\setParam].value(nodes[\blend], \mix, 0.35);
            8.wait;
        };
        if(alive.value) {
            context[\section] = 2;
            v[\message].value("28 / Folded Bronze - Folded body");
            v[\setParam].value(nodes[\blend], \mix, 0.8);
            8.wait;
        };
        if(alive.value) {
            context[\section] = 3;
            v[\message].value("28 / Folded Bronze - A trace of the edge");
            v[\setParam].value(nodes[\blend], \mix, 0.2);
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
        if(context[\finished]==true){v[\message].value("28 / Folded Bronze finished.")};
    }).play(v[\noteClock],quant:1);
    context[\routines].add(performance);

    v[\selection] = context[\owned].collect(_[\id]).asSet; v[\fit].value;
    v[\message].value("28 / Folded Bronze: Audio ON to listen; Stop examples / PANIC to stop.");
} {
    "Evaluate the current VOID.scd and wait for audio to be ready, then run this study.".postln;
};
)
