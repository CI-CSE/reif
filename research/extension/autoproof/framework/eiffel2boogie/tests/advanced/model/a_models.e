note
	model: x, y
class
	A_MODELS

feature

	x: INTEGER

	y: INTEGER

	z: INTEGER

	foo
		do
			x := 1
			z := 1 -- OK: z is non-model
		ensure
			modify_model (["x", "y"], Current)
		end

	bar
		note
			explicit: wrapping
		do
			if x > 0 then
				foo		-- Bad
			else
				unwrap
				y := 1 	-- Bad: y is model
				wrap
			end
		ensure
			modify_model (["x"], Current)
		end

	bar_ok
		note
			explicit: wrapping
		do
			if x > 0 then
				foo
			else
				unwrap
				y := 1
				wrap
			end
		ensure
			modify_model (["x", "y"], Current)
		end

end
