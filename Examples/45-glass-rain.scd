/*
VOID STUDY 45 / Glass Rain

LEARN
A melodic miniature transformed by grains and a frozen spectrum.

COMPOSER'S NOTE
A short descending subject gradually joins the noise of a recorded voice, pauses inside a spectral image, and returns altered.

SCORE
78 BPM; global scale Minor; root 0 semitones above C.
64 beats of material + 8 beats of tail; about 55.4 seconds.
Form: A descending figure (16 beats) / Rain gathers (16 beats) / The held image (16 beats) / The altered figure (16 beats).
Hz parameters and MIDI-mode patterns keep their literal pitches.

PLAY
Evaluate the current VOID.scd first. Evaluate this entire parenthesized block.
Audio ON makes the patch audible. It adds its own selected nodes to the canvas.
Use Stop examples or ~void[\stopHelpExamples].value to stop early.
Undo removes the last build; saved patches retain nodes/patterns, while this file runs the written form.
This study sets the shared tempo/root/tuning and stops earlier help-built examples.
Recording and external MIDI output require your own device/button choices.

TRY
1. Use a different recording for the cloud.
2. Keep the spectrum live through the still section.
3. Bring back only the last four notes of the subject.
*/
(

var v, origin, nodes, context, make, wire, mod, phrase, alive, performance, scaleIndex;
v = ~void;
if(v.notNil and: {v[\ready]} and: {v[\trackHelpExample].notNil}) {
    scaleIndex = v[\scaleNames].indexOfEqual("Minor");
    if(scaleIndex.isNil) {Error("This VOID installation is missing the study tuning.").throw};
    v[\checkpoint].value;
    v[\stopHelpExamples].value;
    v[\bpm] = 78; v[\root] = 0; v[\scaleMode] = 0;
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
    make.value(\line, \noteseq, (base: 72, division: 2, length: 16, gateLength: 0.7));
    make.value(\lead, \polysynth, (wave: 0, gain: 0.25, attack: 0.012, release: 0.65));
    make.value(\cloud, \granular, (density: 14, size: 0.11, scan: 0.024, pitchScatter: 0.5, gain: 0.035));
    make.value(\spectral, \spectral, (smear: 5, mix: 0.65));
    make.value(\mix, \mixer, (gain0: 0.7, gain1: 0.65, pan0: -0.25, pan1: 0.3));
    make.value(\echo, \delay, (sync: 1, division: 0.75, feedback: 0.42, mix: 0.28));
    make.value(\room, \reverb, (mix: 0.3, size: 0.92, shimmer: 0));
    make.value(\score, \note, ());
    nodes[\score][\text] = "45 / Glass Rain\nA melodic miniature transformed by grains and a frozen spectrum\nA descending figure -> Rain gathers -> The held image -> The altered figure\nStop examples / PANIC ends this score.";

    // The bundled voice recording makes this study portable without a download.
    v[\loadSound].value(nodes[\cloud], Platform.resourceDir +/+ "sounds/a11wlk01.wav", false);

    // MUSICAL MATERIAL / [] is a rest; a nested array is a chord.
    phrase.value(\line, (notes: [[7], [6], [4], [2], [], [3], [2], [0], [], [4], [3], [1], [0], [], [], []], degrees: true));

    // ROUTING / audio and note cables use wire; knob modulation uses mod.
    wire.value(\line, \lead, 0, 1);
    wire.value(\lead, \mix, 0, 1);
    wire.value(\cloud, \spectral, 0, 1);
    wire.value(\spectral, \mix, 1, 1);
    wire.value(\mix, \echo, 0, 1);
    wire.value(\echo, \room, 0, 1);
    wire.value(\room, \output, 0, 1);

    context = v[\trackHelpExample].value(nodes,nodes[\line],"45 / Glass Rain");
    context[\lessonNumber] = 45; context[\scoreBeats] = 64; context[\tailBeats] = 8;
    alive = {v[\helpExampleAlive].value(context)};

    // FORM / every wait is measured in beats on VOID's shared note clock.
    performance = Routine({
        if(alive.value) {
            context[\section] = 0;
            v[\message].value("45 / Glass Rain - A descending figure");
            16.wait;
        };
        if(alive.value) {
            context[\section] = 1;
            v[\message].value("45 / Glass Rain - Rain gathers");
            v[\setParam].value(nodes[\cloud], \gain, 0.09);
            v[\setParam].value(nodes[\cloud], \density, 42);
            v[\setParam].value(nodes[\cloud], \pitchScatter, 5);
            16.wait;
        };
        if(alive.value) {
            context[\section] = 2;
            v[\message].value("45 / Glass Rain - The held image");
            v[\setParam].value(nodes[\spectral], \freeze, 1);
            v[\setParam].value(nodes[\lead], \gain, 0.12);
            v[\setParam].value(nodes[\spectral], \smear, 20);
            16.wait;
        };
        if(alive.value) {
            context[\section] = 3;
            v[\message].value("45 / Glass Rain - The altered figure");
            v[\setParam].value(nodes[\spectral], \freeze, 0);
            v[\setParam].value(nodes[\cloud], \gain, 0.035);
            phrase.value(\line, (notes: [[7], [], [4], [], [], [3], [], [0], [], [4], [], [1], [0], [], [], []], degrees: true));
            v[\setParam].value(nodes[\lead], \gain, 0.23);
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
        if(context[\finished]==true){v[\message].value("45 / Glass Rain finished.")};
    }).play(v[\noteClock],quant:1);
    context[\routines].add(performance);

    // The conductor is queued first, then the note parts share the next beat.
    v[\startSequence].value(nodes[\line]);

    v[\selection] = context[\owned].collect(_[\id]).asSet; v[\fit].value;
    v[\message].value("45 / Glass Rain: Audio ON to listen; Stop examples / PANIC to stop.");
} {
    "Evaluate the current VOID.scd and wait for audio to be ready, then run this study.".postln;
};
)
