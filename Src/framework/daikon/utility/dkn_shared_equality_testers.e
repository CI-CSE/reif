note
	description: "Shared equality testers"
	author: ""
	date: "$Date: 2010-07-20 16:11:53 +0800 (Tue, 20 Jul 2010) $"
	revision: "$Revision: 83959 $"

class
	DKN_SHARED_EQUALITY_TESTERS

feature -- Access

	daikon_program_point_equality_tester: DKN_PROGRAM_POINT_EQUALITY_TESTER
			-- Equality tester for {DKN_PROGRAM_POINT}
		once
			create Result
		end

	daikon_variable_equality_tester: DKN_VARIABLE_EQUALITY_TESTER
			-- Equality tester for {DKN_VARIABLE}
		once
			create Result
		end

	daikon_invariant_equality_tester: DKN_INVARIANT_EQUALITY_TESTER
			-- Equality tester for {DKN_INVARIANT}
		once
			create Result
		end


end
