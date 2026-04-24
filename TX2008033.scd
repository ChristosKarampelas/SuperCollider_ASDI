//1
(
s.quit;

Server.default.options.blockSize = 1024;
Server.default.options.hardwareBufferSize = 1024;
Server.default.options.numInputBusChannels = 0;
Server.default.options.numOutputBusChannels = 2;
Server.default.options.memSize = 65536;
Server.default.latency = 0.3;
)
//2
s.boot;
//3
(
Pdef(\piece).stop;
Ndef(\mix).clear;
s.freeAll;
)
//4
(
SynthDef(\bass, {
    arg freq=45, amp=0.18, gate=1, pan=0;
    var sig, env;

    sig = SinOsc.ar(freq, 0, 0.75) + SinOsc.ar(freq * 2, 0, 0.18);
    sig = HPF.ar(sig, 28);
    sig = LPF.ar(sig, 120);

    env = EnvGen.ar(Env.asr(0.08, 1, 1.8), gate, doneAction: 2);
    sig = sig * env * amp;

    Out.ar(0, Pan2.ar(sig, pan));
}).add;

SynthDef(\kick, {
    arg amp=0.32, pan=0;
    var pitchEnv, ampEnv, sig;

    pitchEnv = XLine.kr(75, 34, 0.18);
    ampEnv = EnvGen.kr(Env.perc(0.002, 0.6), doneAction: 2);

    sig = SinOsc.ar(pitchEnv, 0, 1.0);
    sig = sig + (BPF.ar(WhiteNoise.ar(0.015), 3200, 0.4) * 0.15);
    sig = LPF.ar(sig, 2500);
    sig = sig * ampEnv * amp;

    Out.ar(0, Pan2.ar(sig, pan));
}).add;

SynthDef(\dustHat, {
    arg amp=0.025, pan=0;
    var env, sig;

    env = EnvGen.kr(Env.perc(0.001, 0.08), doneAction: 2);
    sig = WhiteNoise.ar;
    sig = HPF.ar(sig, 8000);
    sig = sig * env * amp;

    Out.ar(0, Pan2.ar(sig, pan));
}).add;

SynthDef(\wash, {
    arg freq=220, amp=0.08, gate=1, pan=0;
    var sig, env, detune;

    detune = [0.996, 1.0, 1.004];
    sig = Mix(VarSaw.ar(freq * detune, 0, 0.45, 0.16));
    sig = sig + SinOsc.ar(freq * 0.5, 0, 0.05);
    sig = LPF.ar(sig, 1800);
    sig = HPF.ar(sig, 90);

    env = EnvGen.ar(Env.adsr(4.0, 2.0, 0.7, 8.0), gate, doneAction: 2);
    sig = FreeVerb.ar(sig, 0.55, 0.9, 0.3);
    sig = sig * env * amp;

    Out.ar(0, Pan2.ar(sig, pan));
}).add;

SynthDef(\glass, {
    arg freq=440, amp=0.06, pan=0;
    var sig;

    sig = Pluck.ar(
        WhiteNoise.ar(0.08),
        Impulse.kr(1e-6),
        0.1,
        (1 / freq).clip(0.0005, 0.1),
        6.5,
        0.18
    );

    sig = LPF.ar(sig, 4200);
    sig = sig + (CombC.ar(sig, 0.5, 0.32, 3.2) * 0.2);
    sig = sig * amp;

    Out.ar(0, Pan2.ar(sig, pan));
}).add;

SynthDef(\string, {
    arg freq=440, amp=0.09, gate=1, pan=0;
    var sig, env, vib, noise;

    vib = SinOsc.kr(4.2, 0, 0.003, 1);
    noise = BrownNoise.ar(0.008);

    sig = Mix([
        Saw.ar(freq * vib, 0.22),
        Saw.ar(freq * 1.002 * vib, 0.18),
        Pulse.ar(freq * 0.5 * vib, 0.4, 0.05)
    ]);

    sig = sig + (noise * 0.2);
    sig = RLPF.ar(sig, 2400, 0.35);
    sig = HPF.ar(sig, 160);

    env = EnvGen.ar(Env.adsr(0.4, 1.8, 0.72, 3.5), gate, doneAction: 2);
    sig = sig * env * amp;
    sig = FreeVerb.ar(sig, 0.35, 0.75, 0.2);

    Out.ar(0, Pan2.ar(sig, pan));
}).add;

SynthDef(\air, {
    arg amp=0.018, gate=1, pan=0;
    var sig, env;

    sig = PinkNoise.ar;
    sig = HPF.ar(sig, 6000);
    sig = LPF.ar(sig, 12000);
    env = EnvGen.ar(Env.asr(6, 1, 6), gate, doneAction: 2);

    sig = sig * env * amp;
    Out.ar(0, Pan2.ar(sig, pan));
}).add;
)
//5
(
~bpm = 72;
TempoClock.default.tempo = ~bpm / 60;
)
//6
(
Pdef(\piece,
    Ppar([

        Pbind(
            \instrument, \bass,
            \midinote, Pseq([
                28, 28, 28, 28,
                33, 33, 33, 33
            ], inf),
            \dur, 2,
            \legato, 0.95,
            \amp, 0.18,
            \pan, 0
        ),

        Pbind(
            \instrument, \kick,
            \dur, Pseq([Rest(4), 4, Rest(8)], inf),
            \amp, 0.3,
            \pan, 0
        ),

        Pbind(
            \instrument, \dustHat,
            \dur, Pwrand([0.5, 1, Rest(1)], [0.2, 0.35, 0.45], inf),
            \amp, 0.02,
            \pan, Pwhite(-0.5, 0.5, inf)
        ),

        Pbind(
            \instrument, \wash,
            \midinote, Pseq([
                [52, 55, 59],
                [52, 55, 59],
                [57, 60, 64],
                [57, 60, 64]
            ], inf),
            \dur, 8,
            \legato, 1.0,
            \amp, 0.075,
            \pan, 0
        ),

        Pbind(
            \instrument, \glass,
            \midinote, Pseq([
                64, 67, 71, 74,
                72, 69, 67, 64
            ], inf),
            \dur, Pseq([4, 2, 2, 4, 4, 2, 2, 4], inf),
            \amp, 0.05,
            \pan, -0.25
        ),

        Pbind(
            \instrument, \string,
            \midinote, Pseq([
                76, 79, 83, 81,
                79, 76, 74, 72,
                77, 81, 84, 83,
                81, 77, 76, 72
            ], inf),
            \dur, 2,
            \legato, 0.98,
            \amp, 0.085,
            \pan, Pseq([-0.2, -0.1, 0.1, 0.2], inf)
        ),

        Pbind(
            \instrument, \air,
            \dur, 16,
            \legato, 1.0,
            \amp, 0.016,
            \pan, 0
        )
    ])
);
)
//7
(
Ndef(\mix, {
    var sig;

    sig = In.ar(0, 2);
    sig = LeakDC.ar(sig);
    sig = LPF.ar(sig, 17000);
    sig = Compander.ar(sig, sig, 0.3, 1, 0.45, 0.02, 0.2);
    sig = Limiter.ar(sig, 0.88, 0.03);

    ReplaceOut.ar(0, sig);
}).play(addAction: \addToTail);
)
//8
Pdef(\piece).play(quant: 4);
s.meter;
//9
Pdef(\piece).stop;
(
Pdef(\piece).stop;
Ndef(\mix).clear;
s.freeAll;
)