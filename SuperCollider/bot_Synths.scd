// For playing the State Pattern just 3 Synths are needed:
// Melody, Bass, Percussion

// All Extra Synths are played outside the State Pattern

(
~rbus = Bus.audio(s, 2);
~mbus = Bus.audio(s, 2);

SynthDef(\bSaw, { |freq = 500, fb = 1.25, gate = 1, release = 0.5, lfrange = 2, out = 0|

	var snd, env, env2, lfo, lfo2 , sub, s_env;

	lfo = LFNoise1.ar(freq.linlin(50, 1500, 4, 0.125)).range(0.25, lfrange);

	sub = SinOsc.ar(freq * 0.125).dup * 0.1;
	s_env = XLine.kr(1, 1, 16, doneAction:2 );

	env = EnvGen.ar(Env.adsr(0.01, release), gate, doneAction: 2);
	env2 = EnvGen.ar(Env.linen(0.01, 1.0, 1.0), doneAction: 0);
	snd = Saw.ar(freq*  [1, 1.01]* 0.25 ) * 0.25 + sub * env;
	sub = SinOsc.ar(freq * 0.125).dup * 0.2;

	snd = RLPF.ar(snd, freq * lfo, 0.5).tanh * 0.5;
	snd = snd + FreeVerb.ar(snd, 1.0, 0.7);

	Out.ar(out, snd);

}).add;


SynthDef(\pl, { |freq = 500, release = 1, fb = 1.25, out = 0|

	var snd, env, env2, lfo, lfo2, noise;

	noise = PinkNoise.ar(0.5);
	lfo2 = LFCub.kr([3, 8] * 0.1).range(0.1, 1);
	lfo = LFNoise1.ar(freq.linlin(50, 1500, 4, 0.125)).range(0.25, 10) * lfo2.tanh;

	env = EnvGen.ar(Env.perc(0.01, release), doneAction: 2);

	snd = Saw.ar(freq  * [1, 1.01] * 1) * 0.25 * env;

	snd = RLPF.ar(snd, freq * lfo * 2, lfo2).tanh * 0.5;

	snd = FreeVerb.ar(snd, 1.0, 0.7) * 0.25 + snd;


	Out.ar(out, snd);

}).add;


SynthDef(\fx, { |freq = 500, release = 1, fb = 1.25, amp = 1, out = 0|

	var snd, env, env2, lfo, lfo2, noise;

	lfo2 = LFCub.kr([3, 8] * XLine.kr(0.1, 4, release)).range(0.05, 1);
	lfo = LFNoise1.ar(freq.linlin(50, 1500, 4, 0.125)).range(0.25, 10) * lfo2.tanh;

	env = EnvGen.ar(Env.perc(0.01, release), doneAction: 2);
	snd = PinkNoise.ar(0.5);

	snd = RLPF.ar(snd, freq * lfo * 2, lfo2).tanh * 0.5;

	snd = FreeVerb.ar(snd, 1.0, 0.7) * 0.25 + snd;

	Out.ar(out, snd * amp);

}).add;


SynthDef(\kick, { |freq = 100, release = 1, fb = 1.25, dur = 0.1, drop = 0.05, out = 0|

	var snd, env, env2, lfo, lfn, kick, bass, hsnd;

	lfo = LFPulse.kr(8);
	lfn = LFNoise1.kr(1).range(0.5, 2);

	env = EnvGen.ar(Env.perc(0.01, release), doneAction: 0);

	env2 = EnvGen.ar(Env([0, 1, 0], [0.01, release * 3]), doneAction: 2);
	kick = SinOsc.ar(XLine.kr(280 + rand(40), 50, drop), mul: 1.2).tanh * env;

	bass = SinOscFB.ar(freq * 0.25, 1.0) * lfo;
	bass = BPF.ar(bass, freq * env.range(0.5, 4) * lfn * 2, 0.1) * 8;

	snd = kick + bass.tanh * 0.125;

	hsnd = HPF.ar(snd, 900);
	hsnd = FreeVerb.ar(hsnd, 1.0, 0.7) * 0.5 + snd;

	snd = snd + hsnd * env2;

	Out.ar(out,  snd.dup * 0.75);

}).add;


SynthDef(\drone, { |freq = 100,  amps = #[0.2, 0.1,  0.1], rings = #[0.1, 0.25, 0.5]
	release = 3, fb = 1.25, dur = 0.1, drop = 0.05, out = 0, fscale = 1, dscale = 10, gate = 1, amp = 0.25 |

	var snd, env, env2, lfo, lfn, kick, bass, hsnd;

	lfo = LFPulse.kr(0.125 * 0.5).range(1, 2);
	lfo = lfo.lag(0.01 + rand(3.0));
	env = Linen.kr(gate, 1, 1, release, doneAction: 2);

	snd = PinkNoise.ar(0.05);

	snd = DynKlank.ar(`[
		[freq, freq * 1.5, freq * 2, freq* 4, freq * 6] * lfo ,
		amps,
		rings],
	snd, fscale * [1, 1.01] * 0.5, 0, dscale).tanh * 0.7;

	hsnd = HPF.ar(snd);
	hsnd = FreeVerb.ar(hsnd,1.0, 0.6, 0.2);

	snd = snd + hsnd * env;

	Out.ar(out, snd* amp);
}).add;


Ndef(\reverb, { |wet = 0.1, r_level = 0.2|

	var snd, reverb, fb, hsnd, low, pitch, hasPitch, res;

	snd = In.ar(~rbus, 2);
	snd = Compander.ar(snd * 2, snd * 2, 0.5, 1.0, 0.5, 0.001) * 0.5;
	#pitch, hasPitch = Pitch.kr(snd);
	fb = LocalIn.ar(2);
	fb = DelayL.ar(fb, 0.2, 0.2);
	//fb = ComplexRes.ar(fb.tanh, fb.range(50, 800), 1)  * wet * 2;

	res = CombL.ar(snd, 0.01, 1/ pitch) * r_level;
	res = HPF.ar(snd, 100);

	snd = snd + res;

	hsnd = HPF.ar(snd);
	reverb = JPverb.ar(hsnd, 3.0, 0.3, 1.0);

	snd = reverb * wet + snd * 0.75;
	LocalOut.ar(snd);

	snd = snd;

});

Ndef(\master, {
	var snd = In.ar(~mbus, 2);
	snd = snd;
});
)
