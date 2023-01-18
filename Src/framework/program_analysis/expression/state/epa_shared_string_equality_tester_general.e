note
	description: "Summary description for {}."
	author: ""
	date: "$Date: 2013-01-14 16:17:32 +0800 (Mon, 14 Jan 2013) $"
	revision: "$Revision: 90571 $"

deferred class EPA_SHARED_STRING_EQUALITY_TESTER_GENERAL

inherit
	ANY
		undefine
			copy,
			is_equal
		end

feature -- Once

	string_equality_tester_general: EPA_STRING_EQALITY_TESTER
			-- Shared string equality tester.
		once
			Result := create {EPA_STRING_EQALITY_TESTER}
		end

	string_case_insensitive_equality_tester_general: EPA_STRING_CASE_INSENSITIVE_EQALITY_TESTER
			-- Shared string equality tester.
		once
			Result := create {EPA_STRING_CASE_INSENSITIVE_EQALITY_TESTER}
		end


end
