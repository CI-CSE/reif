note
	description: "Summary description for {AFX_PROGRAM_STATE_SUSPICIOUSNESS_VALUE_CALCULATOR}."
	author: ""
	date: "$Date: 2013-10-17 18:01:19 +0800 (Thu, 17 Oct 2013) $"
	revision: "$Revision: 93135 $"

deferred class
	AFX_PROGRAM_STATE_SUSPICIOUSNESS_VALUE_CALCULATOR

feature -- Access

	last_suspiciousness_value: REAL
			-- Suspiciousness value from last computation.

feature -- Basic operation

	calculate_suspiciousness_value
			-- Calculate suspiciousness value and make the result available in `last_suspiciousness_value'.
		deferred
		end

end
