/*
VOID STUDY 14 / Clockwork Rain

LEARN
Chance against a stable reference pulse.

COMPOSER'S NOTE
A probabilistic clock interrupts a regular bass ostinato, so the omissions have a clear context.

SCORE
100 BPM; global scale Minor; root 0 semitones above C.
40 beats of material + 4 beats of tail; about 26.4 seconds.
Form: Broken rain (16 beats) / A denser shower (16 beats) / Few drops (8 beats).
Hz parameters and MIDI-mode patterns keep their literal pitches.

PLAY
Evaluate the current VOID.scd first. Evaluate this entire parenthesized block.
Audio ON makes the patch audible. It adds its own selected nodes to the canvas.
Use Stop examples or ~void[\stopHelpExamples].value to stop early.
Undo removes the last build; saved patches retain nodes/patterns, while this file runs the written form.
This study sets the shared tempo/root/tuning and stops earlier help-built examples.
Recording and external MIDI output require your own device/button choices.

TRY
1. Set the clock probability to 1, then back to 0.55.
2. Use a shorter pluck decay to expose the gaps.
3. Leave the bass unchanged while increasing the event rate.
*/
(

var v, origin, nodes, context, make, wire, mod, phrase, alive, performance, scaleIndex;
v = ~void;
if(v.notNil and: {v[\ready]} and: {v[\trackHelpExample].notNil}) {
    scaleIndex = v[\scaleNames].indexOfEqual("Minor");
    if(scaleIndex.isNil) {Error("This VOID installation is missing the study tuning.").throw};
    v[\checkpoint].value;
    v[\stopHelpExamples].value;
    v[\bpm] = 100; v[\root] = 0; v[\scaleMode] = 0;
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
    make.value(\ground, \noteseq, (base: 36, division: 1, length: 4, gateLength: 0.7));
    make.value(\bass, \polysynth, (wave: 0, gain: 0.28, attack: 0.012, release: 0.35));
    make.value(\wander, \chaotic, (kind: 0, rate: 10, amount: 0.35));
    make.value(\chance, \clock, (division: 4, probability: 0.55));
    make.value(\rain, \pluck, (freq: 659.25, auto: 0, decay: 0.12, gain: 0.1));
    make.value(\right, \pan, (pan: 0.5));
    make.value(\room, \reverb, (mix: 0.22, size: 0.8, shimmer: 0));
    make.value(\score, \note, ());
    nodes[\score][\text] = "14 / Clockwork Rain\nChance against a stable reference pulse\nBroken rain -> A denser shower -> Few drops\nStop examples / PANIC ends this score.";

    // MUSICAL MATERIAL / [] is a rest; a nested array is a chord.
    phrase.value(\ground, (notes: [[0], [], [4], [3]], degrees: true));

    // ROUTING / audio and note cables use wire; knob modulation uses mod.
    wire.value(\ground, \bass, 0, 1);
    wire.value(\chance, \rain, 0, 1);
    wire.value(\rain, \right, 0, 1);
    wire.value(\right, \room, 0, 1);
    wire.value(\bass, \room, 0, 1);
    wire.value(\room, \output, 0, 1);
    mod.value(\wander, \right, \pan, 0.15);

    context = v[\trackHelpExample].value(nodes,nodes[\ground],"14 / Clockwork Rain");
    context[\lessonNumber] = 14; context[\scoreBeats] = 40; context[\tailBeats] = 4;
    alive = {v[\helpExampleAlive].value(context)};

    // FORM / every wait is measured in beats on VOID's shared note clock.
    performance = Routine({
        if(alive.value) {
            context[\section] = 0;
            v[\message].value("14 / Clockwork Rain - Broken rain");
            16.wait;
        };
        if(alive.value) {
            context[\section] = 1;
            v[\message].value("14 / Clockwork Rain - A denser shower");
            v[\setParam].value(nodes[\chance], \probability, 0.8);
            16.wait;
        };
        if(alive.value) {
            context[\section] = 2;
            v[\message].value("14 / Clockwork Rain - Few drops");
            v[\setParam].value(nodes[\chance], \probability, 0.28);
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
        if(context[\finished]==true){v[\message].value("14 / Clockwork Rain finished.")};
    }).play(v[\noteClock],quant:1);
    context[\routines].add(performance);

    // The conductor is queued first, then the note parts share the next beat.
    v[\startSequence].value(nodes[\ground]);

    v[\selection] = context[\owned].collect(_[\id]).asSet; v[\fit].value;
    v[\message].value("14 / Clockwork Rain: Audio ON to listen; Stop examples / PANIC to stop.");
} {
    "Evaluate the current VOID.scd and wait for audio to be ready, then run this study.".postln;
};
)
