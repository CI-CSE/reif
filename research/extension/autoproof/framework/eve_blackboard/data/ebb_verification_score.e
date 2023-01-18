note
	description: "Summary description for {EBB_VERIFICATION_SCORE}."
	author: ""
	date: "$Date: 2011-01-18 17:02:49 +0800 (Tue, 18 Jan 2011) $"
	revision: "$Revision: 85384 $"

class
	EBB_VERIFICATION_SCORE

feature -- Access

	not_verified: REAL_32 = -2.0
			-- Score indicating that no verifcation was done yet.

	failed: REAL_32 = -1.0
			-- Failed verification score.

	successful: REAL_32 = 1.0
			-- Successful verification score.

	lowest_score: REAL_32 = 0.0
			-- Lowest possible verification score.

	highest_score: REAL_32 = 1.0
			-- Highest possible verification score.

	partialy_verified (a_degree: REAL_32): REAL_32
			-- Score for partial verification.
		require
			a_degree_in_range: 0.0 <= a_degree and a_degree <= 1.0
		do
			Result := a_degree
		end

end
