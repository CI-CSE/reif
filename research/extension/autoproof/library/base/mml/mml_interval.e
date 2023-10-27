note
	description: "Closed integer intervals."
	author: "Nadia Polikarpova"
	theory: "set.bpl"
	maps_to: "Interval"

class
	MML_INTERVAL

inherit
	MML_SET [INTEGER]

create
	from_range

feature {NONE} -- Initialization

	from_range (l, u: INTEGER)
			-- Create interval [l, u].
		local
		    i: INTEGER
		do
			if l <= u then
				create array.make (1, u - l + 1)
				from
					i := l
				until
					i > u
				loop
					array [i - l + 1] := i
					i := i + 1
				end
			else
				create array.make (1, 0)
			end
		end

end

