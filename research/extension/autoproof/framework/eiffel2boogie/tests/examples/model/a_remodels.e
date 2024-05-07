note
	-- a replaces x, y is old and b is new
	model: a, yy, b

class
	A_REMODELS

inherit
	A_MODELS
		rename
			x as xx,
			y as yy
		redefine
			foo
		end

feature
	a: BOOLEAN
		note
			replaces: xx
		attribute
		end

	b: BOOLEAN

	foo
		do
			xx := 1
			z := 1
			yy := 1
			a := True
			b := True -- Bad
		end

	-- bar still fails as before
	-- bar_ok still verifies becuase foo added model a, which replaces x

	bad1
		do
		ensure
			modify_model (["z"], Current) -- Bad: z is not a model
		end

	new
		note
			explicit: wrapping
		do
			foo
		ensure
			modify_model (["a", "yy"], Current)
		end

invariant
	xx_definition: xx = if a then 1 else 0 end
end
