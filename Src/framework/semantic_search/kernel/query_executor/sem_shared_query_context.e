note
	description: "Shared query context"
	author: ""
	date: "$Date: 2010-10-13 05:49:19 +0800 (Wed, 13 Oct 2010) $"
	revision: "$Revision: 84569 $"

class
	SEM_SHARED_QUERY_CONTEXT

feature -- Access

	value_pool: SEM_VALUE_POOL
			-- Pool of values
		once
			create Result.make (100)
		end

end
