/*
VOID STUDY 33 / Shur Nocturne

LEARN
A melodic study in an editable Persian reference collection.

COMPOSER'S NOTE
A quiet tonic and fifth support a line that lingers around the second degree. This uses VOID's 24-EDO Shur approximation.

SCORE
70 BPM; global scale Persian · Shur (24-EDO approx.); root 0 semitones above C.
36 beats of material + 6 beats of tail; about 36 seconds.
Form: Four complete phrases (36.0 beats).
Hz parameters and MIDI-mode patterns keep their literal pitches.

PLAY
Evaluate the current VOID.scd first. Evaluate this entire parenthesized block.
Audio ON makes the patch audible. It adds its own selected nodes to the canvas.
Use Stop examples or ~void[\stopHelpExamples].value to stop early.
Undo removes the last build; saved patches retain nodes/patterns, while this file runs the written form.
This study sets the shared tempo/root/tuning and stops earlier help-built examples.
Recording and external MIDI output require your own device/button choices.

TRY
1. Adjust the second-degree cents in the custom tuning editor.
2. Remove accompaniment and shape the line by velocity alone.
3. Change the duration of the return to the tonic.
*/
(

var v, origin, nodes, context, make, wire, mod, phrase, alive, performance, scaleIndex;
v = ~void;
if(v.notNil and: {v[\ready]} and: {v[\trackHelpExample].notNil}) {
    scaleIndex = v[\scaleNames].indexOfEqual("Persian · Shur (24-EDO approx.)");
    if(scaleIndex.isNil) {Error("This VOID installation is missing the study tuning.").throw};
    v[\checkpoint].value;
    v[\stopHelpExamples].value;
    v[\bpm] = 70; v[\root] = 0; v[\scaleMode] = 0;
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
    make.value(\line, \noteseq, (base: 60, division: 2, length: 16, gateLength: 0.7));
    make.value(\lead, \polysynth, (wave: 3, gain: 0.25, attack: 0.012, release: 0.55));
    make.value(\pedalLine, \noteseq, (base: 36, division: 0.25, length: 1, gateLength: 0.9));
    make.value(\pedal, \polysynth, (wave: 0, gain: 0.18, attack: 0.2, release: 1.2));
    make.value(\room, \reverb, (mix: 0.27, size: 0.8, shimmer: 0));
    make.value(\score, \note, ());
    nodes[\score][\text] = "33 / Shur Nocturne\nA melodic study in an editable Persian reference collection\nFour complete phrases\nStop examples / PANIC ends this score.";

    // MUSICAL MATERIAL / [] is a rest; a nested array is a chord.
    phrase.value(\line, (notes: [[0], [1], [0], [], [1], [2], [3], [2], [1], [0], [-1], [0], [], [1], [0], []], degrees: true, duration: [1, 0.5, 0.5, 1, 1, 1, 2, 1, 1, 2, 0.5, 1.5, 1, 1, 2, 1], velocity: [88, 56, 71, 50, 63, 69, 80, 64, 57, 76, 49, 64, 50, 55, 65, 50]));
    phrase.value(\pedalLine, (notes: [[0, 4]], degrees: true));

    // ROUTING / audio and note cables use wire; knob modulation uses mod.
    wire.value(\line, \lead, 0, 1);
    wire.value(\pedalLine, \pedal, 0, 1);
    wire.value(\lead, \room, 0, 1);
    wire.value(\pedal, \room, 0, 1);
    wire.value(\room, \output, 0, 1);

    context = v[\trackHelpExample].value(nodes,nodes[\line],"33 / Shur Nocturne");
    context[\lessonNumber] = 33; context[\scoreBeats] = 36.0; context[\tailBeats] = 6;
    alive = {v[\helpExampleAlive].value(context)};

    // FORM / every wait is measured in beats on VOID's shared note clock.
    performance = Routine({
        if(alive.value) {
            context[\section] = 0;
            v[\message].value("33 / Shur Nocturne - Four complete phrases");
            36.0.wait;
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
            6.wait; context[\finished] = true;
        };
        // This also handles deleting a study node while the score is running.
        v[\stopHelpExample].value(context);
        if(context[\finished]==true){v[\message].value("33 / Shur Nocturne finished.")};
    }).play(v[\noteClock],quant:1);
    context[\routines].add(performance);

    // The conductor is queued first, then the note parts share the next beat.
    v[\startSequence].value(nodes[\line]);
    v[\startSequence].value(nodes[\pedalLine]);

    v[\selection] = context[\owned].collect(_[\id]).asSet; v[\fit].value;
    v[\message].value("33 / Shur Nocturne: Audio ON to listen; Stop examples / PANIC to stop.");
} {
    "Evaluate the current VOID.scd and wait for audio to be ready, then run this study.".postln;
};
)
