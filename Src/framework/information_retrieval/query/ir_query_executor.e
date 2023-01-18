note
	description: "Class to execute a query"
	author: ""
	date: "$Date: 2010-10-13 05:49:19 +0800 (Wed, 13 Oct 2010) $"
	revision: "$Revision: 84569 $"

deferred class
	IR_QUERY_EXECUTOR

feature -- Access

	last_result: detachable IR_QUERY_RESULT
			-- Result of the last executed query

feature -- Basic operations

	execute (a_query: IR_QUERY)
			-- Execute `a_query', make result available in `last_result'.
		deferred
		end

end
