note
	description: "Visitor for {IR_QUERY}"
	author: ""
	date: "$Date: 2010-10-07 21:20:22 +0800 (Thu, 07 Oct 2010) $"
	revision: "$Revision: 84524 $"

deferred class
	IR_QUERY_VISITOR

feature -- Process

	process_boolean_query (a_query: IR_BOOLEAN_QUERY)
			-- Process `a_query'.
		deferred
		end

end
