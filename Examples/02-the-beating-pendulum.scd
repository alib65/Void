/*
VOID STUDY 02 / The Beating Pendulum

LEARN
Unison tuning and slow spatial movement.

COMPOSER'S NOTE
A steady pitch becomes a slowly changing surface as nearby frequencies interfere.

SCORE
72 BPM; global scale Minor; root 0 semitones above C.
40 beats of material + 4 beats of tail; about 36.7 seconds.
Form: Close beating (16 beats) / Wider beating (16 beats) / Still centre (8 beats).
Hz parameters and MIDI-mode patterns keep their literal pitches.

PLAY
Evaluate the current VOID.scd first. Evaluate this entire parenthesized block.
Audio ON makes the patch audible. It adds its own selected nodes to the canvas.
Use Stop examples or ~void[\stopHelpExamples].value to stop early.
Undo removes the last build; saved patches retain nodes/patterns, while this file runs the written form.
This study sets the shared tempo/root/tuning and stops earlier help-built examples.
Recording and external MIDI output require your own device/button choices.

TRY
1. Compare Detune 2 with 12 cents.
2. Set Unison voices to 1 to remove the beating.
3. Set the motion LFO Minimum and Maximum to zero to hear the timbre without movement.
*/
(

var v, origin, nodes, context, make, wire, mod, phrase, alive, performance, scaleIndex;
v = ~void;
if(v.notNil and: {v[\ready]} and: {v[\trackHelpExample].notNil}) {
    scaleIndex = v[\scaleNames].indexOfEqual("Minor");
    if(scaleIndex.isNil) {Error("This VOID installation is missing the study tuning.").throw};
    v[\checkpoint].value;
    v[\stopHelpExamples].value;
    v[\bpm] = 72; v[\root] = 0; v[\scaleMode] = 0;
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
    make.value(\tone, \osc, (freq: 146.83, wave: 0, gain: 0.065, voices: 3, detune: 5, spread: 0.65));
    make.value(\motion, \lfo, (rate: 0.11, shape: 0, low: -1, high: 1));
    make.value(\stereo, \pan, (auto: 0, rate: 0.11));
    make.value(\room, \reverb, (mix: 0.2, size: 0.8, shimmer: 0));
    make.value(\score, \note, ());
    nodes[\score][\text] = "02 / The Beating Pendulum\nUnison tuning and slow spatial movement\nClose beating -> Wider beating -> Still centre\nStop examples / PANIC ends this score.";

    // ROUTING / audio and note cables use wire; knob modulation uses mod.
    wire.value(\tone, \stereo, 0, 1);
    wire.value(\stereo, \room, 0, 1);
    wire.value(\room, \output, 0, 1);
    mod.value(\motion, \stereo, \pan, 0.35);

    context = v[\trackHelpExample].value(nodes,nodes[\tone],"02 / The Beating Pendulum");
    context[\lessonNumber] = 2; context[\scoreBeats] = 40; context[\tailBeats] = 4;
    alive = {v[\helpExampleAlive].value(context)};

    // FORM / every wait is measured in beats on VOID's shared note clock.
    performance = Routine({
        if(alive.value) {
            context[\section] = 0;
            v[\message].value("02 / The Beating Pendulum - Close beating");
            16.wait;
        };
        if(alive.value) {
            context[\section] = 1;
            v[\message].value("02 / The Beating Pendulum - Wider beating");
            v[\setParam].value(nodes[\tone], \detune, 12);
            16.wait;
        };
        if(alive.value) {
            context[\section] = 2;
            v[\message].value("02 / The Beating Pendulum - Still centre");
            v[\setParam].value(nodes[\stereo], \auto, 0);
            v[\setParam].value(nodes[\tone], \detune, 2);
            v[\setParam].value(nodes[\motion], \low, 0);
            v[\setParam].value(nodes[\motion], \high, 0);
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
        if(context[\finished]==true){v[\message].value("02 / The Beating Pendulum finished.")};
    }).play(v[\noteClock],quant:1);
    context[\routines].add(performance);

    v[\selection] = context[\owned].collect(_[\id]).asSet; v[\fit].value;
    v[\message].value("02 / The Beating Pendulum: Audio ON to listen; Stop examples / PANIC to stop.");
} {
    "Evaluate the current VOID.scd and wait for audio to be ready, then run this study.".postln;
};
)
