/*
VOID STUDY 48 / Rooms of Memory

LEARN
Private snapshots, locked parameters and a continuous morph.

COMPOSER'S NOTE
A stable phrase walks between two timbral rooms. Its loudness is locked so the change of colour remains easy to judge.

SCORE
90 BPM; global scale Minor; root 0 semitones above C.
56 beats of material + 4 beats of tail; about 40 seconds.
Form: Room A (8 beats) / Walk toward B (16 beats) / Room B (8 beats) / Walk back (16 beats) / Room A remembered (8 beats).
Hz parameters and MIDI-mode patterns keep their literal pitches.

PLAY
Evaluate the current VOID.scd first. Evaluate this entire parenthesized block.
Audio ON makes the patch audible. It adds its own selected nodes to the canvas.
Use Stop examples or ~void[\stopHelpExamples].value to stop early.
Undo removes the last build; saved patches retain nodes/patterns, while this file runs the written form.
This study sets the shared tempo/root/tuning and stops earlier help-built examples.
Recording and external MIDI output require your own device/button choices.

TRY
1. Unlock the lead gain to include it in the morph.
2. Change only one parameter in the second snapshot.
3. Store similar states in the app toolbar Snapshots and compare the native MORPH control.
*/
(

var v, origin, nodes, context, make, wire, mod, phrase, alive, performance, scaleIndex, capture, morph, ownedIDs, gainIndex;
v = ~void;
if(v.notNil and: {v[\ready]} and: {v[\trackHelpExample].notNil}) {
    scaleIndex = v[\scaleNames].indexOfEqual("Minor");
    if(scaleIndex.isNil) {Error("This VOID installation is missing the study tuning.").throw};
    v[\checkpoint].value;
    v[\stopHelpExamples].value;
    v[\bpm] = 90; v[\root] = 0; v[\scaleMode] = 0;
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
    make.value(\lead, \polysynth, (wave: 0, gain: 0.24, attack: 0.012, release: 0.4));
    make.value(\tone, \filter, (cutoff: 750, resonance: 0.2));
    make.value(\echo, \delay, (sync: 1, division: 0.75, feedback: 0.25, mix: 0.15));
    make.value(\stereo, \pan, (pan: -0.4));
    make.value(\room, \reverb, (mix: 0.22, size: 0.8, shimmer: 0));
    make.value(\score, \note, ());
    nodes[\score][\text] = "48 / Rooms of Memory\nPrivate snapshots, locked parameters and a continuous morph\nRoom A -> Walk toward B -> Room B -> Walk back -> Room A remembered\nStop examples / PANIC ends this score.";

    // MUSICAL MATERIAL / [] is a rest; a nested array is a chord.
    phrase.value(\line, (notes: [[0], [2], [4], [], [6], [4], [2], [1], [0], [3], [5], [4], [2], [1], [0], []], degrees: true));

    // ROUTING / audio and note cables use wire; knob modulation uses mod.
    wire.value(\line, \lead, 0, 1);
    wire.value(\lead, \tone, 0, 1);
    wire.value(\tone, \echo, 0, 1);
    wire.value(\echo, \stereo, 0, 1);
    wire.value(\stereo, \room, 0, 1);
    wire.value(\room, \output, 0, 1);

    context = v[\trackHelpExample].value(nodes,nodes[\line],"48 / Rooms of Memory");
    context[\lessonNumber] = 48; context[\scoreBeats] = 56; context[\tailBeats] = 4;
    alive = {v[\helpExampleAlive].value(context)};

    // These snapshots contain only this study. User toolbar slots remain available.
    ownedIDs = context[\owned].collect(_[\id]).asSet;
    capture = {v[\parameterSnapshot].value.select { |item|ownedIDs.includes(item[\id])}};
    gainIndex = v[\registry][\polysynth][\params].detectIndex { |spec|spec[\key]==\gain };
    nodes[\lead][\params][gainIndex][\locked] = true; v[\sendParam].value(nodes[\lead],gainIndex);
    context[\roomA] = capture.value;
    v[\setParam].value(nodes[\lead], \wave, 2);
    v[\setParam].value(nodes[\lead], \gain, 0.38);
    v[\setParam].value(nodes[\tone], \cutoff, 4200);
    v[\setParam].value(nodes[\tone], \resonance, 0.6);
    v[\setParam].value(nodes[\echo], \mix, 0.42);
    v[\setParam].value(nodes[\stereo], \pan, 0.4);
    context[\roomB] = capture.value; v[\applySnapshot].value(context[\roomA]);
    morph = { |amount|
        context[\roomA].do { |a|
            var b,node;
            b = context[\roomB].detect { |item|item[\id]==a[\id] }; node = v[\find].value(a[\id]);
            if(node.notNil and: {b.notNil}) {
                node[\params].do { |parameter,i|
                    if(parameter[\locked].not) {
                        parameter[\base] = a[\params][i][\base].blend(b[\params][i][\base],amount);
                        v[\sendParam].value(node,i);
                    };
                };
            };
        };
    };

    // FORM / every wait is measured in beats on VOID's shared note clock.
    performance = Routine({
        if(alive.value) {
            context[\section] = 0;
            v[\message].value("48 / Rooms of Memory - Room A");
            morph.value(0);
            8.wait;
        };
        if(alive.value) {
            context[\section] = 1;
            v[\message].value("48 / Rooms of Memory - Walk toward B");
            16.do { |i| if(alive.value) {morph.value((i+1)/16); 1.wait} };
        };
        if(alive.value) {
            context[\section] = 2;
            v[\message].value("48 / Rooms of Memory - Room B");
            morph.value(1);
            8.wait;
        };
        if(alive.value) {
            context[\section] = 3;
            v[\message].value("48 / Rooms of Memory - Walk back");
            16.do { |i| if(alive.value) {morph.value(1-((i+1)/16)); 1.wait} };
        };
        if(alive.value) {
            context[\section] = 4;
            v[\message].value("48 / Rooms of Memory - Room A remembered");
            morph.value(0);
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
        if(context[\finished]==true){v[\message].value("48 / Rooms of Memory finished.")};
    }).play(v[\noteClock],quant:1);
    context[\routines].add(performance);

    // The conductor is queued first, then the note parts share the next beat.
    v[\startSequence].value(nodes[\line]);

    v[\selection] = context[\owned].collect(_[\id]).asSet; v[\fit].value;
    v[\message].value("48 / Rooms of Memory: Audio ON to listen; Stop examples / PANIC to stop.");
} {
    "Evaluate the current VOID.scd and wait for audio to be ready, then run this study.".postln;
};
)
