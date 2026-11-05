/*
VOID STUDY 30 / Shimmer Canopy

LEARN
Long reverberation with restrained octave feedback.

COMPOSER'S NOTE
Widely spaced chord attacks give the room time to become a musical layer.

SCORE
68 BPM; global scale Minor; root 0 semitones above C.
48 beats of material + 8 beats of tail; about 49.4 seconds.
Form: A low canopy (16 beats) / A higher halo (16 beats) / The last light (16 beats).
Hz parameters and MIDI-mode patterns keep their literal pitches.

PLAY
Evaluate the current VOID.scd first. Evaluate this entire parenthesized block.
Audio ON makes the patch audible. It adds its own selected nodes to the canvas.
Use Stop examples or ~void[\stopHelpExamples].value to stop early.
Undo removes the last build; saved patches retain nodes/patterns, while this file runs the written form.
This study sets the shared tempo/root/tuning and stops earlier help-built examples.
Recording and external MIDI output require your own device/button choices.

TRY
1. Set Shimmer to zero and compare the decay.
2. Make the chords shorter while retaining the long room.
3. Reduce the dry contribution as the shimmer rises.
*/
(

var v, origin, nodes, context, make, wire, mod, phrase, alive, performance, scaleIndex;
v = ~void;
if(v.notNil and: {v[\ready]} and: {v[\trackHelpExample].notNil}) {
    scaleIndex = v[\scaleNames].indexOfEqual("Minor");
    if(scaleIndex.isNil) {Error("This VOID installation is missing the study tuning.").throw};
    v[\checkpoint].value;
    v[\stopHelpExamples].value;
    v[\bpm] = 68; v[\root] = 0; v[\scaleMode] = 0;
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
    make.value(\changes, \noteseq, (base: 48, division: 0.25, length: 4, gateLength: 0.6));
    make.value(\chords, \polysynth, (wave: 3, gain: 0.25, attack: 0.1, release: 1.4));
    make.value(\room, \reverb, (size: 0.94, mix: 0.38, shimmer: 0.05, damping: 0.45));
    make.value(\stereo, \pan, (auto: 0.25, rate: 0.055));
    make.value(\score, \note, ());
    nodes[\score][\text] = "30 / Shimmer Canopy\nLong reverberation with restrained octave feedback\nA low canopy -> A higher halo -> The last light\nStop examples / PANIC ends this score.";

    // MUSICAL MATERIAL / [] is a rest; a nested array is a chord.
    phrase.value(\changes, (notes: [[0, 2, 4, 6], [3, 5, 7, 9], [5, 7, 9, 11], [0, 2, 4, 6]], degrees: true, velocity: [75, 62, 69, 56]));

    // ROUTING / audio and note cables use wire; knob modulation uses mod.
    wire.value(\changes, \chords, 0, 1);
    wire.value(\chords, \room, 0, 1);
    wire.value(\room, \stereo, 0, 1);
    wire.value(\stereo, \output, 0, 1);

    context = v[\trackHelpExample].value(nodes,nodes[\changes],"30 / Shimmer Canopy");
    context[\lessonNumber] = 30; context[\scoreBeats] = 48; context[\tailBeats] = 8;
    alive = {v[\helpExampleAlive].value(context)};

    // FORM / every wait is measured in beats on VOID's shared note clock.
    performance = Routine({
        if(alive.value) {
            context[\section] = 0;
            v[\message].value("30 / Shimmer Canopy - A low canopy");
            16.wait;
        };
        if(alive.value) {
            context[\section] = 1;
            v[\message].value("30 / Shimmer Canopy - A higher halo");
            v[\setParam].value(nodes[\room], \shimmer, 0.2);
            16.wait;
        };
        if(alive.value) {
            context[\section] = 2;
            v[\message].value("30 / Shimmer Canopy - The last light");
            v[\setParam].value(nodes[\room], \shimmer, 0.3);
            v[\setParam].value(nodes[\chords], \gain, 0.18);
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
        if(context[\finished]==true){v[\message].value("30 / Shimmer Canopy finished.")};
    }).play(v[\noteClock],quant:1);
    context[\routines].add(performance);

    // The conductor is queued first, then the note parts share the next beat.
    v[\startSequence].value(nodes[\changes]);

    v[\selection] = context[\owned].collect(_[\id]).asSet; v[\fit].value;
    v[\message].value("30 / Shimmer Canopy: Audio ON to listen; Stop examples / PANIC to stop.");
} {
    "Evaluate the current VOID.scd and wait for audio to be ready, then run this study.".postln;
};
)
