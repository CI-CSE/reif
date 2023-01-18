note
	description: "Shared equality tests in RapidMiner library"
	author: ""
	date: "$Date: 2010-12-13 05:32:20 +0800 (Mon, 13 Dec 2010) $"
	revision: "$Revision: 85139 $"

class
	RM_SHARED_EQUALITY_TESTERS

feature -- Equality testers

	rm_decision_tree_path_equality_tester: RM_DECISION_TREE_PATH_EQUALITY_TESTER
			-- Equality tester for objects of type {RM_DECISION_TREE_PATH}
		once
			create Result
		end

end
