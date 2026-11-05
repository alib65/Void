/*
VOID STUDY 22 / Grain Atlas

LEARN
Scanning, freezing and dispersing a sample.

COMPOSER'S NOTE
One bundled recording becomes three different landscapes without changing the source file.

SCORE
76 BPM; global scale Minor; root 0 semitones above C.
48 beats of material + 4 beats of tail; about 41.1 seconds.
Form: Travel (16 beats) / A fixed place (16 beats) / A dispersed map (16 beats).
Hz parameters and MIDI-mode patterns keep their literal pitches.

PLAY
Evaluate the current VOID.scd first. Evaluate this entire parenthesized block.
Audio ON makes the patch audible. It adds its own selected nodes to the canvas.
Use Stop examples or ~void[\stopHelpExamples].value to stop early.
Undo removes the last build; saved patches retain nodes/patterns, while this file runs the written form.
This study sets the shared tempo/root/tuning and stops earlier help-built examples.
Recording and external MIDI output require your own device/button choices.

TRY
1. Replace the bundled sound with a sustained instrumental note.
2. Reduce Grain size while increasing Density.
3. Compare frozen position with slow scanning at the same density.
*/
(

var v, origin, nodes, context, make, wire, mod, phrase, alive, performance, scaleIndex;
v = ~void;
if(v.notNil and: {v[\ready]} and: {v[\trackHelpExample].notNil}) {
    scaleIndex = v[\scaleNames].indexOfEqual("Minor");
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
    make.value(\cloud, \granular, (density: 18, size: 0.13, position: 0.2, scan: 0.018, pitchScatter: 0, positionScatter: 0.04, gain: 0.14));
    make.value(\tone, \filter, (cutoff: 4800));
    make.value(\room, \reverb, (mix: 0.35, size: 0.92, shimmer: 0));
    make.value(\score, \note, ());
    nodes[\score][\text] = "22 / Grain Atlas\nScanning, freezing and dispersing a sample\nTravel -> A fixed place -> A dispersed map\nStop examples / PANIC ends this score.";

    // The bundled voice recording makes this study portable without a download.
    v[\loadSound].value(nodes[\cloud], Platform.resourceDir +/+ "sounds/a11wlk01.wav", false);

    // ROUTING / audio and note cables use wire; knob modulation uses mod.
    wire.value(\cloud, \tone, 0, 1);
    wire.value(\tone, \room, 0, 1);
    wire.value(\room, \output, 0, 1);

    context = v[\trackHelpExample].value(nodes,nodes[\cloud],"22 / Grain Atlas");
    context[\lessonNumber] = 22; context[\scoreBeats] = 48; context[\tailBeats] = 4;
    alive = {v[\helpExampleAlive].value(context)};

    // FORM / every wait is measured in beats on VOID's shared note clock.
    performance = Routine({
        if(alive.value) {
            context[\section] = 0;
            v[\message].value("22 / Grain Atlas - Travel");
            16.wait;
        };
        if(alive.value) {
            context[\section] = 1;
            v[\message].value("22 / Grain Atlas - A fixed place");
            v[\setParam].value(nodes[\cloud], \freeze, 1);
            v[\setParam].value(nodes[\cloud], \position, 0.52);
            16.wait;
        };
        if(alive.value) {
            context[\section] = 2;
            v[\message].value("22 / Grain Atlas - A dispersed map");
            v[\setParam].value(nodes[\cloud], \freeze, 0);
            v[\setParam].value(nodes[\cloud], \pitchScatter, 6);
            v[\setParam].value(nodes[\cloud], \positionScatter, 0.2);
            v[\setParam].value(nodes[\cloud], \size, 0.055);
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
        if(context[\finished]==true){v[\message].value("22 / Grain Atlas finished.")};
    }).play(v[\noteClock],quant:1);
    context[\routines].add(performance);

    v[\selection] = context[\owned].collect(_[\id]).asSet; v[\fit].value;
    v[\message].value("22 / Grain Atlas: Audio ON to listen; Stop examples / PANIC to stop.");
} {
    "Evaluate the current VOID.scd and wait for audio to be ready, then run this study.".postln;
};
)
