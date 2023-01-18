note
	description: "Object that represents a branching block in a CFG."
	author: ""
	date: "$Date: 2011-09-05 03:39:02 +0800 (Mon, 05 Sep 2011) $"
	revision: "$Revision: 87158 $"

deferred class
	EPA_BRANCHING_BLOCK

inherit
	EPA_BASIC_BLOCK

feature -- Access

	condition: EXPR_AS
			-- Condition on which execution branches
		deferred
		ensure
			result_attached: Result /= Void
		end

invariant
	asts_valid: asts.count = 1 and then asts.first = condition

end
