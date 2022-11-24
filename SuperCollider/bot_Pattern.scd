

(
var d_arr, release, mtranspose, mode ,temp, part, scale;

var nextmode = \slow;
var shift = 0;
var oldtranspose = 0;
var oldshift = 0;
var nextshift = 0;
var nextds = 1;
var drone = false;

~root = 0;
~ds = 1;
~count = 0;
~partRepeats = 4;


/////////////////////////////////////////////////////////////////////////// PART I //////////////////////////////////////////////////////////////////

// For each Part the is a Function evaluated by Plazy
// Those Function will be evaluated every nth repeat
// and alter the State Machine Pattern e.g. by choosing a diffrent mode

~p1 = Plazy({


	if(drone == true, {
		~drone.set(\gate, 0);
	});

	~drone;

	part = \p1;

	//Pdef.removeAll;
	~count = ~count + 1;
	release = 0.5;
	mode = nextmode;
	nextmode = [\slow, \fast, \vib, \mod].choose;

	// Modulate sometimes
	if(nextmode == \mod, {
		~root = ~root +5 % 12;
	});

	shift = nextshift;
	nextshift = [7, 3, 0].choose;

	~ds= nextds;
	nextds = [1 , 1, 0.5, 0.5, 3, 2].choose;


	if(~ds > 1, {
		~drone = Synth(\drone, [
				\freq, (48 + ~root).midicps,
				\out, ~mbus
		]);
		drone = true;
	},{drone == false});

	"---------------------------".postln;
	["count: " ++ ~count].postln;
	["mode: " ++ mode].postln;
	["shift: " ++ shift].postln;
	["ds: " ++ ~ds].postln;
	"---------------------------".postln;

	temp = ~data[part][mode];
	part = ~data[part];
	scale = ~data[\scales][mode];

	Ndef(\master).set(\wet, ~ds.linexp(0.25, 2, 0.25, 1.0));
	Ndef(\master).set(\r_level, 0.2);

	// Some wusch at every start :)
	Synth(\fx, [\amp, 1.0.rand, \out, ~mbus]);

	// One Pfsm for each instrument combined in one Event Stream using Ppar
	// The Part is Over when EVERY Instrument / StateMachine is finished -> nil, nil
	// This will always be a bit diffrent each repeat
	// So we can hear diffrent "solos" from time to time

	Pbindf(
		Ppar([

			Pfsm([
				#[0, 1],

				Pbind(
					\instrument, part[\inst][\melo],
					\degree, Pseq(temp[\0][\deg] + shift),
					\dur, Pseq(temp[\0][\dur] * ~ds),
					),
				#[0, 1],

				Pbind(
					\instrument, part[\inst][\melo],
					\degree, Pseq(temp[\1][\deg] + shift),
					\dur, Pseq(temp[\1][\dur] * ~ds),
				),
				#[0, 2],

				nil, nil,
			]),

			Pfsm([
				#[0, 1],
				Pbind(
					\instrument,  part[\inst][\perc],
					\degree, Pseq(temp[\0][\deg] + shift),
					\dur, Pseq([0.5 ].stutter(4.rand + 4), 1),
					\ctranspose, -12

				), #[0, 1, 0],

				Pbind(
					\instrument,  part[\inst][\perc],
					\degree, Pseq(temp[\1][\deg] + shift),
					\dur, Pseq([0.5, 0.5, 0.5, 0.5].flat, 2),
					\ctranspose, -12

				), #[0, 2, 0],

				nil, nil,
			]),

			Pfsm([

				#[0,1],
				Pbind(
					\instrument,part[\inst][\bass],
					\degree, Pseq(temp[\0][\deg] + shift),
					\dur, Pseq(temp[\0][\dur] * ~ds),
				), #[0, 1, 0],

				Pbind(
					\instrument,  part[\inst][\bass],
					\degree, Pseq(temp[\1][\deg] + shift),
					\dur, Pseq(temp[\1][\dur] * ~ds),
					\mtranspose, Prand([0, 7])

				), #[0, 2, 1, 0],
				nil, nil,
		])], 1),

		// Global Keys for all Instruments -> Pbindf

		\root, ~root,
		\release, 0.5,
		\out, ~mbus,
		\scale, scale

	);
});


////////////////////////////////////////// PART II /////////////////////////////////////////////////////////////

// Same Syntax but diffrent Function in Plazy
// And other patterns used in state machine

~p2 = Plazy({

	part = \p2;


		if(drone == true, {
		~drone.set(\gate, 0);
	});

	// Modulate every 2nd

	if(~count % 2 == 0, {
			~root = ~root +5 % 12;
	});

	~count = ~count + 1;
	release = 0.1;
	mode = nextmode;
	nextmode = [\slow, \fast, \vib, \mod].choose;

	~ds = 2/3;
	shift = nextshift;
	nextshift = [7, -7, 14, 3, 0, 0, 0, 0].choose;

	"---------------------------".postln;
	["count: " ++ ~count].postln;

	["mode: " ++ mode].postln;
	["shift: " ++ shift].postln;
	["ds: " ++ ~ds].postln;

	"---------------------------".postln;

	temp = ~data[part][mode];
	part = ~data[part];
	scale = ~data[\scales][mode];

	Ndef(\master).set(\wet, ~ds.linexp(0.25, 2, 0.25, 2.0));
	Ndef(\master).set(\r_level, 1.0);

	Pbindf(

		Ppar([
			Pfsm([

				#[0, 1],

				Pbind(
					\instrument,  part[\inst][\melo],
					\degree, Pseq(temp[\0][\deg] + shift),
					\dur, Pseq(temp[\0][\dur] * ~ds),
					\release, temp[\0][\rel] * 0.5

				), #[0, 1, 0, 0],

				Pbind(
					\instrument,  part[\inst][\melo],
					\degree, Pseq(temp[\1][\deg] + shift),
					\dur, Pseq(temp[\1][\dur] * ~ds),
					\release, temp[\1][\rel]  * 0.5

				), #[0, 2],
				nil, nil,
			]).trace,

			Pfsm([

				#[0,1],
				Pbind(
					\instrument,  \bSaw,
					\degree, Pseq(temp[\0][\deg] + shift),
					\dur, Pseq(temp[\0][\dur] * ~ds),
					\release, temp[\0][\rel] * 1,
				), #[0, 1],

				Pbind(
					\instrument,  \bSaw,
					\degree, Pseq(temp[\1][\deg] + shift),
					\dur, Pseq(temp[\1][\dur] * ~ds),
					\mtranspose, Prand([0, 7]),
					\release, temp[\1][\rel] * 1,
				), #[0, 2, 1, 0],
				nil, nil,
		])], 1),
		// global keys

		\root, ~root,
		\scale, scale,
		\out, ~mbus
	);
});


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

)

s.meter;

