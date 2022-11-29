(
if (s.options.memSize < (65536 * 4)) {
	// More memSize for the JPverb in Master
	s.options.memSize_(65536 * 4);
	s.reboot;
};

~root = 0;
~ds = 1;
~count = 0;
~partRepeats = 4;

s.waitForBoot {
	"bot_Synths.scd".loadRelative;
	"bot_Data.scd".loadRelative;
	"bot_Pattern.scd".loadRelative;

	s.sync;

	// todo: i guess don't need these, right?
	//~drone.set(\gate, 1);
	//~drone = Synth(\drone, [\gate, 0]);
	//~drone = Synth(\drone);

	///////////////////////////////////////////// Play Parts ///////////////////////////////////////////////////

	// This Part ist still ab bit rudimentary
	// and just to Test if everything is working and playing correctly

	Ndef(\master).play;

	Pseq([

		Pbind(\instrument, \drone,
			\dur, Pseq([1, 2, 1, 1] * 1, 1),
			\lfrange, 8,
			\root, ~root
		),

		Pn(~p1, 4),

		Pbind(\instrument, \drone,
			\dur, Pseq([1, 2, 1, 1] * 1, 1),
			\lfrange, 8,
			\root, ~root
		),

		Pn(~p2, 8),


	], inf).play;
};
)

s.meter;

Ndef(\master).stop(10);
Ndef(\master).play(fadeTime: 10);