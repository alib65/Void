/*
VOID / an experimental instrument and patch canvas
SuperCollider 3.13+ / core UGens and Qt only
Select this entire file and evaluate. Close the window to release its resources.
Sound pools hold up to 16 mono grain sources; PLAYER preserves stereo files.
*/
(
var v;
if(~void.notNil and: { ~void[\close].notNil }) { ~void[\close].value };
~void = ();
v = ~void;

// 1 Config & theme ------------------------------------------------------------
v[\server] = s;
v[\alive] = true;
v[\ready] = false;
v[\nodes] = List.new;
v[\cords] = List.new;
v[\retired] = List.new;
v[\selection] = Set.new;
v[\nextID] = 1;
v[\undo] = List.new;
v[\redo] = List.new;
v[\snapshots] = Array.newClear(8);
v[\snapshotA] = 0; v[\snapshotB] = 1;
v[\zoom] = 1.0; v[\pan] = 30@40;
v[\bpm] = 110; v[\root] = 0; v[\scaleIndex] = 1;
v[\globalChaos] = 0.25; v[\audioOn] = true;
v[\leftOpen] = true; v[\rightOpen] = true;
v[\inspectorScroll] = 0; v[\libraryScroll] = 0;
v[\space] = false; v[\help] = false;
v[\recording] = false; v[\recordBusy] = false;
v[\status] = "Welcome to VOID. Demo builds a playable patch.";
v[\hits] = List.new; v[\knobHits] = List.new;
v[\paletteHits] = List.new; v[\cableSegments] = List.new;
v[\bg] = Color.new255(7,7,10);
v[\panel] = Color.new255(15,15,20);
v[\glass] = Color.new255(20,20,26);
v[\ink] = Color.new255(232,233,240);
v[\muted] = Color.new255(128,131,148);
v[\line] = Color.new255(41,42,53);
v[\colors] = [Color.new255(71,221,229), Color.new255(221,103,225),
    Color.new255(244,181,88), Color.new255(184,222,108)];
v[\categories] = ["SOURCES", "MODULATORS & TIME", "PROCESSORS", "UTILITY"];
v[\scaleNames] = ["Chromatic", "Minor", "Major", "Dorian", "Pentatonic", "Whole tone"];
v[\scales] = [(0..11), [0,2,3,5,7,8,10], [0,2,4,5,7,9,11],
    [0,2,3,5,7,9,10], [0,3,5,7,10], [0,2,4,6,8,10]];
// Keep the original six indices so version-1 patches retain their tuning.
v[\scaleCatalog] = v[\scaleNames].collect { |name,i|
    (name:name, degrees:v[\scales][i], period:12, group:"Common")
}.as(List);
v[\addScale] = { |name,degrees,period=12,group="Scales"|
    v[\scaleCatalog].add((name:name,degrees:degrees.collect { |degree|degree.mod(period).round(0.000000001) }.as(Set).asArray.sort,period:period,group:group))
};
Scale.names.do { |key|
    var scale;
    scale = Scale.at(key);
    v[\addScale].value(scale.name++" ("++key++")",scale.semitones,scale.stepsPerOctave,
        if(scale.pitchesPerOctave==24){"Arabic / 24-tone"}{"Core scales"});
};
Tuning.names.do { |key|
    var tuning;
    tuning = Tuning.at(key);
    v[\addScale].value(tuning.name++" ("++key++")",tuning.semitones,tuning.stepsPerOctave,"Tunings");
};
// Reference pitch collections, not a model of dastgah/maqam melodic practice.
[
    ["Shur",[0,1.5,3,5,7,8,10]], ["Shur (lowered fifth)",[0,1.5,3,5,6.5,8,10]], ["Abu Ata",[0,1.5,3,5,7,8,10]],
    ["Dashti",[0,1.5,3,5,7,8,10]], ["Bayat-e Tork",[0,1.5,3,5,7,8,10]],
    ["Afshari",[0,1.5,3,5,6.5,8,10]], ["Segah",[0,1.5,3.5,5.5,7,8.5,10.5]],
    ["Chahargah",[0,1.5,4,5,7,8.5,11]], ["Homayun",[0,1.5,4,5,7,8,10]],
    ["Bayat-e Esfahan",[0,2,3,5,7,8.5,11]], ["Mahur",[0,2,4,5,7,9,11]],
    ["Nava",[0,2,3.5,5,7,9,10]], ["Rast Panjgah",[0,2,4,5,7,9,11]]
].do { |item|v[\addScale].value("Persian · "++item[0]++" (24-EDO approx.)",item[1],12,"Persian")};
(2..127).do { |edo|v[\addScale].value(edo.asString++" EDO",Array.series(edo,0,12/edo),12,"EDO")};
v[\scaleNames] = v[\scaleCatalog].collect(_[\name]).asArray;
v[\scales] = v[\scaleCatalog].collect(_[\degrees]).asArray;
v[\scaleMode] = 0; v[\customScale] = nil;
v[\scaleResolution] = 16384;
v[\noteTypes] = [\midiin,\midiout,\noteseq];
v[\midiDefs] = List.new; v[\midiConnections] = Set.new;
v[\noteSerial] = 0; v[\cordSerial] = 0;
v[\noteClock] = TempoClock.new(v[\bpm]/60).permanent_(true);
v[\rootNames] = ["C","C#","D","D#","E","F","F#","G","G#","A","A#","B"];
v[\modes] = ["Smooth", "Step", "Walk", "Trigger", "Scale"];
v[\font] = Font.default.copy.size_(12);
v[\smallFont] = Font.default.copy.size_(10);
v[\titleFont] = Font.default.copy.size_(13).bold_(true);
v[\message] = { |message| v[\status] = message.asString; message.postln };
v[\spec] = { |key, label, low=0, high=1, default=0.5, warp=\lin, pitch=nil|
    (key:key, label:label, min:low, max:high, default:default, warp:warp, pitch:pitch)
};
v[\norm] = { |spec, value|
    if(spec[\warp] == \exp) {
        value.clip(spec[\min], spec[\max]).explin(spec[\min], spec[\max], 0, 1)
    } { value.linlin(spec[\min], spec[\max], 0, 1).clip(0,1) }
};
v[\actual] = { |spec, norm|
    if(spec[\warp] == \exp) { norm.clip(0,1).linexp(0,1,spec[\min],spec[\max]) }
    { norm.clip(0,1).linlin(0,1,spec[\min],spec[\max]) }
};
v[\format] = { |value|
    if(value.abs >= 1000) { (value / 1000).round(0.01).asString ++ "k" }
    { value.round(if(value.abs < 10) {0.01} {0.1}).asString }
};
v[\find] = { |id| v[\nodes].detect { |n| n[\id] == id } };
v[\selected] = { v[\nodes].detect { |n| v[\selection].includes(n[\id]) } };

// 2 Server & SynthDefs --------------------------------------------------------
// Deferred construction lets the registry supply each DSP function.
v[\defineDefs] = {
    SynthDef(\void_audioCord, { |src=0, dst=0, amount=1, life=1|
        var fade;
        fade = EnvGen.kr(Env.asr(0.03,1,0.04), life, doneAction:2);
        Out.ar(dst, InFeedback.ar(src,2) * amount.lag(0.03) * fade);
    }).add;
    SynthDef(\void_controlCord, { |src=0, dst=0, amount=0.25, life=1|
        var fade;
        fade = EnvGen.kr(Env.asr(0.03,1,0.04), life, doneAction:2);
        Out.kr(dst, In.kr(src) * amount.lag(0.03) * fade);
    }).add;
    SynthDef(\void_clearAudio, { |bus=0| ReplaceOut.ar(bus, DC.ar([0,0])) }).add;
    SynthDef(\void_clearControl, { |bus=0| ReplaceOut.kr(bus, 0) }).add;
    SynthDef(\void_hardware, { |bus=0, on=1, panic=0|
        var sound;
        sound = Limiter.ar(LeakDC.ar(InFeedback.ar(bus,2)), 0.966, 0.01);
        Out.ar(0, sound * on.lag(0.04) * (1-panic));
    }).add;
    SynthDef(\void_disk, { |bus=0, buf=0| DiskOut.ar(buf, InFeedback.ar(bus,2)) }).add;
    SynthDef(\void_voice,{ |out=0,freq=440,velocity=0.7,gate=1,paramsBus=0,bend=0|
        var pitch,sound,env,params,wave,attack,release,cutoff;
        params = In.kr(paramsBus,4); wave = params[0]; attack = params[1]; release = params[2]; cutoff = params[3];
        pitch = (freq*(2**(bend/12))).clip(8,20000);
        env = EnvGen.kr(Env.asr(attack.max(0.001),1,release.max(0.01)),gate+Impulse.kr(0),doneAction:2);
        sound = SelectX.ar(wave.clip(0,4),[SinOsc.ar(pitch),Saw.ar(pitch)*0.45,
            Pulse.ar(pitch)*0.35,LFTri.ar(pitch)*0.7,SinOsc.ar(pitch+(SinOsc.ar(pitch*2)*pitch*2))*0.6]);
        Out.ar(out,Pan2.ar(LPF.ar(sound,cutoff.clip(30,19000))*env*velocity*0.18));
    }).add;
    v[\order].do { |key|
        var reg;
        reg = v[\registry][key];
        if(([\note]++v[\noteTypes]).includes(key).not) {
            SynthDef(reg[\def], {
                var inputs, trigger, p, result, audio, ctrl, fade, active, dry, peaks, scope;
                inputs = reg[\inputs].collect { |port,i|
                    var bus;
                    bus = ("in"++i).asSymbol.kr(0);
                    if(port[\kind] == \audio) { InFeedback.ar(bus,2) } { In.kr(bus) }
                };
                trigger = inputs.last + \hit.tr(0);
                p = v[\paramGraph].value(reg, trigger);
                result = reg[\dsp].value(p, inputs, trigger);
                audio = result[\a]; ctrl = result[\k];
                fade = EnvGen.kr(Env.asr(0.035,1,0.04), \life.kr(1), doneAction:2);
                active = \active.kr(1).lag(0.035);
                peaks = [0,0]; scope = [];
                if(audio.notNil) {
                    dry = if(reg[\category] >= 2 and: { reg[\inputs].first[\kind] == \audio })
                        { inputs.first } { DC.ar([0,0]) };
                    audio = LeakDC.ar(audio);
                    audio = Select.ar(CheckBadValues.ar(audio, 0, 0) > 0, [audio, DC.ar(0)]);
                    audio = audio.tanh;
                    audio = ((audio * active) + (dry * (1-active))) * fade;
                    if(key == \output) { audio = Limiter.ar(audio,0.966,0.01) };
                    Out.ar(\out.kr(0), audio);
                    peaks = Amplitude.kr(audio,0.01,0.15);
                    if(key == \scope) {
                        var wave, spectrum;
                        wave = A2K.kr(DelayN.ar(audio.sum * 0.5,0.05,Array.series(32,0,0.001)));
                        spectrum = Amplitude.kr(BPF.ar(audio.sum * 0.5,Array.geom(32,35,1.22),0.12),0.01,0.1);
                        scope = Select.kr(p[\mode].round, [wave,spectrum]);
                    };
                };
                if(ctrl.notNil) {
                    ctrl = ctrl.clip(-8,8) * active * fade;
                    Out.kr(\controlOut.kr(0), ctrl);
                    if(audio.isNil) { peaks = [ctrl.abs,ctrl.abs] };
                };
                SendReply.kr(Impulse.kr(15), '/void/node',
                    [\uid.kr(0)] ++ peaks ++ [result[\pos] ? 0,result[\sound] ? -1] ++ p[\values] ++ scope);
            }).add;
        };
    };
};

// 3 Parameter engine ----------------------------------------------------------
// Every base, random window and modulation sum is evaluated on scsynth.
// The lookup contains actual semitone offsets, including the wrap at the period.
// Its size is independent of the number of degrees (127 EDO is never truncated).
v[\quantize] = { |note, scale, root|
    var period, relative, position;
    period = \scalePeriod.kr(12).max(0.01); relative = note-root;
    position = (relative.mod(period)/period*v[\scaleResolution]).round;
    ((relative/period).floor*period) + root + Index.kr(\scaleBuf.kr(0),position)
};
v[\activeScale] = {
    var entry,degrees,mode,period;
    entry = v[\customScale] ? v[\scaleCatalog][v[\scaleIndex]];
    period = entry[\period]; degrees = entry[\degrees];
    mode = v[\scaleMode].asInteger.mod(degrees.size);
    (name:entry[\name],period:period,
        degrees:degrees.collect { |degree|(degree-degrees[mode]).mod(period) }.sort)
};
v[\quantizeNote] = { |note|
    var scale,period,relative,octave,targets;
    scale = v[\activeScale].value; period = scale[\period]; relative = note-v[\root];
    octave = (relative/period).floor;
    targets = (scale[\degrees]++[period]).collect { |degree|degree+(octave*period)+v[\root] };
    targets.minItem { |candidate|(candidate-note).abs }
};
v[\degreeNote] = { |degree,base=60|
    var scale,count,whole,fraction,a,b;
    scale = v[\activeScale].value; count = scale[\degrees].size;
    whole = degree.floor.asInteger; fraction = degree-whole;
    a = scale[\degrees].wrapAt(whole)+((whole/count).floor*scale[\period]);
    b = scale[\degrees].wrapAt(whole+1)+(((whole+1)/count).floor*scale[\period]);
    base+v[\root]+a.blend(b,fraction)
};
v[\updateScaleBuffer] = {
    var scale,signature,targets,index,table;
    scale = v[\activeScale].value; signature = [scale[\degrees],scale[\period]].asCompileString;
    if(v[\scaleBuffer].notNil and: {signature!=v[\scaleSignature]}) {
        targets = scale[\degrees]++[scale[\period]]; index = 0;
        table = FloatArray.fill(v[\scaleResolution]+1,{ |i|
            var position;
            position = i/v[\scaleResolution]*scale[\period];
            while {index<(targets.size-1) and: {position>((targets[index]+targets[index+1])/2)}} {index = index+1};
            targets[index]
        });
        // Small packets avoid UDP limits, and preserve ordering before /s_new.
        table.clump(512).do { |part,i|v[\scaleBuffer].setn(i*512,part)};
        v[\scaleSignature] = signature;
    };
};
v[\paramGraph] = { |reg, trigger|
    var p, bpm, scale, root, tick, chaos;
    p = (); bpm = \bpm.kr(110).max(20);
    scale = \scaleBuf.kr(0);
    root = \root.kr(0); tick = Impulse.kr(bpm/60) + trigger;
    chaos = (\chaos.kr(0) * \chaosAmount.kr(0.5) * \globalChaos.kr(0.25)).lag(0.1);
    p[\values] = reg[\params].collect { |spec,i|
        var base, enabled, mode, rate, depth, low, high, noise, value, actual, mod, locked;
        base = ("p"++i).asSymbol.kr(v[\norm].value(spec,spec[\default]));
        locked = ("l"++i).asSymbol.kr(0);
        enabled = ("r"++i).asSymbol.kr(0) * (1-locked);
        mode = ("m"++i).asSymbol.kr(0).round.clip(0,4);
        rate = ("t"++i).asSymbol.kr(0.3).clip(0.01,40);
        depth = ("d"++i).asSymbol.kr(0.2).clip(0,1);
        low = ("lo"++i).asSymbol.kr(0);
        high = ("hi"++i).asSymbol.kr(1);
        mod = In.kr(("mb"++i).asSymbol.kr(0));
        noise = Select.kr(mode, [LFNoise2.kr(rate), LFNoise0.kr(rate),
            Demand.kr(Impulse.kr(rate),0,Dbrown(-1,1,0.22,inf)).lag(0.1/rate),
            TRand.kr(-1,1,tick), LFNoise0.kr(rate)]).clip(-1,1);
        value = Select.kr(enabled, [base, (base + (noise * depth)).clip(low.min(high),low.max(high))]);
        value = (value + mod).clip(0,1).lag(0.025);
        actual = if(spec[\warp] == \exp) { spec[\min] * ((spec[\max]/spec[\min]) ** value) }
            { value.linlin(0,1,spec[\min],spec[\max]) };
        if(spec[\pitch].notNil) {
            var note, quant;
            note = switch(spec[\pitch], \hz, {actual.max(0.01).cpsmidi},
                \ratio, {actual.max(0.01).log2*12+60}, {actual});
            quant = v[\quantize].value(note,scale,root);
            quant = switch(spec[\pitch], \hz, {quant.midicps},
                \ratio, {2 ** ((quant-60)/12)}, {quant});
            actual = Select.kr(mode.eq(4) * enabled, [actual,quant]);
        };
        actual = actual.lag(0.015);
        p[spec[\key]] = actual;
        p[(spec[\key].asString++"Chaos").asSymbol] = chaos * (1-locked);
        actual
    };
    p[\bpm] = bpm; p[\scale] = scale; p[\root] = root;
    p[\tick] = tick; p[\chaos] = chaos;
    p
};
v[\sendParam] = { |node,i|
    var p;
    p = node[\params][i];
    if(v[\ready] and: {node[\synth].notNil}) {
        node[\synth].set(("p"++i).asSymbol,p[\base], ("r"++i).asSymbol,(p[\random] and: {p[\locked].not}).asInteger,
            ("l"++i).asSymbol,p[\locked].asInteger,
            ("m"++i).asSymbol,p[\mode], ("t"++i).asSymbol,p[\rate],
            ("d"++i).asSymbol,p[\depth], ("lo"++i).asSymbol,p[\low], ("hi"++i).asSymbol,p[\high]);
    };
};
v[\setParam] = { |node,key,value|
    var index;
    index = v[\registry][node[\type]][\params].detectIndex { |spec| spec[\key] == key };
    if(index.notNil) {
        node[\params][index][\base] = v[\norm].value(v[\registry][node[\type]][\params][index],value);
        v[\sendParam].value(node,index);
    };
};
v[\globalArgs] = {
    [\bpm,v[\bpm],\root,v[\root],\scaleBuf,(v[\scaleBuffer].bufnum ? 0),
        \scalePeriod,v[\activeScale].value[\period],\globalChaos,v[\globalChaos]]
};
v[\sendGlobals] = {
    v[\noteClock].tempo = v[\bpm]/60;
    v[\updateScaleBuffer].value;
    v[\nodes].do { |n| if(n[\synth].notNil) {n[\synth].set(*v[\globalArgs].value)} };
};

// 4 Object registry -----------------------------------------------------------
// Add an entry with params, audio inlet count, control output flag and DSP.
v[\registry] = IdentityDictionary.new;
v[\order] = List.new;
v[\register] = { |key,name,category,audioIns,hasAudio,hasControl,params,dsp,character|
    v[\registry][key] = (name:name,category:category,params:params,dsp:dsp,
        character:character,def:("void_"++key).asSymbol,nodeDrawing:{ |node|v[\drawNode].value(node)},
        inputs:Array.fill(audioIns,{ |i| (name:if(audioIns==1){"Audio"}{"Input "++(i+1)},kind:\audio) })
            ++ [(name:"Trigger",kind:\control)],
        outputs:if(hasAudio){[(name:"Stereo",kind:\audio)]}{[]}
            ++ if(hasControl){[(name:"Control / trigger",kind:\control)]}{[]});
    v[\order].add(key);
};
// Compact parameter factory is always called with explicit musical ranges.
v[\register].value(\player,"PLAYER",0,0,true,false,[
    v[\spec].value(\rate,"Rate",-4,4,1), v[\spec].value(\gain,"Gain",0,1,0.5),
    v[\spec].value(\start,"Start",0,0.999,0), v[\spec].value(\end,"End",0.001,1,1),
    v[\spec].value(\loop,"Loop",0,1,1)
], { |p,ins,tr|
    var buf, right, frames, start, end, rate, jump, phase, reset, travel, playing, sound;
    buf = \buf.kr(0); right = \bufR.kr(0); frames = BufFrames.kr(buf).max(2);
    start = p[\start].min(p[\end]-0.001).max(0) * frames;
    end = p[\end].max(p[\start]+0.001).min(1) * frames;
    jump = Dust.kr(p[\startChaos]*8); tr = tr + Impulse.kr(0) + jump;
    rate = (p[\rate] + (TRand.kr(-3,3,jump)*p[\rateChaos])).clip(-4,4);
    reset = Select.kr(rate < 0,[start,end-1]);
    reset = (reset + (TRand.kr(0,1,jump)*(end-start)*p[\startChaos])).clip(start,end-1);
    phase = Phasor.ar(tr,rate*BufRateScale.kr(buf),start,end,reset);
    travel = Sweep.kr(tr,rate.abs/BufDur.kr(buf).max(0.001));
    playing = (p[\loop].round + (travel < ((end-start)/frames))).clip(0,1).lag(0.025);
    sound = [BufRd.ar(1,buf,phase,1,4),BufRd.ar(1,right,phase,1,4)] * p[\gain] * playing;
    sound = sound * (1-(Decay2.kr(jump,0.002,0.04)*p[\gainChaos]*0.7));
    (a:sound, pos:A2K.kr(phase)/frames)
}, "Dust jumps, reverse playback and short stochastic stutters.");

v[\register].value(\granular,"GRANULAR CLOUD",0,0,true,false,[
    v[\spec].value(\position,"Position",0,1,0.3), v[\spec].value(\density,"Density",0.2,140,22,\exp),
    v[\spec].value(\pitch,"Pitch",0.125,4,1,\exp,\ratio), v[\spec].value(\size,"Grain size",0.005,1,0.15,\exp),
    v[\spec].value(\sound,"Sound / morph",0,15,0), v[\spec].value(\scan,"Scan speed",-2,2,0.03),
    v[\spec].value(\pitchScatter,"Pitch scatter",0,24,0.3), v[\spec].value(\positionScatter,"Position scatter",0,1,0.08),
    v[\spec].value(\spread,"Stereo spread",0,1,0.8), v[\spec].value(\shape,"Envelope shape",0,3,0),
    v[\spec].value(\freeze,"Freeze",0,1,0), v[\spec].value(\gain,"Gain",0,1,0.3),
    v[\spec].value(\quantize,"Quantize scatter",0,1,0)
], { |p,ins,tr|
    var bufs, envs, count, density, clock, choice, pick, buf, phase, pos, pitch, scatter, sound;
    bufs = NamedControl.kr(\bufs, [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]);
    envs = NamedControl.kr(\envs, [0,0,0,0]); count = \poolCount.kr(1).max(1);
    density = (p[\density]*(1+(Decay2.kr(Dust.kr(p[\densityChaos]*3),0.01,0.25)*p[\densityChaos]*5))).clip(0.2,180);
    clock = Select.kr(p[\densityChaos] > 0.15,[Impulse.kr(density),Dust.kr(density)]) + tr;
    choice = p[\sound].clip(0,count-1);
    pick = choice.floor + (TRand.kr(0,1,clock) < choice.frac);
    pick = Select.kr(TRand.kr(0,1,clock) < p[\soundChaos], [pick,TIRand.kr(0,count-1,clock)]);
    buf = Select.kr(pick,bufs);
    phase = Phasor.kr(0,
        p[\scan]*(1-p[\freeze].round)/ControlRate.ir/BufDur.kr(buf).max(0.01),0,1);
    pos = (p[\position] + phase + (TRand.kr(-1,1,clock)*(p[\positionScatter]+(p[\positionChaos]*0.3)))).wrap(0,1);
    scatter = TRand.kr(-1,1,clock)*(p[\pitchScatter]+(p[\pitchChaos]*12));
    pitch = (p[\pitch].log2*12 + 60 + scatter);
    pitch = Select.kr(p[\quantize].round,[pitch,v[\quantize].value(pitch,p[\scale],p[\root])]);
    pitch = 2 ** ((pitch-60)/12);
    sound = GrainBuf.ar(2,clock,p[\size],buf,pitch,pos,4,
        TRand.kr(-1,1,clock)*p[\spread],Select.kr(p[\shape].round,envs),256);
    (a:sound*p[\gain]*0.45, pos:pos, sound:pick)
}, "Per-grain sound choice, scatter, random pan and Dust density bursts.");

v[\register].value(\osc,"OSC",0,1,true,false,[
    v[\spec].value(\freq,"Frequency",20,12000,110,\exp,\hz), v[\spec].value(\wave,"Wave morph",0,4,0),
    v[\spec].value(\gain,"Gain",0,0.7,0.18), v[\spec].value(\detune,"Detune cents",0,80,8),
    v[\spec].value(\width,"Pulse width",0.03,0.97,0.5), v[\spec].value(\voices,"Unison voices",1,7,3),
    v[\spec].value(\spread,"Spread",0,1,0.5), v[\spec].value(\fm,"FM depth Hz",0,3000,0)
], { |p,ins,tr|
    var jump, pitch, wave, sound;
    jump = Dust.kr(p[\freqChaos]*2);
    pitch = TChoose.kr(jump,[-12,0,0,12,24]);
    pitch = v[\quantize].value(p[\freq].cpsmidi+pitch,p[\scale],p[\root]).midicps;
    pitch = Select.kr(p[\freqChaos]>0,[p[\freq],pitch]);
    wave = (p[\wave]+(LFNoise2.kr(0.3)*p[\waveChaos]*2)).clip(0,4);
    sound = Mix.fill(7,{ |i|
        var freq, voice, offset;
        offset = (i-((p[\voices].round-1)/2))/((p[\voices].round-1)/2).max(1);
        freq = (pitch * (2 ** (((offset*p[\detune]) + (LFNoise2.kr(0.2)*p[\freqChaos]*15))/1200))
            + (ins[0].sum*0.5*p[\fm])).clip(12,19000);
        voice = SelectX.ar(wave,[SinOsc.ar(freq),Saw.ar(freq)*0.65,
            Pulse.ar(freq,0.5)*0.5,LFTri.ar(freq),Pulse.ar(freq,p[\width])*0.5]);
        Pan2.ar(voice,(offset*p[\spread]).clip(-1,1)) * (p[\voices].round > i).lag(0.03)
    });
    (a:sound*p[\gain]/p[\voices].sqrt)
}, "Scale-tuned octave jumps, pitch drift and waveform morphs.");

v[\register].value(\fm,"FM",0,0,true,false,[
    v[\spec].value(\freq,"Carrier Hz",20,8000,110,\exp,\hz), v[\spec].value(\ratio,"Modulator ratio",0.125,16,2,\exp),
    v[\spec].value(\index,"Index",0,24,2), v[\spec].value(\feedback,"Feedback",0,2,0.1),
    v[\spec].value(\gain,"Gain",0,0.7,0.16)
], { |p|
    var freq, index, mod;
    freq = p[\freq]; index = p[\index]*(1+(LFNoise2.kr(0.4)*p[\indexChaos]));
    mod = SinOscFB.ar(freq*p[\ratio],(p[\feedback]+(LFNoise2.kr(1).range(0,0.5)*p[\feedbackChaos])).clip(0,2));
    (a:Pan2.ar(SinOsc.ar((freq+mod*freq*index).clip(-19000,19000))*p[\gain]))
}, "Stochastic index swells and feedback accents.");

v[\register].value(\noise,"NOISE",0,0,true,false,[
    v[\spec].value(\kind,"White / pink / brown / crackle / dust",0,4,1),
    v[\spec].value(\density,"Density",0.1,2000,20,\exp), v[\spec].value(\colour,"Colour cutoff",30,18000,5000,\exp),
    v[\spec].value(\gain,"Gain",0,0.7,0.12)
], { |p|
    var source, cutoff;
    source = Array.fill(2,{ SelectX.ar(p[\kind],[WhiteNoise.ar,PinkNoise.ar,BrownNoise.ar,
        Crackle.ar(1.7),Dust2.ar(p[\density])]) });
    cutoff = (p[\colour]*(LFNoise2.kr(0.3).exprange(0.5,2)**p[\colourChaos])).clip(30,19000);
    (a:LPF.ar(source,cutoff)*p[\gain])
}, "Moving noise colour and irregular density.");

v[\register].value(\pluck,"PLUCK",0,0,true,false,[
    v[\spec].value(\freq,"Frequency",30,4000,110,\exp,\hz), v[\spec].value(\decay,"Decay seconds",0.1,20,4,\exp),
    v[\spec].value(\coef,"Damping coefficient",-0.95,0.95,0.4),
    v[\spec].value(\auto,"Auto clock",0,1,1), v[\spec].value(\gain,"Gain",0,1,0.4)
], { |p,ins,tr|
    var hit, freq;
    hit = tr + (Impulse.kr(p[\bpm]/60)*p[\auto].round) + Dust.kr(p[\freqChaos]*4);
    freq = (p[\freq]*(2**(TIRand.kr(-1,2,hit)*p[\freqChaos]))).clip(25,8000);
    (a:Pan2.ar(Pluck.ar(WhiteNoise.ar(0.4),hit,0.05,freq.reciprocal,p[\decay],p[\coef]),
        TRand.kr(-0.7,0.7,hit)*p[\freqChaos])*p[\gain])
}, "Random excitations, register changes and pluck positions.");

v[\chords] = [[0,4,7,12,16,19,24],[0,3,7,12,15,19,24],
    [0,5,7,12,17,19,24],[0,4,7,11,14,19,24],[0,3,7,10,14,19,24]];
v[\register].value(\drone,"DRONE",0,0,true,false,[
    v[\spec].value(\rootNote,"Root MIDI",24,84,45,\lin,\midi), v[\spec].value(\chord,"Chord type",0,4,1),
    v[\spec].value(\spread,"Spread cents",0,60,9), v[\spec].value(\beating,"Slow beating Hz",0.01,2,0.12,\exp),
    v[\spec].value(\gain,"Gain",0,0.8,0.22)
], { |p|
    var sound;
    sound = Mix.fill(7,{ |i|
        var note, freq;
        note = p[\rootNote]+Select.kr(p[\chord].round,v[\chords].collect { |c| c[i] });
        freq = note.midicps*(2**((LFNoise2.kr(p[\beating]*(i+1)/5)*p[\spread]*(1+p[\spreadChaos]))/1200));
        Pan2.ar(SinOsc.ar(freq,0,1/(i+1)),(i-3)/3)
    });
    (a:sound*p[\gain]*0.4)
}, "Independent slow beating in a harmonic chord stack.");

v[\register].value(\mic,"MIC IN",0,0,true,false,[
    v[\spec].value(\gain,"Input gain",0,4,0.7), v[\spec].value(\gate,"Noise gate threshold",0,0.2,0.01)
], { |p|
    var sound, gate;
    sound = SoundIn.ar([0,1]); gate = (Amplitude.kr(sound.sum*0.5)>p[\gate]).lag(0.03);
    (a:sound*p[\gain]*gate)
}, "Gentle stochastic gate movement through parameter dice.");

v[\register].value(\lfo,"LFO",1,0,false,true,[
    v[\spec].value(\rate,"Rate Hz",0.01,40,0.2,\exp), v[\spec].value(\shape,"Sine / triangle / saw / square / S&H",0,4,0),
    v[\spec].value(\low,"Minimum",-1,1,-1), v[\spec].value(\high,"Maximum",-1,1,1),
    v[\spec].value(\sync,"Clock sync",0,1,0), v[\spec].value(\division,"Clock multiplier",0.0625,16,1,\exp)
], { |p|
    var rate, signal;
    rate = Select.kr(p[\sync].round,[p[\rate],p[\bpm]/60*p[\division]]);
    rate = rate*(1+(LFNoise2.kr(0.1)*p[\rateChaos]*0.5));
    signal = SelectX.kr(p[\shape],[SinOsc.kr(rate),LFTri.kr(rate),LFSaw.kr(rate),
        LFPulse.kr(rate).range(-1,1),LFNoise0.kr(rate)]);
    (k:signal.linlin(-1,1,p[\low],p[\high]),pos:signal*0.5+0.5)
}, "Slow stochastic rate drift.");

v[\register].value(\random,"RANDOM",1,0,false,true,[
    v[\spec].value(\rate,"Rate",0.01,40,1,\exp), v[\spec].value(\mode,"Smooth / step / walk",0,2,0),
    v[\spec].value(\low,"Minimum",-1,1,-1), v[\spec].value(\high,"Maximum",-1,1,1)
], { |p|
    var signal, rate;
    rate = p[\rate]*(1+(p[\rateChaos]*4));
    signal = SelectX.kr(p[\mode],[LFNoise2.kr(rate),LFNoise0.kr(rate),
        Demand.kr(Impulse.kr(rate),0,Dbrown(-1,1,0.15,inf)).lag(0.08/rate)]).clip(-1,1);
    (k:signal.linlin(-1,1,p[\low],p[\high]),pos:signal*0.5+0.5)
}, "Brownian walks, steps and smooth control noise.");

v[\register].value(\chaotic,"CHAOS",1,0,false,true,[
    v[\spec].value(\rate,"Iteration rate",0.1,1000,20,\exp), v[\spec].value(\kind,"Lorenz / Henon / Latoocarfian",0,2,0),
    v[\spec].value(\a,"Attractor A",0,1,0.5), v[\spec].value(\b,"Attractor B",0,1,0.5),
    v[\spec].value(\amount,"Output amount",0,1,0.7)
], { |p|
    var signal, rate;
    rate = p[\rate]*(1+p[\rateChaos]);
    signal = SelectX.ar(p[\kind],[LorenzL.ar(rate,10,p[\a]*8+24,2.667,0.01)*0.045,
        HenonC.ar(rate,1.2+p[\a]*0.2,0.2+p[\b]*0.1)*0.7,
        LatoocarfianC.ar(rate,0.8+p[\a]*0.4,2.5+p[\b],0.5,0.5)*0.6]).tanh;
    (k:A2K.kr(signal)*p[\amount],pos:A2K.kr(signal)*0.5+0.5)
}, "Core Lorenz, Henon and Latoocarfian attractors.");

v[\register].value(\clock,"CLOCK",1,0,false,true,[
    v[\spec].value(\division,"Tempo multiplier",0.0625,16,1,\exp),
    v[\spec].value(\probability,"Probability",0,1,1)
], { |p|
    var tick;
    tick = Impulse.kr(p[\bpm]/60*p[\division]);
    tick = CoinGate.kr((p[\probability]-(p[\probabilityChaos]*0.3)).clip(0,1),tick);
    (k:Trig1.kr(tick,0.012),pos:Decay.kr(tick,0.12))
}, "Probabilistic clock omissions.");

v[\register].value(\euclid,"EUCLID",1,0,false,true,[
    v[\spec].value(\steps,"Steps",1,32,16), v[\spec].value(\pulses,"Pulses",0,32,5),
    v[\spec].value(\rotation,"Rotation",0,31,0), v[\spec].value(\division,"Tempo multiplier",0.25,16,4,\exp)
], { |p,ins,tr|
    var tick, steps, pulses, index, gate;
    tick = Impulse.kr(p[\bpm]/60*p[\division])+tr;
    steps = p[\steps].round.max(1); pulses = p[\pulses].round.min(steps);
    index = (PulseCount.kr(tick)-1+p[\rotation].round).mod(steps);
    gate = ((index*pulses).mod(steps)<pulses);
    gate = Select.kr(TRand.kr(0,1,tick)<(p[\pulsesChaos]*0.2),[gate,1-gate]);
    (k:Trig1.kr(tick*gate,0.012),pos:index/steps)
}, "Probabilistic rhythm inversions.");

v[\register].value(\sequencer,"STEP SEQ",1,0,false,true,[
    v[\spec].value(\division,"Tempo multiplier",0.25,16,2,\exp),
    v[\spec].value(\length,"Length",1,16,16), v[\spec].value(\smooth,"Glide seconds",0,1,0.03),
    v[\spec].value(\triggerOut,"Output gates",0,1,0)
], { |p,ins,tr|
    var values, gates, probs, tick, index, valid, value;
    values = NamedControl.kr(\steps,[0.2,0.4,0.6,0.3,0.5,0.8,0.4,0.1,0.6,0.3,0.7,0.5,0.4,0.8,0.2,0.5]);
    gates = NamedControl.kr(\gates,[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]);
    probs = NamedControl.kr(\probs,[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]);
    tick = Impulse.kr(p[\bpm]/60*p[\division])+tr;
    index = (PulseCount.kr(tick)-1).mod(p[\length].round.max(1));
    valid = tick*Select.kr(index,gates)*(TRand.kr(0,1,tick)<Select.kr(index,probs));
    value = (Select.kr(index,values)+(TRand.kr(-0.5,0.5,tick)*p[\chaos])).clip(0,1);
    value = Latch.kr(value,valid).lag(p[\smooth]);
    (k:Select.kr(p[\triggerOut].round,[value,Trig1.kr(valid,0.012)]),pos:index/16)
}, "Per-step probability and independent stochastic value mutation.");

v[\register].value(\envelope,"ENVELOPE",1,1,true,true,[
    v[\spec].value(\attack,"Attack",0.001,8,0.01,\exp), v[\spec].value(\decay,"Decay",0.005,12,0.4,\exp),
    v[\spec].value(\sustain,"Sustain",0,1,0.5), v[\spec].value(\release,"Release",0.005,12,0.6,\exp),
    v[\spec].value(\hold,"Gate length",0.01,8,0.2,\exp), v[\spec].value(\mode,"AD / ADSR",0,1,0)
], { |p,ins,tr|
    var gate, ad, adsr, env;
    tr = tr+Dust.kr(p[\chaos]*2); gate = Trig1.kr(tr,p[\hold]);
    ad = EnvGen.kr(Env.perc(p[\attack],p[\decay],1,-4),tr);
    adsr = EnvGen.kr(Env.adsr(p[\attack],p[\decay],p[\sustain],p[\release]),gate);
    env = Select.kr(p[\mode].round,[ad,adsr]); (a:ins[0]*env,k:env,pos:env)
}, "Dust retriggers for rhythmic VCA accents.");

v[\register].value(\filter,"FILTER",2,1,true,false,[
    v[\spec].value(\cutoff,"Cutoff",25,19000,2200,\exp), v[\spec].value(\resonance,"Resonance",0,0.98,0.2),
    v[\spec].value(\kind,"LP / HP / BP / notch / Moog",0,4,0), v[\spec].value(\drive,"Drive",1,12,1,\exp),
    v[\spec].value(\mix,"Mix",0,1,1)
], { |p,ins|
    var source, cutoff, res, wet;
    source = (ins[0]*p[\drive]).tanh;
    cutoff = (p[\cutoff]*(2**(LFNoise2.kr(0.4)*p[\cutoffChaos]*3))).clip(25,19000);
    res = (p[\resonance]+(Decay.kr(Dust.kr(p[\resonanceChaos]*3),0.1)*p[\resonanceChaos]*0.6)).clip(0,0.98);
    wet = SelectX.ar(p[\kind],[RLPF.ar(source,cutoff,1-res),RHPF.ar(source,cutoff,1-res),
        BPF.ar(source,cutoff,1-res)*2,BRF.ar(source,cutoff,1-res),MoogFF.ar(source,cutoff,res*3.9)]);
    (a:(ins[0]*(1-p[\mix]))+(wet*p[\mix]))
}, "LFNoise cutoff sweeps and Dust resonance spikes.");

v[\register].value(\delay,"DELAY",2,1,true,false,[
    v[\spec].value(\time,"Delay seconds",0.005,3.8,0.36,\exp), v[\spec].value(\feedback,"Feedback",0,1.15,0.45),
    v[\spec].value(\mix,"Mix",0,1,0.35), v[\spec].value(\tone,"Loop filter",80,18000,6000,\exp),
    v[\spec].value(\freeze,"Freeze",0,1,0), v[\spec].value(\sync,"Tempo sync",0,1,0),
    v[\spec].value(\division,"Beat length",0.0625,4,0.5,\exp)
], { |p,ins|
    var local, freeze, time, jump, wet, loop;
    local = LocalIn.ar(2); jump = Dust.kr(p[\timeChaos]*3);
    freeze = (p[\freeze].round + (TRand.kr(0,1,jump)<(p[\freezeChaos]*0.2))).clip(0,1).lag(0.03);
    time = Select.kr(p[\sync].round,[p[\time],60/p[\bpm]*p[\division]]);
    time = (time*(2**(TRand.kr(-2,1,jump)*p[\timeChaos]))).clip(0.005,3.9).lag(0.035);
    loop = (ins[0]*(1-freeze))+(local.reverse*SelectX.kr(freeze,[p[\feedback],1]));
    wet = DelayC.ar(LeakDC.ar(LPF.ar(loop,p[\tone])).tanh,4,[time,time*1.003]);
    LocalOut.ar(wet);
    (a:(ins[0]*(1-p[\mix]))+(wet*p[\mix]))
}, "Tape-time jumps and stochastic feedback freezes.");

v[\register].value(\reverb,"REVERB",2,1,true,false,[
    v[\spec].value(\size,"Room size",0,1,0.85), v[\spec].value(\damping,"Damping",0,1,0.4),
    v[\spec].value(\mix,"Mix",0,1,0.4), v[\spec].value(\shimmer,"Shimmer feedback",0,0.88,0.15),
    v[\spec].value(\freeze,"Freeze",0,1,0)
], { |p,ins|
    var local, freeze, input, wet, shifted;
    local = LocalIn.ar(2);
    freeze = (p[\freeze].round + (LFNoise0.kr(0.3)> (1-(p[\freezeChaos]*0.2)))).clip(0,1).lag(0.05);
    input = (ins[0]*(1-freeze))+(local*p[\shimmer]);
    wet = FreeVerb2.ar(input[0],input[1],1,(p[\size]+(freeze*0.12)).clip(0,0.995),p[\damping]);
    shifted = PitchShift.ar(wet,0.2,2,0.015,0.025);
    LocalOut.ar(LeakDC.ar(shifted+(wet*freeze*0.7)).tanh);
    (a:(ins[0]*(1-p[\mix]))+(wet*p[\mix]))
}, "Rare ambient freezes with octave shimmer in the feedback path.");

v[\register].value(\spectral,"SPECTRAL",2,1,true,false,[
    v[\spec].value(\freeze,"FFT freeze",0,1,0), v[\spec].value(\smear,"Magnitude smear",0,80,0),
    v[\spec].value(\scramble,"Bin scramble",0,1,0), v[\spec].value(\width,"Scramble width",0,1,0.2),
    v[\spec].value(\mix,"Mix",0,1,1)
], { |p,ins,tr|
    var wet, tick;
    tick = tr + Dust.kr(0.5+(p[\freezeChaos]*5));
    wet = ins[0].collect { |channel|
        var chain;
        chain = FFT(LocalBuf(2048),channel);
        chain = PV_MagFreeze(chain,(p[\freeze]+(TRand.kr(0,1,tick)<(p[\freezeChaos]*0.3)))>0.5);
        chain = PV_MagSmear(chain,p[\smear].round);
        chain = PV_BinScramble(chain,p[\scramble],p[\width],tick);
        IFFT(chain)
    };
    (a:(ins[0]*(1-p[\mix]))+(wet*p[\mix]))
}, "Random spectral captures and bin permutations.");

v[\register].value(\pitchshift,"PITCH SHIFT",2,1,true,false,[
    v[\spec].value(\ratio,"Pitch ratio",0.125,4,1,\exp,\ratio), v[\spec].value(\pitchDisp,"Pitch dispersion",0,1,0),
    v[\spec].value(\timeDisp,"Time dispersion",0,0.2,0.01), v[\spec].value(\mix,"Mix",0,1,1)
], { |p,ins|
    var ratio, wet;
    ratio = (p[\ratio]*(2**(LFNoise2.kr(0.5)*p[\ratioChaos]))).clip(0.125,4);
    wet = PitchShift.ar(ins[0],0.2,ratio,p[\pitchDisp],p[\timeDisp]);
    (a:(ins[0]*(1-p[\mix]))+(wet*p[\mix]))
}, "Slow random pitch drift.");

v[\register].value(\crush,"CRUSH",2,1,true,false,[
    v[\spec].value(\sampleRate,"Sample rate",100,48000,12000,\exp), v[\spec].value(\bits,"Bit depth",2,24,12),
    v[\spec].value(\mix,"Mix",0,1,1)
], { |p,ins|
    var rate, steps, wet;
    rate = (p[\sampleRate]*(2**(LFNoise0.kr(2)*p[\sampleRateChaos]*2))).clip(60,SampleRate.ir);
    steps = 2**p[\bits].round;
    wet = Latch.ar(ins[0],Impulse.ar(rate)).round(1/steps);
    (a:(ins[0]*(1-p[\mix]))+(wet*p[\mix]))
}, "Stochastic sample-rate staircases.");

v[\register].value(\distort,"DISTORT",2,1,true,false,[
    v[\spec].value(\drive,"Drive",1,40,3,\exp), v[\spec].value(\mode,"Tanh / fold / clip",0,2,0),
    v[\spec].value(\tone,"Tone cutoff",60,19000,8000,\exp), v[\spec].value(\mix,"Mix",0,1,0.7)
], { |p,ins|
    var source, wet;
    source = ins[0]*p[\drive]*(1+(LFNoise2.kr(1)*p[\driveChaos]*0.8));
    wet = LPF.ar(SelectX.ar(p[\mode],[source.tanh,source.fold2(1),source.clip2(1)]),p[\tone]);
    (a:(ins[0]*(1-p[\mix]))+(wet*p[\mix]))
}, "Stochastic drive swells.");

v[\register].value(\ring,"RING / FREQ SHIFT",2,1,true,false,[
    v[\spec].value(\frequency,"Frequency Hz",-2000,2000,80), v[\spec].value(\mode,"Ring / frequency shift",0,1,0),
    v[\spec].value(\mix,"Mix",0,1,0.7)
], { |p,ins|
    var freq, wet;
    freq = p[\frequency]+(LFNoise2.kr(0.5)*p[\frequencyChaos]*500);
    wet = SelectX.ar(p[\mode],[ins[0]*SinOsc.ar(freq),FreqShift.ar(ins[0],freq)]);
    (a:(ins[0]*(1-p[\mix]))+(wet*p[\mix]))
}, "Wandering sidebands and non-harmonic shifts.");

v[\register].value(\stutter,"STUTTER",2,1,true,false,[
    v[\spec].value(\size,"Slice seconds",0.015,2,0.15,\exp), v[\spec].value(\repeat,"Capture / repeat",0,1,0),
    v[\spec].value(\rate,"Slice rate",-4,4,1), v[\spec].value(\mix,"Mix",0,1,1)
], { |p,ins,tr|
    var buf, frames, write, repeat, hit, anchor, read, stored, wet, slice;
    buf = LocalBuf(SampleRate.ir*4,2).clear; frames = BufFrames.kr(buf);
    write = Phasor.ar(0,1,0,frames); hit = tr+Dust.kr(p[\repeatChaos]*4);
    repeat = (p[\repeat].round+Trig1.kr(hit,p[\size]*TIRand.kr(2,8,hit))).clip(0,1);
    stored = BufRd.ar(2,buf,write,1,2);
    BufWr.ar((ins[0]*(1-repeat))+(stored*repeat),buf,write);
    anchor = Latch.kr(A2K.kr(write),hit+Changed.kr(repeat));
    slice = (p[\size]*SampleRate.ir).max(64);
    read = Phasor.ar(hit+Changed.kr(repeat),p[\rate],0,slice);
    wet = BufRd.ar(2,buf,(anchor-slice+read).wrap(0,frames-1),1,4);
    wet = wet * (SinOsc.ar(0, (read/slice)*pi).abs.sqrt);
    (a:(ins[0]*(1-(repeat*p[\mix])))+(wet*repeat*p[\mix]),pos:A2K.kr(read)/slice)
}, "Dust captures and short reverse slice repetitions.");

v[\register].value(\resonator,"RESONATOR",2,1,true,false,[
    v[\spec].value(\rootNote,"Root MIDI",24,96,48,\lin,\midi), v[\spec].value(\chord,"Chord type",0,4,1),
    v[\spec].value(\decay,"Decay",0.1,12,3,\exp), v[\spec].value(\mix,"Mix",0,1,0.7)
], { |p,ins|
    var freqs, wet;
    freqs = Array.fill(7,{ |i| (p[\rootNote]+Select.kr(p[\chord].round,
        v[\chords].collect { |c| c[i] })).midicps * (1+(LFNoise2.kr(0.1)*p[\rootNoteChaos]*0.01)) });
    wet = ins[0].collect { |channel| DynKlank.ar(`[freqs,Array.fill(7,0.12),Array.fill(7,p[\decay])],channel) };
    (a:(ins[0]*(1-p[\mix]))+(wet*p[\mix]))
}, "Slowly drifting chord-bank resonances.");

v[\register].value(\compressor,"COMPRESSOR",2,1,true,false,[
    v[\spec].value(\threshold,"Threshold",0.01,1,0.25,\exp), v[\spec].value(\ratio,"Ratio",1,20,4,\exp),
    v[\spec].value(\attack,"Attack",0.001,0.2,0.01,\exp), v[\spec].value(\release,"Release",0.02,2,0.15,\exp),
    v[\spec].value(\makeup,"Makeup gain",0.2,6,1,\exp)
], { |p,ins|
    var threshold;
    threshold = (p[\threshold]*(1+(LFNoise2.kr(0.2)*p[\thresholdChaos]*0.5))).clip(0.01,1);
    (a:Compander.ar(ins[0],ins[0].sum*0.5,threshold,1,1/p[\ratio],p[\attack],p[\release])*p[\makeup])
}, "Slow stochastic threshold breathing.");

v[\register].value(\mixer,"MIXER",3,4,true,false,
    Array.fill(4,{ |i| [v[\spec].value(("gain"++i).asSymbol,"Input "++(i+1)++" gain",0,2,0.7),
        v[\spec].value(("pan"++i).asSymbol,"Input "++(i+1)++" pan",-1,1,0),
        v[\spec].value(("mute"++i).asSymbol,"Input "++(i+1)++" mute",0,1,0)] }).flat,
    { |p,ins|
        (a:Mix.fill(4,{ |i| Balance2.ar(ins[i][0],ins[i][1],p[("pan"++i).asSymbol],
            p[("gain"++i).asSymbol]*(1-p[("mute"++i).asSymbol].round)) }))
    }, "Independent gain and pan dice for four summed stereo inputs.");
v[\register].value(\pan,"PAN",3,1,true,false,[
    v[\spec].value(\pan,"Pan",-1,1,0), v[\spec].value(\auto,"Auto-pan depth",0,1,0),
    v[\spec].value(\rate,"Auto-pan Hz",0.01,20,0.2,\exp)
], { |p,ins|
    var pan;
    pan = (p[\pan]+(SinOsc.kr(p[\rate])*p[\auto])+(LFNoise2.kr(0.3)*p[\panChaos])).clip(-1,1);
    (a:Balance2.ar(ins[0][0],ins[0][1],pan))
}, "Stochastic stereo wandering.");
v[\register].value(\vca,"VCA / GAIN",3,1,true,false,[
    v[\spec].value(\gain,"Gain",0,3,1)
], { |p,ins| (a:ins[0]*p[\gain]) }, "Modulate Gain with any control outlet.");
v[\register].value(\xfade,"XFADE",3,2,true,false,[
    v[\spec].value(\mix,"A to B",0,1,0.5)
], { |p,ins|
    var mix;
    mix = (p[\mix]+(LFNoise2.kr(0.3)*p[\mixChaos]*0.5)).clip(0,1);
    (a:XFade2.ar(ins[0],ins[1],mix*2-1))
}, "Stochastic equal-power crossfades.");
v[\register].value(\scope,"SCOPE",3,1,true,false,[
    v[\spec].value(\mode,"Waveform / spectrum",0,1,0), v[\spec].value(\gain,"Display & audio gain",0.1,4,1,\exp)
], { |p,ins| (a:ins[0]*p[\gain]) }, "Live oscilloscope and 32-band spectrum.");
v[\register].value(\output,"OUTPUT",3,1,true,false,[
    v[\spec].value(\volume,"Master volume",0,1,0.65)
], { |p,ins| (a:Limiter.ar(LeakDC.ar(ins[0])*p[\volume],0.966,0.01)) }, "Protected stereo master output.");
v[\register].value(\recorder,"RECORDER",3,1,true,false,[],
    { |p,ins| (a:InFeedback.ar(\masterBus.kr(0),2)) }, "Records the protected master to a timestamped stereo WAV.");
v[\register].value(\note,"NOTE",3,0,false,false,[],{ () },"Double-click the note body to edit its text.");

v[\registry][\osc][\inputs][0][\name] = "FM (stereo sum)";
v[\nodeLabels] = (osc:["Frequency","Wave","Gain"],fm:["Carrier","Ratio","Index"],
    noise:["Kind","Density","Colour"],drone:["Root","Chord","Spread"],lfo:["Rate","Shape","Minimum"],
    filter:["Cutoff","Resonance","Mode"],delay:["Time","Feedback","Mix"],reverb:["Size","Damping","Mix"],
    resonator:["Root","Chord","Decay"],sequencer:["Rate","Length","Glide"],pitchshift:["Pitch","Pitch disp.","Time disp."],
    mixer:["Gain 1","Pan 1","Mute 1"],chaotic:["Rate","Attractor","A"],random:["Rate","Mode","Minimum"]);
[
    [\player,\loop,["One-shot","Loop"]], [\granular,\shape,["Hann","Perc","Flat","Reverse"]],
    [\granular,\freeze,["Scan","Freeze"]], [\granular,\quantize,["Free","Scale"]],
    [\osc,\wave,["Sine","Saw","Square","Triangle","Pulse"]],
    [\drone,\chord,["Major","Minor","Sus4","Maj7","Min7"]],
    [\lfo,\shape,["Sine","Triangle","Saw","Square","S&H"]],
    [\random,\mode,["Smooth","Step","Walk"]], [\chaotic,\kind,["Lorenz","Henon","Latoo"]],
    [\envelope,\mode,["AD","ADSR"]], [\filter,\kind,["LP","HP","BP","Notch","Moog"]],
    [\distort,\mode,["Tanh","Fold","Clip"]], [\ring,\mode,["Ring","Shift"]],
    [\scope,\mode,["Wave","Spectrum"]], [\resonator,\chord,["Major","Minor","Sus4","Maj7","Min7"]]
].do { |row|
    var spec;
    spec = v[\registry][row[0]][\params].detect { |p|p[\key]==row[1] }; spec[\choices] = row[2];
};

// Musical events use diamond ports; audio and control ports keep their old meaning.
v[\register].value(\polysynth,"POLY SYNTH",0,0,true,false,[
    v[\spec].value(\gain,"Gain",0,1,0.65), v[\spec].value(\wave,"Sine / saw / square / triangle / FM",0,4,0),
    v[\spec].value(\attack,"Attack seconds",0.001,4,0.01,\exp),
    v[\spec].value(\release,"Release seconds",0.01,8,0.35,\exp),
    v[\spec].value(\cutoff,"Cutoff Hz",30,19000,10000,\exp)
], { |p|
    Out.kr(\voiceParamsBus.kr(0),[p[\wave],p[\attack],p[\release],p[\cutoff]]);
    (a:In.ar(\voiceBus.kr(0),2)*p[\gain])
},
    "Play MIDI or NOTE SEQ through the Notes inlet. 32 voices, velocity, sustain and pitch bend.");
v[\registry][\polysynth][\inputs] = [(name:"Notes / chords",kind:\notes)];
v[\nodeLabels][\polysynth] = ["Gain","Wave","Attack"];
v[\nodeLabels][\noteseq] = ["Rate","Length","Base MIDI"];
v[\registry][\polysynth][\params][1][\choices] = ["Sine","Saw","Square","Triangle","FM"];
v[\register].value(\midiin,"MIDI IN",1,0,false,false,[],{ () },
    "Choose a device and channel. Connect the diamond Notes outlet to POLY SYNTH or MIDI OUT.");
v[\registry][\midiin][\inputs] = [];
v[\registry][\midiin][\outputs] = [(name:"Notes / chords",kind:\notes)];
v[\register].value(\noteseq,"NOTE SEQ",1,0,false,false,[
    v[\spec].value(\division,"Steps per beat",0.25,16,2,\exp),
    v[\spec].value(\length,"Length",1,16,16),
    v[\spec].value(\base,"Degree base MIDI",0,120,60),
    v[\spec].value(\gateLength,"Gate fraction",0.01,1,0.8)
], { () },"16 steps of notes, chords or scale degrees, with rests, velocity, probability and duration.");
v[\registry][\noteseq][\inputs] = [];
v[\registry][\noteseq][\outputs] = [(name:"Notes / chords",kind:\notes)];
v[\register].value(\midiout,"MIDI OUT",3,0,false,false,[],{ () },
    "Send notes to a device. MPE mode uses channels 2–16 for independent microtonal pitch bends.");
v[\registry][\midiout][\inputs] = [(name:"Notes / chords",kind:\notes)];
v[\registry][\midiout][\outputs] = [];

// 5 Patch / connection engine -------------------------------------------------
v[\newParam] = { |spec|
    (base:v[\norm].value(spec,spec[\default]), random:false, mode:0,rate:0.3,depth:0.18,low:0,high:1,locked:false)
};
v[\spawn] = { |node|
    var reg, args;
    reg = v[\registry][node[\type]];
    if(v[\ready] and: {([\note]++v[\noteTypes]).includes(node[\type]).not}) {
        node[\group] = Group.tail(v[\objectGroup]);
        if(node[\type]==\polysynth) {
            node[\voiceBus] = Bus.audio(s,2); node[\voiceParamsBus] = Bus.control(s,4);
            node[\voiceGroup] = Group.head(node[\group]); node[\tailGroup] = Group.after(node[\voiceGroup]);
        };
        node[\clears] = List.new;
        node[\ins] = reg[\inputs].collect { |port|
            var bus;
            bus = if(port[\kind] == \audio) {Bus.audio(s,2)} {Bus.control(s,1)};
            if(port[\kind] == \control) {bus.set(0)};
            node[\clears].add(Synth.tail(v[\clearGroup],
                if(port[\kind]==\audio){\void_clearAudio}{\void_clearControl},[\bus,bus.index]));
            bus
        };
        node[\out] = Bus.audio(s,2); node[\controlOut] = Bus.control(s,1);
        node[\modBuses] = node[\params].collect {
            var bus;
            bus = Bus.control(s,1); bus.set(0);
            node[\clears].add(Synth.tail(v[\clearGroup],\void_clearControl,[\bus,bus.index])); bus
        };
        args = [\uid,node[\id],\out,node[\out].index,\controlOut,node[\controlOut].index,
            \active,node[\active].asInteger,\chaos,node[\chaos].asInteger,\chaosAmount,node[\chaosAmount],
            \buf,v[\silent].bufnum,\bufR,v[\silent].bufnum,
            \bufs,Array.fill(16,v[\silent].bufnum),\envs,v[\grainEnvs].collect(_.bufnum)]
            ++ v[\globalArgs].value ++ if(node[\type]==\polysynth){[\voiceBus,node[\voiceBus].index,\voiceParamsBus,node[\voiceParamsBus].index]}{[]};
        node[\ins].do { |bus,i| args = args ++ [("in"++i).asSymbol,bus.index] };
        node[\modBuses].do { |bus,i| args = args ++ [("mb"++i).asSymbol,bus.index] };
        node[\synth] = Synth.tail(node[\group],reg[\def],args);
        node[\params].do { |p,i| v[\sendParam].value(node,i) };
        if(node[\type] == \sequencer) {v[\sendSteps].value(node)};
        v[\syncPool].value(node);
        if(node[\type] == \output) {v[\output] = node};
    };
};
v[\add] = { |type,pos,saveUndo=true,spawn=true|
    var node, reg;
    if(type==\output and: {v[\output].notNil}) {node = v[\output]} {
        if(saveUndo) {v[\checkpoint].value};
        reg = v[\registry][type];
        node = (id:v[\nextID],type:type,pos:pos ? (100@100),active:true,chaos:false,chaosAmount:0.6,noteMode:false,
            params:reg[\params].collect { |spec| v[\newParam].value(spec) },pool:List.new,
            steps:[0.2,0.4,0.6,0.3,0.5,0.8,0.4,0.1,0.6,0.3,0.7,0.5,0.4,0.8,0.2,0.5],
            gates:Array.fill(16,1),probs:Array.fill(16,1.0),text:"Your thoughts, here.",meter:[0,0],live:[],cursor:0);
        v[\newMusicState].value(node);
        if(type==\output){node[\params][0][\locked] = true};
        v[\nextID] = v[\nextID]+1; v[\nodes].add(node); if(spawn){v[\spawn].value(node)};
    };
    v[\selection] = Set[node[\id]]; v[\inspectorScroll] = 0;
    node
};
v[\sendSteps] = { |node|
    if(node[\synth].notNil) {node[\synth].set(\steps,node[\steps],\gates,node[\gates],\probs,node[\probs])};
};
v[\syncPool] = { |node|
    var sounds, master;
    sounds = node[\pool];
    if(node[\synth].notNil and: {v[\silent].notNil}) {
        if(sounds.notEmpty) {
            node[\synth].set(\buf,(sounds.first[\buf] ? v[\silent]).bufnum,
                \bufR,(sounds.first[\right] ? sounds.first[\buf] ? v[\silent]).bufnum,
                \bufs,Array.fill(16,{ |i| (sounds.wrapAt(i)[\buf] ? v[\silent]).bufnum }),\poolCount,sounds.size);
        } {
            node[\synth].set(\buf,v[\silent].bufnum,\bufR,v[\silent].bufnum,
                \bufs,Array.fill(16,v[\silent].bufnum),\poolCount,1);
        };
        master = v[\output];
        if(master.notNil and: {master[\out].notNil} and: {node[\type]==\recorder}) {
            node[\synth].set(\masterBus,master[\out].index)
        };
    };
};
v[\freeSound] = { |sound|
    if(sound[\released]!=true) {
        sound[\released] = true;
        if(sound[\buf].notNil) {sound[\buf].free};
        if(sound[\right].notNil and: {sound[\right] !== sound[\buf]}) {sound[\right].free};
    };
};
v[\loadSound] = { |node,path,saveUndo=true|
    var file, channels, sound, session;
    session = v[\session];
    if(File.exists(path) and: {v[\ready]} and: {node[\pool].size < 16}) {
        file = SoundFile.new;
        if(file.openRead(path)) {
            channels = file.numChannels; file.close;
            if(saveUndo) {v[\checkpoint].value};
            if(node[\type]==\player) {
                var old;
                old = node[\pool].copy; node[\pool].clear;
                {old.do { |snd| v[\freeSound].value(snd) }}.defer(0.15);
            };
            sound = (path:path,wave:FloatArray.newClear(256)); node[\pool].add(sound);
            // GrainBuf always receives a mono buffer, even for a multichannel file.
            sound[\buf] = Buffer.readChannel(s,path,channels:[0],action:{ |buffer|
                if(v[\alive] and: {session==v[\session]} and: {sound[\released]!=true}) {
                    buffer.loadToFloatArray(action:{ |data|
                        var wave, stride;
                        stride = (data.size/256).ceil.asInteger.max(1);
                        wave = Array.fill(256,{ |i|
                            var begin, end;
                            begin = (i*stride).min(data.size-1).max(0);
                            end = (begin+stride-1).min(data.size-1).max(0);
                            data.copyRange(begin,end).abs.maxItem ? 0
                        });
                        {if(v[\alive]) {sound[\wave] = wave}}.defer;
                    });
                    {if(v[\alive]) {v[\syncPool].value(node)}}.defer;
                } {if(sound[\released]!=true){v[\freeSound].value(sound)}};
            });
            if(node[\type]==\player and: {channels>1}) {
                sound[\right] = Buffer.readChannel(s,path,channels:[1],action:{
                    {if(v[\alive] and: {session==v[\session]}) {v[\syncPool].value(node)}}.defer;
                });
            };
            v[\message].value("Loaded "++path.basename);
        } {v[\message].value("Could not read audio: "++path)};
    } {
        if(File.exists(path).not and: {node[\pool].size<16} and: {
            node[\pool].any { |snd|snd[\path]==path }.not
        }) {
            node[\pool].add((path:path,wave:FloatArray.newClear(256),missing:true));
        };
        v[\message].value(if(node[\pool].size>=16){"Sound pool is full (16 sounds)."}{"Missing sound or audio offline: "++path})
    };
};
v[\buildCord] = { |cord|
    var src, dst, bus, sourceBus;
    src = v[\find].value(cord[\src]); dst = v[\find].value(cord[\dst]);
    if(v[\ready] and: {src.notNil} and: {dst.notNil} and: {cord[\kind]!=\notes}) {
        sourceBus = if(cord[\kind]==\audio){src[\out]}{src[\controlOut]};
        bus = if(cord[\param].notNil){dst[\modBuses][cord[\param]]}{dst[\ins][cord[\inlet]]};
        cord[\synth] = Synth.tail(v[\cordGroup],
            if(cord[\kind]==\audio){\void_audioCord}{\void_controlCord},
            [\src,sourceBus.index,\dst,bus.index,\amount,cord[\amount]]);
    };
};
v[\connect] = { |src,outlet,dst,inlet,param=nil,amount=nil,saveUndo=true|
    var kind, targetKind, cord;
    kind = v[\registry][src[\type]][\outputs][outlet][\kind];
    targetKind = if(param.notNil){\control}{v[\registry][dst[\type]][\inputs][inlet][\kind]};
    if(kind==targetKind and: {dst[\type]!=\note} and: {param.isNil or: {v[\noteTypes].includes(dst[\type]).not}}) {
        if(saveUndo){v[\checkpoint].value};
        cord = (src:src[\id],dst:dst[\id],outlet:outlet,inlet:inlet,param:param,kind:kind,
            amount:amount ? if(param.notNil){0.2}{1.0});
        v[\cordSerial] = v[\cordSerial]+1; cord[\uid] = v[\cordSerial];
        v[\cords].add(cord); v[\buildCord].value(cord);
    } {v[\message].value("Connect matching ports: audio, control/trigger, or Notes diamonds.")};
    cord
};
v[\removeCord] = { |cord|
    if(cord[\kind]==\notes){v[\releaseRoute].value(cord)};
    if(cord[\synth].notNil) {cord[\synth].set(\life,0)};
    v[\cords].remove(cord);
    if(v[\selectedCord] === cord) {v[\selectedCord] = nil};
};
v[\cleanTicket] = { |ticket,freeNodes=true|
    if(ticket[\released]!=true) {
        ticket[\released] = true;
        if(freeNodes and: {v[\ready]}) {
            if(ticket[\group].notNil){ticket[\group].free}; ticket[\clears].do(_.free);
        };
        ticket[\buses].do { |bus|if(bus.notNil){bus.free} };
        if(ticket[\freeBuffers]){ticket[\pool].do { |snd|v[\freeSound].value(snd)}};
        v[\retired].remove(ticket);
    };
};
v[\releaseNode] = { |node,freeBuffers=true|
    var ticket;
    v[\stopMusicNode].value(node);
    ticket = (group:node[\group],clears:node[\clears] ? [],
        buses:(node[\ins] ? []) ++ (node[\modBuses] ? []) ++ [node[\out],node[\controlOut],node[\voiceBus],node[\voiceParamsBus]],
        pool:node[\pool].copy,freeBuffers:freeBuffers);
    if(node[\synth].notNil) {node[\synth].set(\life,0)};
    v[\retired].add(ticket); {v[\cleanTicket].value(ticket)}.defer(0.12);
    node[\synth] = nil; node[\group] = nil;
};
v[\deleteSelected] = {
    v[\checkpoint].value;
    if(v[\selectedCord].notNil) {v[\removeCord].value(v[\selectedCord])} {
        v[\nodes].copy.do { |node|
            if(v[\selection].includes(node[\id]) and: {node[\type]!=\output}) {
                v[\cords].copy.do { |cord|
                    if([cord[\src],cord[\dst]].includes(node[\id])) {v[\removeCord].value(cord)};
                };
                v[\releaseNode].value(node); v[\nodes].remove(node);
            };
        };
        v[\selection].clear;
    };
};
v[\bypass] = { |node|
    if(node[\type]!=\output) {
        v[\stopMusicNode].value(node);
        node[\active] = node[\active].not;
        if(node[\synth].notNil) {node[\synth].set(\active,node[\active].asInteger)};
    };
};
v[\mutate] = { |node=nil,full=false|
    v[\checkpoint].value;
    (if(node.isNil){v[\nodes]}{[node]}).do { |n|
        n[\params].do { |p,i|
            if(p[\locked].not) {
                p[\base] = if(full){1.0.rand}{(p[\base]+0.09.rand2).clip(0,1)};
                v[\sendParam].value(n,i);
            };
        };
    };
};

// 5a Musical note events, MIDI and transport -----------------------------------
v[\paramValue] = { |node,key|
    var i,reg;
    reg = v[\registry][node[\type]]; i = reg[\params].detectIndex { |spec|spec[\key]==key };
    v[\actual].value(reg[\params][i],node[\params][i][\base])
};
v[\newMusicState] = { |node|
    node[\voices] = Dictionary.new; node[\voiceOrder] = List.new; node[\voiceTails] = List.new;
    node[\heldNotes] = Dictionary.new; node[\sustain] = Set.new; node[\inputBends] = Dictionary.new;
    node[\midiSource] = "All inputs"; node[\midiChannel] = -1;
    node[\inputMapping] = 0; node[\bendRange] = if(node[\type]==\midiout){48}{2}; node[\midiDestination] = "None";
    node[\mpe] = true; node[\outChannel] = 0; node[\sequenceDegrees] = true;
    node[\noteSteps] = Array.fill(16,{ |i|
        (notes:if(i%4==0){[0,2,4]}{[i%7]},velocity:96,probability:1.0,duration:1.0,enabled:true)
    });
    node[\sequenceIndex] = 0; node[\playing] = false;
};
v[\releaseVoice] = { |node,key|
    var voice;
    voice = node[\voices].removeAt(key); node[\voiceOrder].remove(key);
    if(voice.notNil) {
        if(voice[\synth].notNil and: {v[\ready]}) {
            voice[\synth].moveToTail(node[\tailGroup]); voice[\synth].set(\gate,0);
            node[\voiceTails].add(voice[\synth]);
            if(node[\voiceTails].size>32){node[\tailGroup].freeAll; node[\voiceTails].clear};
        };
        if(voice[\output].notNil) {
            voice[\output].noteOff(voice[\channel],voice[\number],0);
            if(voice[\mpe]) {voice[\output].bend(voice[\channel],8192)};
        };
    };
};
v[\receiveNotes] = { |node,cord,event|
    var key,voice,output,channel,number,bend,used,channels,pitch;
    key = cord[\uid].asString++":"++event[\token];
    switch(event[\kind],
        \off,{v[\releaseVoice].value(node,key)},
        \bend,{
            node[\voices].values.do { |held|
                if(held[\route]==cord[\uid] and: {held[\lane]==event[\lane]}) {
                    held[\bend] = event[\bend];
                    if(held[\synth].notNil){held[\synth].set(\bend,event[\bend])};
                    if(held[\output].notNil) {
                        bend = if(held[\mpe]){held[\pitch]-held[\number]+event[\bend]}{event[\bend]};
                        held[\output].bend(held[\channel],(8192+(bend/node[\bendRange]*8192)).round.clip(0,16383).asInteger);
                    };
                };
            };
        },
        \on,{
            if(v[\ready] and: {node[\active]}) {
                v[\releaseVoice].value(node,key);
                pitch = event[\pitch];
                voice = (pitch:pitch,lane:event[\lane],route:cord[\uid],bend:event[\bend] ? 0);
                if(node[\type]==\polysynth and: {node[\group].notNil}) {
                    while {node[\voices].size>=32} {v[\releaseVoice].value(node,node[\voiceOrder].first)};
                    voice[\synth] = Synth.head(node[\voiceGroup],\void_voice,[\out,node[\voiceBus].index,
                        \freq,pitch.midicps,\bend,voice[\bend],\velocity,event[\velocity]/127,
                        \paramsBus,node[\voiceParamsBus].index]);
                    voice[\synth].onFree({ |ended|
                        node[\voiceTails].remove(ended);
                        if(node[\voices][key].notNil and: {node[\voices][key][\synth]===ended}) {
                            node[\voices].removeAt(key); node[\voiceOrder].remove(key)
                        };
                    });
                };
                if(node[\type]==\midiout and: {node[\midiOutput].notNil}) {
                    output = node[\midiOutput]; number = pitch.round.clip(0,127).asInteger;
                    channel = node[\outChannel];
                    if(node[\mpe]) {
                        channels = (1..15); used = node[\voices].values.collect(_[\channel]);
                        channel = channels.detect { |ch|used.includes(ch).not };
                        if(channel.isNil) {
                            channel = node[\voices][node[\voiceOrder].first][\channel];
                            v[\releaseVoice].value(node,node[\voiceOrder].first);
                        };
                    } {
                        // A MIDI 1 channel cannot hold overlapping copies of the same note.
                        node[\voices].keys.asArray.do { |heldKey|
                            var held;
                            held = node[\voices][heldKey];
                            if(held[\channel]==channel and: {held[\number]==number}) {v[\releaseVoice].value(node,heldKey)};
                        };
                    };
                    bend = voice[\bend]+if(node[\mpe]){pitch-number}{0};
                    output.control(channel,101,0); output.control(channel,100,0);
                    output.control(channel,6,node[\bendRange].asInteger); output.control(channel,38,0);
                    output.control(channel,101,127); output.control(channel,100,127);
                    output.bend(channel,(8192+(bend/node[\bendRange]*8192)).round.clip(0,16383).asInteger);
                    output.noteOn(channel,number,event[\velocity].round.clip(1,127).asInteger);
                    voice.putAll((output:output,channel:channel,number:number,mpe:node[\mpe]));
                };
                if(voice[\synth].notNil or: {voice[\output].notNil}) {
                    node[\voices][key] = voice; node[\voiceOrder].add(key);
                };
            };
        }
    );
};
v[\emitNotes] = { |node,event|
    v[\cords].select { |cord|cord[\kind]==\notes and: {cord[\src]==node[\id]} }.do { |cord|
        var target;
        target = v[\find].value(cord[\dst]);
        if(target.notNil and: {event[\kind]!=\on or: {node[\active]}}) {
            if(event[\kind]==\on) {
                if(cord[\amount]>0) {
                    v[\receiveNotes].value(target,cord,event.copy.put(\velocity,(event[\velocity]*cord[\amount]).clip(1,127)))
                }
            } {v[\receiveNotes].value(target,cord,event)}
        };
    };
};
v[\releaseRoute] = { |cord|
    var node;
    node = v[\find].value(cord[\dst]);
    if(node.notNil and: {node[\voices].notNil}) {
        node[\voices].keys.asArray.do { |key|
            if(node[\voices][key][\route]==cord[\uid]){v[\releaseVoice].value(node,key)}
        };
    };
};
v[\stopSequence] = { |node|
    if(node[\sequenceRoutine].notNil){node[\sequenceRoutine].stop; node[\sequenceRoutine]=nil};
    node[\playing] = false;
    v[\cords].select { |c|c[\kind]==\notes and: {c[\src]==node[\id]} }.do { |c|v[\releaseRoute].value(c)};
    node[\heldNotes].clear; node[\sustain].clear; node[\inputBends].clear;
};
v[\stopMusicNode] = { |node|
    v[\stopSequence].value(node);
    node[\voices].keys.asArray.do { |key|v[\releaseVoice].value(node,key)};
};
v[\panicNotes] = {
    v[\stopHelpExamples].value;
    // Release all event routes before clearing voice groups, regardless of node order.
    v[\nodes].do { |node|v[\stopMusicNode].value(node)};
    v[\nodes].do { |node|
        if(v[\ready] and: {node[\voiceGroup].notNil}) {
            node[\voiceGroup].freeAll; node[\tailGroup].freeAll
        }; node[\voiceTails].clear;
    }
};
v[\tickSequence] = { |node,index|
    var step,beats,base,pitches,token,offs;
    step = node[\noteSteps][index];
    beats = step[\duration]/v[\paramValue].value(node,\division);
    node[\cursor] = index/16; node[\sequenceIndex] = index;
    if(step[\enabled] and: {step[\notes].notEmpty} and: {step[\probability].coin} and: {node[\active]}) {
        base = v[\paramValue].value(node,\base);
        pitches = step[\notes].collect { |note|
            if(node[\sequenceDegrees]){v[\degreeNote].value(note,base)}{note}
        };
        offs = List.new;
        pitches.do { |pitch|
            v[\noteSerial] = v[\noteSerial]+1; token = "seq:"++node[\id]++":"++v[\noteSerial];
            v[\emitNotes].value(node,(kind:\on,token:token,lane:"sequence",pitch:pitch,velocity:step[\velocity],bend:0));
            offs.add((kind:\off,token:token));
        };
        v[\noteClock].sched(beats*v[\paramValue].value(node,\gateLength),{
            if(v[\alive]){offs.do { |event|v[\emitNotes].value(node,event)}}; nil
        });
    };
    beats
};
v[\startSequence] = { |node|
    if(v[\ready]) {
        v[\stopSequence].value(node); node[\playing] = true;
        node[\sequenceRoutine] = Routine({
            var index,beats,length;
            index = 0;
            while {v[\alive] and: {v[\ready]} and: {node[\playing]}} {
                length = v[\paramValue].value(node,\length).round.asInteger;
                index = index%length; beats = v[\tickSequence].value(node,index);
                beats.wait; index = index+1;
            };
        }).play(v[\noteClock],quant:1);
    } {v[\message].value("Restart audio before starting the sequencer.")};
};
v[\endpointName] = { |endpoint|endpoint.device++" / "++endpoint.name};
v[\openMidiOutput] = { |node|
    var ep;
    v[\stopMusicNode].value(node); node[\midiOutput] = nil;
    ep = (MIDIClient.destinations ? []).detect { |item|v[\endpointName].value(item)==node[\midiDestination] };
    if(ep.notNil) {
        var output;
        output = MIDIOut.newByName(ep.device,ep.name); output.latency = 0; node[\midiOutput] = output;
        // RPN 6 declares the lower MPE zone; RPN 0 on each voice sets its bend range.
        output.control(0,101,0); output.control(0,100,6); output.control(0,6,if(node[\mpe]){15}{0});
        output.control(0,101,127); output.control(0,100,127);
    };
};
v[\midiEvent] = { |kind,value,number,channel,source|
    var endpoint,lane,token;
    if(v[\alive] and: {v[\ready]}) {
        endpoint = (MIDIClient.sources ? []).detect { |ep|ep.uid==source };
        lane = source.asString++":"++channel; token = lane++":"++number;
        v[\nodes].select { |node|node[\type]==\midiin }.do { |node|
            var accepts,held,pitch,mapping;
            accepts = (node[\midiChannel]<0 or: {node[\midiChannel]==channel}) and: {
                node[\midiSource]=="All inputs" or: {endpoint.notNil and: {node[\midiSource]==v[\endpointName].value(endpoint)}}
            };
            if(accepts) {
                switch(kind,
                    \on,{
                        if(value==0) {v[\midiEvent].value(\off,0,number,channel,source)} {
                            if(node[\active]) {
                                v[\emitNotes].value(node,(kind:\off,token:token));
                                mapping = node[\inputMapping];
                                pitch = switch(mapping,1,{v[\quantizeNote].value(number)},
                                    2,{v[\degreeNote].value(number-60,60)},{number});
                                held = (kind:\on,token:token,lane:lane,pitch:pitch,velocity:value,
                                    bend:node[\inputBends][lane] ? 0,released:false);
                                node[\heldNotes][token] = held; v[\emitNotes].value(node,held);
                            };
                        };
                    },
                    \off,{
                        held = node[\heldNotes][token];
                        if(held.notNil) {
                            if(node[\sustain].includes(lane)) {held[\released] = true} {
                                v[\emitNotes].value(node,(kind:\off,token:token)); node[\heldNotes].removeAt(token)
                            };
                        };
                    },
                    \bend,{
                        node[\inputBends][lane] = (value-8192)/8192*node[\bendRange];
                        v[\emitNotes].value(node,(kind:\bend,token:"bend",lane:lane,bend:node[\inputBends][lane]));
                    },
                    \cc,{
                        if(number==64) {
                            if(value>=64){node[\sustain].add(lane)} {
                                node[\sustain].remove(lane);
                                node[\heldNotes].keys.asArray.do { |key|
                                    held = node[\heldNotes][key];
                                    if(held[\lane]==lane and: {held[\released]}) {
                                        v[\emitNotes].value(node,(kind:\off,token:key)); node[\heldNotes].removeAt(key)
                                    };
                                };
                            };
                        };
                        if([120,123].includes(number)) {
                            node[\heldNotes].keys.asArray.do { |key|
                                if(node[\heldNotes][key][\lane]==lane) {
                                    v[\emitNotes].value(node,(kind:\off,token:key)); node[\heldNotes].removeAt(key)
                                };
                            }; node[\sustain].remove(lane);
                        };
                    }
                );
            };
        };
    };
};
v[\initMIDI] = {
    try {
        if(MIDIClient.initialized.not){MIDIClient.init(verbose:false)}{MIDIClient.list};
        MIDIClient.sources.do { |ep,i|
            if(v[\midiConnections].includes(ep.uid).not) {
                MIDIIn.connect(i,ep); v[\midiConnections].add(ep.uid)
            };
        };
        v[\midiDefs].do(_.free);
        v[\midiDefs] = [
            MIDIdef.noteOn(\void_noteOn,{ |vel,num,chan,src|v[\midiEvent].value(\on,vel,num,chan,src)}),
            MIDIdef.noteOff(\void_noteOff,{ |vel,num,chan,src|v[\midiEvent].value(\off,vel,num,chan,src)}),
            MIDIdef.bend(\void_bend,{ |val,chan,src|v[\midiEvent].value(\bend,val,0,chan,src)}),
            MIDIdef.cc(\void_cc,{ |val,num,chan,src|v[\midiEvent].value(\cc,val,num,chan,src)})
        ].collect { |def|def.permanent_(true) };
        v[\nodes].select { |n|n[\type]==\midiout }.do { |n|v[\openMidiOutput].value(n)};
        v[\message].value("MIDI ready: "++MIDIClient.sources.size++" inputs, "++MIDIClient.destinations.size++" outputs.");
    } { |error|v[\message].value("MIDI unavailable: "++error.errorString)};
};
// Only parse numeric literals and note names; never evaluate text as SC code.
v[\parseNotes] = { |text,degrees=false,limit=16|
    var tokens,valid,result;
    tokens = text.replace(","," ").replace(Char.tab.asString," ").split($ ).reject(_.isEmpty);
    valid = true; result = List.new;
    if(["", "-", "rest"].includesEqual(text.stripWhiteSpace.toLower)) {tokens = []};
    tokens.do { |token|
        var letter,accidental,octave,tail,note;
        if("^[+-]?[0-9]+([.][0-9]+)?$".matchRegexp(token)) {result.add(token.asFloat)} {
            if(degrees.not and: {"^[A-Ga-g][#b]?-?[0-9]+$".matchRegexp(token)}) {
                letter = token[0].toUpper; tail = token.drop(1); accidental = 0;
                if(tail[0]==$#){accidental=1; tail=tail.drop(1)};
                if(tail[0]==$b){accidental = -1; tail=tail.drop(1)};
                octave = tail.asInteger;
                note = [0,2,4,5,7,9,11]["CDEFGAB".indexOf(letter)]+accidental+((octave+1)*12);
                result.add(note);
            } {valid = false};
        };
    };
    if(result.size>limit){valid=false};
    if(valid){result.asArray}{nil}
};
v[\musicKeys] = [\midiSource,\midiChannel,\inputMapping,\bendRange,\midiDestination,
    \mpe,\outChannel,\sequenceDegrees,\noteSteps];
v[\packMusic] = { |node|
    var data;
    data = (); v[\musicKeys].do { |key|data[key] = node[key].deepCopy }; data
};
v[\restoreMusic] = { |node,data|
    if(data.notNil) {v[\musicKeys].do { |key|if(data[key].notNil){node[key] = data[key].deepCopy}}};
    if(node[\type]==\midiout){v[\openMidiOutput].value(node)};
};

// 6 Canvas & drawing ----------------------------------------------------------
v[\text] = { |string,rect,color=nil,font=nil,align=\left|
    Pen.stringInRect(string.asString,rect,font ? v[\font],color ? v[\ink],QAlignment(align));
};
v[\roundRect] = { |rect,fill,border=nil,radius=8|
    Pen.fillColor = fill; Pen.addRoundedRect(rect,radius,radius); Pen.fill;
    if(border.notNil) {Pen.strokeColor = border; Pen.width = 1;
        Pen.addRoundedRect(rect,radius,radius); Pen.stroke};
};
v[\button] = { |rect,label,color,action,on=false|
    v[\roundRect].value(rect,if(on){color.copy.alpha_(0.17)}{v[\glass]},
        if(on){color.copy.alpha_(0.7)}{v[\line]},5);
    if(label=="⚄") {
        var center,r;
        center = rect.center; r = rect.width*0.23;
        Pen.strokeColor = if(on){color}{v[\muted]}; Pen.width = 1;
        Pen.addRoundedRect(Rect.aboutPoint(center,r+1,r+1),1,1); Pen.stroke;
        Pen.fillColor = if(on){color}{v[\ink]};
        [(-0.5 @ -0.5),(-0.5@0.5),(0@0),(0.5 @ -0.5),(0.5@0.5)].do { |point|
            Pen.addOval(Rect.aboutPoint(center+(point*r),0.7,0.7))
        }; Pen.fill;
    } {v[\text].value(label,rect,if(on){color}{v[\ink]},v[\smallFont],\center)};
    v[\hits].add((kind:\button,rect:rect,action:action));
};
v[\slider] = { |rect,label,value,setter,color=nil|
    var col, x;
    col = color ? v[\colors][1]; x = rect.left+(rect.width*value.clip(0,1));
    v[\roundRect].value(rect,v[\glass],v[\line],4);
    Pen.fillColor = col.copy.alpha_(0.19); Pen.addRoundedRect(Rect(rect.left,rect.top,
        rect.width*value.clip(0,1),rect.height),4,4); Pen.fill;
    Pen.strokeColor = col; Pen.width = 2; Pen.line(x@(rect.top+3),x@(rect.bottom-3)); Pen.stroke;
    v[\text].value(label,rect,v[\ink],v[\smallFont],\center);
    v[\hits].add((kind:\slider,rect:rect,value:value,set:setter));
};
v[\viewportAxis] = { |axis|
    var horizontal,zoom,visible,minimum,contentEnd,maximum,current;
    horizontal = axis==\horizontal; zoom = v[\zoom].max(0.001);
    visible = (if(horizontal){v[\canvas].width}{v[\canvas].height})/zoom;
    if(v[\nodes].isEmpty) {
        minimum = 0; contentEnd = visible;
    } {
        minimum = v[\nodes].collect { |node|if(horizontal){node[\pos].x}{node[\pos].y} }.minItem-64;
        contentEnd = v[\nodes].collect { |node|
            var size;
            size = v[\nodeSize].value(node);
            if(horizontal){node[\pos].x+size.x}{node[\pos].y+size.y}
        }.maxItem+64;
    };
    maximum = (contentEnd-visible).max(minimum);
    current = if(horizontal){0-v[\pan].x/zoom}{0-v[\pan].y/zoom};
    (minimum:minimum,maximum:maximum,value:((current-minimum)/(maximum-minimum).max(0.001)).clip(0,1),
        ratio:(visible/(contentEnd-minimum).max(visible)).clip(0,1))
};
v[\setViewport] = { |axis,value,minimum,maximum|
    var start;
    start = minimum+((maximum-minimum)*value.clip(0,1));
    if(axis==\horizontal) {
        v[\pan] = ((0-start*v[\zoom])@v[\pan].y)
    } {
        v[\pan] = (v[\pan].x@(0-start*v[\zoom]))
    };
};
v[\drawViewportBars] = {
    var canvas,axis,state,track,trackLength,thumbLength,thumb,trackStart;
    canvas = v[\canvas];
    [\horizontal,\vertical].do { |direction|
        state = v[\viewportAxis].value(direction);
        track = if(direction==\horizontal) {
            Rect(canvas.left+8,canvas.bottom-12,(canvas.width-30).max(40),10)
        } {
            Rect(canvas.right-12,canvas.top+8,10,(canvas.height-30).max(40))
        };
        trackLength = if(direction==\horizontal){track.width}{track.height};
        thumbLength = (trackLength*state[\ratio]).max(24).min(trackLength);
        trackStart = if(direction==\horizontal){track.left}{track.top};
        thumb = if(direction==\horizontal) {
            Rect(track.left+((trackLength-thumbLength)*state[\value]),track.top+2,thumbLength,track.height-4)
        } {
            Rect(track.left+2,track.top+((trackLength-thumbLength)*state[\value]),track.width-4,thumbLength)
        };
        Pen.fillColor = v[\line]; Pen.addRoundedRect(track,5,5); Pen.fill;
        Pen.fillColor = v[\colors][0].copy.alpha_(0.85); Pen.addRoundedRect(thumb,4,4); Pen.fill;
        v[\hits].add((kind:\viewportScroll,rect:track,axis:direction,thumb:thumb,
            thumbLength:thumbLength,trackLength:trackLength,trackStart:trackStart,
            minimum:state[\minimum],maximum:state[\maximum]));
    };
};
v[\screen] = { |point| (point*v[\zoom])+v[\pan]+(v[\canvas].left@v[\canvas].top) };
v[\world] = { |point| (point-v[\pan]-(v[\canvas].left@v[\canvas].top))/v[\zoom] };
v[\nodeSize] = { |node|
    248 @ (194 + switch(node[\type],\player,{56},\granular,{56},\sequencer,{80},
        \euclid,{78},\scope,{72},\noteseq,{62},\note,{-38},\recorder,{-25},{0}))
};
v[\nodeRect] = { |node|
    var point, size;
    point = v[\screen].value(node[\pos]); size = v[\nodeSize].value(node)*v[\zoom];
    Rect(point.x,point.y,size.x,size.y)
};
v[\portPoint] = { |node,index,output=false|
    var rect, ports;
    rect = v[\nodeRect].value(node);
    ports = v[\registry][node[\type]][if(output){\outputs}{\inputs}];
    (rect.left+(rect.width*(index+1)/(ports.size+1))) @ if(output){rect.bottom}{rect.top}
};
v[\paramPoint] = { |node,index|
    var rect,z;
    rect = v[\nodeRect].value(node); z = v[\zoom];
    if(index<3) {(rect.left+((44+(index*78))*z))@(rect.top+((89+if([\player,\granular].includes(node[\type])){56}{0})*z))}
    {(rect.right-(8*z))@(rect.top+(62+(index*7))*z)}
};
v[\knob] = { |node,index,center,radius=20,large=false|
    var p,spec,color,angle,live,value,rect,diceRect,shown,scale,label;
    p = node[\params][index]; spec = v[\registry][node[\type]][\params][index];
    color = v[\colors][v[\registry][node[\type]][\category]];
    scale = if(large){1}{radius/19};
    value = p[\base]; angle = (pi*0.75)+(value*pi*1.5);
    live = v[\norm].value(spec,node[\live][index] ? v[\actual].value(spec,value));
    rect = Rect(center.x-radius-5,center.y-radius-5,(radius+5)*2,(radius+5)*2);
    Pen.fillColor = Color.new255(12,12,17); Pen.addOval(Rect.aboutPoint(center,radius-3,radius-3)); Pen.fill;
    Pen.width = 3; Pen.strokeColor = v[\line]; Pen.addArc(center,radius,pi*0.75,pi*1.5); Pen.stroke;
    if(p[\random]) {
        Pen.width = 7; Pen.strokeColor = color.copy.alpha_(0.19);
        Pen.addArc(center,radius+3,pi*0.75+(p[\low].max(value-p[\depth])*pi*1.5),
            (p[\high].min(value+p[\depth])-p[\low].max(value-p[\depth])).max(0)*pi*1.5); Pen.stroke;
    };
    Pen.width = 3; Pen.strokeColor = if(p[\locked]){v[\muted]}{color};
    Pen.addArc(center,radius,pi*0.75,value*pi*1.5); Pen.stroke;
    Pen.width = 2; Pen.line(center,center+(Point(cos(angle),sin(angle))*(radius-6))); Pen.stroke;
    angle = pi*0.75+(live*pi*1.5);
    Pen.fillColor = color; Pen.addOval(Rect.aboutPoint(center+(Point(cos(angle),sin(angle))*(radius+1)),2.5,2.5)); Pen.fill;
    shown = v[\actual].value(spec,value);
    shown = if(spec[\pitch]==\hz and: {node[\noteMode] ? false})
        {shown.cpsmidi.round(0.01).asString++" MIDI"}{v[\format].value(shown)};
    if(spec[\choices].notNil) {shown = spec[\choices][v[\actual].value(spec,value).round.asInteger.clip(0,spec[\choices].size-1)]};
    v[\text].value(shown,
        Rect(center.x-radius-(12*scale),center.y+radius+(4*scale),(radius+(12*scale))*2,17*scale),
            v[\ink],v[\smallFont].copy.size_((11*scale).max(7)),\center);
    if(large.not) {
        label = if(v[\nodeLabels][node[\type]].notNil){v[\nodeLabels][node[\type]][index]}{spec[\label]};
        v[\text].value(label,Rect(center.x-(36*scale),center.y+radius+(20*scale),72*scale,19*scale),
            v[\muted],v[\smallFont].copy.size_((10*scale).max(7)),\center)
    };
    v[\hits].add((kind:\knob,rect:rect,node:node,index:index));
    v[\knobHits].add((rect:rect,node:node,index:index));
    if(large.not and: {v[\noteTypes].includes(node[\type]).not}) {
        diceRect = Rect(center.x+radius-(3*scale),center.y-radius-(8*scale),16*scale,16*scale);
        v[\button].value(diceRect,"⚄",color,{
            v[\checkpoint].value; p[\random] = p[\random].not; v[\sendParam].value(node,index)
        },p[\random]);
    };
};
v[\waveform] = { |node,rect|
    var sound, wave, mid, index, start, end;
    v[\roundRect].value(rect,Color.new255(9,12,16),nil,4);
    index = 0;
    if(node[\type]==\granular) {
        index = (node[\soundCursor] ? v[\actual].value(v[\registry][\granular][\params][4],node[\params][4][\base])).round.asInteger;
    };
    sound = node[\pool].wrapAt(index);
    if(sound.notNil and: {sound[\missing]!=true}) {
        wave = sound[\wave]; mid = rect.top+(rect.height*0.5);
        Pen.strokeColor = v[\colors][0].copy.alpha_(0.6); Pen.width = 1;
        wave.do { |sample,i|
            var x, h;
            x = rect.left+(i/(wave.size-1)*rect.width); h = sample.sqrt*rect.height*0.42;
            Pen.line(x@(mid-h),x@(mid+h));
        }; Pen.stroke;
        Pen.strokeColor = Color.white.copy.alpha_(0.8); Pen.width = 1;
        Pen.line((rect.left+(node[\cursor].clip(0,1)*rect.width))@rect.top,
            (rect.left+(node[\cursor].clip(0,1)*rect.width))@rect.bottom); Pen.stroke;
        v[\text].value(sound[\path].basename,Rect(rect.left+4,rect.top+2,rect.width-8,13),v[\muted],v[\smallFont]);
    } {v[\text].value(if(sound.notNil){"Missing sound · Load to replace"}{"Drop sound here or Load…"},
        rect,v[\muted],v[\smallFont],\center)};
    if(node[\type]==\player) {
        start = node[\params][2][\base]; end = node[\params][3][\base];
        [start,end].do { |value,i|
            var x;
            x = rect.left+(value*rect.width);
            Pen.strokeColor = v[\colors][0]; Pen.width = 2; Pen.line(x@rect.top,x@rect.bottom); Pen.stroke;
            v[\hits].add((kind:\waveHandle,rect:Rect(x-6,rect.top,12,rect.height),
                node:node,index:i+2,waveRect:rect));
        };
    };
};
v[\drawSequence] = { |node,rect|
    var w,active;
    w = rect.width/16; active = (node[\cursor]*16).floor.asInteger.clip(0,15);
    16.do { |i|
        var x, h;
        x = rect.left+(i*w); h = node[\steps][i]*(rect.height-22);
        Pen.fillColor = v[\colors][1].copy.alpha_(if(i==active){0.9}{0.4});
        Pen.addRect(Rect(x+1,rect.bottom-20-h,w-2,h)); Pen.fill;
        Pen.fillColor = if(node[\gates][i]>0){v[\colors][1]}{v[\line]};
        Pen.addRect(Rect(x+2,rect.bottom-17,w-4,6)); Pen.fill;
        Pen.fillColor = v[\colors][1].copy.alpha_(0.35);
        Pen.addRect(Rect(x+1,rect.bottom-7,(w-2)*node[\probs][i],5)); Pen.fill;
    };
    v[\hits].add((kind:\sequence,rect:rect,node:node));
};
v[\drawNode] = { |node|
    var rect,z,reg,color,selected,extraY,size,meter,knobY;
    rect = v[\nodeRect].value(node); z = v[\zoom]; reg = v[\registry][node[\type]];
    color = v[\colors][reg[\category]]; selected = v[\selection].includes(node[\id]);
    size = v[\nodeSize].value(node); meter = node[\meter].maxItem;
    if(rect.intersects(v[\canvas])) {
        if(selected or: {meter>0.04}) {
            Pen.strokeColor = color.copy.alpha_(if(selected){0.15}{0.06}); Pen.width = 6;
            Pen.addRoundedRect(rect.insetBy(-2,-2),11*z,11*z); Pen.stroke;
        };
        v[\roundRect].value(rect,v[\glass],color.copy.alpha_(if(node[\active]){0.7}{0.22}),10*z);
        v[\hits].add((kind:\node,rect:rect,node:node));
        v[\text].value(reg[\name],Rect(rect.left+(12*z),rect.top+(12*z),rect.width-(84*z),22*z),color,
            v[\titleFont].copy.size_((12*z).max(8)));
        v[\button].value(Rect(rect.right-(67*z),rect.top+(10*z),18*z,18*z),"●",color,{
            v[\checkpoint].value; v[\bypass].value(node)
        },node[\active]);
        if(v[\noteTypes].includes(node[\type]).not) {v[\button].value(Rect(rect.right-(45*z),rect.top+(10*z),18*z,18*z),"⚄",color,{
            v[\checkpoint].value; node[\chaos] = node[\chaos].not;
            if(node[\synth].notNil) {node[\synth].set(\chaos,node[\chaos].asInteger)}
        },node[\chaos])};
        if(node[\type]!=\output) {
            v[\button].value(Rect(rect.right-(23*z),rect.top+(10*z),16*z,18*z),"×",v[\muted],{
                v[\selection] = Set[node[\id]]; v[\deleteSelected].value
            });
        };
        extraY = 0;
        if([\player,\granular].includes(node[\type])) {
            v[\waveform].value(node,Rect(rect.left+(12*z),rect.top+(43*z),rect.width-(24*z),48*z)); extraY = 56;
        };
        if(node[\type]==\note) {
            v[\text].value(node[\text],Rect(rect.left+(13*z),rect.top+(44*z),rect.width-(26*z),90*z),v[\ink]);
        };
        knobY = rect.top+((89+extraY)*z);
        reg[\params].size.min(3).do { |i|
            v[\knob].value(node,i,(rect.left+((44+(i*78))*z))@knobY,19*z);
        };
        // Less prominent parameters still expose direct cable targets on the node edge.
        reg[\params].size.do { |i|
            if(i>=3 and: {v[\noteTypes].includes(node[\type]).not}) {
                var point, targetRect;
                point = v[\paramPoint].value(node,i); targetRect = Rect.aboutPoint(point,6*z,4*z);
                Pen.strokeColor = color.copy.alpha_(0.45); Pen.width = 1;
                Pen.addOval(Rect.aboutPoint(point,2*z,2*z)); Pen.stroke;
                v[\hits].add((kind:\paramTarget,rect:targetRect,node:node,index:i,
                    tip:reg[\params][i][\label]++" · modulation"));
                v[\knobHits].add((rect:targetRect,node:node,index:i));
            };
        };
        if(node[\type]==\sequencer) {
            v[\drawSequence].value(node,Rect(rect.left+(12*z),rect.top+(159*z),rect.width-(24*z),66*z));
        };
        if(node[\type]==\euclid) {
            var steps,pulses,rotation,center;
            steps = v[\actual].value(reg[\params][0],node[\params][0][\base]).round.asInteger;
            pulses = v[\actual].value(reg[\params][1],node[\params][1][\base]).round.asInteger.min(steps);
            rotation = v[\actual].value(reg[\params][2],node[\params][2][\base]).round.asInteger;
            center = (rect.left+(124*z))@(rect.top+(194*z));
            steps.do { |i|
                var angle,point,on;
                angle = (i/steps*2*pi)-(pi/2); point = center+(Point(cos(angle),sin(angle))*30*z);
                on = (((i+rotation)*pulses)%steps)<pulses;
                Pen.fillColor = if(on){color}{v[\line]};
                Pen.addOval(Rect.aboutPoint(point,3*z,3*z)); Pen.fill;
            };
        };
        if(node[\type]==\scope) {
            var data,scopeRect;
            data = node[\scope] ? Array.fill(32,0); scopeRect = Rect(rect.left+(12*z),rect.top+(157*z),rect.width-(24*z),62*z);
            v[\roundRect].value(scopeRect,Color.black,nil,3);
            Pen.strokeColor = color; Pen.width = 1;
            data.do { |value,i|
                var point;
                point = (scopeRect.left+(i/31*scopeRect.width))@(scopeRect.top+(scopeRect.height*0.5)-(value.clip(-1,1)*scopeRect.height*0.45));
                if(i==0){Pen.moveTo(point)}{Pen.lineTo(point)};
            }; Pen.stroke;
        };
        if([\player,\granular].includes(node[\type])) {
            v[\button].value(Rect(rect.left+(12*z),rect.bottom-(36*z),82*z,20*z),
                if(node[\type]==\player){"Load…"}{"Add sound…"},color,{v[\chooseSound].value(node)});
        };
        if(node[\type]==\sequencer) {
            v[\button].value(Rect(rect.left+(12*z),rect.bottom-(36*z),82*z,20*z),"Mutate steps",color,{
                v[\checkpoint].value;
                node[\steps] = node[\steps].collect { |x| (x+0.18.rand2).clip(0,1) };
                v[\sendSteps].value(node)
            });
        };
        if(v[\noteTypes].includes(node[\type])) {
            var label;
            label = switch(node[\type],\midiin,{node[\midiSource]},\midiout,{node[\midiDestination]},
                {if(node[\sequenceDegrees]){"Scale degrees / chords"}{"MIDI notes / chords"}});
            if(node[\type]!=\noteseq) {
                v[\text].value(label,Rect(rect.left+(12*z),rect.top+(112*z),rect.width-(24*z),24*z),v[\muted],v[\smallFont]);
            };
            if(node[\type]==\noteseq) {
                v[\button].value(Rect(rect.left+(12*z),rect.top+(159*z),98*z,24*z),
                    if(node[\playing]){"Stop"}{"Play"},color,{
                        if(node[\playing]){v[\stopSequence].value(node)}{v[\startSequence].value(node)}
                    },node[\playing]);
                v[\button].value(Rect(rect.left+(118*z),rect.top+(159*z),112*z,24*z),"Edit notes…",color,{v[\noteEditor].value(node)});
                v[\text].value("Step "++(node[\sequenceIndex]+1)++" · "++label,Rect(rect.left+(12*z),rect.top+(190*z),224*z,20*z),color,v[\smallFont]);
            } {
                v[\button].value(Rect(rect.left+(12*z),rect.top+(65*z),218*z,28*z),"MIDI settings…",color,{v[\midiSettings].value(node)});
            };
        };
        if(node[\type]==\recorder) {
            v[\button].value(Rect(rect.left+(16*z),rect.top+(60*z),216*z,32*z),
                if(v[\recording]){"STOP  "++v[\recordTime].value}{"Record master → WAV"},color,
                {v[\toggleRecord].value},v[\recording]);
        };
        if(node[\type]!=\note) {
            if(([\output,\recorder]++v[\noteTypes]).includes(node[\type]).not) {
                var center,amount;
                center = (rect.left+(138*z))@(rect.bottom-(25*z)); amount = node[\chaosAmount];
                Pen.strokeColor = v[\line]; Pen.width = 2;
                Pen.addArc(center,8*z,pi*0.75,pi*1.5); Pen.stroke;
                Pen.strokeColor = color; Pen.addArc(center,8*z,pi*0.75,amount*pi*1.5); Pen.stroke;
                v[\text].value("CHAOS",Rect(rect.left+(96*z),center.y-(7*z),31*z,14*z),v[\muted],
                    v[\smallFont].copy.size_((8*z).max(6)),\center);
                v[\hits].add((kind:\chaosKnob,node:node,rect:Rect.aboutPoint(center,12*z,12*z),
                    tip:"Object CHAOS amount: "++(amount*100).round.asInteger++"%"));
            };
            2.do { |i|
                Pen.fillColor = v[\line]; Pen.addRect(Rect(rect.right-(73*z),rect.bottom-((27-(i*5))*z),60*z,3*z)); Pen.fill;
                Pen.fillColor = color; Pen.addRect(Rect(rect.right-(73*z),rect.bottom-((27-(i*5))*z),
                    60*z*node[\meter][i].clip(0,1).sqrt,3*z)); Pen.fill;
            };
            v[\text].value("#"++node[\id],Rect(rect.right-(39*z),rect.top+(34*z),32*z,13*z),v[\muted],v[\smallFont]);
            [false,true].do { |output|
                reg[if(output){\outputs}{\inputs}].do { |port,i|
                    var point,portRect;
                    point = v[\portPoint].value(node,i,output); portRect = Rect.aboutPoint(point,7*z,7*z);
                    Pen.fillColor = if(port[\kind]==\audio){color}{v[\glass]}; Pen.strokeColor = color; Pen.width = 1.5;
                    if(port[\kind]==\notes) {
                        Pen.moveTo(point+(0 @ (-6*z))); Pen.lineTo(point+(6*z @ 0));
                        Pen.lineTo(point+(0 @ (6*z))); Pen.lineTo(point+((-6*z) @ 0)); Pen.lineTo(point+(0 @ (-6*z)));
                    } {Pen.addOval(Rect.aboutPoint(point,4.5*z,4.5*z))}; Pen.fillStroke;
                    if(v[\drag].notNil and: {v[\drag][\kind]==\cable} and: {output.not}) {
                        if(port[\kind]==v[\drag][\signal]) {
                            Pen.strokeColor = color.copy.alpha_(0.4); Pen.width = 2;
                            Pen.addOval(Rect.aboutPoint(point,9*z,9*z)); Pen.stroke;
                        };
                    };
                    v[\hits].add((kind:if(output){\outlet}{\inlet},rect:portRect,node:node,index:i,
                        signal:port[\kind],tip:port[\name]++" · "++port[\kind]));
                };
            };
        };
    };
};
v[\bezierPoint] = { |a,b,c,d,t|
    (a*((1-t)**3)) + (b*(3*((1-t)**2)*t)) + (c*(3*(1-t)*(t*t))) + (d*(t**3))
};
v[\drawCable] = { |a,d,color,kind,selected=false,cord=nil|
    var b,c,distance,previous,t,point;
    distance = ((a.y-d.y).abs*0.5).max(50).min(240);
    b = a+(0@distance); c = d-(0@distance);
    Pen.push;
    Pen.strokeColor = if(selected){Color.white}{color.copy.alpha_(0.65)};
    Pen.width = if(kind==\audio){2.2}{1.3}; if(kind==\control){Pen.lineDash = FloatArray[5,4]};
    Pen.moveTo(a); Pen.curveTo(d,b,c); Pen.stroke;
    if(cord.notNil) {
        previous = a;
        28.do { |i|
            point = v[\bezierPoint].value(a,b,c,d,(i+1)/28);
            v[\cableSegments].add((a:previous,b:point,cord:cord)); previous = point;
        };
    };
    t = (Main.elapsedTime*0.28)%1;
    point = v[\bezierPoint].value(a,b,c,d,t);
    Pen.fillColor = color.copy.alpha_(0.8); Pen.addOval(Rect.aboutPoint(point,2,2)); Pen.fill;
    Pen.pop;
};
v[\drawCords] = {
    v[\cords].do { |cord|
        var src,dst,a,d;
        src = v[\find].value(cord[\src]); dst = v[\find].value(cord[\dst]);
        if(src.notNil and: {dst.notNil}) {
            a = v[\portPoint].value(src,cord[\outlet],true);
            d = if(cord[\param].notNil){v[\paramPoint].value(dst,cord[\param])}
                {v[\portPoint].value(dst,cord[\inlet],false)};
            v[\drawCable].value(a,d,v[\colors][v[\registry][src[\type]][\category]],cord[\kind],v[\selectedCord]===cord,cord);
        };
    };
    if(v[\drag].notNil and: {v[\drag][\kind]==\cable}) {
        var drag,target,point;
        drag = v[\drag]; target = v[\dropTarget].value(v[\mouse] ? drag[\start],drag[\signal]);
        point = if(target.notNil){target[\rect].center}{v[\mouse] ? drag[\start]};
        v[\drawCable].value(drag[\start],point,v[\colors][1],drag[\signal]);
        if(target.notNil) {
            Pen.strokeColor = Color.white.copy.alpha_(0.8); Pen.width = 2;
            Pen.addRoundedRect(target[\rect].insetBy(-4,-4),5,5); Pen.stroke;
        };
    };
};
v[\draw] = { |view|
    var width,height,left,right,rect,step,x,y,drag,hover;
    width = view.bounds.width; height = view.bounds.height;
    left = if(v[\leftOpen]){204}{0}; right = if(v[\rightOpen]){344}{0};
    v[\canvas] = Rect(left,104,(width-left-right).max(100),height-128);
    v[\hits].clear; v[\knobHits].clear; v[\cableSegments].clear;
    Pen.fillColor = v[\bg]; Pen.fillRect(Rect(0,0,width,height));
    Pen.use {
        rect = v[\canvas]; Pen.addRect(rect); Pen.clip;
        step = (24*v[\zoom]).max(12); Pen.fillColor = Color.new255(28,29,37);
        x = rect.left+(v[\pan].x%step);
        while {x<rect.right} {
            y = rect.top+(v[\pan].y%step);
            while {y<rect.bottom} {Pen.addRect(Rect(x,y,1,1)); y = y+step}; x = x+step;
        }; Pen.fill;
        v[\drawCords].value;
        v[\nodes].do { |node| v[\registry][node[\type]][\nodeDrawing].value(node) };
        if(v[\nodes].size<=1) {
            v[\text].value("Double-click to add an object · Drop sounds here",
                Rect(rect.left+30,rect.top+rect.height*0.45,rect.width-60,32),v[\muted],v[\font],\center)
        };
        drag = v[\drag];
        if(drag.notNil and: {drag[\kind]==\rubber}) {
            rect = Rect.fromPoints(drag[\start],v[\mouse]);
            Pen.fillColor = v[\colors][0].copy.alpha_(0.07); Pen.strokeColor = v[\colors][0].copy.alpha_(0.6);
            Pen.addRect(rect); Pen.fillStroke;
        };
    };
    v[\hits] = v[\hits].select { |hit|hit[\rect].intersects(v[\canvas])}.as(List);
    v[\hits].do { |hit|hit[\rect] = hit[\rect].sect(v[\canvas])};
    v[\knobHits] = v[\knobHits].select { |hit|hit[\rect].intersects(v[\canvas])}.as(List);
    v[\drawPanels].value(width,height);
    v[\drawTop].value(width);
    if(v[\snapshotOpen]==true) {v[\drawSnapshots].value(width)};
    v[\drawViewportBars].value;
    Pen.fillColor = v[\panel]; Pen.fillRect(Rect(0,height-24,width,24));
    v[\text].value(v[\status],Rect(12,height-22,width-150,20),v[\muted],v[\smallFont]);
    v[\text].value((v[\zoom]*100).round.asInteger.asString++"%  ·  VOID",
        Rect(width-140,height-22,128,20),v[\muted],v[\smallFont],\right);
    hover = v[\hits].reverse.detect { |hit| hit[\tip].notNil and: {hit[\rect].contains(v[\mouse] ? (-10 @ -10))} };
    if(hover.notNil) {
        rect = Rect((v[\mouse].x+14).min(width-235),(v[\mouse].y+18).min(height-48),225,24);
        v[\roundRect].value(rect,v[\panel],v[\line],5); v[\text].value(hover[\tip],rect,v[\ink],v[\smallFont],\center);
    };
    if(v[\help]) {v[\drawHelp].value(width,height)};
};

// 7 Mouse / keyboard interaction ---------------------------------------------
v[\dropTarget] = { |point,kind|
    v[\hits].reverse.detect { |hit|
        (hit[\rect].insetBy(-6,-6).contains(point)) and: {
            ((hit[\kind]==\inlet) and: {hit[\signal]==kind}) or: {
                (kind==\control) and: {[\knob,\paramTarget].includes(hit[\kind])} and: {v[\noteTypes].includes(hit[\node][\type]).not}
            }
        }
    }
};
v[\cableAt] = { |point|
    var found;
    found = v[\cableSegments].reverse.detect { |segment|
        var delta, length, t, nearest;
        delta = segment[\b]-segment[\a]; length = delta.x.squared+delta.y.squared;
        t = (((point.x-segment[\a].x)*delta.x)+((point.y-segment[\a].y)*delta.y))/length.max(0.0001);
        nearest = segment[\a]+(delta*t.clip(0,1)); (point-nearest).rho < 6
    };
    if(found.notNil){found[\cord]}{nil}
};
v[\mouseDown] = { |view,x,y,mods,button,clicks|
    var point, hit, node, cord, spec, coordinate, offset;
    point = x@y; v[\mouse] = point; view.focus;
    hit = v[\hits].reverse.detect { |h| h[\rect].contains(point) };
    if(v[\help]) {v[\help] = false} {
        if((button==2) or: {v[\space]} or: {button==0 and: {mods.isAlt and: {hit.isNil}}}) {
            v[\drag] = (kind:\pan,start:point,pan:v[\pan]);
        } {
            if(button==1) {
                node = if(hit.notNil){hit[\node]}{nil};
                if(node.isNil){node = v[\nodes].reverse.detect { |n| v[\nodeRect].value(n).contains(point) }};
                if(node.notNil) {v[\contextMenu].value(node)} {
                    if(v[\canvas].contains(point)){v[\search].value(v[\world].value(point))}
                };
            } {
                if(hit.notNil) {
                    node = hit[\node];
                    switch(hit[\kind],
                        \button,{hit[\action].value(mods)},
                        \slider,{
                            v[\checkpoint].value; v[\drag] = hit.copy.put(\start,point);
                            hit[\set].value(((x-hit[\rect].left)/hit[\rect].width).clip(0,1));
                        },
                        \viewportScroll,{
                            coordinate = if(hit[\axis]==\horizontal){x}{y};
                            offset = if(hit[\thumb].contains(point)) {
                                coordinate-(if(hit[\axis]==\horizontal){hit[\thumb].left}{hit[\thumb].top})
                            } {hit[\thumbLength]*0.5};
                            v[\drag] = hit.copy.put(\offset,offset);
                            v[\setViewport].value(hit[\axis],
                                ((coordinate-hit[\trackStart]-offset)/(hit[\trackLength]-hit[\thumbLength]).max(1)).clip(0,1),
                                hit[\minimum],hit[\maximum]);
                        },
                        \knob,{
                            spec = v[\registry][node[\type]][\params][hit[\index]];
                            v[\checkpoint].value;
                            if(mods.isAlt) {
                                node[\params][hit[\index]][\base] = v[\norm].value(spec,spec[\default]);
                                v[\sendParam].value(node,hit[\index]);
                            } {
                                if(clicks>=2) {
                                    var midi,actual;
                                    midi = spec[\pitch]==\hz and: {node[\noteMode] ? false};
                                    actual = v[\actual].value(spec,node[\params][hit[\index]][\base]);
                                    v[\editNumber].value(spec[\label]++if(midi){" · MIDI note"}{""},if(midi){actual.cpsmidi}{actual},
                                        if(midi){spec[\min].cpsmidi}{spec[\min]},if(midi){spec[\max].cpsmidi}{spec[\max]},{ |value|
                                            if(midi){value = value.midicps};
                                            node[\params][hit[\index]][\base] = v[\norm].value(spec,value);
                                            v[\sendParam].value(node,hit[\index])
                                        });
                                } {v[\drag] = hit.copy.put(\start,point).put(\value,node[\params][hit[\index]][\base])};
                            };
                        },
                        \chaosKnob,{
                            v[\checkpoint].value;
                            if(mods.isAlt){node[\chaosAmount] = 0.6;
                                if(node[\synth].notNil){node[\synth].set(\chaosAmount,0.6)}} {
                                if(clicks>=2){v[\editNumber].value("Object CHAOS amount",node[\chaosAmount],0,1,{ |value|
                                    node[\chaosAmount] = value; if(node[\synth].notNil){node[\synth].set(\chaosAmount,value)}
                                })} {v[\drag] = hit.copy.put(\start,point).put(\value,node[\chaosAmount])};
                            };
                        },
                        \waveHandle,{v[\checkpoint].value; v[\drag] = hit.copy},
                        \outlet,{
                            v[\drag] = (kind:\cable,node:node,index:hit[\index],signal:hit[\signal],
                                start:v[\portPoint].value(node,hit[\index],true));
                        },
                        \sequence,{
                            v[\checkpoint].value; v[\drag] = hit.copy; v[\editStep].value(hit,point,mods)
                        },
                        \node,{
                            if(clicks>=2 and: {node[\type]==\note}) {v[\editNote].value(node)} {
                                if(mods.isShift) {
                                    if(v[\selection].includes(node[\id])) {v[\selection].remove(node[\id])}
                                    {v[\selection].add(node[\id])};
                                } {if(v[\selection].includes(node[\id]).not){v[\selection] = Set[node[\id]]}};
                                v[\selectedCord] = nil; v[\inspectorScroll] = 0; v[\checkpoint].value;
                                v[\drag] = (kind:\move,start:point,positions:v[\nodes].select { |n|
                                    v[\selection].includes(n[\id]) }.collect { |n| [n,n[\pos]] });
                            };
                        }
                    );
                } {
                    if(v[\canvas].contains(point)) {
                        cord = v[\cableAt].value(point);
                        if(cord.notNil) {v[\selectedCord] = cord; v[\selection].clear} {
                            v[\selectedCord] = nil;
                            if(clicks>=2){v[\search].value(v[\world].value(point))} {
                                if(mods.isShift.not){v[\selection].clear};
                                v[\drag] = (kind:\rubber,start:point,selection:v[\selection].copy)
                            };
                        };
                    };
                };
            };
        };
    };
};
v[\editStep] = { |hit,point,mods|
    var rect,index,node;
    rect = hit[\rect]; node = hit[\node]; index = ((point.x-rect.left)/rect.width*16).floor.asInteger.clip(0,15);
    if(point.y >= (rect.bottom-20) and: {point.y < (rect.bottom-9)}) {
        if(hit[\lastStep] != index) {node[\gates][index] = 1-node[\gates][index]};
    } {
        if(mods.isAlt or: {point.y >= (rect.bottom-9)}) {
            node[\probs][index] = (1-((point.y-rect.top)/(rect.height-20))).clip(0,1);
        } {node[\steps][index] = (1-((point.y-rect.top)/(rect.height-20))).clip(0,1)};
    };
    hit[\lastStep] = index; v[\sendSteps].value(node);
};
v[\mouseMove] = { |view,x,y,mods|
    var drag,point,rect,coordinate;
    point = x@y; v[\mouse] = point; drag = v[\drag];
    if(drag.notNil) {
        switch(drag[\kind],
            \pan,{v[\pan] = drag[\pan]+point-drag[\start]},
            \move,{drag[\positions].do { |pair| pair[0][\pos] = pair[1]+((point-drag[\start])/v[\zoom]) }},
            \knob,{
                drag[\node][\params][drag[\index]][\base] = (drag[\value]+((drag[\start].y-y)*
                    if(mods.isShift){0.0006}{0.005})).clip(0,1);
                v[\sendParam].value(drag[\node],drag[\index]);
            },
            \chaosKnob,{
                drag[\node][\chaosAmount] = (drag[\value]+((drag[\start].y-y)*
                    if(mods.isShift){0.0006}{0.005})).clip(0,1);
                if(drag[\node][\synth].notNil){drag[\node][\synth].set(\chaosAmount,drag[\node][\chaosAmount])};
            },
            \slider,{drag[\set].value(((x-drag[\rect].left)/drag[\rect].width).clip(0,1))},
            \viewportScroll,{
                coordinate = if(drag[\axis]==\horizontal){x}{y};
                v[\setViewport].value(drag[\axis],
                    ((coordinate-drag[\trackStart]-drag[\offset])/(drag[\trackLength]-drag[\thumbLength]).max(1)).clip(0,1),
                    drag[\minimum],drag[\maximum]);
            },
            \waveHandle,{
                drag[\node][\params][drag[\index]][\base] = ((x-drag[\waveRect].left)/drag[\waveRect].width).clip(0,1);
                v[\sendParam].value(drag[\node],drag[\index]);
            },
            \sequence,{v[\editStep].value(drag,point,mods)},
            \rubber,{
                rect = Rect.fromPoints(drag[\start],point); v[\selection] = drag[\selection].copy;
                v[\nodes].do { |node| if(rect.intersects(v[\nodeRect].value(node))) {v[\selection].add(node[\id])} };
            }
        );
    };
};
v[\mouseUp] = { |view,x,y,mods,button|
    var drag,target;
    drag = v[\drag];
    if(drag.notNil and: {drag[\kind]==\cable}) {
        target = v[\dropTarget].value(x@y,drag[\signal]);
        if(target.notNil) {
            v[\connect].value(drag[\node],drag[\index],target[\node],
                if(target[\kind]==\inlet){target[\index]}{0},
                if(target[\kind]==\inlet){nil}{target[\index]});
        };
    };
    v[\drag] = nil;
};
v[\wheel] = { |view,x,y,mods,dx,dy|
    var before,newZoom;
    if(mods.isCmd or: {mods.isCtrl}) {
        before = v[\world].value(x@y); newZoom = (v[\zoom]*(2**(dy/180))).clip(0.3,2.2);
        v[\zoom] = newZoom; v[\pan] = (x@y)-(v[\canvas].left@v[\canvas].top)-(before*newZoom);
    } {
        if(v[\rightOpen] and: {x>v[\canvas].right}) {
            v[\inspectorScroll] = (v[\inspectorScroll]-(dy*2)).clip(0,v[\inspectorMax] ? 0)
        } {
            if(v[\leftOpen] and: {x<v[\canvas].left}) {
                v[\libraryScroll] = (v[\libraryScroll]-(dy*2)).clip(0,1100)
            } {v[\pan] = v[\pan]+((dx*1.4)@(dy*1.4))};
        };
    };
};
v[\keyDown] = { |view,char,mods,unicode,keycode,key|
    var command,letter;
    key = key ? keycode;
    letter = if(key.inclusivelyBetween(65,90)){key.asAscii.toLower}{char.toLower};
    command = mods.isCmd or: {mods.isCtrl};
    if(key==32) {v[\space] = true};
    if([8,127].includes(unicode) or: {[16777223,16777219].includes(key)}) {v[\deleteSelected].value};
    if(command) {
        if(key==46){CmdPeriod.run};
        switch(letter,
            $d,{if(mods.isShift){v[\copy].value; v[\paste].value}{v[\showHelp].value}},
            $c,{v[\copy].value}, $v,{v[\paste].value},
            $a,{v[\selection] = v[\nodes].collect { |n| n[\id] }.asSet},
            $z,{if(mods.isShift){v[\redoAction].value}{v[\undoAction].value}},
            $y,{v[\redoAction].value}, $s,{v[\save].value}, $o,{v[\load].value}
        );
    } {
        switch(letter,
            $b,{v[\checkpoint].value; v[\nodes].do { |n| if(v[\selection].includes(n[\id])){v[\bypass].value(n)} }},
            $h,{v[\showHelp].value}, $?,{v[\showHelp].value},
            $f,{v[\fit].value}, $m,{v[\mutate].value},
            $r,{v[\toggleRecord].value},
            $t,{v[\tap].value},
            $p,{v[\panicNotes].value; if(v[\hardware].notNil){v[\hardware].set(\panic,1)}; v[\audioOn] = false},
            $i,{v[\rightOpen] = v[\rightOpen].not}, $l,{v[\leftOpen] = v[\leftOpen].not}
        );
        if(key==16777216){v[\drag] = nil; v[\help] = false; v[\snapshotOpen] = false};
    };
    true
};

// 8 Panels & top bar ----------------------------------------------------------
v[\editNumber] = { |title,value,low,high,setter|
    var win,field;
    win = Window(title,Rect(200,200,300,82)).background_(v[\panel]);
    field = TextField(win,Rect(12,15,276,30)).string_(value.round(0.0001).asString)
        .font_(v[\font]).background_(v[\glass]).stringColor_(v[\ink]);
    StaticText(win,Rect(12,51,276,18)).string_("Enter to apply · Esc to cancel").stringColor_(v[\muted]).font_(v[\smallFont]);
    field.action_({setter.value(field.string.asFloat.clip(low,high)); win.close});
    field.keyDownAction_({ |view,char,mods,unicode,keycode,key| if(key==16777216){win.close}; nil });
    v[\dialogs].add(win); v[\installHelpShortcuts].value(win.view); win.front; field.focus; field.selectAll;
};
v[\editNote] = { |node|
    var win,field,button;
    win = Window("VOID · Note",Rect(200,200,460,260)).background_(v[\panel]);
    field = TextView(win,Rect(12,12,436,195)).string_(node[\text])
        .font_(v[\font]).background_(v[\glass]).stringColor_(v[\ink]);
    button = UserView(win,Rect(340,220,108,26)).background_(v[\panel]);
    button.drawFunc_({
        v[\roundRect].value(Rect(0,0,108,26),v[\glass],v[\line],5);
        v[\text].value("Save note",Rect(0,0,108,26),v[\ink],v[\smallFont],\center)
    });
    button.mouseDownAction_({v[\checkpoint].value; node[\text] = field.string; win.close});
    v[\dialogs].add(win); v[\installHelpShortcuts].value(win.view); win.front; field.focus;
};
v[\chooseSound] = { |node|
    Dialog.openPanel({ |paths|
        {if(paths.isString){[paths]}{paths.asArray}.do { |path| v[\loadSound].value(node,path) }}.defer
    },multipleSelection:node[\type]==\granular);
};
v[\fit] = {
    var left,top,right,bottom,canvas;
    canvas = v[\canvas];
    if(canvas.notNil and: {v[\nodes].notEmpty}) {
        left = v[\nodes].collect { |n| n[\pos].x }.minItem;
        top = v[\nodes].collect { |n| n[\pos].y }.minItem;
        right = v[\nodes].collect { |n| n[\pos].x+v[\nodeSize].value(n).x }.maxItem;
        bottom = v[\nodes].collect { |n| n[\pos].y+v[\nodeSize].value(n).y }.maxItem;
        v[\zoom] = ((canvas.width-70)/(right-left).max(1)).min((canvas.height-70)/(bottom-top).max(1)).clip(0.3,1.25);
        v[\pan] = (35@35)-((left@top)*v[\zoom]);
    };
};
v[\tap] = {
    var now,delta;
    now = Main.elapsedTime;
    if(v[\lastTap].notNil) {
        delta = now-v[\lastTap];
        if(delta>0.18 and: {delta<3}) {
            v[\bpm] = (60/delta).clip(20,300).round(0.1); v[\sendGlobals].value
        };
    };
    v[\lastTap] = now;
};
v[\parseScala] = { |text|
    var lines,count,valid,values,period,result;
    result = nil; valid = true;
    lines = text.split(Char.nl).collect { |line|line.split($!).first.stripWhiteSpace }.reject(_.isEmpty);
    if(lines.size>=3 and: {"^[0-9]+$".matchRegexp(lines[1])}) {
        count = lines[1].asInteger;
        if(count.inclusivelyBetween(1,512) and: {lines.size>=(count+2)}) {
            values = Array.fill(count,{ |i|
                var token,parts,value;
                token = lines[i+2].replace(Char.tab.asString," ").split($ ).reject(_.isEmpty).first;
                value = 0;
                if("^[0-9]+/[0-9]+$".matchRegexp(token)) {
                    parts = token.split($/).collect(_.asFloat);
                    if(parts.minItem>0){value = (parts[0]/parts[1]).log2*12}{valid = false};
                } {
                    if("^[0-9]+([.][0-9]*)?$".matchRegexp(token)) {
                        value = if(token.find(".").notNil){token.asFloat/100}{token.asFloat.max(0.000001).log2*12};
                    } {valid = false};
                }; value
            });
            period = values.last;
            if(period<=0 or: {period>120} or: {values.any { |n|n<=0 }} or: {
                (1..(count-1)).any { |i|if(count>1){values[i]<=values[i-1]}{false} }
            }) {valid = false};
            if(valid) {
                result = (name:lines[0],period:period,
                    degrees:[0]++if(count>1){values.copyRange(0,count-2)}{[]});
            };
        };
    }; result
};
v[\importScala] = { |path|
    var scale;
    try {scale = v[\parseScala].value(File.readAllString(path))} {scale = nil};
    if(scale.notNil) {
        v[\checkpoint].value; v[\customScale] = scale; v[\scaleMode] = 0; v[\sendGlobals].value;
        v[\message].value("Imported Scala tuning: "++scale[\name]);
    } {v[\message].value("Invalid Scala file. Use 1–512 ascending intervals in cents or ratios, ending with the period.")};
    scale.notNil
};

// Musical editors use native Qt controls so text, numbers and selection are accessible.
v[\dialogLabel] = { |win,rect,text|
    StaticText(win,rect).string_(text).font_(v[\smallFont]).stringColor_(v[\ink])
};
v[\dialogButton] = { |win,rect,text,action|
    Button(win,rect).states_([[text,v[\ink],v[\glass]]]).action_(action)
};
v[\scaleBrowser] = {
    var win,search,list,results,details,mode,root,cents,period,name,customMode,update,filter,choose;
    win = Window("VOID · Scales, modes & tuning",Rect(100,70,780,650)).background_(v[\panel]);
    v[\dialogLabel].value(win,Rect(16,8,748,24),"Search all core scales, Arabic maqamat, Persian references, tunings and 2–127 EDO");
    search = TextField(win,Rect(16,36,748,28)).background_(v[\glass]).stringColor_(v[\ink]);
    list = ListView(win,Rect(16,74,748,260)).background_(v[\glass]).stringColor_(v[\ink]).font_(v[\font]);
    details = StaticText(win,Rect(16,340,748,44)).stringColor_(v[\ink]).font_(v[\smallFont]);
    v[\dialogLabel].value(win,Rect(16,388,55,24),"Mode");
    mode = NumberBox(win,Rect(70,388,70,26)).decimals_(0).clipLo_(0).clipHi_(126).value_(v[\scaleMode]);
    v[\dialogLabel].value(win,Rect(160,388,222,24),"Root semitones (fractional allowed)");
    root = NumberBox(win,Rect(382,388,100,26)).decimals_(4).clipLo_(0).clipHi_(11.9999).value_(v[\root]);
    v[\dialogLabel].value(win,Rect(16,424,748,22),"Mode 0 = original. Other modes rotate the selected pitch collection. C = 0, C# = 1, etc.");
    update = {
        var entry,index;
        index = results[list.value ? 0];
        if(index.notNil) {
            entry = v[\scaleCatalog][index]; mode.clipHi_(entry[\degrees].size-1);
            details.string_(entry[\name]++" · "++entry[\degrees].size++" degrees · period "++
                (entry[\period]*100).round(0.01)++" cents\n"++
                entry[\degrees].collect { |n|(n*100).round(0.01).asString }.join("  "));
        };
    };
    filter = {
        var query;
        query = search.string.toLower;
        results = (0..(v[\scaleCatalog].size-1)).select { |i|
            query.isEmpty or: {(v[\scaleCatalog][i][\group]++" "++v[\scaleNames][i]).toLower.find(query).notNil}
        };
        list.items_(results.collect { |i|v[\scaleCatalog][i][\group]++" · "++v[\scaleNames][i] });
        if(results.notEmpty){list.value_(results.indexOf(v[\scaleIndex]) ? 0); update.value};
    };
    choose = {
        if(results.notEmpty) {
            v[\checkpoint].value; v[\customScale] = nil;
            v[\scaleIndex] = results[list.value]; v[\scaleMode] = mode.value.round.asInteger;
            v[\root] = root.value; v[\sendGlobals].value;
            v[\message].value("Scale: "++v[\scaleNames][v[\scaleIndex]]++" · mode "++v[\scaleMode]);
        };
    };
    search.action_({filter.value}); search.keyUpAction_({filter.value}); list.action_({mode.value_(0); update.value});
    list.enterKeyAction_({choose.value});
    v[\dialogButton].value(win,Rect(548,386,216,30),"Use selected scale / mode",{choose.value});
    v[\dialogLabel].value(win,Rect(16,456,748,22),"Custom tuning: enter cents from the tonic, including 0, excluding the period endpoint.");
    name = TextField(win,Rect(16,485,330,26)).string_("Custom tuning");
    v[\dialogLabel].value(win,Rect(362,485,122,26),"Period in cents");
    period = NumberBox(win,Rect(490,485,116,26)).clipLo_(1).clipHi_(10000).value_(v[\activeScale].value[\period]*100);
    v[\dialogLabel].value(win,Rect(620,485,54,26),"Mode");
    customMode = NumberBox(win,Rect(674,485,90,26)).clipLo_(0).clipHi_(511).decimals_(0)
        .value_(if(v[\customScale].notNil){v[\scaleMode]}{0});
    cents = TextField(win,Rect(16,521,748,28)).string_(v[\activeScale].value[\degrees].collect { |n|(n*100).round(0.001).asString }.join(" "));
    v[\dialogButton].value(win,Rect(16,560,224,28),"Copy selected scale to custom",{
        if(results.notEmpty) {
            var entry;
            entry = v[\scaleCatalog][results[list.value]];
            name.string_(entry[\name]); period.value_(entry[\period]*100); customMode.value_(mode.value);
            cents.string_(entry[\degrees].collect { |n|(n*100).round(0.001).asString }.join(" "));
        };
    });
    v[\dialogButton].value(win,Rect(252,560,210,28),"Apply custom cents",{
        var values;
        values = v[\parseNotes].value(cents.string,true,512);
        if(values.notNil and: {values.notEmpty} and: {values.minItem>=0} and: {values.maxItem<period.value}) {
            v[\checkpoint].value; values = (values++[0]).as(Set).asArray.sort;
            v[\customScale] = (name:name.string,degrees:values/100,period:period.value/100);
            v[\scaleMode] = customMode.value.round.asInteger.mod(values.size); v[\root] = root.value; v[\sendGlobals].value;
            v[\message].value("Custom tuning applied: "++name.string);
        } {v[\message].value("Use numeric cents >= 0 and below the period; separate values with spaces.")};
    });
    v[\dialogButton].value(win,Rect(486,560,278,28),"Import Scala .scl…",{
        FileDialog({ |paths|{if(v[\alive] and: {v[\importScala].value(paths.first)}) {
            if(win.isClosed.not){win.close}; v[\scaleBrowser].value
        }}.defer},fileMode:1,acceptMode:0);
    });
    v[\dialogLabel].value(win,Rect(16,598,748,40),"Persian and core Arabic presets are reference approximations. Adjust cents for the tradition or performance.\nMIDI IN: choose Degree mapping to access successive EDO pitches on consecutive keys.");
    filter.value; v[\dialogs].add(win); v[\installHelpShortcuts].value(win.view); win.front; search.focus;
};
v[\noteEditor] = { |node|
    var win,mode,rows,status,chord,stepIndex,chordRoot,chordDefs,fillRows,saveRows;
    win = Window("VOID · NOTE SEQ #"++node[\id],Rect(80,50,860,720)).background_(v[\panel]);
    v[\dialogLabel].value(win,Rect(16,8,828,23),"Each row plays a note or chord. Empty / rest / - = rest. Degree 0 is the tonic; MIDI C4 = 60.");
    mode = PopUpMenu(win,Rect(16,38,300,26)).items_(["Scale degrees (0 2 4 = scale triad)","MIDI pitches / note names (C4 E4 G4)"])
        .value_(if(node[\sequenceDegrees]){0}{1});
    v[\dialogLabel].value(win,Rect(330,38,514,26),"Use the inspector for rate, length, base octave and gate length.");
    [ ["Step",16,44],["On",62,32],["Notes / chord",106,360],["Velocity",482,80],["Chance %",580,80],["Duration ×",680,95] ].do { |h|
        v[\dialogLabel].value(win,Rect(h[1],76,h[2],22),h[0])
    };
    rows = Array.fill(16,{ |i|
        var y,row;
        y = 104+(i*29); row = ();
        v[\dialogLabel].value(win,Rect(16,y,40,24),(i+1).asString);
        row[\on] = CheckBox(win,Rect(62,y,32,24));
        row[\notes] = TextField(win,Rect(106,y,360,24));
        row[\velocity] = NumberBox(win,Rect(482,y,80,24)).clipLo_(1).clipHi_(127).decimals_(0);
        row[\probability] = NumberBox(win,Rect(580,y,80,24)).clipLo_(0).clipHi_(100).decimals_(1);
        row[\duration] = NumberBox(win,Rect(680,y,95,24)).clipLo_(0.0625).clipHi_(16).decimals_(3); row
    });
    fillRows = {
        rows.do { |row,i|
            var step;
            step = node[\noteSteps][i]; row[\on].value_(step[\enabled]);
            row[\notes].string_(step[\notes].collect(_.asString).join(" "));
            row[\velocity].value_(step[\velocity]); row[\probability].value_(step[\probability]*100);
            row[\duration].value_(step[\duration]);
        };
    };
    status = StaticText(win,Rect(16,664,828,42)).font_(v[\smallFont]).stringColor_(v[\ink]);
    saveRows = {
        var steps,valid;
        valid = true;
        steps = rows.collect { |row,i|
            var notes;
            notes = v[\parseNotes].value(row[\notes].string,mode.value==0);
            if(notes.isNil) {valid = false; status.string_("Invalid notes in step "++(i+1)++". Use numbers, note names (MIDI mode), or rest.")};
            (notes:notes,enabled:row[\on].value,velocity:row[\velocity].value.round.asInteger,
                probability:row[\probability].value/100,duration:row[\duration].value)
        };
        if(valid) {
            v[\checkpoint].value; node[\noteSteps] = steps; node[\sequenceDegrees] = mode.value==0;
            status.string_("Pattern saved. "++if(node[\sequenceDegrees]){"Degrees follow the global scale / root / mode."}{"MIDI pitches are literal; decimals preserve microtones."});
        }; valid
    };
    chordDefs = [["Scale triad",[0,2,4]],["Scale seventh",[0,2,4,6]],["Scale ninth",[0,2,4,6,8]],
        ["Major",[0,4,7]],["Minor",[0,3,7]],["Diminished",[0,3,6]],["Augmented",[0,4,8]],
        ["Sus2",[0,2,7]],["Sus4",[0,5,7]],["Dominant 7",[0,4,7,10]],
        ["Major 7",[0,4,7,11]],["Minor 7",[0,3,7,10]],["Major 9",[0,4,7,11,14]],
        ["Minor 9",[0,3,7,10,14]],["Fourth stack",[0,5,10]],["Fifth stack",[0,7,14]]];
    v[\dialogLabel].value(win,Rect(16,576,42,25),"Step");
    stepIndex = NumberBox(win,Rect(58,576,54,26)).value_(1).clipLo_(1).clipHi_(16).decimals_(0);
    v[\dialogLabel].value(win,Rect(126,576,42,25),"Root");
    chordRoot = NumberBox(win,Rect(168,576,70,26)).value_(0).clipLo_(-127).clipHi_(127).decimals_(3);
    chord = PopUpMenu(win,Rect(252,576,220,26)).items_(chordDefs.collect(_[0]));
    v[\dialogButton].value(win,Rect(486,576,180,26),"Insert chord",{
        var item,isDegree;
        item = chordDefs[chord.value]; isDegree = chord.value<3;
        if((mode.value==0)==isDegree) {
            rows[stepIndex.value.round.asInteger-1][\notes].string_((item[1]+chordRoot.value).collect(_.asString).join(" "));
            status.string_("Chord inserted; Apply saves the pattern.");
        } {status.string_(if(isDegree){"Choose Scale degrees mode for scale chords."}{"Choose MIDI mode for semitone chords; set Root to a MIDI pitch such as 60."})};
    });
    v[\dialogButton].value(win,Rect(16,620,160,30),"Apply pattern",{saveRows.value});
    v[\dialogButton].value(win,Rect(190,620,160,30),"Apply & play",{if(saveRows.value){v[\startSequence].value(node)}});
    v[\dialogButton].value(win,Rect(364,620,120,30),"Stop",{v[\stopSequence].value(node)});
    v[\dialogButton].value(win,Rect(498,620,160,30),"Scales & modes…",{v[\scaleBrowser].value});
    fillRows.value; v[\dialogs].add(win); v[\installHelpShortcuts].value(win.view); win.front;
};
v[\midiSettings] = { |node|
    var win,sources,destinations,input,channel,mapping,range,destination,mpe,outChannel;
    v[\initMIDI].value;
    win = Window("VOID · "++v[\registry][node[\type]][\name]++" #"++node[\id],Rect(180,120,650,360)).background_(v[\panel]);
    if(node[\type]==\midiin) {
        sources = ["All inputs"]++(MIDIClient.sources ? []).collect { |ep|v[\endpointName].value(ep)};
        v[\dialogLabel].value(win,Rect(16,14,618,24),"Input device");
        input = PopUpMenu(win,Rect(16,44,618,28)).items_(sources).value_(sources.indexOfEqual(node[\midiSource]) ? 0);
        v[\dialogLabel].value(win,Rect(16,86,180,24),"Channel");
        channel = PopUpMenu(win,Rect(200,86,180,28)).items_(["All channels"]++(1..16).collect(_.asString)).value_(node[\midiChannel]+1);
        v[\dialogLabel].value(win,Rect(16,128,180,24),"Keyboard mapping");
        mapping = PopUpMenu(win,Rect(200,128,434,28)).items_(["Chromatic MIDI (unaltered)","Nearest pitch in global scale","Scale degrees (key 60 = tonic)"]).value_(node[\inputMapping]);
    } {
        destinations = ["None"]++(MIDIClient.destinations ? []).collect { |ep|v[\endpointName].value(ep)};
        if(destinations.includesEqual(node[\midiDestination]).not){destinations = destinations++[node[\midiDestination]]};
        v[\dialogLabel].value(win,Rect(16,14,618,24),"Output device");
        destination = PopUpMenu(win,Rect(16,44,618,28)).items_(destinations).value_(destinations.indexOfEqual(node[\midiDestination]) ? 0);
        mpe = CheckBox(win,Rect(16,86,618,28)).string_("MPE / channel per note: channels 2–16, independent microtones").value_(node[\mpe]);
        v[\dialogLabel].value(win,Rect(16,128,180,24),"Standard output channel");
        outChannel = NumberBox(win,Rect(200,128,100,28)).clipLo_(1).clipHi_(16).decimals_(0).value_(node[\outChannel]+1);
    };
    v[\dialogLabel].value(win,Rect(16,174,180,24),"Pitch bend range (semitones)");
    range = NumberBox(win,Rect(200,174,100,28)).clipLo_(1).clipHi_(96).decimals_(0).value_(node[\bendRange]);
    v[\dialogLabel].value(win,Rect(16,216,618,70),if(node[\type]==\midiin){
        "Sustain CC64, note-on velocity 0, pitch bend, CC120/123 and device/channel filtering are supported.\nConnect the Notes diamond to POLY SYNTH, then its audio outlet to OUTPUT."
    } {
        "The receiver must accept the configured bend range (RPN 0). MPE mode has 15 independent voices.\nStandard MIDI rounds fractional notes. Internal POLY SYNTH always preserves microtones."
    });
    v[\dialogButton].value(win,Rect(16,306,180,30),"Apply settings",{
        v[\checkpoint].value; v[\stopMusicNode].value(node); node[\bendRange] = range.value.round.asInteger;
        if(node[\type]==\midiin) {
            node[\midiSource] = sources[input.value]; node[\midiChannel] = channel.value-1;
            node[\inputMapping] = mapping.value;
        } {
            node[\midiDestination] = destinations[destination.value]; node[\mpe] = mpe.value;
            node[\outChannel] = outChannel.value.round.asInteger-1; v[\openMidiOutput].value(node);
        }; win.close;
    });
    v[\dialogButton].value(win,Rect(210,306,190,30),"Refresh MIDI devices",{win.close; v[\midiSettings].value(node)});
    v[\dialogs].add(win); v[\installHelpShortcuts].value(win.view); win.front;
};
v[\musicPatch] = { |sequence=false|
    var source,synth,output;
    if(v[\ready]) {
        v[\checkpoint].value;
        source = v[\add].value(if(sequence){\noteseq}{\midiin},40@80,false);
        synth = v[\add].value(\polysynth,340@160,false); output = v[\output];
        v[\connect].value(source,0,synth,0,nil,1,false);
        v[\connect].value(synth,0,output,0,nil,1,false);
        v[\selection] = Set[source[\id]]; v[\fit].value;
        if(sequence){v[\noteEditor].value(source)}{v[\midiSettings].value(source)};
        v[\message].value(if(sequence){"NOTE SEQ → POLY SYNTH → OUTPUT. Edit notes, then Apply & play."}{"MIDI IN → POLY SYNTH → OUTPUT. Choose your input, Apply, then play."});
    };
};

v[\drawTop] = { |width|
    var output,volume,color,siteRect;
    output = v[\output]; color = v[\colors][0];
    Pen.fillColor = v[\panel]; Pen.fillRect(Rect(0,0,width,104));
    v[\text].value("V O I D",Rect(16,8,80,30),v[\ink],v[\titleFont].copy.size_(20));
    v[\text].value("Ali Balighi © 2026",Rect(16,38,106,12),v[\muted],v[\smallFont].copy.size_(9));
    siteRect = Rect(16,50,106,12);
    v[\text].value("alibalighi.com",siteRect,color,v[\smallFont]);
    Pen.strokeColor = color; Pen.width = 1;
    Pen.line((siteRect.left+1)@(siteRect.bottom-3),(siteRect.left+siteRect.width-1)@(siteRect.bottom-3)); Pen.stroke;
    v[\hits].add((kind:\button,rect:siteRect,tip:"Open alibalighi.com",action:{"https://alibalighi.com".openOS}));
    v[\button].value(Rect(108,16,106,28),if(v[\ready]){if(v[\audioOn]){"● Audio ON"}{"Audio OFF"}}{"Restart audio"},
        color,{
            if(v[\ready]) {
                v[\audioOn] = v[\audioOn].not;
                v[\hardware].set(\on,v[\audioOn].asInteger,\panic,0);
            } {v[\restart].value};
        },v[\audioOn] and: {v[\ready]});
    if(output.notNil) {
        volume = output[\params][0][\base];
        v[\slider].value(Rect(228,16,118,28),"MASTER  "++(volume*100).round.asInteger++"%",volume,
            { |value| output[\params][0][\base] = value; v[\sendParam].value(output,0) },v[\colors][3]);
    };
    v[\button].value(Rect(360,16,76,28),v[\bpm].asString++" BPM",v[\colors][1],{
        v[\editNumber].value("Tempo",v[\bpm],20,300,{ |value|v[\bpm]=value; v[\sendGlobals].value})
    });
    v[\button].value(Rect(441,16,36,28),"TAP",v[\colors][1],{v[\tap].value});
    v[\button].value(Rect(490,16,106,28),v[\activeScale].value[\name].keep(14),v[\colors][1],{v[\scaleBrowser].value});
    v[\hits].last[\tip] = v[\activeScale].value[\name]++" · mode "++v[\scaleMode];
    v[\button].value(Rect(601,16,40,28),v[\rootNames][v[\root].round.asInteger.mod(12)],v[\colors][1],{v[\scaleBrowser].value});
    v[\button].value(Rect(655,16,72,28),"MUTATE",v[\colors][1],{v[\mutate].value});
    v[\slider].value(Rect(739,16,142,28),"CHAOS  "++(v[\globalChaos]*100).round.asInteger++"%",v[\globalChaos],
        { |value| v[\globalChaos] = value; v[\sendGlobals].value },v[\colors][1]);
    v[\text].value("EXPERIMENTAL PATCH INSTRUMENT",Rect(900,18,(width-914).max(1),24),v[\muted],v[\smallFont],\right);
    v[\button].value(Rect(16,62,74,26),"Library",v[\colors][0],{v[\leftOpen] = v[\leftOpen].not},v[\leftOpen]);
    v[\button].value(Rect(97,62,80,26),"Inspector",v[\colors][0],{v[\rightOpen] = v[\rightOpen].not},v[\rightOpen]);
    v[\button].value(Rect(184,62,64,26),"Fit view",v[\muted],{v[\fit].value});
    v[\button].value(Rect(263,62,84,26),"Snapshots",v[\colors][1],{v[\snapshotOpen] = (v[\snapshotOpen] ? false).not},v[\snapshotOpen] ? false);
    v[\button].value(Rect(354,62,104,26),if(v[\recording]){"■ "++v[\recordTime].value}{"● Record"},
        Color.new255(245,104,115),{v[\toggleRecord].value},v[\recording]);
    v[\button].value(Rect(473,62,48,26),"Save",v[\muted],{v[\save].value});
    v[\button].value(Rect(528,62,48,26),"Load",v[\muted],{v[\load].value});
    v[\button].value(Rect(583,62,52,26),"Demo",v[\colors][2],{v[\demo].value});
    v[\button].value(Rect(642,62,36,26),"?",v[\muted],{v[\showHelp].value});
    v[\button].value(Rect(693,62,68,26),"PANIC",Color.new255(245,104,115),{
        v[\panicNotes].value; if(v[\hardware].notNil){v[\hardware].set(\panic,1)};
        v[\audioOn] = false; v[\message].value("Silenced. Audio ON resumes output.")
    });
    v[\button].value(Rect(774,62,74,26),"MIDI +",v[\colors][0],{v[\musicPatch].value(false)});
    v[\button].value(Rect(855,62,90,26),"Notes +",v[\colors][1],{v[\musicPatch].value(true)});
    v[\text].value("CPU "++s.avgCPU.round(0.1)++"%   ·   "++s.numSynths++" synths   ·   "++v[\nodes].size++" objects",
        Rect(958,64,(width-974).max(1),22),v[\muted],v[\smallFont],\right);
    Pen.strokeColor = v[\line]; Pen.width = 1; Pen.line(0@103,width@103); Pen.stroke;
};
v[\drawPanels] = { |width,height|
    var x,y,node,reg,color,contentTop,cord;
    if(v[\leftOpen]) {
        Pen.fillColor = v[\panel]; Pen.fillRect(Rect(0,104,204,height-128));
        v[\text].value("OBJECT LIBRARY",Rect(16,115,172,23),v[\muted],v[\smallFont]);
        Pen.use {
            Pen.addRect(Rect(0,146,204,height-174)); Pen.clip; y = 151-v[\libraryScroll];
            v[\categories].do { |name,category|
                color = v[\colors][category];
                v[\text].value(name,Rect(16,y,172,22),color,v[\smallFont]); y = y+27;
                if(v[\collapsedCategories].includes(category).not) {
                    v[\order].select { |key| v[\registry][key][\category]==category }.do { |key|
                        var rect;
                        rect = Rect(12,y,180,29);
                        v[\button].value(rect,v[\registry][key][\name],color,{
                            var center;
                            center = v[\world].value(v[\canvas].center);
                            v[\add].value(key,center-(124@90));
                        }); y = y+34;
                    };
                };
                v[\hits].add((kind:\button,rect:Rect(12,y-(if(v[\collapsedCategories].includes(category)){27}{
                    v[\order].count { |key|v[\registry][key][\category]==category }*34+27}),180,22),action:{
                    if(v[\collapsedCategories].includes(category)){v[\collapsedCategories].remove(category)}
                    {v[\collapsedCategories].add(category)}
                }));
                y = y+15;
            };
        };
        // Remove off-panel hit regions produced by the scrollable library.
        v[\hits] = v[\hits].reject { |hit| hit[\rect].left<204 and: {
            (hit[\rect].top<146) or: {hit[\rect].bottom>(height-24)}
        } }.as(List);
    };
    if(v[\rightOpen]) {
        x = width-344;
        Pen.fillColor = v[\panel]; Pen.fillRect(Rect(x,104,344,height-128));
        v[\text].value("INSPECTOR",Rect(x+16,115,312,23),v[\muted],v[\smallFont]);
        node = v[\selected].value; cord = v[\selectedCord];
        if(cord.notNil) {
            v[\text].value(if(cord[\param].notNil){"PARAMETER MODULATION"}{"PATCH CABLE"},Rect(x+16,152,312,24),v[\ink],v[\titleFont]);
            v[\slider].value(Rect(x+16,195,312,28),if(cord[\kind]==\notes){"Velocity scale: "}{"Depth / gain: "}++cord[\amount].round(0.01),
                if(cord[\kind]==\notes){cord[\amount]/2}{(cord[\amount]+2)/4},{ |value|
                    cord[\amount] = if(cord[\kind]==\notes){value*2}{value*4-2};
                    if(cord[\synth].notNil){cord[\synth].set(\amount,cord[\amount])}
                });
            v[\button].value(Rect(x+16,237,144,28),"Delete cable",v[\colors][1],{v[\deleteSelected].value});
        } {
            if(node.isNil) {
                v[\text].value("Select an object or cable.\n\nDrag a control outlet onto any knob.\n\nScroll here to explore parameters.",
                    Rect(x+18,160,306,150),v[\muted]);
            } {
                reg = v[\registry][node[\type]]; color = v[\colors][reg[\category]];
                v[\text].value(reg[\name],Rect(x+16,148,312,28),color,v[\titleFont]);
                Pen.use {
                    Pen.addRect(Rect(x,185,344,height-211)); Pen.clip;
                    contentTop = 194-v[\inspectorScroll]; y = contentTop;
                    v[\text].value(reg[\character],Rect(x+16,y,310,44),v[\muted],v[\smallFont]); y = y+49;
                    v[\button].value(Rect(x+16,y,312,26),"Help / examples (Cmd+D)",color,{v[\showHelp].value(node[\type])}); y = y+34;
                    if(v[\noteTypes].includes(node[\type]).not) {v[\slider].value(Rect(x+16,y,312,26),"OBJECT CHAOS  "++(node[\chaosAmount]*100).round.asInteger++"%",
                        node[\chaosAmount],{ |value|
                            node[\chaosAmount] = value;
                            if(node[\synth].notNil){node[\synth].set(\chaosAmount,value)}
                        },color); y = y+36};
                    if(v[\noteTypes].includes(node[\type])) {
                        v[\button].value(Rect(x+16,y,312,26),if(node[\type]==\noteseq){"Edit notes / chords…"}{"MIDI device / channel settings…"},
                            color,{if(node[\type]==\noteseq){v[\noteEditor].value(node)}{v[\midiSettings].value(node)}}); y = y+34;
                        if(node[\type]==\noteseq) {
                            v[\button].value(Rect(x+16,y,148,26),"Play from start",color,{v[\startSequence].value(node)});
                            v[\button].value(Rect(x+180,y,148,26),"Stop",color,{v[\stopSequence].value(node)}); y = y+34;
                        };
                    };
                    if(node[\type]==\polysynth) {
                        v[\text].value("Active voices: "++node[\voices].size++" / 32",Rect(x+16,y,312,24),color,v[\smallFont]); y = y+30;
                        v[\button].value(Rect(x+16,y,312,26),"Audition chord",color,{
                            var cord,events;
                            cord = (uid:0); events = [0,2,4].collect { |degree|
                                v[\noteSerial] = v[\noteSerial]+1;
                                (kind:\on,token:"audition:"++v[\noteSerial],lane:"audition",
                                    pitch:v[\degreeNote].value(degree),velocity:90,bend:0)
                            };
                            events.do { |event|v[\receiveNotes].value(node,cord,event)};
                            v[\noteClock].sched(1,{
                                events.do { |event|event[\kind] = \off; v[\receiveNotes].value(node,cord,event)}; nil
                            });
                        }); y = y+34;
                    };
                    if(reg[\params].any { |spec|spec[\pitch]==\hz}) {
                        v[\button].value(Rect(x+16,y,312,24),if(node[\noteMode] ? false){"Pitch entry: MIDI note · click for Hz"}{"Pitch entry: Hz · click for MIDI note"},
                            color,{v[\checkpoint].value; node[\noteMode] = (node[\noteMode] ? false).not}); y = y+32;
                    };
                    if([\player,\granular].includes(node[\type])) {
                        v[\button].value(Rect(x+16,y,312,25),"Add sound…",color,{v[\chooseSound].value(node)}); y = y+32;
                        node[\pool].do { |sound,i|
                            v[\text].value((i+1).asString++"  "++if(sound[\missing]==true){"MISSING · "}{""}++sound[\path].basename,
                                Rect(x+16,y,278,24),v[\ink],v[\smallFont]);
                            v[\button].value(Rect(x+300,y,27,23),"×",v[\muted],{
                                v[\checkpoint].value; node[\pool].remove(sound); v[\syncPool].value(node);
                                {v[\freeSound].value(sound)}.defer(1.1)
                            }); y = y+28;
                        }; y = y+8;
                    };
                    reg[\params].do { |spec,i|
                        var p,mods;
                        p = node[\params][i];
                        mods = v[\cords].select { |c| c[\dst]==node[\id] and: {c[\param]==i} };
                        if(v[\noteTypes].includes(node[\type])) {
                            v[\text].value(spec[\label],Rect(x+16,y,230,22),v[\ink],v[\font]);
                            v[\button].value(Rect(x+280,y,47,21),"LOCK",color,{
                                v[\checkpoint].value; p[\locked] = p[\locked].not
                            },p[\locked]);
                            v[\slider].value(Rect(x+16,y+27,312,28),v[\format].value(v[\actual].value(spec,p[\base])),p[\base],
                                { |value|p[\base] = value},color); y = y+68;
                        } {
                        v[\text].value(spec[\label],Rect(x+16,y,210,22),v[\ink],v[\font]);
                        v[\button].value(Rect(x+230,y,43,21),"DICE",color,{
                            v[\checkpoint].value; p[\random] = p[\random].not; v[\sendParam].value(node,i)
                        },p[\random]);
                        v[\button].value(Rect(x+280,y,47,21),"LOCK",color,{
                            v[\checkpoint].value; p[\locked] = p[\locked].not; v[\sendParam].value(node,i)
                        },p[\locked]);
                        v[\knob].value(node,i,(x+47)@(y+60),23,true);
                        v[\button].value(Rect(x+91,y+29,88,23),v[\modes][p[\mode]],color,{
                            v[\checkpoint].value; p[\mode] = (p[\mode]+1)%5; v[\sendParam].value(node,i)
                        });
                        v[\slider].value(Rect(x+185,y+29,142,23),"Rate "++v[\format].value(p[\rate])++" Hz",
                            p[\rate].explin(0.01,40,0,1),{ |value|
                                p[\rate] = value.linexp(0,1,0.01,40); v[\sendParam].value(node,i)
                            },color);
                        v[\slider].value(Rect(x+91,y+59,236,23),"Depth "++(p[\depth]*100).round.asInteger++"%",p[\depth],
                            { |value| p[\depth] = value; v[\sendParam].value(node,i) },color);
                        v[\slider].value(Rect(x+91,y+89,115,23),"Min "++v[\format].value(v[\actual].value(spec,p[\low])),p[\low],
                            { |value| p[\low] = value.min(p[\high]); v[\sendParam].value(node,i) },color);
                        v[\slider].value(Rect(x+212,y+89,115,23),"Max "++v[\format].value(v[\actual].value(spec,p[\high])),p[\high],
                            { |value| p[\high] = value.max(p[\low]); v[\sendParam].value(node,i) },color);
                        y = y+121;
                        mods.do { |c|
                            var source;
                            source = v[\find].value(c[\src]);
                            v[\slider].value(Rect(x+16,y,279,22),
                                v[\registry][source[\type]][\name]++" #"++source[\id]++"  "++c[\amount].round(0.01),
                                (c[\amount]+1)/2,{ |value|
                                    c[\amount] = value*2-1; if(c[\synth].notNil){c[\synth].set(\amount,c[\amount])}
                                },v[\colors][1]);
                            v[\button].value(Rect(x+301,y,26,22),"×",v[\muted],{v[\checkpoint].value; v[\removeCord].value(c)});
                            y = y+28;
                        };
                        };
                        Pen.strokeColor = v[\line]; Pen.width = 1;
                        Pen.line((x+16)@(y+3),(x+328)@(y+3)); Pen.stroke; y = y+17;
                    };
                    v[\inspectorMax] = (y-contentTop-(height-220)).max(0);
                };
                v[\hits] = v[\hits].reject { |hit| hit[\rect].left>=x and: {
                    (hit[\rect].top<185) or: {hit[\rect].bottom>(height-25)}
                } }.as(List);
                v[\knobHits] = v[\knobHits].select { |hit| hit[\rect].left<x or: {
                    hit[\rect].top>=185 and: {hit[\rect].bottom<=(height-25)}
                } }.as(List);
            };
        };
    };
};
v[\fuzzy] = { |name,query|
    var index;
    index = 0; name.toLower.do { |char|
        if(index<query.size and: {char==query[index]}) {index = index+1}
    }; index==query.size
};
v[\search] = { |position|
    var win,field,list,results,index,category,update,choose;
    if(v[\searchWindow].notNil){v[\searchWindow].close};
    results = v[\order].copy; index = 0; category = -1;
    win = Window("VOID · Add an object",Rect(230,170,430,526)).background_(v[\panel]); v[\searchWindow] = win;
    field = TextField(win,Rect(14,14,402,32)).font_(v[\font]).background_(v[\glass]).stringColor_(v[\ink]);
    list = UserView(win,Rect(12,58,406,454)).background_(v[\panel]);
    update = {
        results = v[\order].select { |key| (category<0 or: {v[\registry][key][\category]==category})
            and: {v[\fuzzy].value(v[\registry][key][\name],field.string.toLower)} };
        index = index.clip(0,(results.size-1).max(0)); list.refresh
    };
    choose = {if(results.notEmpty){v[\add].value(results[index],position); win.close}};
    list.drawFunc_({
        var start;
        ["ALL","SOUND","MOD","FX","UTIL"].do { |label,i|
            var rect;
            rect = Rect(i*81,0,77,26);
            v[\roundRect].value(rect,v[\glass],if(category==(i-1)){v[\colors][1]}{v[\line]},5);
            v[\text].value(label,rect,v[\ink],v[\smallFont],\center);
        };
        start = (index-6).max(0);
        results.copyRange(start,(start+11).min(results.size-1)).do { |key,i|
            var reg,rect;
            reg = v[\registry][key]; rect = Rect(0,36+(i*33),406,29);
            v[\roundRect].value(rect,if(index==(i+start)){v[\glass]}{v[\panel]},nil,4);
            v[\text].value(reg[\name],Rect(12,rect.top,280,29),v[\colors][reg[\category]],v[\font]);
        };
        v[\text].value("↑ ↓ choose · Enter add · Esc close · type to search",Rect(8,432,390,20),v[\muted],v[\smallFont]);
    });
    list.mouseDownAction_({ |view,x,y,mods,button,clicks|
        if(y<29){category = (x/81).floor.asInteger-1; update.value} {
            index = ((index-6).max(0)+((y-36)/33).floor.asInteger).clip(0,(results.size-1).max(0)); choose.value
        }
    });
    field.keyDownAction_({ |view,char,mods,unicode,keycode,key|
        switch(key,16777235,{index=(index-1).max(0); list.refresh; true},
            16777237,{index=(index+1).min((results.size-1).max(0)); list.refresh; true},
            16777216,{win.close; true},{nil})
    });
    field.keyUpAction_({update.value}); field.action_({choose.value});
    win.onClose_({v[\searchWindow]=nil}); v[\dialogs].add(win); v[\installHelpShortcuts].value(win.view); win.front; field.focus;
};
v[\contextMenu] = { |node|
    var menu;
    v[\selection] = Set[node[\id]];
    menu = Menu(
        MenuAction("Help / examples (Cmd+D)",{v[\showHelp].value(node[\type])}),
        MenuAction("Randomize this object",{v[\mutate].value(node,true)}),
        MenuAction("Nudge this object",{v[\mutate].value(node,false)}),
        MenuAction("Toggle CHAOS",{
            v[\checkpoint].value; node[\chaos] = node[\chaos].not;
            if(node[\synth].notNil){node[\synth].set(\chaos,node[\chaos].asInteger)}
        }),
        MenuAction("Trigger / restart",{if(node[\synth].notNil){node[\synth].set(\hit,1)}}),
        MenuAction("Bypass (B)",{v[\checkpoint].value; v[\bypass].value(node)}),
        MenuAction("Duplicate (Cmd+Shift+D)",{v[\copy].value; v[\paste].value}),
        MenuAction("Delete",{v[\deleteSelected].value})
    );
    if([\player,\granular].includes(node[\type])) {menu.addAction(MenuAction("Load sound…",{v[\chooseSound].value(node)}))};
    if(node[\type]==\note) {menu.addAction(MenuAction("Edit note…",{v[\editNote].value(node)}))};
    menu.front;
};
v[\drawSnapshots] = { |width|
    var x,y;
    x = ((width-590)/2).max(5); y = 111;
    v[\roundRect].value(Rect(x,y,590,166),v[\panel],v[\colors][1].copy.alpha_(0.5),8);
    v[\text].value("SNAPSHOTS · click recall · Shift-click store",Rect(x+15,y+8,540,24),v[\ink],v[\smallFont]);
    8.do { |i|
        v[\button].value(Rect(x+15+(i*70),y+39,62,31),(i+1).asString++if(v[\snapshots][i].isNil){"  empty"}{"  ●"},
            v[\colors][1],{ |mods|
                if(mods.isShift or: {v[\snapshots][i].isNil}) {v[\checkpoint].value; v[\snapshots][i] = v[\parameterSnapshot].value;
                    v[\message].value("Stored snapshot "++(i+1))}
                {v[\checkpoint].value; v[\applySnapshot].value(v[\snapshots][i])};
            },v[\snapshots][i].notNil);
    };
    v[\button].value(Rect(x+15,y+81,90,25),"A: "++(v[\snapshotA]+1),v[\colors][1],{v[\snapshotA]=(v[\snapshotA]+1)%8});
    v[\button].value(Rect(x+112,y+81,90,25),"B: "++(v[\snapshotB]+1),v[\colors][1],{v[\snapshotB]=(v[\snapshotB]+1)%8});
    v[\slider].value(Rect(x+215,y+81,360,25),"MORPH  A → B",v[\morph] ? 0,{ |value|
        v[\morph] = value; v[\morphSnapshots].value(value)
    });
    v[\text].value("Slots store values, dice, locks and object chaos. Morph respects locked parameters.",
        Rect(x+15,y+118,560,30),v[\muted],v[\smallFont]);
};
v[\drawHelp] = { |width,height|
    var rect,lines;
    rect = Rect(((width-700)/2).max(10),125,700,(height-160).min(660));
    Pen.fillColor = Color.black.copy.alpha_(0.82); Pen.fillRect(Rect(0,0,width,height));
    v[\roundRect].value(rect,v[\panel],v[\line],10);
    v[\text].value("V O I D  /  FIELD GUIDE",Rect(rect.left+28,rect.top+20,640,35),v[\ink],v[\titleFont].copy.size_(19));
    lines = ["Double-click empty canvas     Search / add object", "Drag bottom port to top port   Connect audio or triggers",
        "Control outlet → any knob      Add modulation; inspector adjusts depth", "Drag knob vertically          Change value · Shift = fine",
        "Double-click knob              Type a value · Alt-click = default", "Dice / CHAOS                   Parameter motion / object character",
        "Drag empty canvas             Select several objects", "Space/middle-drag or edge bars Pan · wheel also pans",
        "Cmd/Ctrl + wheel               Zoom at pointer · F = fit view", "Shift-click object             Add / remove selection",
        "Cmd/Ctrl D · Shift D           Object help · duplicate selection", "Delete / Backspace · B          Delete selection · bypass",
        "Cmd/Ctrl Z · Shift Z / Y        Undo · redo (60 steps)", "Cmd/Ctrl S · O                 Save patch · open patch",
        "M · T · R · P                   Mutate · tap tempo · record · panic",
        "L · I · H / ? · Esc             Library · inspector · help · dismiss",
        "Drop sounds                    PLAYER · hold Shift for GRANULAR CLOUD",
        "Waveform edge handles          Drag PLAYER start / end", "STEP SEQ                        Draw values · bottom squares toggle gates",
        "Alt-drag STEP SEQ               Draw probability (also the bottom strip)",
        "Snapshots                      Click recall · Shift-click store · A/B + morph",
        "Cmd/Ctrl + Period              Stop · click Restart audio to rebuild patch"];
    lines.do { |line,i| v[\text].value(line,Rect(rect.left+28,rect.top+72+(i*23),644,22),v[\muted],Font.monospace(11)) };
};

// Plain-language help and three authored recipes for every object.
v[\helpBook] = { (
osc: (description: "OSC makes a steady musical tone by repeating a wave. Frequency chooses the pitch, Wave chooses its colour, and Gain sets its loudness. Connect its round audio outlet to OUTPUT. It is a continuous sound source; use POLY SYNTH for notes with individual starts and endings.",examples: [(title: "A quiet sine tone",text: "Listen to a soft A at 220 Hz. Change Frequency slowly, then try the other Wave positions.",nodes: [(key: \focus,type: \osc,params: (freq: 220,wave: 0,gain: 0.075,voices: 1))],cords: [(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "A wide saw sound",text: "Three slightly detuned saw waves make a broad, warm tone. Unison voices and Detune control the thickness.",nodes: [(key: \focus,type: \osc,params: (freq: 110,wave: 1,gain: 0.05,voices: 3,detune: 12,spread: 0.8))],cords: [(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "A hollow pulse tone",text: "The narrow pulse has a bright, hollow colour. Move Pulse width between 0.1 and 0.8 to hear the change.",nodes: [(key: \focus,type: \osc,params: (freq: 165,wave: 4,width: 0.2,gain: 0.055,voices: 1))],cords: [(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)])],pieceRole: "A quiet extra sustained tone supports the bass and changes pitch with the harmony."),
fm: (description: "FM makes a tone by using one oscillator to move the pitch of another very quickly. Carrier sets the main pitch. Ratio sets the relationship between the two oscillators. Index changes the amount of movement: low values are gentle; high values become bright or metallic.",examples: [(title: "A soft electric tone",text: "A simple 2:1 ratio and a low Index make a rounded electric tone.",nodes: [(key: \focus,type: \fm,params: (freq: 220,ratio: 2,index: 0.8,gain: 0.065))],cords: [(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "A glassy bell colour",text: "The non-integer ratio adds bell-like overtones. This example sustains; put ENVELOPE after it for a struck bell.",nodes: [(key: \focus,type: \fm,params: (freq: 330,ratio: 3.5,index: 3,gain: 0.045))],cords: [(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "A rough bass colour",text: "A low carrier and a higher Index make a strong bass colour. Reduce Index for a softer version.",nodes: [(key: \focus,type: \fm,params: (freq: 55,ratio: 1,index: 5,gain: 0.04,feedback: 0.2))],cords: [(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)])],pieceRole: "An extra FM tone adds a small bright layer above the bass."),
noise: (description: "NOISE makes sound without a single clear note. White is bright, pink is darker, and brown is deeper. Colour removes high frequencies. Dust makes separate tiny clicks instead of a steady hiss. Noise is useful for wind, breath and percussion.",examples: [(title: "Soft pink wind",text: "A low Colour setting turns pink noise into a gentle wind sound.",nodes: [(key: \focus,type: \noise,params: (kind: 1,colour: 1200,gain: 0.055))],cords: [(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "Deep brown rumble",text: "Brown noise with a low cutoff makes a quiet low rumble.",nodes: [(key: \focus,type: \noise,params: (kind: 2,colour: 350,gain: 0.045))],cords: [(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "Scattered dust clicks",text: "Dust creates small, irregular clicks. Density controls how often they happen.",nodes: [(key: \focus,type: \noise,params: (kind: 4,density: 12,colour: 7000,gain: 0.065))],cords: [(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)])],pieceRole: "A low-level noise layer provides air around the notes."),
pluck: (description: "PLUCK makes a short ringing sound, like a string being picked. Frequency sets its note, Decay controls how long it rings, and Damping changes the brightness. Auto clock picks it once per beat. Turn Auto clock off when a CLOCK or EUCLID object supplies the triggers.",examples: [(title: "One picked note per beat",text: "A 220 Hz string is picked on every beat. Decay 1.2 leaves a clear space between notes.",nodes: [(key: \focus,type: \pluck,params: (freq: 220,decay: 1.2,gain: 0.2,auto: 1))],cords: [(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "A deep damped string",text: "A lower note and stronger damping give a soft bass pluck.",nodes: [(key: \focus,type: \pluck,params: (freq: 82.41,decay: 0.65,coef: 0.7,gain: 0.2,auto: 1))],cords: [(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "Long ringing strings",text: "A brighter note with a long Decay lets successive plucks overlap.",nodes: [(key: \focus,type: \pluck,params: (freq: 329.63,decay: 5,coef: 0.2,gain: 0.14,auto: 1))],cords: [(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)])],pieceRole: "A short low pluck plays the Euclidean percussion pattern."),
drone: (description: "DRONE holds several related notes at once. Root MIDI sets the bottom note and Chord type chooses their relationship. Slightly different tunings make the notes slowly beat against each other. Spread and Slow beating control this movement.",examples: [(title: "A still minor chord",text: "A low minor chord rings continuously with only a little tuning spread.",nodes: [(key: \focus,type: \drone,params: (rootNote: 45,chord: 1,spread: 4,beating: 0.08,gain: 0.12))],cords: [(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "A wide major seventh",text: "A major-seventh stack, wider stereo spread and stronger beating make a luminous pad.",nodes: [(key: \focus,type: \drone,params: (rootNote: 48,chord: 3,spread: 14,beating: 0.18,gain: 0.1))],cords: [(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "A suspended atmosphere",text: "A suspended chord avoids a major or minor third. Slow beating makes the sustained sound breathe.",nodes: [(key: \focus,type: \drone,params: (rootNote: 43,chord: 2,spread: 22,beating: 0.045,gain: 0.1))],cords: [(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)])],pieceRole: "A quiet held chord thickens each section. Its root follows the progression."),
player: (description: "PLAYER plays an audio file while keeping its left and right channels separate. Rate changes speed and pitch together; a negative rate plays backwards. Start and End choose a region of the file. Loop repeats it. The examples load SuperCollider's bundled voice recording; you can replace it with your own sound.",examples: [(title: "A repeating recording",text: "Hear the original recording loop. Use Load or Add sound to choose your own file.",nodes: [(key: \focus,type: \player,params: (rate: 1,gain: 0.14,loop: 1))],cords: [(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)],samples: [\focus]),(title: "A slower recording",text: "Half speed lowers the recording by one octave and doubles its duration.",nodes: [(key: \focus,type: \player,params: (rate: 0.5,gain: 0.14,loop: 1))],cords: [(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)],samples: [\focus]),(title: "A backwards recording",text: "Negative Rate plays the selected region backwards.",nodes: [(key: \focus,type: \player,params: (rate: -1,gain: 0.14,loop: 1))],cords: [(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)],samples: [\focus])],pieceRole: "A looping fragment of the bundled voice recording adds a quiet background layer."),
granular: (description: "GRANULAR CLOUD plays many tiny pieces of an audio file at once. Grain size changes the length of each piece, Density changes how many start each second, and Position chooses where they come from. Scan moves that position over time. Pitch and Scatter can turn a familiar recording into a new texture.",examples: [(title: "A gentle cloud",text: "Small grains move slowly through the voice recording.",nodes: [(key: \focus,type: \granular,params: (density: 18,size: 0.12,scan: 0.025,gain: 0.16,pitchScatter: 0))],cords: [(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)],samples: [\focus]),(title: "A frozen place",text: "Freeze stops scanning, so grains keep reading around one chosen position.",nodes: [(key: \focus,type: \granular,params: (density: 35,size: 0.07,position: 0.45,freeze: 1,scan: 0.1,gain: 0.13))],cords: [(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)],samples: [\focus]),(title: "A scattered cloud",text: "Pitch scatter, random grain positions and a wide stereo spread make a changing texture.",nodes: [(key: \focus,type: \granular,params: (density: 45,size: 0.045,pitchScatter: 7,positionScatter: 0.2,spread: 1,gain: 0.12))],cords: [(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)],samples: [\focus])],pieceRole: "A slowly scanning cloud made from the bundled voice recording surrounds the melody."),
mic: (description: "MIC IN brings the first two input channels of the SuperCollider audio device into the patch. Input gain controls their level. Noise gate closes the input when the signal is quiet. These examples start with Input gain at zero; raise it gradually when your input is ready.",examples: [(title: "Hear the input",text: "MIC IN connects directly to OUTPUT. Raise Input gain to hear the chosen audio-device inputs.",nodes: [(key: \focus,type: \mic,params: (gain: 0,gate: 0.01))],cords: [(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "Put the input in a room",text: "Raise Input gain, then compare the dry input with the reverb sound.",nodes: [(key: \focus,type: \mic,params: (gain: 0)),(key: \space,type: \reverb,params: (mix: 0.3))],cords: [(src: \focus,dst: \space,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \space,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "Echo the input",text: "Raise Input gain and speak or play short sounds. Each sound leaves tempo-synchronised repeats.",nodes: [(key: \focus,type: \mic,params: (gain: 0)),(key: \echo,type: \delay,params: (sync: 1,division: 0.5,feedback: 0.35,mix: 0.3))],cords: [(src: \focus,dst: \echo,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \echo,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)])],pieceRole: "An optional live input enters the fourth mixer channel. It starts at gain zero."),
lfo: (description: "LFO is a slow repeating movement rather than an audible sound. Connect its hollow outlet to a knob to make that knob rise and fall. Rate sets the speed and Shape sets the movement. Minimum and Maximum limit the values it sends.",examples: [(title: "A slow filter breath",text: "A sine movement gently opens and closes the filter.",nodes: [(key: \source,type: \osc,params: (freq: 110,wave: 1,gain: 0.055)),(key: \tone,type: \filter,params: (cutoff: 1300,resonance: 0.4)),(key: \focus,type: \lfo,params: (rate: 0.15,shape: 0,low: -1,high: 1))],cords: [(src: \source,dst: \tone,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \tone,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \tone,outlet: 0,inlet: 0,param: \cutoff,amount: 0.12)]),(title: "Side-to-side movement",text: "A triangle movement sends the sound gradually from left to right.",nodes: [(key: \source,type: \osc,params: (freq: 110,wave: 1,gain: 0.055)),(key: \tone,type: \pan,params: ()),(key: \focus,type: \lfo,params: (rate: 0.2,shape: 1,low: -1,high: 1))],cords: [(src: \source,dst: \tone,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \tone,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \tone,outlet: 0,inlet: 0,param: \pan,amount: 0.35)]),(title: "A soft pulse",text: "A sine movement changes loudness without changing the note.",nodes: [(key: \source,type: \osc,params: (freq: 110,wave: 1,gain: 0.055)),(key: \tone,type: \vca,params: (gain: 0.3)),(key: \focus,type: \lfo,params: (rate: 1,shape: 0,low: 0,high: 1))],cords: [(src: \source,dst: \tone,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \tone,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \tone,outlet: 0,inlet: 0,param: \gain,amount: 0.18)])],pieceRole: "Its hollow outlet makes a small, continuous change to the main filter brightness."),
random: (description: "RANDOM moves a knob in an unpredictable way. Smooth glides between values, Step jumps to new values, and Walk takes small steps from the last value. Rate controls how often it moves. Use a small cable depth for gentle variation.",examples: [(title: "A wandering filter",text: "Smooth random movement changes the brightness of a steady saw sound.",nodes: [(key: \source,type: \osc,params: (freq: 110,wave: 1,gain: 0.055)),(key: \tone,type: \filter,params: (cutoff: 1300,resonance: 0.4)),(key: \focus,type: \random,params: (rate: 0.6,mode: 0,low: -1,high: 1))],cords: [(src: \source,dst: \tone,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \tone,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \tone,outlet: 0,inlet: 0,param: \cutoff,amount: 0.13)]),(title: "Random stereo places",text: "Stepped random values move the sound to a new stereo position.",nodes: [(key: \source,type: \osc,params: (freq: 110,wave: 1,gain: 0.055)),(key: \tone,type: \pan,params: ()),(key: \focus,type: \random,params: (rate: 2,mode: 1,low: -1,high: 1))],cords: [(src: \source,dst: \tone,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \tone,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \tone,outlet: 0,inlet: 0,param: \pan,amount: 0.35)]),(title: "A walking filter",text: "Walk makes a series of small changes rather than unrelated jumps.",nodes: [(key: \source,type: \osc,params: (freq: 110,wave: 1,gain: 0.055)),(key: \tone,type: \filter,params: (cutoff: 1300,resonance: 0.4)),(key: \focus,type: \random,params: (rate: 3,mode: 2,low: -1,high: 1))],cords: [(src: \source,dst: \tone,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \tone,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \tone,outlet: 0,inlet: 0,param: \cutoff,amount: 0.16)])],pieceRole: "Its hollow outlet makes a small, continuous change to the main filter brightness."),
chaotic: (description: "CHAOS creates movement from a small mathematical system that never settles into a simple repeating loop. It sends control values, so connect its hollow outlet to a knob. Kind chooses a different behaviour. Rate sets how fast the system changes, and Output amount limits its strength.",examples: [(title: "A Lorenz filter",text: "Lorenz movement makes an irregular brightness pattern.",nodes: [(key: \source,type: \osc,params: (freq: 110,wave: 1,gain: 0.055)),(key: \tone,type: \filter,params: (cutoff: 1300,resonance: 0.4)),(key: \focus,type: \chaotic,params: (kind: 0,rate: 12,amount: 0.5))],cords: [(src: \source,dst: \tone,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \tone,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \tone,outlet: 0,inlet: 0,param: \cutoff,amount: 0.12)]),(title: "Henon stereo motion",text: "Henon sends more angular movement into the stereo position.",nodes: [(key: \source,type: \osc,params: (freq: 110,wave: 1,gain: 0.055)),(key: \tone,type: \pan,params: ()),(key: \focus,type: \chaotic,params: (kind: 1,rate: 8,amount: 0.4))],cords: [(src: \source,dst: \tone,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \tone,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \tone,outlet: 0,inlet: 0,param: \pan,amount: 0.25)]),(title: "A restless filter",text: "Latoocarfian movement gives the filter a different kind of uneven rhythm.",nodes: [(key: \source,type: \osc,params: (freq: 110,wave: 1,gain: 0.055)),(key: \tone,type: \filter,params: (cutoff: 1300,resonance: 0.4)),(key: \focus,type: \chaotic,params: (kind: 2,rate: 18,amount: 0.4))],cords: [(src: \source,dst: \tone,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \tone,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \tone,outlet: 0,inlet: 0,param: \cutoff,amount: 0.1)])],pieceRole: "Its hollow outlet makes a small, continuous change to the main filter brightness."),
clock: (description: "CLOCK sends regular trigger pulses. It makes no sound on its own: connect it to a Trigger inlet. Tempo multiplier chooses how many pulses happen per beat. Probability can leave some pulses out.",examples: [(title: "Pick a string on the beat",text: "CLOCK triggers PLUCK once per beat. PLUCK's own Auto clock is turned off.",nodes: [(key: \focus,type: \clock,params: (division: 1)),(key: \sound,type: \pluck,params: (freq: 220,auto: 0,gain: 0.18))],cords: [(src: \focus,dst: \sound,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \sound,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "Four picks per beat",text: "A multiplier of four makes a quick picked rhythm.",nodes: [(key: \focus,type: \clock,params: (division: 4)),(key: \sound,type: \pluck,params: (freq: 330,decay: 0.3,auto: 0,gain: 0.12))],cords: [(src: \focus,dst: \sound,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \sound,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "An incomplete rhythm",text: "Probability 0.55 leaves out some of the two pulses per beat.",nodes: [(key: \focus,type: \clock,params: (division: 2,probability: 0.55)),(key: \sound,type: \pluck,params: (freq: 165,decay: 0.7,auto: 0,gain: 0.18))],cords: [(src: \focus,dst: \sound,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \sound,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)])],pieceRole: "Extra clock pulses add occasional picked accents to the percussion."),
euclid: (description: "EUCLID spreads a chosen number of hits as evenly as possible over a repeating number of steps. Steps is the length of the circle, Pulses is the number of hits, and Rotation moves the pattern around. Connect its hollow outlet to a Trigger inlet.",examples: [(title: "Five hits in sixteen steps",text: "A familiar uneven rhythm drives a short plucked note.",nodes: [(key: \focus,type: \euclid,params: (steps: 16,pulses: 5,division: 4)),(key: \sound,type: \pluck,params: (freq: 110,decay: 0.3,auto: 0,gain: 0.18))],cords: [(src: \focus,dst: \sound,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \sound,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "Three hits in eight steps",text: "A shorter cycle gives a different rhythmic shape.",nodes: [(key: \focus,type: \euclid,params: (steps: 8,pulses: 3,division: 2)),(key: \sound,type: \pluck,params: (freq: 220,decay: 0.6,auto: 0,gain: 0.18))],cords: [(src: \focus,dst: \sound,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \sound,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "Rotate a seven-step rhythm",text: "Two hits move around a seven-step cycle. Change Rotation to hear a new starting point.",nodes: [(key: \focus,type: \euclid,params: (steps: 7,pulses: 2,rotation: 3,division: 3)),(key: \sound,type: \pluck,params: (freq: 330,decay: 0.4,auto: 0,gain: 0.16))],cords: [(src: \focus,dst: \sound,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \sound,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)])],pieceRole: "Five hits in sixteen steps make the piece's main percussion pattern. Later sections use more hits."),
sequencer: (description: "STEP SEQ repeats a row of control values. It can move a knob in steps or send trigger pulses. Draw the bars to change values, use the small squares to turn steps on and off, and use probability to leave some steps out. For named notes and chords, open NOTE SEQ.",examples: [(title: "Draw a brightness pattern",text: "The bars change FILTER Cutoff. Draw higher bars for brighter steps.",nodes: [(key: \source,type: \osc,params: (freq: 110,wave: 1,gain: 0.06)),(key: \tone,type: \filter,params: (cutoff: 500)),(key: \focus,type: \sequencer,params: (division: 2,length: 8))],cords: [(src: \source,dst: \tone,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \tone,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \tone,outlet: 0,inlet: 0,param: \cutoff,amount: 0.28)]),(title: "Draw a loudness pattern",text: "The bars change VCA Gain. Low bars make quiet steps and high bars make louder steps.",nodes: [(key: \source,type: \osc,params: (freq: 220,gain: 0.08)),(key: \level,type: \vca,params: (gain: 0.05)),(key: \focus,type: \sequencer,params: (division: 4,length: 16))],cords: [(src: \source,dst: \level,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \level,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \level,outlet: 0,inlet: 0,param: \gain,amount: 0.3)]),(title: "Turn step gates into picks",text: "Output gates sends trigger pulses. Turn individual gate squares off to create rests.",nodes: [(key: \focus,type: \sequencer,params: (division: 4,length: 8,triggerOut: 1)),(key: \sound,type: \pluck,params: (freq: 165,auto: 0,decay: 0.4,gain: 0.17))],cords: [(src: \focus,dst: \sound,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \sound,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)])],pieceRole: "Its control pattern adds a small repeating brightness figure to the main filter."),
envelope: (description: "ENVELOPE gives a sound a beginning and an ending. Attack is the time it takes to rise and Decay is the time it takes to fall. ADSR mode also has a held level and a release. Feed audio into its filled inlet and trigger pulses into its hollow inlet. The hollow outlet can also shape another knob.",examples: [(title: "Short soft notes",text: "A clock opens and closes a steady oscillator. The envelope turns it into separate notes.",nodes: [(key: \source,type: \osc,params: (freq: 220,gain: 0.08)),(key: \beat,type: \clock,params: (division: 2)),(key: \focus,type: \envelope,params: (attack: 0.01,decay: 0.25,mode: 0))],cords: [(src: \source,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \beat,dst: \focus,outlet: 0,inlet: 1,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "Slow swells",text: "A slow clock triggers an envelope with a long rise and fall.",nodes: [(key: \source,type: \osc,params: (freq: 165,wave: 2,gain: 0.05)),(key: \beat,type: \clock,params: (division: 0.25)),(key: \focus,type: \envelope,params: (attack: 1.1,decay: 1.8,mode: 0))],cords: [(src: \source,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \beat,dst: \focus,outlet: 0,inlet: 1,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "Held notes with release",text: "ADSR mode holds the sound briefly before releasing it.",nodes: [(key: \source,type: \fm,params: (freq: 220,index: 1,gain: 0.06)),(key: \beat,type: \clock,params: (division: 1)),(key: \focus,type: \envelope,params: (attack: 0.03,decay: 0.15,sustain: 0.5,release: 0.4,hold: 0.25,mode: 1))],cords: [(src: \source,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \beat,dst: \focus,outlet: 0,inlet: 1,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)])],pieceRole: "The lead passes through an extra rhythmic volume shape, triggered by the percussion pattern."),
filter: (description: "FILTER removes parts of a sound to change its brightness and colour. Low-pass keeps the low frequencies, high-pass keeps the high ones, and band-pass keeps a narrow area. Cutoff chooses the dividing point. Resonance makes the area around that point stand out.",examples: [(title: "A warm low-pass",text: "Only the lower part of each pluck passes through.",nodes: [(key: \source,type: \pluck,params: (freq: 220,decay: 1.2,gain: 0.18)),(key: \focus,type: \filter,params: (kind: 0,cutoff: 900,resonance: 0.25))],cords: [(src: \source,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "A thin high-pass",text: "Removing the low frequencies makes a small, bright sound.",nodes: [(key: \source,type: \pluck,params: (freq: 220,decay: 1.2,gain: 0.18)),(key: \focus,type: \filter,params: (kind: 1,cutoff: 1200,resonance: 0.2))],cords: [(src: \source,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "A ringing band",text: "A narrow band gives each pluck a resonant vowel-like colour.",nodes: [(key: \source,type: \pluck,params: (freq: 220,decay: 1.2,gain: 0.18)),(key: \focus,type: \filter,params: (kind: 2,cutoff: 1800,resonance: 0.75))],cords: [(src: \source,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)])],pieceRole: "This is the main brightness control. It opens in the middle sections and closes at the end."),
delay: (description: "DELAY repeats a sound after a short time. Time is the gap before each repeat. Feedback decides how many repeats remain, and Mix blends them with the original sound. Tempo sync measures the gap in beats instead of seconds.",examples: [(title: "A single short echo",text: "A quiet repeat follows every pluck.",nodes: [(key: \source,type: \pluck,params: (freq: 220,decay: 1.2,gain: 0.18)),(key: \focus,type: \delay,params: (time: 0.22,feedback: 0.2,mix: 0.3))],cords: [(src: \source,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "Echoes on the beat",text: "Tempo sync and a half-beat length place repeats between the picked notes.",nodes: [(key: \source,type: \pluck,params: (freq: 220,decay: 1.2,gain: 0.18)),(key: \focus,type: \delay,params: (sync: 1,division: 0.5,feedback: 0.48,mix: 0.35))],cords: [(src: \source,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "A dark echo trail",text: "A low Loop filter removes brightness from successive repeats.",nodes: [(key: \source,type: \pluck,params: (freq: 220,decay: 1.2,gain: 0.18)),(key: \focus,type: \delay,params: (time: 0.6,feedback: 0.67,tone: 1200,mix: 0.4))],cords: [(src: \source,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)])],pieceRole: "Beat-synchronised echoes join the notes into longer rhythmic phrases."),
reverb: (description: "REVERB adds the many small reflections you hear in a room. Room size controls how spacious it sounds. Damping makes the reflections darker. Mix blends the room with the original sound. Shimmer sends a little octave-shifted sound back into the reverb.",examples: [(title: "A small room",text: "Short, dark reflections put a pluck in a small space.",nodes: [(key: \source,type: \pluck,params: (freq: 220,decay: 1.2,gain: 0.18)),(key: \focus,type: \reverb,params: (size: 0.3,damping: 0.65,mix: 0.25,shimmer: 0))],cords: [(src: \source,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "A large hall",text: "A larger room leaves a longer, more open trail.",nodes: [(key: \source,type: \pluck,params: (freq: 220,decay: 1.2,gain: 0.18)),(key: \focus,type: \reverb,params: (size: 0.9,damping: 0.3,mix: 0.4,shimmer: 0))],cords: [(src: \source,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "An octave shimmer",text: "A little shimmer adds a higher halo to the long reflections.",nodes: [(key: \source,type: \pluck,params: (freq: 220,decay: 1.2,gain: 0.18)),(key: \focus,type: \reverb,params: (size: 0.94,damping: 0.4,mix: 0.45,shimmer: 0.28))],cords: [(src: \source,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)])],pieceRole: "A large room connects all the layers and leaves a tail at the end."),
spectral: (description: "SPECTRAL splits sound into many frequency pieces, changes them, then joins them again. Smear spreads those pieces into a blur. Scramble moves some of them around. Freeze holds a captured spectrum, turning a changing sound into a sustained texture.",examples: [(title: "Blur a plucked note",text: "Magnitude smear spreads each ringing note into a softer texture.",nodes: [(key: \source,type: \pluck,params: (freq: 220,decay: 1.2,gain: 0.18)),(key: \focus,type: \spectral,params: (smear: 14,mix: 0.8))],cords: [(src: \source,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "Rearrange the colour",text: "Bin scramble moves some of the frequency pieces to unexpected places.",nodes: [(key: \source,type: \pluck,params: (freq: 220,decay: 1.2,gain: 0.18)),(key: \focus,type: \spectral,params: (scramble: 0.35,width: 0.22,mix: 0.7))],cords: [(src: \source,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "Capture a spectrum",text: "After four beats, FFT freeze holds the material heard at that moment. Set Freeze back to zero to listen again.",nodes: [(key: \source,type: \pluck,params: (freq: 220,decay: 1.2,gain: 0.18)),(key: \focus,type: \spectral,params: (smear: 5,mix: 0.8))],cords: [(src: \source,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)],actions: [(node: \focus,param: \freeze,value: 1,after: 4)])],pieceRole: "The lead melody passes through this processor before entering the main mix."),
pitchshift: (description: "PITCH SHIFT changes the pitch of incoming audio while keeping its general speed. Ratio 2 raises it one octave and 0.5 lowers it one octave. Pitch dispersion spreads the pitches apart, and Time dispersion makes the grains less regular.",examples: [(title: "An octave above",text: "Ratio 2 adds a higher version of the picked note.",nodes: [(key: \source,type: \pluck,params: (freq: 220,decay: 1.2,gain: 0.18)),(key: \focus,type: \pitchshift,params: (ratio: 2,mix: 0.65,pitchDisp: 0,timeDisp: 0.01))],cords: [(src: \source,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "An octave below",text: "Ratio 0.5 puts the sound in a lower register.",nodes: [(key: \source,type: \pluck,params: (freq: 220,decay: 1.2,gain: 0.18)),(key: \focus,type: \pitchshift,params: (ratio: 0.5,mix: 0.75,pitchDisp: 0))],cords: [(src: \source,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "A scattered fifth",text: "Ratio 1.5 adds a fifth while dispersion makes the result less steady.",nodes: [(key: \source,type: \pluck,params: (freq: 220,decay: 1.2,gain: 0.18)),(key: \focus,type: \pitchshift,params: (ratio: 1.5,pitchDisp: 0.08,timeDisp: 0.04,mix: 0.5))],cords: [(src: \source,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)])],pieceRole: "The lead melody passes through this processor before entering the main mix."),
crush: (description: "CRUSH makes digital sound coarser. Lower Sample rate removes fast detail, and lower Bit depth makes the wave use fewer loudness levels. Mix lets the rough version sit beside the clean sound.",examples: [(title: "A little digital grain",text: "Twelve bits and a moderate sample rate add a small amount of roughness.",nodes: [(key: \source,type: \pluck,params: (freq: 220,decay: 1.2,gain: 0.18)),(key: \focus,type: \crush,params: (sampleRate: 12000,bits: 12,mix: 0.6))],cords: [(src: \source,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "An old small sampler",text: "Six bits make the quiet parts of each note much more coarse.",nodes: [(key: \source,type: \pluck,params: (freq: 220,decay: 1.2,gain: 0.18)),(key: \focus,type: \crush,params: (sampleRate: 6000,bits: 6,mix: 0.65))],cords: [(src: \source,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "A broken radio",text: "A very low sample rate and four bits turn the pluck into a rough buzzing object.",nodes: [(key: \source,type: \pluck,params: (freq: 220,decay: 1.2,gain: 0.18)),(key: \focus,type: \crush,params: (sampleRate: 1500,bits: 4,mix: 0.5))],cords: [(src: \source,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)])],pieceRole: "The lead melody passes through this processor before entering the main mix."),
distort: (description: "DISTORT changes the shape of a wave to add new overtones. Drive pushes the sound harder. Tanh rounds its edges, Fold bends the wave back on itself, and Clip cuts the edges off. Tone removes excess high frequencies.",examples: [(title: "A warm edge",text: "A little rounded distortion thickens each pluck.",nodes: [(key: \source,type: \pluck,params: (freq: 220,decay: 1.2,gain: 0.18)),(key: \focus,type: \distort,params: (drive: 3,mode: 0,tone: 5000,mix: 0.45))],cords: [(src: \source,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "Fold the wave",text: "Folding adds changing high overtones as the note decays.",nodes: [(key: \source,type: \pluck,params: (freq: 220,decay: 1.2,gain: 0.18)),(key: \focus,type: \distort,params: (drive: 8,mode: 1,tone: 4500,mix: 0.45))],cords: [(src: \source,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "A clipped attack",text: "Clipping gives a more abrupt edge to the start of the note.",nodes: [(key: \source,type: \pluck,params: (freq: 220,decay: 1.2,gain: 0.18)),(key: \focus,type: \distort,params: (drive: 10,mode: 2,tone: 2800,mix: 0.4))],cords: [(src: \source,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)])],pieceRole: "The lead melody passes through this processor before entering the main mix."),
ring: (description: "RING / FREQ SHIFT makes new tones from the incoming sound. Ring mode multiplies it by another wave, often creating a bell-like or trembling colour. Frequency shift moves all frequencies by the same number of hertz, so the overtones stop lining up in the usual way.",examples: [(title: "A slow tremble",text: "Ring mode at 5 Hz makes a fast change in loudness.",nodes: [(key: \source,type: \pluck,params: (freq: 220,decay: 1.2,gain: 0.18)),(key: \focus,type: \ring,params: (frequency: 5,mode: 0,mix: 0.8))],cords: [(src: \source,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "A metallic colour",text: "A faster ring frequency makes new pitches around the plucked note.",nodes: [(key: \source,type: \pluck,params: (freq: 220,decay: 1.2,gain: 0.18)),(key: \focus,type: \ring,params: (frequency: 80,mode: 0,mix: 0.6))],cords: [(src: \source,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "Slide the overtones",text: "Frequency shift moves every frequency up by 120 Hz.",nodes: [(key: \source,type: \pluck,params: (freq: 220,decay: 1.2,gain: 0.18)),(key: \focus,type: \ring,params: (frequency: 120,mode: 1,mix: 0.6))],cords: [(src: \source,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)])],pieceRole: "The lead melody passes through this processor before entering the main mix."),
stutter: (description: "STUTTER remembers a short piece of recent audio and repeats it. Slice seconds is the length of that piece. Rate changes its playback speed and can reverse it. Capture / repeat holds the slice; a trigger can also cause a temporary repeat.",examples: [(title: "Repeat a small slice",text: "The object listens for four beats, then starts repeating its latest slice. Turn Capture / repeat off to hear the live sound.",nodes: [(key: \source,type: \pluck,params: (freq: 220,decay: 1.2,gain: 0.18)),(key: \focus,type: \stutter,params: (size: 0.15,mix: 0.75))],cords: [(src: \source,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)],actions: [(node: \focus,param: \repeat,value: 1,after: 4)]),(title: "A reverse memory",text: "After four beats, the captured slice plays backwards.",nodes: [(key: \source,type: \pluck,params: (freq: 220,decay: 1.2,gain: 0.18)),(key: \focus,type: \stutter,params: (size: 0.3,rate: -1,mix: 0.7))],cords: [(src: \source,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)],actions: [(node: \focus,param: \repeat,value: 1,after: 4)]),(title: "A slower fragment",text: "A longer captured piece plays at half speed after four beats.",nodes: [(key: \source,type: \pluck,params: (freq: 220,decay: 1.2,gain: 0.18)),(key: \focus,type: \stutter,params: (size: 0.5,rate: 0.5,mix: 0.65))],cords: [(src: \source,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)],actions: [(node: \focus,param: \repeat,value: 1,after: 4)])],pieceRole: "The lead melody passes through this processor before entering the main mix."),
resonator: (description: "RESONATOR makes incoming sound ring at a group of chosen pitches, like exciting several strings or metal bars. Root MIDI and Chord type tune the ringing notes. Decay sets how long they last. Even a small click can become a chord.",examples: [(title: "A ringing minor chord",text: "Each picked sound excites a low minor-chord bank.",nodes: [(key: \source,type: \pluck,params: (freq: 220,decay: 1.2,gain: 0.18)),(key: \focus,type: \resonator,params: (rootNote: 48,chord: 1,decay: 2,mix: 0.65))],cords: [(src: \source,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "A bright major seventh",text: "A higher major-seventh bank gives a brighter set of ringing pitches.",nodes: [(key: \source,type: \pluck,params: (freq: 220,decay: 1.2,gain: 0.18)),(key: \focus,type: \resonator,params: (rootNote: 60,chord: 3,decay: 3,mix: 0.6))],cords: [(src: \source,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "Long suspended strings",text: "A suspended chord and longer decay make overlapping resonances.",nodes: [(key: \source,type: \pluck,params: (freq: 220,decay: 1.2,gain: 0.18)),(key: \focus,type: \resonator,params: (rootNote: 43,chord: 2,decay: 6,mix: 0.6))],cords: [(src: \source,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)])],pieceRole: "The lead melody passes through this processor before entering the main mix."),
compressor: (description: "COMPRESSOR reduces the difference between louder and quieter parts of a sound. Threshold is the level where it starts working. Ratio controls how strongly it reduces peaks. Attack and Release control its response speed. Makeup gain adjusts the level after compression.",examples: [(title: "Gentle peak control",text: "A moderate ratio softens the loudest part of the pluck.",nodes: [(key: \source,type: \pluck,params: (freq: 220,decay: 1.2,gain: 0.18)),(key: \focus,type: \compressor,params: (threshold: 0.08,ratio: 2,attack: 0.01,release: 0.2,makeup: 1))],cords: [(src: \source,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "Tighter attacks",text: "A faster attack catches more of the picked peak.",nodes: [(key: \source,type: \pluck,params: (freq: 220,decay: 1.2,gain: 0.18)),(key: \focus,type: \compressor,params: (threshold: 0.035,ratio: 6,attack: 0.002,release: 0.12,makeup: 1.2))],cords: [(src: \source,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "Slow recovery",text: "A longer release keeps the sound controlled for more of the space between notes.",nodes: [(key: \source,type: \pluck,params: (freq: 220,decay: 1.2,gain: 0.18)),(key: \focus,type: \compressor,params: (threshold: 0.025,ratio: 8,attack: 0.008,release: 0.65,makeup: 1.3))],cords: [(src: \source,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)])],pieceRole: "The lead melody passes through this processor before entering the main mix."),
mixer: (description: "MIXER brings up to four stereo sounds together. Each input has its own gain, stereo position and mute switch. This lets you balance several musical parts before sending them through shared effects.",examples: [(title: "Balance two tones",text: "A low sine and a higher triangle enter separate mixer channels. Move Input 1 and Input 2 gain to compare them.",nodes: [(key: \low,type: \osc,params: (freq: 110,gain: 0.05)),(key: \high,type: \osc,params: (freq: 220,wave: 3,gain: 0.05)),(key: \focus,type: \mixer,params: (gain0: 0.7,gain1: 0.4))],cords: [(src: \low,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \high,dst: \focus,outlet: 0,inlet: 1,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "Put two parts apart",text: "The first sound is left and the second is right. Both remain in the same stereo mix.",nodes: [(key: \low,type: \pluck,params: (freq: 165,decay: 0.7,gain: 0.16)),(key: \high,type: \drone,params: (rootNote: 57,gain: 0.08)),(key: \focus,type: \mixer,params: (pan0: -0.65,pan1: 0.65,gain0: 0.65,gain1: 0.65))],cords: [(src: \low,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \high,dst: \focus,outlet: 0,inlet: 1,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "Leave one channel silent",text: "Input 2 starts muted. Click its mute value in the inspector to bring the drone into the mix.",nodes: [(key: \low,type: \pluck,params: (freq: 220,gain: 0.15)),(key: \high,type: \drone,params: (rootNote: 45,gain: 0.1)),(key: \focus,type: \mixer,params: (mute1: 1))],cords: [(src: \low,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \high,dst: \focus,outlet: 0,inlet: 1,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)])],pieceRole: "Four channels balance lead, chords, bass and percussion/cloud before the shared effects."),
pan: (description: "PAN places stereo audio between the left and right speakers. Pan sets a fixed place. Auto-pan depth moves around that place, and Auto-pan Hz sets the speed. It changes position rather than pitch.",examples: [(title: "A place on the left",text: "The ringing note sits left of centre.",nodes: [(key: \source,type: \pluck,params: (freq: 220,gain: 0.16)),(key: \focus,type: \pan,params: (pan: -0.7))],cords: [(src: \source,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "A place on the right",text: "The same note sits right of centre.",nodes: [(key: \source,type: \pluck,params: (freq: 220,gain: 0.16)),(key: \focus,type: \pan,params: (pan: 0.7))],cords: [(src: \source,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "A moving sound",text: "Auto-pan moves the note smoothly between the speakers.",nodes: [(key: \source,type: \pluck,params: (freq: 220,gain: 0.16)),(key: \focus,type: \pan,params: (pan: 0,auto: 0.8,rate: 0.18))],cords: [(src: \source,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)])],pieceRole: "A small automatic pan gives the completed mix a slow stereo movement."),
vca: (description: "VCA / GAIN changes how loud a sound is. Gain 1 keeps its level, Gain 0 is silent, and larger values raise the level. Connect a control outlet to Gain to make a pulse, swell or rhythm.",examples: [(title: "Turn a sound down",text: "A VCA at 0.3 makes the original oscillator quieter.",nodes: [(key: \source,type: \osc,params: (freq: 220,gain: 0.1)),(key: \focus,type: \vca,params: (gain: 0.3))],cords: [(src: \source,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "Make a gentle swell",text: "An LFO changes the VCA gain to create a repeating swell.",nodes: [(key: \source,type: \osc,params: (freq: 165,wave: 3,gain: 0.08)),(key: \motion,type: \lfo,params: (rate: 0.25,low: 0,high: 1)),(key: \focus,type: \vca,params: (gain: 0.1))],cords: [(src: \source,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \motion,dst: \focus,outlet: 0,inlet: 0,param: \gain,amount: 0.25),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "Draw a volume rhythm",text: "STEP SEQ bars decide how loud each step is.",nodes: [(key: \source,type: \fm,params: (freq: 110,index: 1,gain: 0.06)),(key: \motion,type: \sequencer,params: (division: 4,length: 8)),(key: \focus,type: \vca,params: (gain: 0.05))],cords: [(src: \source,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \motion,dst: \focus,outlet: 0,inlet: 0,param: \gain,amount: 0.25),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)])],pieceRole: "A gain stage sits after the mixer and before the tone and space effects."),
xfade: (description: "XFADE blends between two stereo inputs. At 0 you hear A, at 1 you hear B, and the middle shares both. It adjusts the blend to keep the transition fairly even in loudness. Connect a slow control to Mix for an automatic change of colour.",examples: [(title: "Only the first sound",text: "At Mix 0, you hear the low sine on input A.",nodes: [(key: \a,type: \osc,params: (freq: 110,gain: 0.055)),(key: \b,type: \osc,params: (freq: 165,wave: 3,gain: 0.055)),(key: \focus,type: \xfade,params: (mix: 0))],cords: [(src: \a,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \b,dst: \focus,outlet: 0,inlet: 1,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "Only the second sound",text: "At Mix 1, you hear the higher triangle on input B.",nodes: [(key: \a,type: \osc,params: (freq: 110,gain: 0.055)),(key: \b,type: \osc,params: (freq: 165,wave: 3,gain: 0.055)),(key: \focus,type: \xfade,params: (mix: 1))],cords: [(src: \a,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \b,dst: \focus,outlet: 0,inlet: 1,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "Blend two colours",text: "At Mix 0.5, the two different tones share the sound.",nodes: [(key: \a,type: \osc,params: (freq: 110,gain: 0.055)),(key: \b,type: \osc,params: (freq: 165,wave: 3,gain: 0.055)),(key: \focus,type: \xfade,params: (mix: 0.5))],cords: [(src: \a,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \b,dst: \focus,outlet: 0,inlet: 1,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)])],pieceRole: "The lead and pad become the two sides of a blend before the lead mixer channel."),
scope: (description: "SCOPE shows a sound while passing it onwards. Waveform draws its fast changes in level. Spectrum shows which frequency areas are strongest. Display & audio gain changes both the picture and the level of the sound leaving the object.",examples: [(title: "See a sine wave",text: "The smooth repeating curve comes from a sine oscillator.",nodes: [(key: \source,type: \osc,params: (freq: 110,wave: 0,gain: 0.06)),(key: \focus,type: \scope,params: (mode: 0))],cords: [(src: \source,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "See a square wave",text: "A square wave has abrupt edges. Compare the shape with the sine example.",nodes: [(key: \source,type: \osc,params: (freq: 110,wave: 2,gain: 0.06)),(key: \focus,type: \scope,params: (mode: 0))],cords: [(src: \source,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "See the overtones",text: "Spectrum mode shows the many frequency bands in a saw wave.",nodes: [(key: \source,type: \osc,params: (freq: 110,wave: 1,gain: 0.06)),(key: \focus,type: \scope,params: (mode: 1))],cords: [(src: \source,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)])],pieceRole: "It displays the final mix after the shared effects and before OUTPUT."),
output: (description: "OUTPUT is the permanent stereo destination of the patch. Sounds reach the audio device after passing through its master volume and protection. You can connect several audio cables to it; they are added together. Audio OFF mutes the hardware, while recording can still capture the master.",examples: [(title: "Send one tone to the speakers",text: "A quiet oscillator goes straight to the existing OUTPUT. Turn Audio ON if the toolbar is muted.",nodes: [(key: \source,type: \osc,params: (freq: 220,gain: 0.07))],cords: [(src: \source,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)],focus: \output),(title: "Add two sounds",text: "Two quiet tones share OUTPUT and are added together.",nodes: [(key: \one,type: \osc,params: (freq: 220,gain: 0.04)),(key: \two,type: \osc,params: (freq: 330,gain: 0.04))],cords: [(src: \one,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \two,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)],focus: \output),(title: "Send a small instrument",text: "A note sequencer plays a chord through POLY SYNTH into the permanent master.",nodes: [(key: \seq,type: \noteseq,params: (length: 4,division: 1)),(key: \sound,type: \polysynth,params: (gain: 0.35))],cords: [(src: \seq,dst: \sound,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \sound,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)],patterns: [(node: \seq,notes: [[0,2,4],[3,5,7],[4,6,8],[0,2,4]],degrees: true)],focus: \output)],pieceRole: "All musical layers reach this protected stereo master. The piece does not replace it."),
recorder: (description: "RECORDER records the protected master to a stereo WAV file. It follows the master automatically, so it does not need an audio cable to hear the finished mix. Click Record to begin and click again to finish the file. The saved path appears in the status line.",examples: [(title: "Record one sound",text: "A picked note is ready to record. Click RECORDER's Record master button, then click it again to finish.",nodes: [(key: \source,type: \pluck,params: (freq: 220,gain: 0.16)),(key: \focus,type: \recorder,params: ())],cords: [(src: \source,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "Record an effect trail",text: "The recorder captures the full sound including reverb. Start and stop recording manually.",nodes: [(key: \source,type: \pluck,params: (freq: 330,gain: 0.14)),(key: \space,type: \reverb,params: (mix: 0.4)),(key: \focus,type: \recorder,params: ())],cords: [(src: \source,dst: \space,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \space,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "Record a chord pattern",text: "Apply and play this short pattern, then start recording when ready.",nodes: [(key: \seq,type: \noteseq,params: (length: 4,division: 1)),(key: \sound,type: \polysynth,params: (gain: 0.35)),(key: \focus,type: \recorder,params: ())],cords: [(src: \seq,dst: \sound,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \sound,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)],patterns: [(node: \seq,notes: [[0,2,4],[3,5,7],[4,6,8],[0,2,4]],degrees: true)])],pieceRole: "A RECORDER is included for capturing the whole performance. Press Record yourself; building the piece does not create a recording."),
note: (description: "NOTE is a written reminder on the canvas. It makes no sound and needs no cables. Double-click its body to edit the words. Use it for playing instructions, a score, a patch title or the meaning of a group of controls.",examples: [(title: "Label a sound",text: "The NOTE names a quiet oscillator patch. Double-click the note body to change the title.",nodes: [(key: \focus,type: \note,params: ()),(key: \sound,type: \osc,params: (freq: 220,gain: 0.06))],cords: [(src: \sound,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)],textNotes: (focus: "A quiet A\nOSC -> OUTPUT\nFrequency: 220 Hz")),(title: "Write playing instructions",text: "The note tells the performer how to change the sound over time.",nodes: [(key: \focus,type: \note,params: ()),(key: \sound,type: \drone,params: (gain: 0.09))],cords: [(src: \sound,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)],textNotes: (focus: "For 8 slow breaths:\nRaise Spread a little.\nThen return to stillness.")),(title: "Write a short score",text: "A written score sits beside a four-chord pattern.",nodes: [(key: \focus,type: \note,params: ()),(key: \seq,type: \noteseq,params: (length: 4,division: 0.5)),(key: \sound,type: \polysynth,params: (gain: 0.3))],cords: [(src: \seq,dst: \sound,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \sound,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)],patterns: [(node: \seq,notes: [[0,2,4],[3,5,7],[4,6,8],[0,2,4]],degrees: true)],textNotes: (focus: "Four chords\nRepeat quietly.\nOpen the filter on the last chord.\nStop and let the release finish."))],pieceRole: "The canvas note is a score with the four section names, their lengths, and the performance instructions."),
polysynth: (description: "POLY SYNTH turns note events into sound. It can play up to 32 notes at once, so chords work as well as single notes. Wave changes the colour. Attack and Release shape the start and end of each note. Connect a MIDI IN or NOTE SEQ diamond outlet to its diamond inlet, then send its round audio outlet to OUTPUT.",examples: [(title: "Four separate notes",text: "A short scale-degree pattern plays a soft sine instrument.",nodes: [(key: \seq,type: \noteseq,params: (length: 4,division: 2)),(key: \focus,type: \polysynth,params: (gain: 0.35,wave: 0,release: 0.2))],cords: [(src: \seq,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)],patterns: [(node: \seq,notes: [[0],[1],[2],[4]],degrees: true)]),(title: "Play chords",text: "Four-note chords show polyphony. A longer release lets them overlap slightly.",nodes: [(key: \seq,type: \noteseq,params: (length: 4,division: 0.5)),(key: \focus,type: \polysynth,params: (gain: 0.3,wave: 3,attack: 0.08,release: 1.2))],cords: [(src: \seq,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)],patterns: [(node: \seq,notes: [[0,2,4,6],[3,5,7,9],[4,6,8,10],[0,2,4,6]],degrees: true)]),(title: "A bell-like melody",text: "The FM waveform and a short attack make a clear, ringing melody.",nodes: [(key: \seq,type: \noteseq,params: (length: 8,division: 3)),(key: \focus,type: \polysynth,params: (gain: 0.3,wave: 4,release: 0.45))],cords: [(src: \seq,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)],patterns: [(node: \seq,notes: [[0],[4],[2],[6],[4],[7],[6],[2]],degrees: true,velocity: [92,64,78,60,90,64,76,55])])],pieceRole: "It is the lead instrument. Two more POLY SYNTH objects play chords and bass."),
noteseq: (description: "NOTE SEQ repeats a pattern of musical notes and chords. Each step can have several notes, a rest, a velocity, a probability and a duration. Degree mode follows the global scale and root; MIDI mode plays exact note numbers or note names. Its diamond outlet carries notes rather than audio.",examples: [(title: "A small scale melody",text: "Degrees 0, 1, 2 and 4 make a four-note phrase in the selected global scale.",nodes: [(key: \focus,type: \noteseq,params: (length: 4,division: 2)),(key: \sound,type: \polysynth,params: (gain: 0.35))],cords: [(src: \focus,dst: \sound,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \sound,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)],patterns: [(node: \focus,notes: [[0],[1],[2],[4]],degrees: true)]),(title: "Chords with space",text: "A chord, a rest, another chord and a rest make a simple call and response.",nodes: [(key: \focus,type: \noteseq,params: (length: 4,division: 1,gateLength: 0.65)),(key: \sound,type: \polysynth,params: (gain: 0.3,wave: 3,release: 0.7))],cords: [(src: \focus,dst: \sound,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \sound,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)],patterns: [(node: \focus,notes: [[0,2,4],[],[3,5,7],[]],degrees: true)]),(title: "Exact notes and microtones",text: "MIDI numbers 60, 64.5 and 67 form a chord with a quarter-tone middle note. Literal pitches stay fixed when the global scale changes.",nodes: [(key: \focus,type: \noteseq,params: (length: 4,division: 1)),(key: \sound,type: \polysynth,params: (gain: 0.3))],cords: [(src: \focus,dst: \sound,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \sound,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)],patterns: [(node: \focus,notes: [[60,64.5,67],[],[62,65.25,69],[]],degrees: false)])],pieceRole: "Three independent note sequencers play melody, four-note chords and bass. This object is the lead sequencer."),
midiin: (description: "MIDI IN receives notes from a keyboard, controller or another application. It makes no audio itself. Choose the device and channel in MIDI settings, then connect its diamond outlet to POLY SYNTH or MIDI OUT. Velocity, sustain pedal and pitch bend are supported.",examples: [(title: "Play the synth by hand",text: "Choose your input in MIDI settings, then play the controller. All channels are accepted.",nodes: [(key: \focus,type: \midiin,params: ()),(key: \sound,type: \polysynth,params: (gain: 0.4))],cords: [(src: \focus,dst: \sound,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \sound,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "Listen to channel two",text: "Only MIDI channel 2 plays this instrument. Set your keyboard to channel 2.",nodes: [(key: \focus,type: \midiin,params: ()),(key: \sound,type: \polysynth,params: (gain: 0.35,wave: 3))],cords: [(src: \focus,dst: \sound,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \sound,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)],music: (focus: (midiChannel: 1))),(title: "Walk through a microtonal scale",text: "Degree mapping makes neighbouring keys play neighbouring degrees of the global scale. Choose an EDO or Persian/Arabic preset in Scales.",nodes: [(key: \focus,type: \midiin,params: ()),(key: \sound,type: \polysynth,params: (gain: 0.35,wave: 0))],cords: [(src: \focus,dst: \sound,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \sound,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)],music: (focus: (inputMapping: 2)))],pieceRole: "An optional MIDI IN lets you improvise over the piece using the lead instrument. Choose a controller in its settings."),
midiout: (description: "MIDI OUT sends note events to another instrument or application. Choose the destination in MIDI settings. Standard mode uses one channel and rounds fractional pitches. MPE mode gives notes separate channels so microtonal chords keep their individual tuning. A POLY SYNTH is included in these examples so you can also hear the notes internally.",examples: [(title: "Send a simple melody",text: "Choose an output destination. Standard mode sends the four-note melody on MIDI channel 1.",nodes: [(key: \seq,type: \noteseq,params: (length: 4,division: 2)),(key: \focus,type: \midiout,params: ()),(key: \sound,type: \polysynth,params: (gain: 0.3))],cords: [(src: \seq,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \seq,dst: \sound,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \sound,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)],patterns: [(node: \seq,notes: [[60],[62],[64],[67]],degrees: false)],music: (focus: (mpe: false,outChannel: 0,bendRange: 2))),(title: "Send a microtonal chord",text: "Choose an MPE-capable destination with matching pitch-bend range. The internal monitor also plays the fractional chord.",nodes: [(key: \seq,type: \noteseq,params: (length: 4,division: 1)),(key: \focus,type: \midiout,params: ()),(key: \sound,type: \polysynth,params: (gain: 0.3))],cords: [(src: \seq,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \seq,dst: \sound,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \sound,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)],patterns: [(node: \seq,notes: [[60,64.5,67.25],[],[62,65.5,69.25],[]],degrees: false)]),(title: "Send the chosen scale",text: "Choose a destination and use MPE for fractional degrees. Change the global scale to hear and transmit another tuning.",nodes: [(key: \seq,type: \noteseq,params: (length: 8,division: 2)),(key: \focus,type: \midiout,params: ()),(key: \sound,type: \polysynth,params: (gain: 0.3))],cords: [(src: \seq,dst: \focus,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \seq,dst: \sound,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \sound,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)],patterns: [(node: \seq,notes: [[0],[1],[2],[3],[4],[5],[6],[7]],degrees: true)])],pieceRole: "The lead note pattern also reaches MIDI OUT. Choose a destination to double the lead on an external instrument."),
overview: (description: "VOID is an instrument made by joining objects with cables. Filled round ports carry stereo audio, hollow round ports carry movement or triggers, and diamonds carry notes and chords. Select an object and press Cmd+D for its description and examples. Ctrl+D works on Windows/Linux. Cmd/Ctrl+Shift+D duplicates. Build example adds a patch; Copy code copies runnable SuperCollider text. Turn Audio ON to hear a built example. Stop examples silences only help-built examples.",examples: [(title: "A quiet sine tone",text: "Listen to a soft A at 220 Hz. Change Frequency slowly, then try the other Wave positions.",nodes: [(key: \focus,type: \osc,params: (freq: 220,wave: 0,gain: 0.075,voices: 1))],cords: [(src: \focus,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)]),(title: "Chords with space",text: "A chord, a rest, another chord and a rest make a simple call and response.",nodes: [(key: \focus,type: \noteseq,params: (length: 4,division: 1,gateLength: 0.65)),(key: \sound,type: \polysynth,params: (gain: 0.3,wave: 3,release: 0.7))],cords: [(src: \focus,dst: \sound,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \sound,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)],patterns: [(node: \focus,notes: [[0,2,4],[],[3,5,7],[]],degrees: true)]),(title: "Play the synth by hand",text: "Choose your input in MIDI settings, then play the controller. All channels are accepted.",nodes: [(key: \focus,type: \midiin,params: ()),(key: \sound,type: \polysynth,params: (gain: 0.4))],cords: [(src: \focus,dst: \sound,outlet: 0,inlet: 0,param: nil,amount: 1),(src: \sound,dst: \output,outlet: 0,inlet: 0,param: nil,amount: 1)])],pieceRole: "The complete piece brings together melody, harmony, bass, percussion, a granular texture, shared effects and a four-section arrangement.")
) }.value;

// Object help examples are data, so the GUI builds them without evaluating text.
v[\helpExamples] = List.new;
v[\helpExampleAlive] = { |context|
    v[\alive] and: {v[\ready]} and: {context[\app]===v} and: {context[\session]==v[\session]}
        and: {context[\stopped]!=true} and: {context[\owned].every { |node|v[\find].value(node[\id])===node }}
};
v[\stopHelpExample] = { |context|
    if(context.notNil and: {context[\stopped]!=true}) {
        context[\stopped] = true;
        context[\routines].do { |routine|if(routine!==thisThread){routine.stop}};
        if(context[\session]==v[\session]) {
            context[\owned].do { |node|
                if(v[\find].value(node[\id])===node) {
                    v[\stopMusicNode].value(node); node[\active] = false;
                    if(v[\ready] and: {node[\synth].notNil}){node[\synth].set(\active,0)};
                };
            };
        };
    };
};
v[\stopHelpExamples] = {v[\helpExamples].copy.do { |context|v[\stopHelpExample].value(context)}};
v[\trackHelpExample] = { |nodes,focus,title|
    var context;
    context = (app:v,session:v[\session],nodes:nodes,focus:focus,title:title,
        owned:nodes.values.reject { |node|node[\type]==\output }.asArray,routines:List.new,stopped:false);
    v[\helpExamples] = v[\helpExamples].reject { |old|old[\stopped]==true }.as(List);
    v[\helpExamples].add(context); v[\lastHelpExample] = context; context
};
v[\helpExampleOrigin] = {
    ((v[\nodes].collect { |node|node[\pos].x+v[\nodeSize].value(node).x }.maxItem ? 0)+70) @ 50
};
v[\helpPattern] = { |node,data|
    node[\sequenceDegrees] = data[\degrees] ? true;
    16.do { |i|
        node[\noteSteps][i] = (notes:data[\notes].wrapAt(i).copy,enabled:true,
            velocity:(data[\velocity] ? [88]).wrapAt(i),probability:(data[\probability] ? [1.0]).wrapAt(i),
            duration:(data[\duration] ? [1.0]).wrapAt(i));
    };
};
v[\runHelpActions] = { |context,actions|
    var routine;
    routine = Routine({
        var elapsed;
        elapsed = 0;
        actions.sort { |a,b|a[\after]<b[\after] }.do { |event|
            (event[\after]-elapsed).max(0).wait; elapsed = event[\after];
            if(v[\helpExampleAlive].value(context)) {
                v[\setParam].value(context[\nodes][event[\node]],event[\param],event[\value])
            };
        };
    }).play(v[\noteClock],quant:1);
    context[\routines].add(routine);
};
v[\helpPieceRecipe] = { |type|
    var recipe,aliases,focus,first,params,node,processors;
    recipe = (
        title:"Glass Garden · a complete 32-bar piece",
        text:"A four-section piece: Dawn, Motion, Mirror and Return, eight bars each, followed by two bars of tail. Three note sequencers play melody, chords and bass; a Euclidean pluck and a granular cloud add rhythm and texture. The arrangement changes the harmony, melody, orchestration and dynamics every eight beats. It uses your current global tempo, scale and root. "++v[\helpBook][type][\pieceRole],
        piece:true,
        nodes:[
            (key:\leadSeq,type:\noteseq,params:(division:2,length:16,base:60,gateLength:0.7)),
            (key:\lead,type:\polysynth,params:(gain:0.28,wave:0,attack:0.012,release:0.45)),
            (key:\padSeq,type:\noteseq,params:(division:0.25,length:1,base:48,gateLength:0.9)),
            (key:\pad,type:\polysynth,params:(gain:0.2,wave:3,attack:0.35,release:2,cutoff:3400)),
            (key:\bassSeq,type:\noteseq,params:(division:1,length:8,base:36,gateLength:0.6)),
            (key:\bass,type:\polysynth,params:(gain:0,wave:0,attack:0.015,release:0.24,cutoff:1200)),
            (key:\rhythm,type:\euclid,params:(steps:16,pulses:5,division:4)),
            (key:\drum,type:\pluck,params:(freq:70,auto:0,decay:0.16,coef:0.65,gain:0)),
            (key:\cloud,type:\granular,params:(density:16,size:0.09,pitchScatter:0,scan:0.018,gain:0.04)),
            (key:\mix,type:\mixer,params:(gain0:0.7,gain1:0.6,gain2:0.7,gain3:0.5,pan0:0.15,pan1:-0.25)),
            (key:\tone,type:\filter,params:(cutoff:700,resonance:0.24)),
            (key:\echo,type:\delay,params:(sync:1,division:0.75,feedback:0.38,mix:0.25)),
            (key:\space,type:\reverb,params:(size:0.9,mix:0.3,shimmer:0.08)),
            (key:\stereo,type:\pan,params:(auto:0.15,rate:0.07)),
            (key:\display,type:\scope,params:(mode:1)),
            (key:\score,type:\note,params:())
        ],
        cords:[
            (src:\leadSeq,dst:\lead,outlet:0,inlet:0,amount:1),
            (src:\padSeq,dst:\pad,outlet:0,inlet:0,amount:1),
            (src:\bassSeq,dst:\bass,outlet:0,inlet:0,amount:1),
            (src:\rhythm,dst:\drum,outlet:0,inlet:0,amount:1),
            (src:\lead,dst:\mix,outlet:0,inlet:0,amount:1),
            (src:\pad,dst:\mix,outlet:0,inlet:1,amount:1),
            (src:\bass,dst:\mix,outlet:0,inlet:2,amount:1),
            (src:\drum,dst:\mix,outlet:0,inlet:3,amount:1),
            (src:\cloud,dst:\mix,outlet:0,inlet:3,amount:1),
            (src:\mix,dst:\tone,outlet:0,inlet:0,amount:1),
            (src:\tone,dst:\echo,outlet:0,inlet:0,amount:1),
            (src:\echo,dst:\space,outlet:0,inlet:0,amount:1),
            (src:\space,dst:\stereo,outlet:0,inlet:0,amount:1),
            (src:\stereo,dst:\display,outlet:0,inlet:0,amount:1),
            (src:\display,dst:\output,outlet:0,inlet:0,amount:1)
        ],
        patterns:[
            (node:\leadSeq,degrees:true,notes:[[0],[2],[4],[],[7],[4],[2],[1],[0],[],[2],[4],[6],[4],[2],[]]),
            (node:\padSeq,degrees:true,notes:[[0,2,4,6]],velocity:[62],duration:[2]),
            (node:\bassSeq,degrees:true,notes:[[0],[0],[4],[0],[7],[4],[2],[4]],velocity:[86,58,72,56,80,60,70,52])
        ],samples:[\cloud],
        textNotes:(score:"GLASS GARDEN\nDawn / Motion / Mirror / Return\n8 bars each + 2 bars of tail\nUses the current tempo, root and scale.\nStop examples or PANIC ends the performance.")
    ).deepCopy;
    aliases = (overview:\leadSeq,noteseq:\leadSeq,polysynth:\lead,euclid:\rhythm,pluck:\drum,
        granular:\cloud,mixer:\mix,filter:\tone,delay:\echo,reverb:\space,pan:\stereo,scope:\display,note:\score,output:\output);
    focus = aliases[type];
    if(focus.isNil) {
        focus = \focus;
        first = v[\helpBook][type][\examples][0][\nodes].detect { |entry|entry[\key]==\focus };
        params = if(first.notNil){first[\params].deepCopy}{()};
        if([\osc,\fm,\noise,\drone,\player].includes(type)){params[\gain] = if(type==\noise){0.012}{0.035}};
        if(type==\mic){params[\gain] = 0};
        if(type==\envelope){params = (attack:0.015,decay:0.3,hold:0.15)};
        node = (key:\focus,type:type,params:params); recipe[\nodes] = recipe[\nodes].add(node);
        if([\osc,\fm,\noise,\drone,\player,\mic].includes(type)) {
            recipe[\cords] = recipe[\cords].add((src:\focus,dst:\mix,outlet:0,inlet:3,amount:0.6));
            if(type==\player){recipe[\samples] = recipe[\samples].add(\focus)};
        };
        if([\lfo,\random,\chaotic,\sequencer].includes(type)) {
            recipe[\cords] = recipe[\cords].add((src:\focus,dst:\tone,outlet:0,inlet:0,param:\cutoff,amount:0.06));
        };
        if(type==\clock){recipe[\cords] = recipe[\cords].add((src:\focus,dst:\drum,outlet:0,inlet:0,amount:1))};
        if(type==\midiin){recipe[\cords] = recipe[\cords].add((src:\focus,dst:\lead,outlet:0,inlet:0,amount:1))};
        if(type==\midiout){recipe[\cords] = recipe[\cords].add((src:\leadSeq,dst:\focus,outlet:0,inlet:0,amount:1))};
        processors = [\envelope,\spectral,\pitchshift,\crush,\distort,\ring,\stutter,\resonator,\compressor,\xfade];
        if(processors.includes(type)) {
            recipe[\cords] = recipe[\cords].reject { |cord|cord[\src]==\lead and: {cord[\dst]==\mix} };
            recipe[\cords] = recipe[\cords] ++ [(src:\lead,dst:\focus,outlet:0,inlet:0,amount:1),
                (src:\focus,dst:\mix,outlet:0,inlet:0,amount:1)];
            if(type==\envelope){recipe[\cords] = recipe[\cords].add((src:\rhythm,dst:\focus,outlet:0,inlet:1,amount:1))};
            if(type==\xfade){recipe[\cords] = recipe[\cords].add((src:\pad,dst:\focus,outlet:0,inlet:1,amount:1))};
        };
        if(type==\vca) {
            recipe[\cords] = recipe[\cords].reject { |cord|cord[\src]==\mix and: {cord[\dst]==\tone} };
            recipe[\cords] = recipe[\cords] ++ [(src:\mix,dst:\focus,outlet:0,inlet:0,amount:1),
                (src:\focus,dst:\tone,outlet:0,inlet:0,amount:1)];
        };
    };
    recipe[\focus] = focus; recipe
};
// This function is closed: its full readable source is embedded in copied piece code.
v[\arrangeHelpPiece] = { |context|
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
};
v[\helpRecipe] = { |type,index|
    if(index==3){v[\helpPieceRecipe].value(type)}{v[\helpBook][type][\examples][index].deepCopy}
};
v[\buildHelpExample] = { |type=\overview,index=0,play=true|
    var recipe,nodes,origin,focus,context;
    context = nil;
    if(v[\ready]) {
        recipe = v[\helpRecipe].value(type,index); nodes = (output:v[\output]); origin = v[\helpExampleOrigin].value;
        v[\checkpoint].value;
        recipe[\nodes].do { |entry,i|
            var node;
            node = v[\add].value(entry[\type],origin+((i%3*295)@((i/3).floor*305)),false);
            nodes[entry[\key]] = node;
            entry[\params].keysValuesDo { |key,value|v[\setParam].value(node,key,value)};
        };
        (recipe[\music] ? ()).keysValuesDo { |key,settings|v[\restoreMusic].value(nodes[key],settings)};
        (recipe[\patterns] ? []).do { |data|v[\helpPattern].value(nodes[data[\node]],data)};
        (recipe[\textNotes] ? ()).keysValuesDo { |key,text|nodes[key][\text] = text};
        (recipe[\samples] ? []).do { |key|v[\loadSound].value(nodes[key],Platform.resourceDir +/+ "sounds/a11wlk01.wav",false)};
        recipe[\cords].do { |cord|
            var target,param;
            target = nodes[cord[\dst]];
            param = if(cord[\param].notNil){v[\registry][target[\type]][\params].detectIndex { |spec|spec[\key]==cord[\param] }}{nil};
            v[\connect].value(nodes[cord[\src]],cord[\outlet],target,cord[\inlet],param,cord[\amount],false);
        };
        focus = nodes[recipe[\focus] ? \focus] ? nodes[recipe[\nodes].first[\key]];
        context = v[\trackHelpExample].value(nodes,focus,recipe[\title]);
        if(play) {
            if(recipe[\piece] ? false){v[\arrangeHelpPiece].value(context)};
            if(recipe[\actions].notNil){v[\runHelpActions].value(context,recipe[\actions])};
            (recipe[\patterns] ? []).do { |data|v[\startSequence].value(nodes[data[\node]])};
        };
        v[\selection] = Set[focus[\id]]; v[\fit].value;
        v[\message].value("Added "++recipe[\title]++". Audio ON to listen; Stop examples or PANIC to stop.");
    } {v[\message].value("Restart audio before building a help example.")};
    context
};
v[\helpExampleCode] = { |type=\overview,index=0|
    var recipe,lines,names,focus;
    recipe = v[\helpRecipe].value(type,index); names = recipe[\nodes].collect(_[\key]);
    lines = List["(","// "++recipe[\title],"// Open/evaluate VOID.scd first. This example adds nodes; Audio ON makes it audible.",
        "var v, origin, nodes, context;","v = ~void;","if(v.notNil and: {v[\\ready]}) {",
        "    v[\\checkpoint].value;","    origin = v[\\helpExampleOrigin].value;","    nodes = (output:v[\\output]);"];
    recipe[\nodes].do { |entry,i|
        var reference;
        reference = "nodes["++entry[\key].asCompileString++"]";
        lines.add("    "++reference++" = v[\\add].value("++entry[\type].asCompileString++", origin + ("++(i%3*295)++" @ "++((i/3).floor*305).asInteger++"), false);");
        entry[\params].keys.asArray.sort.do { |key|
            lines.add("    v[\\setParam].value("++reference++", "++key.asCompileString++", "++entry[\params][key].asCompileString++");")
        };
    };
    (recipe[\music] ? ()).keysValuesDo { |key,settings|
        lines.add("    v[\\restoreMusic].value(nodes["++key.asCompileString++"], "++settings.asCompileString++");")
    };
    (recipe[\patterns] ? []).do { |data|
        lines.add("    v[\\helpPattern].value(nodes["++data[\node].asCompileString++"], "++data.asCompileString++");")
    };
    (recipe[\textNotes] ? ()).keysValuesDo { |key,text|
        lines.add("    nodes["++key.asCompileString++"][\\text] = "++text.asCompileString++";")
    };
    (recipe[\samples] ? []).do { |key|
        lines.add("    v[\\loadSound].value(nodes["++key.asCompileString++"], Platform.resourceDir +/+ \"sounds/a11wlk01.wav\", false);")
    };
    recipe[\cords].do { |cord|
        var node,param;
        node = recipe[\nodes].detect { |entry|entry[\key]==cord[\dst] };
        param = if(cord[\param].notNil){v[\registry][node[\type]][\params].detectIndex { |spec|spec[\key]==cord[\param] }}{nil};
        lines.add("    v[\\connect].value(nodes["++cord[\src].asCompileString++"], "++cord[\outlet]++", nodes["++
            cord[\dst].asCompileString++"], "++cord[\inlet]++", "++param.asCompileString++", "++cord[\amount]++", false);")
    };
    focus = recipe[\focus] ? if(names.includes(\focus)){\focus}{names.first};
    lines.add("    context = v[\\trackHelpExample].value(nodes, nodes["++focus.asCompileString++"], "++recipe[\title].asCompileString++");");
    if(recipe[\piece] ? false) {
        lines.add("    // Complete score and arrangement: four eight-bar sections, then a two-bar tail.");
        lines.add("    ("++v[\arrangeHelpPiece].asCompileString++").value(context);");
    };
    if(recipe[\actions].notNil){lines.add("    v[\\runHelpActions].value(context, "++recipe[\actions].asCompileString++");")};
    (recipe[\patterns] ? []).do { |data|lines.add("    v[\\startSequence].value(nodes["++data[\node].asCompileString++"]);")};
    lines.add("    v[\\selection] = Set[context[\\focus][\\id]]; v[\\fit].value;");
    lines.add("} { \"Open VOID and restart its audio first.\".postln; };");
    lines.add("// Stop this and other help-built examples: ~void[\\stopHelpExamples].value;"); lines.add(")");
    lines.join(Char.nl.asString)
};

v[\helpSetText] = { |view,text|
    view.string_(text); view.setStringColor(v[\ink],0,text.size); view.select(0,0);
};
v[\helpDescription] = { |type|
    var entry,reg,ports,controls;
    entry = v[\helpBook][type]; reg = v[\registry][type];
    if(type==\overview) {
        entry[\description]++"\n\nSHORTCUTS\nCmd/Ctrl+D: object help and examples\nCmd/Ctrl+Shift+D: duplicate selection\nCmd/Ctrl+C / V: copy / paste objects\nCmd/Ctrl+Z: undo; Shift+Z or Ctrl+Y: redo\nCmd/Ctrl+S / O: save / load patch\nDouble-click canvas: add an object\nDrag a knob: change it; Shift: fine; double-click: type a value\nF: fit view; wheel: pan; Cmd/Ctrl+wheel: zoom\nB: bypass; M: mutate; T: tap tempo; R: record; P: panic\nL / I: library / inspector; H / ?: help\nCmd/Ctrl+Period: stop audio; Restart audio rebuilds it\nEsc: close this help window\n\nEvery object has three simple examples and a complete musical piece. Copy code, paste it into the SuperCollider IDE, select the whole block and evaluate. Build example performs the same setup directly. Examples use the current global tempo, scale and root. They add nodes alongside your patch; Undo can remove the last build. MIDI examples need a chosen device; MIC IN begins at gain zero; recording starts only when you press Record."
    } {
        ports = if(type==\note){"No audio, note or control ports."} {
            "Inputs: "++if(reg[\inputs].isEmpty){"none"}{reg[\inputs].collect { |p|p[\name]++" ("++p[\kind]++")" }.join(", ")}++
            "\nOutputs: "++if(reg[\outputs].isEmpty){"none"}{reg[\outputs].collect { |p|p[\name]++" ("++p[\kind]++")" }.join(", ")}
        };
        controls = reg[\params].collect { |spec|
            spec[\label]++": "++if(spec[\choices].notNil){spec[\choices].join(" / ")}{spec[\min].asString++" to "++spec[\max]}
        }.join(Char.nl.asString);
        entry[\description]++"\n\n"++ports++if(controls.isEmpty){""}{"\n\nControls (scroll to read all):\n"++controls}++
            "\n\nRound filled ports = audio. Round hollow ports = control / trigger. Diamonds = notes / chords.\nChoose any of the three simple examples or the complete musical piece below."
    }
};
v[\closeHelp] = {
    var window;
    window = v[\helpWindow]; v[\helpWindow] = nil; v[\helpUI] = nil;
    if(window.notNil and: {window.isClosed.not}){window.close};
};
v[\showHelp] = { |type=nil|
    var win,bounds,width,height,search,list,title,description,examples,explanation,code,status,copy,build,stop,copyWords,results,update,filter,select;
    if(type.isNil){type = if(v[\selected].value.notNil){v[\selected].value[\type]}{\overview}};
    if(v[\helpBook][type].isNil){type = \overview};
    if(v[\helpWindow].notNil and: {v[\helpWindow].isClosed.not}) {
        v[\helpUI][\select].value(type); v[\helpWindow].front;
    } {
        bounds = Window.screenBounds; width = (bounds.width-80).min(1120).max(880); height = (bounds.height-130).min(820).max(620);
        win = Window("VOID · Object help & playable examples · Cmd+D",Rect(60,60,width,height)).background_(v[\panel]);
        win.view.minSize = 880@620; v[\helpWindow] = win;
        search = TextField(win,Rect(14,14,232,28)).background_(v[\glass]).stringColor_(v[\ink]);
        list = ListView(win,Rect(14,52,232,height-112)).resize_(4).background_(v[\glass]).stringColor_(v[\ink]).font_(v[\font]);
        title = StaticText(win,Rect(264,12,width-280,30)).resize_(2).font_(v[\titleFont].copy.size_(18)).stringColor_(v[\colors][0]);
        description = TextView(win,Rect(264,50,width-280,154)).resize_(2).editable_(false).enterInterpretsSelection_(false)
            .background_(v[\glass]).stringColor_(v[\ink]).font_(v[\font]);
        examples = PopUpMenu(win,Rect(264,214,width-280,28)).resize_(2);
        explanation = TextView(win,Rect(264,252,width-280,80)).resize_(2).editable_(false).enterInterpretsSelection_(false)
            .background_(v[\panel]).stringColor_(v[\ink]).font_(v[\font]);
        code = TextView(win,Rect(264,342,width-280,height-411)).resize_(5).editable_(false).enterInterpretsSelection_(false)
            .background_(v[\glass]).stringColor_(v[\ink]).font_(Font.monospace(11));
        status = StaticText(win,Rect(264,height-27,width-280,22)).resize_(8).font_(v[\smallFont]).stringColor_(v[\muted]);
        update = {
            var recipe;
            recipe = v[\helpRecipe].value(v[\helpType],examples.value);
            v[\helpSetText].value(explanation,recipe[\text]); v[\helpSetText].value(code,v[\helpExampleCode].value(v[\helpType],examples.value));
            status.string_("Copy code to the SuperCollider IDE, or Build example to add it here. Audio ON to listen.");
        };
        filter = {
            var query;
            query = search.string.toLower;
            results = ([\overview]++v[\order].asArray).select { |key|
                query.isEmpty or: {((if(key==\overview){"Start here / Shortcuts"}{v[\registry][key][\name]})++" "++v[\helpBook][key][\description]).toLower.find(query).notNil}
            };
            list.items_(results.collect { |key|if(key==\overview){"Start here / Shortcuts"}{v[\registry][key][\name]} });
            if(results.includes(v[\helpType])){list.value_(results.indexOf(v[\helpType]))};
        };
        select = { |key|
            v[\helpType] = key;
            if(results.isNil or: {results.includes(key).not}){search.string_(""); filter.value};
            list.value_(results.indexOf(key));
            title.string_(if(key==\overview){"VOID · Start here"}{v[\registry][key][\name]++" · in plain words"});
            v[\helpSetText].value(description,v[\helpDescription].value(key));
            examples.items_(v[\helpBook][key][\examples].collect { |entry,i|(i+1).asString++" · "++entry[\title] }++["4 · Glass Garden · complete musical piece"]);
            examples.value_(0); update.value;
        };
        search.action_({filter.value}); search.keyUpAction_({filter.value});
        list.action_({if(list.value.notNil){select.value(results[list.value])}});
        examples.action_({update.value});
        copy = v[\dialogButton].value(win,Rect(264,height-58,128,28),"Copy code",{
            code.select(0,code.string.size); code.invokeMethod(\copy); code.focus;
            status.string_("Code copied. Paste into the SuperCollider IDE and evaluate the whole block.");
        }).resize_(7);
        build = v[\dialogButton].value(win,Rect(402,height-58,148,28),"Build example",{
            var context;
            context = v[\buildHelpExample].value(v[\helpType],examples.value);
            status.string_(if(context.notNil){"Added "++context[\title]++". Undo removes the build; Stop examples silences it."}{"Click Restart audio first."});
        }).resize_(7);
        stop = v[\dialogButton].value(win,Rect(560,height-58,148,28),"Stop examples",{
            v[\stopHelpExamples].value; status.string_("Help-built examples stopped. Their objects remain on the canvas.");
        }).resize_(7);
        copyWords = v[\dialogButton].value(win,Rect(718,height-58,146,28),"Copy description",{
            description.select(0,description.string.size); description.invokeMethod(\copy); description.focus;
            status.string_("Object description copied.");
        }).resize_(7);
        v[\dialogButton].value(win,Rect(14,height-50,232,28),"Start here / Shortcuts",{select.value(\overview)}).resize_(7);
        v[\helpUI] = (window:win,search:search,list:list,title:title,description:description,examples:examples,
            explanation:explanation,code:code,copy:copy,build:build,stop:stop,copyWords:copyWords,status:status,select:select);
        v[\helpType] = type; filter.value; select.value(type);
        win.onClose_({if(v[\helpWindow]===win){v[\helpWindow] = nil; v[\helpUI] = nil}});
        v[\dialogs].add(win); v[\installHelpShortcuts].value(win.view,true); win.front; list.focus;
    };
};
// Install only on VOID's own views, preserving each view's native editing keys.
v[\helpShortcutViews] = IdentitySet.new;
v[\installHelpShortcuts] = { |view,helpView=false|
    if(v[\helpShortcutViews].includes(view).not) {
        var previous;
        previous = view.keyDownAction; v[\helpShortcutViews].add(view);
        view.keyDownAction_({ |sender,char,mods,unicode,keycode,key|
            var letter,inHelp,result;
            key = key ? keycode; letter = if(key.inclusivelyBetween(65,90)){key.asAscii.toLower}{if(char.isKindOf(Char)){char.toLower}{0.asAscii}};
            inHelp = helpView and: {v[\helpWindow].notNil};
            if((mods.isCmd or: {mods.isCtrl}) and: {letter==$d} and: {mods.isShift.not}) {
                if(inHelp){v[\helpWindow].front}{v[\showHelp].value}; true
            } {
                if(inHelp and: {key==16777216}) {v[\closeHelp].value; true} {
                    if(previous.notNil){previous.value(sender,char,mods,unicode,keycode,key)}{nil}
                }
            }
        });
    };
    view.children.do { |child|v[\installHelpShortcuts].value(child,helpView)};
};

// 9 Snapshots / save / load / undo --------------------------------------------
v[\packNode] = { |n|
    (id:n[\id],type:n[\type],x:n[\pos].x,y:n[\pos].y,active:n[\active],noteMode:n[\noteMode] ? false,
        chaos:n[\chaos],chaosAmount:n[\chaosAmount],params:n[\params].deepCopy,
        paths:n[\pool].collect { |sound|sound[\path] }.asArray,
        steps:n[\steps].copy,gates:n[\gates].copy,probs:n[\probs].copy,text:n[\text].copy,music:v[\packMusic].value(n))
};
v[\packCord] = { |c|
    (src:c[\src],dst:c[\dst],outlet:c[\outlet],inlet:c[\inlet],param:c[\param],kind:c[\kind],amount:c[\amount])
};
v[\serialize] = {
    (format:"VOID",version:1,nodes:v[\nodes].collect { |n|v[\packNode].value(n) }.asArray,
        cords:v[\cords].collect { |c|v[\packCord].value(c) }.asArray,snapshots:v[\snapshots].deepCopy,
        bpm:v[\bpm],root:v[\root],scale:v[\scaleIndex],scaleName:v[\scaleNames][v[\scaleIndex]],scaleMode:v[\scaleMode],customScale:v[\customScale].deepCopy,globalChaos:v[\globalChaos],
        snapshotA:v[\snapshotA],snapshotB:v[\snapshotB],pan:v[\pan],zoom:v[\zoom])
};
v[\checkpoint] = {
    if(v[\restoring]!=true and: {v[\ready]}) {
        v[\undo].add(v[\serialize].value); if(v[\undo].size>60){v[\undo].removeAt(0)}; v[\redo].clear;
    };
};
v[\restore] = { |data|
    var hardware,session,bus;
    if(data.isKindOf(Event) and: {data[\format]=="VOID"} and: {data[\version]==1}) {
        v[\stopHelpExamples].value;
        v[\restoring] = true; v[\session] = (v[\session] ? 0)+1;
        hardware = v[\hardware]; session = v[\session];
        if(hardware.notNil){hardware.set(\on,0)};
        if(v[\recording]){v[\toggleRecord].value};
        v[\cords].copy.do { |c|v[\removeCord].value(c) };
        v[\nodes].do { |n|v[\releaseNode].value(n) }; v[\nodes].clear; v[\selection].clear;
        v[\bpm] = data[\bpm]; v[\root] = data[\root]; v[\scaleIndex] = data[\scale].clip(0,v[\scaleCatalog].size-1);
        if(data[\scaleName].notNil){v[\scaleIndex] = v[\scaleNames].indexOfEqual(data[\scaleName]) ? v[\scaleIndex]};
        v[\scaleMode] = data[\scaleMode] ? 0; v[\customScale] = data[\customScale].deepCopy;
        v[\sendGlobals].value;
        v[\globalChaos] = data[\globalChaos]; v[\snapshots] = data[\snapshots].deepCopy;
        v[\snapshotA] = data[\snapshotA] ? 0; v[\snapshotB] = data[\snapshotB] ? 1;
        v[\pan] = data[\pan]; v[\zoom] = data[\zoom]; v[\nextID] = 1; v[\output] = nil;
        // OUTPUT is created first so master-following objects always have a valid bus.
        data[\nodes].sort { |a,b| (a[\type]==\output).asInteger > (b[\type]==\output).asInteger }.do { |item|
            var n;
            if(v[\registry][item[\type]].notNil) {
                n = v[\add].value(item[\type],item[\x]@item[\y],false,false);
                n[\id] = item[\id]; n[\active] = item[\active]; n[\chaos] = item[\chaos];
                n[\chaosAmount] = item[\chaosAmount]; n[\params] = item[\params].deepCopy;
                n[\noteMode] = item[\noteMode] ? false;
                n[\steps] = item[\steps].copy; n[\gates] = item[\gates].copy;
                n[\probs] = item[\probs].copy; n[\text] = item[\text];
                v[\restoreMusic].value(n,item[\music]);
                v[\spawn].value(n);
                item[\paths].do { |path|v[\loadSound].value(n,path,false)};
            };
        };
        if(v[\output].isNil){v[\add].value(\output,700@150,false)};
        v[\nextID] = (v[\nodes].collect { |n|n[\id] }.maxItem ? 0)+1;
        data[\cords].do { |c|
            var src,dst;
            src = v[\find].value(c[\src]); dst = v[\find].value(c[\dst]);
            if(src.notNil and: {dst.notNil}) {
                v[\connect].value(src,c[\outlet],dst,c[\inlet],c[\param],c[\amount],false)
            };
        };
        v[\selection].clear; v[\selectedCord] = nil; v[\inspectorScroll] = 0;
        if(hardware.notNil) {
            bus = v[\output][\out].index;
            {if(v[\alive] and: {v[\ready]} and: {v[\session]==session}) {
                hardware.set(\bus,bus,\on,v[\audioOn].asInteger)
            }}.defer(0.055);
        };
        v[\nodes].do { |n|if(n[\type]==\recorder){v[\syncPool].value(n)}};
        v[\restoring] = false;
    } {v[\message].value("This is not a supported VOID patch.")};
};
v[\undoAction] = {
    if(v[\undo].notEmpty and: {v[\ready]}) {
        v[\redo].add(v[\serialize].value); v[\restore].value(v[\undo].pop);
        v[\message].value("Undo")
    };
};
v[\redoAction] = {
    if(v[\redo].notEmpty and: {v[\ready]}) {
        v[\undo].add(v[\serialize].value); v[\restore].value(v[\redo].pop);
        v[\message].value("Redo")
    };
};
v[\save] = {
    Dialog.savePanel({ |path| {try {
        v[\serialize].value.writeArchive(path); v[\message].value("Saved "++path.basename)
    } { |error|v[\message].value("Save failed: "++error.errorString)}}.defer });
};
v[\load] = {
    Dialog.openPanel({ |path| {try {
        var data;
        data = Object.readArchive(path); v[\checkpoint].value; v[\restore].value(data);
        v[\message].value("Opened "++path.basename)
    } { |error|v[\message].value("Load failed: "++error.errorString)}}.defer });
};
v[\parameterSnapshot] = {
    v[\nodes].collect { |n| (id:n[\id],type:n[\type],params:n[\params].deepCopy,
        chaos:n[\chaos],chaosAmount:n[\chaosAmount],steps:n[\steps].copy,gates:n[\gates].copy,probs:n[\probs].copy,music:v[\packMusic].value(n)) }.asArray
};
v[\applySnapshot] = { |snapshot|
    snapshot.do { |item|
        var node;
        node = v[\find].value(item[\id]);
        if(node.notNil and: {node[\type]==item[\type]}) {
            v[\restoreMusic].value(node,item[\music]);
            node[\params] = item[\params].deepCopy; node[\chaos] = item[\chaos];
            node[\chaosAmount] = item[\chaosAmount];
            node[\params].do { |p,i|v[\sendParam].value(node,i)};
            if(node[\synth].notNil){node[\synth].set(\chaos,node[\chaos].asInteger,\chaosAmount,node[\chaosAmount])};
            node[\steps] = item[\steps].copy; node[\gates] = item[\gates].copy; node[\probs] = item[\probs].copy;
            if(node[\type]==\sequencer){v[\sendSteps].value(node)};
        };
    };
};
v[\morphSnapshots] = { |amount|
    var a,b;
    a = v[\snapshots][v[\snapshotA]]; b = v[\snapshots][v[\snapshotB]];
    if(a.notNil and: {b.notNil}) {
        a.do { |item|
            var target,node;
            target = b.detect { |other|other[\id]==item[\id] and: {other[\type]==item[\type]} };
            node = v[\find].value(item[\id]);
            if(target.notNil and: {node.notNil}) {
                node[\params].do { |p,i|
                    if(p[\locked].not) {
                        p[\base] = item[\params][i][\base].blend(target[\params][i][\base],amount);
                        p[\rate] = item[\params][i][\rate].blend(target[\params][i][\rate],amount);
                        p[\depth] = item[\params][i][\depth].blend(target[\params][i][\depth],amount);
                        v[\sendParam].value(node,i);
                    };
                };
                node[\chaosAmount] = item[\chaosAmount].blend(target[\chaosAmount],amount);
                if(node[\synth].notNil){node[\synth].set(\chaosAmount,node[\chaosAmount])};
            };
        };
    };
};
v[\copy] = {
    var ids;
    ids = v[\selection].copy;
    v[\clipboard] = (nodes:v[\nodes].select { |n|ids.includes(n[\id]) and: {n[\type]!=\output} }
        .collect { |n|v[\packNode].value(n) },
        cords:v[\cords].select { |c|ids.includes(c[\src]) and: {ids.includes(c[\dst])} }
        .collect { |c|v[\packCord].value(c) });
};
v[\paste] = {
    var map,created;
    map = Dictionary.new; created = Set.new;
    if(v[\clipboard].notNil) {
        v[\checkpoint].value;
        v[\clipboard][\nodes].do { |item|
            var n;
            n = v[\add].value(item[\type],(item[\x]+35)@(item[\y]+35),false);
            map[item[\id]] = n; created.add(n[\id]);
            n[\params] = item[\params].deepCopy; n[\text] = item[\text];
            n[\noteMode] = item[\noteMode] ? false;
            v[\restoreMusic].value(n,item[\music]);
            n[\chaos] = item[\chaos]; n[\chaosAmount] = item[\chaosAmount]; n[\active] = item[\active];
            n[\steps] = item[\steps].copy; n[\gates] = item[\gates].copy; n[\probs] = item[\probs].copy;
            n[\params].do { |p,i|v[\sendParam].value(n,i)};
            if(n[\synth].notNil){n[\synth].set(\chaos,n[\chaos].asInteger,\chaosAmount,n[\chaosAmount],\active,n[\active].asInteger)};
            if(n[\type]==\sequencer){v[\sendSteps].value(n)};
            item[\paths].do { |path|v[\loadSound].value(n,path,false)};
        };
        v[\clipboard][\cords].do { |c|
            if(map[c[\src]].notNil and: {map[c[\dst]].notNil}) {
                v[\connect].value(map[c[\src]],c[\outlet],map[c[\dst]],c[\inlet],c[\param],c[\amount],false)
            };
        };
        v[\selection] = created;
    };
};
v[\recordTime] = {
    var seconds;
    seconds = (Main.elapsedTime-(v[\recordStart] ? Main.elapsedTime)).asInteger.max(0);
    (seconds div: 60).asString.padLeft(2,"0")++":"++(seconds%60).asString.padLeft(2,"0")
};
v[\finishRecording] = {
    var buf;
    buf = v[\recordBuffer];
    if(v[\disk].notNil){v[\disk].free; v[\disk] = nil};
    v[\recording] = false;
    if(buf.notNil) {
        v[\recordBusy] = true;
        v[\recordRoutine] = Routine({
            s.sync; buf.close; v[\recordOpened] = false; s.sync; v[\recordBuffer] = nil; buf.free;
            {v[\recordBusy] = false; v[\recordBuffer] = nil;
                v[\message].value("Recording saved: "++v[\recordPath])}.defer;
        }).play(SystemClock);
    };
};
v[\toggleRecord] = {
    if(v[\ready] and: {v[\recordBusy].not}) {
        if(v[\recording]) {v[\finishRecording].value} {
            var dir,path;
            dir = Platform.recordingsDir; dir.mkdir;
            path = dir +/+ ("VOID_"++Date.localtime.stamp++"_"++1000000.rand++".wav");
            v[\recordPath] = path; v[\recordBusy] = true;
            v[\recordRoutine] = Routine({
                var buf;
                buf = Buffer.alloc(s,65536,2); v[\recordBuffer] = buf; v[\recordOpened] = false; s.sync;
                buf.write(path,"wav","float",0,0,true); v[\recordOpened] = true; s.sync;
                {if(v[\alive] and: {v[\ready]}) {
                    v[\recordBuffer] = buf;
                    v[\disk] = Synth.tail(v[\masterGroup],\void_disk,[\buf,buf.bufnum,\bus,v[\output][\out].index]);
                    v[\recordStart] = Main.elapsedTime; v[\recording] = true; v[\recordBusy] = false;
                    v[\message].value("Recording stereo master to "++path);
                } {buf.close; buf.free}}.defer;
            }).play(SystemClock);
        };
    };
};

// 10 Startup ------------------------------------------------------------------
v[\dialogs] = List.new; v[\collapsedCategories] = Set.new;
v[\session] = 0;
v[\decodePath] = { |path|
    var result,index,a,b;
    if(path.beginsWith("file://")) {
        path = path.replace("file://localhost", "").replace("file://", "");
        result = String.new; index = 0;
        while {index<path.size} {
            a = nil; b = nil;
            if(path[index]==$% and: {(index+2)<path.size}) {
                a = "0123456789abcdef".indexOf(path[index+1].toLower);
                b = "0123456789abcdef".indexOf(path[index+2].toLower);
            };
            if(a.notNil and: {b.notNil}) {result = result.add(((a*16)+b).asAscii); index = index+3}
            {result = result.add(path[index]); index = index+1};
        };
        path = result;
        if(Platform.name==\windows and: {path.size>2} and: {path[0]==$/} and: {path[2]==$:}) {path = path.drop(1)};
    };
    path
};
v[\dropSounds] = { |view,x,y|
    var data,paths,node;
    data = View.currentDrag; paths = if(data.isString){data.split(Char.nl)}{data.asArray};
    paths = paths.select(_.isString).collect { |path|
        v[\decodePath].value(path.stripWhiteSpace)
    }.reject { |path|path.isEmpty};
    node = v[\nodes].reverse.detect { |n|[\player,\granular].includes(n[\type]) and: {v[\nodeRect].value(n).contains(x@y)} };
    if(node.isNil) {node = v[\add].value(if(v[\shiftDown] ? false){\granular}{\player},v[\world].value(x@y))};
    paths.do { |path|v[\loadSound].value(node,path) };
};
v[\startDraw] = {
    if(v[\redraw].notNil){v[\redraw].stop};
    v[\redraw] = Routine({
        while {v[\alive]} {
            {if(v[\alive] and: {v[\view].notNil}) {v[\view].refresh}}.defer;
            (1/30).wait;
        };
    }).play(AppClock);
};
v[\buildGUI] = {
    var bounds,win,view;
    bounds = Window.screenBounds;
    win = Window("VOID · Experimental patch instrument",Rect(20,40,(bounds.width-40).min(1440),(bounds.height-100).min(940)))
        .background_(v[\bg]).acceptsMouseOver_(true);
    win.view.minSize = 1080@640;
    view = UserView(win,win.view.bounds).resize_(5).background_(v[\bg]).canFocus_(true);
    v[\window] = win; v[\view] = view;
    view.drawFunc_({ |uv|v[\draw].value(uv)});
    view.mouseDownAction_(v[\mouseDown]); view.mouseMoveAction_(v[\mouseMove]);
    view.mouseUpAction_(v[\mouseUp]); view.mouseWheelAction_(v[\wheel]);
    view.mouseOverAction_({ |uv,x,y|v[\mouse]=x@y});
    view.keyDownAction_({ |uv,char,mods,unicode,keycode,key|
        v[\shiftDown] = mods.isShift; v[\keyDown].value(uv,char,mods,unicode,keycode,key)
    });
    view.keyUpAction_({ |uv,char,mods,unicode,keycode,key|v[\shiftDown] = mods.isShift; if(key==32){v[\space]=false}; true});
    view.keyModifiersChangedAction_({ |uv,mods|v[\shiftDown] = mods.isShift});
    view.canReceiveDragHandler_({ |uv,x,y|View.currentDrag.notNil}); view.receiveDragHandler_(v[\dropSounds]);
    win.onClose_({v[\close].value});
    v[\installHelpShortcuts].value(win.view);
    win.front; view.focus; v[\startDraw].value;
};
v[\demo] = {
    var old,drone,osc,cloud,filter,delay,reverb,lfo,output,example;
    if(v[\ready]) {
        v[\checkpoint].value;
        v[\stopHelpExamples].value;
        old = v[\nodes].reject { |n|n[\type]==\output };
        v[\cords].copy.do { |c|v[\removeCord].value(c)};
        old.do { |n|v[\releaseNode].value(n); v[\nodes].remove(n)};
        output = v[\output]; output[\pos] = 930@320;
        cloud = v[\add].value(\granular,20@20,false);
        drone = v[\add].value(\drone,20@330,false);
        osc = v[\add].value(\osc,325@330,false);
        filter = v[\add].value(\filter,325@20,false);
        delay = v[\add].value(\delay,630@20,false);
        reverb = v[\add].value(\reverb,630@330,false);
        lfo = v[\add].value(\lfo,930@20,false);
        v[\setParam].value(osc,\freq,55); v[\setParam].value(osc,\gain,0.07);
        v[\setParam].value(drone,\gain,0.19); v[\setParam].value(filter,\cutoff,1400);
        v[\setParam].value(reverb,\mix,0.5); v[\setParam].value(delay,\feedback,0.48);
        [[cloud,filter],[drone,filter],[osc,filter],[filter,delay],[delay,reverb],[reverb,output]].do { |pair|
            v[\connect].value(pair[0],0,pair[1],0,nil,0.8,false)
        };
        v[\connect].value(lfo,0,filter,0,0,0.12,false);
        drone[\params][2][\random] = true; drone[\params][2][\depth] = 0.12; v[\sendParam].value(drone,2);
        cloud[\params][0][\random] = true; cloud[\params][0][\depth] = 0.25; v[\sendParam].value(cloud,0);
        [cloud,drone,delay].do { |n|n[\chaos]=true; n[\synth].set(\chaos,1)};
        example = Platform.resourceDir +/+ "sounds/a11wlk01.wav";
        if(File.exists(example)){v[\loadSound].value(cloud,example,false)};
        v[\selection] = Set[cloud[\id]]; v[\audioOn] = true; v[\hardware].set(\on,1,\panic,0);
        v[\fit].value; v[\message].value("Demo is playing. Drag a knob, enable dice, or drop your own sounds.");
    };
};
v[\freeEngine] = {
    var wasReady;
    v[\panicNotes].value;
    wasReady = v[\ready]; v[\ready] = false;
    if(wasReady and: {v[\rootGroup].notNil}){v[\rootGroup].free};
    v[\retired].copy.do { |ticket|v[\cleanTicket].value(ticket,false)};
    v[\nodes].do { |node|
        ((node[\ins] ? [])++(node[\modBuses] ? [])++[node[\out],node[\controlOut],node[\voiceBus],node[\voiceParamsBus]]).do { |bus|if(bus.notNil){bus.free} };
        node[\pool].do { |sound|v[\freeSound].value(sound)};
        node[\pool].clear; node[\ins] = nil; node[\modBuses] = nil;
        node[\out] = nil; node[\controlOut] = nil; node[\voiceBus] = nil; node[\voiceParamsBus] = nil; node[\voiceGroup] = nil; node[\tailGroup] = nil; node[\synth] = nil; node[\group] = nil; node[\clears] = nil;
    };
    v[\cords].do { |cord|cord[\synth]=nil};
    (v[\grainEnvs] ? []).do(_.free); if(v[\silent].notNil){v[\silent].free};
    if(v[\scaleBuffer].notNil){v[\scaleBuffer].free}; v[\scaleBuffer] = nil; v[\scaleSignature] = nil;
    v[\grainEnvs] = nil; v[\silent] = nil; v[\hardware] = nil;
    if(v[\oscdef].notNil){v[\oscdef].free};
};
v[\initialize] = {
    if(s.serverRunning.not) {
        s.options.memSize = s.options.memSize.max(131072);
        s.options.numAudioBusChannels = s.options.numAudioBusChannels.max(4096);
        s.options.numControlBusChannels = s.options.numControlBusChannels.max(32768);
        s.options.maxNodes = s.options.maxNodes.max(16384);
        s.options.numBuffers = s.options.numBuffers.max(2048);
    };
    s.waitForBoot {
        if(v[\alive]) {
        v[\bootRoutine] = Routine({
            v[\defineDefs].value;
            v[\silent] = Buffer.alloc(s,64,1);
            v[\scaleBuffer] = Buffer.alloc(s,v[\scaleResolution]+1,1);
            s.sync; v[\updateScaleBuffer].value;
            v[\grainEnvs] = [Env.sine(1),Env([0,1,0],[0.1,0.9],[-3,-6]),
                Env([0,1,1,0],[0.2,0.6,0.2],\sin),Env([0,1,0],[0.9,0.1],[6,-3])]
                .collect { |env|Buffer.sendCollection(s,env.discretize(1024),1) };
            s.sync;
            v[\rootGroup] = Group.head(s);
            v[\objectGroup] = Group.head(v[\rootGroup]);
            v[\clearGroup] = Group.after(v[\objectGroup]);
            v[\cordGroup] = Group.after(v[\clearGroup]);
            v[\masterGroup] = Group.after(v[\cordGroup]); s.sync;
            v[\oscdef] = OSCdef(\void_node,{ |msg|
                {if(v[\alive]) {
                    var node,count;
                    node = v[\find].value(msg[3].asInteger);
                    if(node.notNil) {
                        count = node[\params].size; node[\meter] = [msg[4],msg[5]];
                        node[\cursor] = msg[6]; node[\soundCursor] = msg[7]; node[\live] = msg.copyRange(8,7+count);
                        if(node[\type]==\scope){node[\scope]=msg.copyRange(8+count,39+count)};
                    };
                }}.defer;
            },'/void/node',s.addr);
            {if(v[\alive]) {
                v[\ready] = true; v[\booting] = false;
                v[\initMIDI].value;
                if(v[\window].isNil){v[\buildGUI].value};
                if(v[\pendingRestore].notNil) {
                    v[\restore].value(v[\pendingRestore]); v[\pendingRestore] = nil
                } {
                    v[\add].value(\output,620@180,false); v[\selection].clear
                };
                v[\hardware] = Synth.tail(v[\masterGroup],\void_hardware,
                    [\bus,v[\output][\out].index,\on,v[\audioOn].asInteger]);
                v[\startDraw].value; v[\message].value("VOID is ready. Demo starts a sound; double-click the canvas to build.");
            }}.defer;
        }).play(SystemClock);
        };
    };
};
v[\restart] = {
    if(v[\booting]!=true) {
        v[\pendingRestore] = v[\serialize].value;
        v[\freeEngine].value; v[\booting] = true; v[\initialize].value;
    };
};
v[\cmdPeriod] = {
    {if(v[\alive]) {
        v[\ready] = false; v[\panicNotes].value;
        v[\audioOn] = false; v[\booting] = false;
        if(v[\recording]) {v[\disk] = nil; v[\finishRecording].value};
        v[\nodes].do { |n|n[\synth]=nil; n[\group]=nil; n[\clears]=nil};
        v[\cords].do { |c|c[\synth]=nil};
        v[\message].value("Audio stopped. Click Restart audio to rebuild this patch.");
        if(v[\view].notNil){v[\view].refresh};
    }}.defer;
};
CmdPeriod.add(v[\cmdPeriod]);
v[\close] = {
    if(v[\alive]) {
        v[\panicNotes].value;
        v[\midiDefs].do(_.free); v[\midiDefs].clear;
        v[\noteClock].stop;
        v[\alive] = false; v[\session] = v[\session]+1;
        CmdPeriod.remove(v[\cmdPeriod]);
        if(v[\redraw].notNil){v[\redraw].stop};
        if(v[\bootRoutine].notNil){v[\bootRoutine].stop};
        if(v[\recordRoutine].notNil){v[\recordRoutine].stop};
        if(v[\disk].notNil){v[\disk].free};
        if(v[\recordBuffer].notNil){
            if(v[\recordOpened] ? false){v[\recordBuffer].close(v[\recordBuffer].freeMsg)}{v[\recordBuffer].free}
        };
        v[\freeEngine].value;
        v[\dialogs].do { |win|if(win.isClosed.not){win.close} };
        v[\helpShortcutViews].clear;
        if(v[\window].notNil and: {v[\window].isClosed.not}) {
            v[\window].onClose = nil; v[\window].close
        };
        "VOID closed. Audio resources released.".postln;
    };
};
v[\initialize].value;
)
