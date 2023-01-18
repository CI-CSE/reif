note
	description: "Summary description for {EPA_CONTROL_DISTANCE_CONSTANT}."
	author: ""
	date: "$Date: 2011-09-20 17:29:31 +0800 (Tue, 20 Sep 2011) $"
	revision: "$Revision: 87242 $"

class
	EPA_CONTROL_DISTANCE_CONSTANT
		
feature -- Constant

	Infinite_distance: INTEGER_32 = 1_000_000
			-- Infinite distance for unreachable control positions.

end
