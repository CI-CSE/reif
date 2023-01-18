note
	description: "[
			Objects comparing scored values.
		]"
	date: "$Date: 2016-03-19 06:37:47 +0800 (周六, 19 3月 2016) $"
	revision: "$Revision: 98571 $"

class
	SCORED_VALUE_COMPARATOR [G]

inherit
	PART_COMPARATOR [SCORED_VALUE [G]]
	
feature -- Status report

	less_than (u, v: SCORED_VALUE [G]): BOOLEAN
			-- Is `u' considered less than `v'?
		do
			Result := u < v
		end

end
