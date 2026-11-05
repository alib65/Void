/*
VOID STUDY 13 / Sevenfold

LEARN
A composed seven-eighth-note phrase.

COMPOSER'S NOTE
The accent groups are 2 + 2 + 3. A low response confirms the last group instead of a conventional downbeat.

SCORE
112 BPM; global scale Minor; root 0 semitones above C.
28 beats of material + 4 beats of tail; about 17.1 seconds.
Form: Eight seven-step phrases (28 beats).
Hz parameters and MIDI-mode patterns keep their literal pitches.

PLAY
Evaluate the current VOID.scd first. Evaluate this entire parenthesized block.
Audio ON makes the patch audible. It adds its own selected nodes to the canvas.
Use Stop examples or ~void[\stopHelpExamples].value to stop early.
Undo removes the last build; saved patches retain nodes/patterns, while this file runs the written form.
This study sets the shared tempo/root/tuning and stops earlier help-built examples.
Recording and external MIDI output require your own device/button choices.

TRY
1. Clap the seven-step accent pattern.
2. Move the last bass note to step six.
3. Rewrite the accents as 3 + 2 + 2.
*/
(

var v, origin, nodes, context, make, wire, mod, phrase, alive, performance, scaleIndex;
v = ~void;
if(v.notNil and: {v[\ready]} and: {v[\trackHelpExample].notNil}) {
    scaleIndex = v[\scaleNames].indexOfEqual("Minor");
    if(scaleIndex.isNil) {Error("This VOID installation is missing the study tuning.").throw};
    v[\checkpoint].value;
    v[\stopHelpExamples].value;
    v[\bpm] = 112; v[\root] = 0; v[\scaleMode] = 0;
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
    make.value(\seven, \noteseq, (base: 60, division: 2, length: 7, gateLength: 0.7));
    make.value(\lead, \polysynth, (wave: 3, gain: 0.25, attack: 0.012, release: 0.35));
    make.value(\ground, \noteseq, (base: 36, division: 2, length: 7, gateLength: 0.7));
    make.value(\bass, \polysynth, (wave: 0, gain: 0.3, attack: 0.012, release: 0.35));
    make.value(\room, \reverb, (mix: 0.18, size: 0.8, shimmer: 0));
    make.value(\score, \note, ());
    nodes[\score][\text] = "13 / Sevenfold\nA composed seven-eighth-note phrase\nEight seven-step phrases\nStop examples / PANIC ends this score.";

    // MUSICAL MATERIAL / [] is a rest; a nested array is a chord.
    phrase.value(\seven, (notes: [[0], [2], [4], [3], [5], [4], [1]], degrees: true, velocity: [96, 58, 87, 55, 93, 64, 72]));
    phrase.value(\ground, (notes: [[0], [], [4], [], [3], [], [4]], degrees: true, velocity: [92, 50, 74, 50, 86, 50, 68]));

    // ROUTING / audio and note cables use wire; knob modulation uses mod.
    wire.value(\seven, \lead, 0, 1);
    wire.value(\ground, \bass, 0, 1);
    wire.value(\lead, \room, 0, 1);
    wire.value(\bass, \room, 0, 1);
    wire.value(\room, \output, 0, 1);

    context = v[\trackHelpExample].value(nodes,nodes[\seven],"13 / Sevenfold");
    context[\lessonNumber] = 13; context[\scoreBeats] = 28; context[\tailBeats] = 4;
    alive = {v[\helpExampleAlive].value(context)};

    // FORM / every wait is measured in beats on VOID's shared note clock.
    performance = Routine({
        if(alive.value) {
            context[\section] = 0;
            v[\message].value("13 / Sevenfold - Eight seven-step phrases");
            28.wait;
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
        if(context[\finished]==true){v[\message].value("13 / Sevenfold finished.")};
    }).play(v[\noteClock],quant:1);
    context[\routines].add(performance);

    // The conductor is queued first, then the note parts share the next beat.
    v[\startSequence].value(nodes[\seven]);
    v[\startSequence].value(nodes[\ground]);

    v[\selection] = context[\owned].collect(_[\id]).asSet; v[\fit].value;
    v[\message].value("13 / Sevenfold: Audio ON to listen; Stop examples / PANIC to stop.");
} {
    "Evaluate the current VOID.scd and wait for audio to be ready, then run this study.".postln;
};
)
