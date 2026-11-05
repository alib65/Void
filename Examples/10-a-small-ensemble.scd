/*
VOID STUDY 10 / A Small Ensemble

LEARN
Balance, panning and manual master recording.

COMPOSER'S NOTE
Three independent parts share a mixer. The recorder follows the protected master without an audio cable.

SCORE
96 BPM; global scale Minor; root 0 semitones above C.
40 beats of material + 4 beats of tail; about 27.5 seconds.
Form: Balance the ensemble (32 beats) / A quiet last phrase (8 beats).
Hz parameters and MIDI-mode patterns keep their literal pitches.

PLAY
Evaluate the current VOID.scd first. Evaluate this entire parenthesized block.
Audio ON makes the patch audible. It adds its own selected nodes to the canvas.
Use Stop examples or ~void[\stopHelpExamples].value to stop early.
Undo removes the last build; saved patches retain nodes/patterns, while this file runs the written form.
This study sets the shared tempo/root/tuning and stops earlier help-built examples.
Recording and external MIDI output require your own device/button choices.

TRY
1. Balance the three mixer channels before changing timbres.
2. Record a take, then press Record again to finish its WAV file.
3. Write a NOTE with one performance instruction per part.
*/
(

var v, origin, nodes, context, make, wire, mod, phrase, alive, performance, scaleIndex;
v = ~void;
if(v.notNil and: {v[\ready]} and: {v[\trackHelpExample].notNil}) {
    scaleIndex = v[\scaleNames].indexOfEqual("Minor");
    if(scaleIndex.isNil) {Error("This VOID installation is missing the study tuning.").throw};
    v[\checkpoint].value;
    v[\stopHelpExamples].value;
    v[\bpm] = 96; v[\root] = 0; v[\scaleMode] = 0;
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
    make.value(\line, \noteseq, (base: 60, division: 2, length: 8, gateLength: 0.7));
    make.value(\lead, \polysynth, (wave: 3, gain: 0.26, attack: 0.012, release: 0.35));
    make.value(\ground, \noteseq, (base: 36, division: 1, length: 4, gateLength: 0.7));
    make.value(\bass, \polysynth, (wave: 0, gain: 0.3, attack: 0.012, release: 0.35));
    make.value(\string, \pluck, (freq: 329.63, decay: 0.4, gain: 0.12));
    make.value(\mix, \mixer, (gain0: 0.65, gain1: 0.7, gain2: 0.6, pan0: 0.3, pan2: -0.45));
    make.value(\room, \reverb, (mix: 0.25, size: 0.8, shimmer: 0));
    make.value(\glue, \compressor, (threshold: 0.035, ratio: 2, attack: 0.012, release: 0.25, makeup: 1.1));
    make.value(\display, \scope, (mode: 1));
    make.value(\recorder, \recorder, ());
    make.value(\score, \note, ());
    nodes[\score][\text] = "10 / A Small Ensemble\nBalance, panning and manual master recording\nBalance the ensemble -> A quiet last phrase\nStop examples / PANIC ends this score.";

    // MUSICAL MATERIAL / [] is a rest; a nested array is a chord.
    phrase.value(\line, (notes: [[0], [2], [4], [], [5], [4], [2], [1]], degrees: true));
    phrase.value(\ground, (notes: [[0], [], [3], [4]], degrees: true));

    // ROUTING / audio and note cables use wire; knob modulation uses mod.
    wire.value(\line, \lead, 0, 1);
    wire.value(\ground, \bass, 0, 1);
    wire.value(\lead, \mix, 0, 1);
    wire.value(\bass, \mix, 1, 1);
    wire.value(\string, \mix, 2, 1);
    wire.value(\mix, \glue, 0, 1);
    wire.value(\glue, \room, 0, 1);
    wire.value(\room, \display, 0, 1);
    wire.value(\display, \output, 0, 1);

    context = v[\trackHelpExample].value(nodes,nodes[\line],"10 / A Small Ensemble");
    context[\lessonNumber] = 10; context[\scoreBeats] = 40; context[\tailBeats] = 4;
    alive = {v[\helpExampleAlive].value(context)};

    // FORM / every wait is measured in beats on VOID's shared note clock.
    performance = Routine({
        if(alive.value) {
            context[\section] = 0;
            v[\message].value("10 / A Small Ensemble - Balance the ensemble");
            32.wait;
        };
        if(alive.value) {
            context[\section] = 1;
            v[\message].value("10 / A Small Ensemble - A quiet last phrase");
            v[\setParam].value(nodes[\lead], \gain, 0.17);
            v[\setParam].value(nodes[\string], \gain, 0.07);
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
        if(context[\finished]==true){v[\message].value("10 / A Small Ensemble finished.")};
    }).play(v[\noteClock],quant:1);
    context[\routines].add(performance);

    // The conductor is queued first, then the note parts share the next beat.
    v[\startSequence].value(nodes[\line]);
    v[\startSequence].value(nodes[\ground]);

    v[\selection] = context[\owned].collect(_[\id]).asSet; v[\fit].value;
    v[\message].value("10 / A Small Ensemble: Audio ON to listen; Stop examples / PANIC to stop.");
} {
    "Evaluate the current VOID.scd and wait for audio to be ready, then run this study.".postln;
};
)
