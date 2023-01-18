note
	description: "Summary description for {E2B_BLACKBOARD_SCORES}."
	author: ""
	date: "$Date: 2013-01-05 00:03:10 +0800 (Sat, 05 Jan 2013) $"
	revision: "$Revision: 90399 $"

class
	E2B_BLACKBOARD_SCORES

feature

	successful: REAL = 1.0
	successful_with_errors: REAL = 0.25
	failed: REAL = -0.25
	skipped: REAL = 0.0

end
