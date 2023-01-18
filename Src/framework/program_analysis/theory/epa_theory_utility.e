note
	description: "Summary description for {EPA_THEORY_UTILITY}."
	author: ""
	date: "$Date: 2010-06-25 19:15:55 +0800 (Fri, 25 Jun 2010) $"
	revision: "$Revision: 83700 $"

class
	EPA_THEORY_UTILITY

feature -- Equality tester

	class_with_prefix_equality_tester: AGENT_BASED_EQUALITY_TESTER [EPA_CLASS_WITH_PREFIX]
			-- Equality test for predicate access pattern
		do
			create Result.make (agent (a, b: EPA_CLASS_WITH_PREFIX): BOOLEAN do Result := a.is_equal (b) end)
		end

end
