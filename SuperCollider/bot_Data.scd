// Here we can set and exchange ther core repertoir
// what each state in each oart will play

(
~data = (

	/////////  GLOBALS //////////////////////////////////////

	\scales:(
		\slow: Scale.minor,
		\fast: Scale.minor,
		\vib: Scale.minor,
		\mod: Scale.minor
	),

	////////////////////// PART I /////////////////////////////
	\p1:(
		\inst: (
			\melo: \pl,
			\bass: \bSaw,
			\perc: \kick
		),

		\slow:(
			\0:(
				\deg: [0, 7, 9, 8, 7, 8],
				\dur: [1/ 2, 3/2, 1/2, 1/2, 1/2, 1/2],
				\rel: [0.5]
			),

			\1:(
				\deg: [6, 4, 0, 0],
				\dur:  [1/2, 3/2, 1/2, 1/2],
				\rel: [0.5]
			)
		),

		\fast:(
			\0:(
				\deg: [9, 8, 7, 7, 11, 0, 7, 0],
				\dur: [1/2, 1/4, 1/4, 1/2, 1/4, 1/4],
				\rel: [0.5]
			),

			\1:(
				\deg: [0, 0, 5, 0],
				\dur:  [0.5],
				\rel: [0.5]
			)
		),

		\vib:(
			\0:(
				\deg: [9, 8, 7, 7, 11, 0, 7, 0],
				\dur: [0.5],
				\rel: [0.5]
			),

			\1:(
				\deg: [9, 8, 7, 7, 11, 0, 7, 0],
				\dur: [0.5],
				\rel: [0.5]
			)
		),

		\mod:(
			\0:(
				\deg: [0, 0, 0, 0, 0, 0, 0, -1],
				\dur: [0.5],
				\rel: [0.5]
			),

			\1:(
				\deg: [0, 1, -1, 0],
				\dur: [0.5],
				\rel: [0.5]
			)
		)
	),

	//////////////////////// PART II ////////////////////////////////////

	\p2:(

		\inst: (
			\melo: \pl,
			\bass: \bFB,
			\perc: \kick
		),

		\slow:(
			\0:(
				\deg: [0, 0,  1, 0, 0, 0, -1, 0].stutter(8),
				\dur: [0.25],
				\rel: [0.1]
			),

			\1:(
				\deg: [0, 0, -1, 0].stutter(8),
				\dur:  [0.25],
				\rel: [0.1]
			)
		),

		\fast:(
			\0:(
				\deg: [0, 1,  0, 0, 0, 0, -1, 0].stutter(8),
				\dur: [0.125, 0.125, 0.25],
				\rel: [0.1]
			),

			\1:(
				\deg: [0, 0, 1, 0].stutter(8),
				\dur: [0.125, 0.125, 0.25],
				\rel: [0.1]
			)
		),

		\vib:(
			\0:(
				\deg: [0, 0,  0, 0, 0, 0, 0, 0].stutter(8),
				\dur: [0.25],
				\rel: [0.1]
			),

			\1:(
				\deg:[1, 0, 0, 0].stutter(8),
				\dur: [0.25],
				\rel: [0.1]
			)
		),

		\mod:(
			\0:(
				\deg: [0, 0, 0, 0, 0, 0, 0, -1].stutter(8),
				\dur:  [0.5, 0.25, 0.25],
				\rel: [0.1]
			),

			\1:(
				\deg: [0, 1, -1, 0].stutter(8),
				\dur: [0.5, 0.25, 0.25],
				\rel: [0.1]
			)
		)
	),
);

)

