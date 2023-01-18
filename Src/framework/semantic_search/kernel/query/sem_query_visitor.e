note
	description: "Visitor for {SEM_QUERY}s"
	author: ""
	date: "$Date: 2010-10-07 00:14:06 +0800 (Thu, 07 Oct 2010) $"
	revision: "$Revision: 84518 $"

deferred class
	SEM_QUERY_VISITOR

feature -- Process

	process_boolean_query (a_query: SEM_BOOLEAN_QUERY)
			-- Process `a_query'.
		deferred
		end

end
