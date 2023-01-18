note
	description: "Summary description for {IV_SHARED_TYPES}."
	author: ""
	date: "$Date: 2012-05-10 22:58:31 +0800 (Thu, 10 May 2012) $"
	revision: "$Revision: 88710 $"

class
	IV_SHARED_TYPES

feature {NONE} -- Access

	types: IV_TYPES
			-- Shared access to Boogie types.
		once
			create Result
		end

end
