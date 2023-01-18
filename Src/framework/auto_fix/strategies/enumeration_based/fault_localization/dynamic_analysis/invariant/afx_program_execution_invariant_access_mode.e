note
	description: "Summary description for {AFX_PROGRAM_EXECUTION_INVARIANT_ACCESS_MODE}."
	author: ""
	date: "$Date: 2013-10-17 18:01:19 +0800 (Thu, 17 Oct 2013) $"
	revision: "$Revision: 93135 $"

class
	AFX_PROGRAM_EXECUTION_INVARIANT_ACCESS_MODE

feature -- Status report

	is_valid_invariant_access_mode (a_mode: INTEGER): BOOLEAN
			-- Is `a_mode' a valid invariant access mode?
		do
			Result := Invariant_passing_all <= a_mode and then a_mode <= Invariant_failing_only
		end

feature -- Constant

	Invariant_passing_all: INTEGER = 1
	Invariant_passing_only: INTEGER = 2
	Invariant_failing_all: INTEGER = 3
	Invariant_failing_only: INTEGER = 4

end
