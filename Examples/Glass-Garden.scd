(
// Glass Garden · a complete 32-bar piece
// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.
var v, origin, nodes, context;
v = ~void;
if(v.notNil and: {v[\ready]}) {
    v[\checkpoint].value;
    origin = v[\helpExampleOrigin].value;
    nodes = (output:v[\output]);
    nodes['leadSeq'] = v[\add].value('noteseq', origin + (0 @ 0), false);
    v[\setParam].value(nodes['leadSeq'], 'base', 60);
    v[\setParam].value(nodes['leadSeq'], 'division', 2);
    v[\setParam].value(nodes['leadSeq'], 'gateLength', 0.7);
    v[\setParam].value(nodes['leadSeq'], 'length', 16);
    nodes['lead'] = v[\add].value('polysynth', origin + (295 @ 0), false);
    v[\setParam].value(nodes['lead'], 'attack', 0.012);
    v[\setParam].value(nodes['lead'], 'gain', 0.28);
    v[\setParam].value(nodes['lead'], 'release', 0.45);
    v[\setParam].value(nodes['lead'], 'wave', 0);
    nodes['padSeq'] = v[\add].value('noteseq', origin + (590 @ 0), false);
    v[\setParam].value(nodes['padSeq'], 'base', 48);
    v[\setParam].value(nodes['padSeq'], 'division', 0.25);
    v[\setParam].value(nodes['padSeq'], 'gateLength', 0.9);
    v[\setParam].value(nodes['padSeq'], 'length', 1);
    nodes['pad'] = v[\add].value('polysynth', origin + (0 @ 305), false);
    v[\setParam].value(nodes['pad'], 'attack', 0.35);
    v[\setParam].value(nodes['pad'], 'cutoff', 3400);
    v[\setParam].value(nodes['pad'], 'gain', 0.2);
    v[\setParam].value(nodes['pad'], 'release', 2);
    v[\setParam].value(nodes['pad'], 'wave', 3);
    nodes['bassSeq'] = v[\add].value('noteseq', origin + (295 @ 305), false);
    v[\setParam].value(nodes['bassSeq'], 'base', 36);
    v[\setParam].value(nodes['bassSeq'], 'division', 1);
    v[\setParam].value(nodes['bassSeq'], 'gateLength', 0.6);
    v[\setParam].value(nodes['bassSeq'], 'length', 8);
    nodes['bass'] = v[\add].value('polysynth', origin + (590 @ 305), false);
    v[\setParam].value(nodes['bass'], 'attack', 0.015);
    v[\setParam].value(nodes['bass'], 'cutoff', 1200);
    v[\setParam].value(nodes['bass'], 'gain', 0);
    v[\setParam].value(nodes['bass'], 'release', 0.24);
    v[\setParam].value(nodes['bass'], 'wave', 0);
    nodes['rhythm'] = v[\add].value('euclid', origin + (0 @ 610), false);
    v[\setParam].value(nodes['rhythm'], 'division', 4);
    v[\setParam].value(nodes['rhythm'], 'pulses', 5);
    v[\setParam].value(nodes['rhythm'], 'steps', 16);
    nodes['drum'] = v[\add].value('pluck', origin + (295 @ 610), false);
    v[\setParam].value(nodes['drum'], 'auto', 0);
    v[\setParam].value(nodes['drum'], 'coef', 0.65);
    v[\setParam].value(nodes['drum'], 'decay', 0.16);
    v[\setParam].value(nodes['drum'], 'freq', 70);
    v[\setParam].value(nodes['drum'], 'gain', 0);
    nodes['cloud'] = v[\add].value('granular', origin + (590 @ 610), false);
    v[\setParam].value(nodes['cloud'], 'density', 16);
    v[\setParam].value(nodes['cloud'], 'gain', 0.04);
    v[\setParam].value(nodes['cloud'], 'pitchScatter', 0);
    v[\setParam].value(nodes['cloud'], 'scan', 0.018);
    v[\setParam].value(nodes['cloud'], 'size', 0.09);
    nodes['mix'] = v[\add].value('mixer', origin + (0 @ 915), false);
    v[\setParam].value(nodes['mix'], 'gain0', 0.7);
    v[\setParam].value(nodes['mix'], 'gain1', 0.6);
    v[\setParam].value(nodes['mix'], 'gain2', 0.7);
    v[\setParam].value(nodes['mix'], 'gain3', 0.5);
    v[\setParam].value(nodes['mix'], 'pan0', 0.15);
    v[\setParam].value(nodes['mix'], 'pan1', -0.25);
    nodes['tone'] = v[\add].value('filter', origin + (295 @ 915), false);
    v[\setParam].value(nodes['tone'], 'cutoff', 700);
    v[\setParam].value(nodes['tone'], 'resonance', 0.24);
    nodes['echo'] = v[\add].value('delay', origin + (590 @ 915), false);
    v[\setParam].value(nodes['echo'], 'division', 0.75);
    v[\setParam].value(nodes['echo'], 'feedback', 0.38);
    v[\setParam].value(nodes['echo'], 'mix', 0.25);
    v[\setParam].value(nodes['echo'], 'sync', 1);
    nodes['space'] = v[\add].value('reverb', origin + (0 @ 1220), false);
    v[\setParam].value(nodes['space'], 'mix', 0.3);
    v[\setParam].value(nodes['space'], 'shimmer', 0.08);
    v[\setParam].value(nodes['space'], 'size', 0.9);
    nodes['stereo'] = v[\add].value('pan', origin + (295 @ 1220), false);
    v[\setParam].value(nodes['stereo'], 'auto', 0.15);
    v[\setParam].value(nodes['stereo'], 'rate', 0.07);
    nodes['display'] = v[\add].value('scope', origin + (590 @ 1220), false);
    v[\setParam].value(nodes['display'], 'mode', 1);
    nodes['score'] = v[\add].value('note', origin + (0 @ 1525), false);
    v[\helpPattern].value(nodes['leadSeq'], ('node': 'leadSeq', 'notes': [[0], [2], [4], [], [7], [4], [2], [1], [0], [], [2], [4], [6], [4], [2], []], 'degrees': true));
    v[\helpPattern].value(nodes['padSeq'], ('node': 'padSeq', 'velocity': [62], 'notes': [[0, 2, 4, 6]], 'degrees': true, 
  'duration': [2]));
    v[\helpPattern].value(nodes['bassSeq'], ('notes': [[0], [0], [4], [0], [7], [4], [2], [4]], 'velocity': [86, 58, 72, 56, 80, 60, 70, 52], 'node': 'bassSeq', 'degrees': true));
    nodes['score'][\text] = "GLASS GARDEN
Dawn / Motion / Mirror / Return
8 bars each + 2 bars of tail
Uses the current tempo, root and scale.
Stop examples or PANIC ends the performance.";
    v[\loadSound].value(nodes['cloud'], Platform.resourceDir +/+ "sounds/a11wlk01.wav", false);
    v[\connect].value(nodes['leadSeq'], 0, nodes['lead'], 0, nil, 1, false);
    v[\connect].value(nodes['padSeq'], 0, nodes['pad'], 0, nil, 1, false);
    v[\connect].value(nodes['bassSeq'], 0, nodes['bass'], 0, nil, 1, false);
    v[\connect].value(nodes['rhythm'], 0, nodes['drum'], 0, nil, 1, false);
    v[\connect].value(nodes['lead'], 0, nodes['mix'], 0, nil, 1, false);
    v[\connect].value(nodes['pad'], 0, nodes['mix'], 1, nil, 1, false);
    v[\connect].value(nodes['bass'], 0, nodes['mix'], 2, nil, 1, false);
    v[\connect].value(nodes['drum'], 0, nodes['mix'], 3, nil, 1, false);
    v[\connect].value(nodes['cloud'], 0, nodes['mix'], 3, nil, 1, false);
    v[\connect].value(nodes['mix'], 0, nodes['tone'], 0, nil, 1, false);
    v[\connect].value(nodes['tone'], 0, nodes['echo'], 0, nil, 1, false);
    v[\connect].value(nodes['echo'], 0, nodes['space'], 0, nil, 1, false);
    v[\connect].value(nodes['space'], 0, nodes['stereo'], 0, nil, 1, false);
    v[\connect].value(nodes['stereo'], 0, nodes['display'], 0, nil, 1, false);
    v[\connect].value(nodes['display'], 0, nodes['output'], 0, nil, 1, false);
    context = v[\trackHelpExample].value(nodes, nodes['leadSeq'], "Glass Garden · a complete 32-bar piece");
    // Complete score and arrangement: four eight-bar sections, then a two-bar tail.
    ({ |context|
    var app,nodes,routine;
    app = ~void; nodes = context[\nodes];
    routine = Routine({
        var sections,melodies,roots,section,phrase,root,settings,lead,bass,pad;
        sections = [
            (name:"Dawn",lead:0.23,pad:0.2,bass:0,drum:0,cloud:0.04,cutoff:700,wave:0,pulses:3),
            (name:"Motion",lead:0.29,pad:0.18,bass:0.24,drum:0.2,cloud:0.055,cutoff:2200,wave:3,pulses:5),
            (name:"Mirror",lead:0.27,pad:0.17,bass:0.26,drum:0.22,cloud:0.045,cutoff:3700,wave:4,pulses:7),
            (name:"Return",lead:0.2,pad:0.2,bass:0.15,drum:0.09,cloud:0.02,cutoff:950,wave:0,pulses:3)
        ];
        melodies = [
            [[0],[2],[4],[],[7],[4],[2],[1],[0],[],[2],[4],[6],[4],[2],[]],
            [[0],[4],[2],[6],[4],[7],[6],[2],[0],[2],[4],[7],[9],[7],[4],[2]],
            [[7],[6],[4],[2],[0],[],[2],[4],[6],[4],[2],[1],[0],[2],[4],[]],
            [[0],[],[2],[],[4],[],[2],[],[0],[],[],[1],[0],[],[],[]]
        ];
        roots = [0,3,5,4]; section = 0;
        while {section<4 and: {app[\helpExampleAlive].value(context)}} {
            settings = sections[section]; context[\section] = section;
            app[\setParam].value(nodes[\lead],\gain,settings[\lead]);
            app[\setParam].value(nodes[\lead],\wave,settings[\wave]);
            app[\setParam].value(nodes[\pad],\gain,settings[\pad]);
            app[\setParam].value(nodes[\bass],\gain,settings[\bass]);
            app[\setParam].value(nodes[\drum],\gain,settings[\drum]);
            app[\setParam].value(nodes[\cloud],\gain,settings[\cloud]);
            app[\setParam].value(nodes[\tone],\cutoff,settings[\cutoff]);
            app[\setParam].value(nodes[\rhythm],\pulses,settings[\pulses]);
            app[\setParam].value(nodes[\rhythm],\rotation,section);
            if(context[\focus][\type]==\stutter){app[\setParam].value(context[\focus],\repeat,if(section==2){1}{0})};
            app[\message].value("Glass Garden · "++settings[\name]++" · section "++(section+1)++" / 4");
            phrase = 0;
            while {phrase<4 and: {app[\helpExampleAlive].value(context)}} {
                root = roots[phrase];
                lead = nodes[\leadSeq]; bass = nodes[\bassSeq]; pad = nodes[\padSeq];
                16.do { |i|
                    lead[\noteSteps][i] = (notes:melodies[section][i]+root,enabled:true,
                        velocity:[91,59,76,55,84,62,72,58].wrapAt(i),probability:1,duration:1);
                    bass[\noteSteps][i] = (notes:[0,0,4,0,7,4,2,4].wrapAt(i).asArray+root,
                        enabled:true,velocity:[86,58,72,56,80,60,70,52].wrapAt(i),probability:1,duration:1);
                    pad[\noteSteps][i] = (notes:[0,2,4,6]+root,enabled:true,velocity:62,probability:1,duration:2);
                };
                if(context[\focus][\type]==\drone){app[\setParam].value(context[\focus],\rootNote,app[\degreeNote].value(root,36))};
                if([\osc,\fm].includes(context[\focus][\type])){app[\setParam].value(context[\focus],\freq,app[\degreeNote].value(root,36).midicps)};
                context[\phrase] = phrase; context[\rootDegree] = root;
                // One phrase is two 4/4 bars. Four phrases make each eight-bar section.
                8.wait; phrase = phrase+1;
            };
            section = section+1;
        };
        if(app[\helpExampleAlive].value(context)) {
            [\leadSeq,\padSeq,\bassSeq].do { |key|app[\stopSequence].value(nodes[key])};
            app[\setParam].value(nodes[\drum],\gain,0); app[\setParam].value(nodes[\cloud],\gain,0);
            // Let the instrument releases, echoes and room ring for two more bars.
            8.wait; context[\finished] = true; app[\stopHelpExample].value(context);
            app[\message].value("Glass Garden finished: 32 bars and a two-bar tail.");
        };
    }).play(app[\noteClock],quant:1);
    context[\routines].add(routine);
}).value(context);
    v[\startSequence].value(nodes['leadSeq']);
    v[\startSequence].value(nodes['padSeq']);
    v[\startSequence].value(nodes['bassSeq']);
    v[\selection] = Set[context[\focus][\id]]; v[\fit].value;
} { "Open VOID and restart its audio first.".postln; };
// Stop this and other help-built examples: ~void[\stopHelpExamples].value;
)