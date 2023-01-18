note
	description: "Summary description for {AFX_FIX_SKELETON_CONSTANT}."
	author: ""
	date: "$Date: 2013-10-17 18:01:19 +0800 (Thu, 17 Oct 2013) $"
	revision: "$Revision: 93135 $"

deferred class
	AFX_FIX_SKELETON_CONSTANT

inherit
	ANY
		undefine
			is_equal,
			copy
		end

feature -- Constants

	afore_skeleton_complexity: INTEGER is 1
			-- Complexity level for afore fix skeleton

	wrapping_skeleton_complexity: INTEGER is 2
			-- Complexity level for wrapping fix skeleton


end
